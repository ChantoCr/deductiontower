import 'package:anime_deduction_tower/app/router.dart';
import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/characters/presentation/providers/character_providers.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/game_match.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/match_controller.dart';
import 'package:anime_deduction_tower/features/game/presentation/helpers/match_lookup_helper.dart';
import 'package:anime_deduction_tower/features/game/presentation/helpers/match_presentation_mapper.dart';
import 'package:anime_deduction_tower/features/game/presentation/providers/trait_category_providers.dart';
import 'package:anime_deduction_tower/features/game/presentation/widgets/category_guess_dialog.dart';
import 'package:anime_deduction_tower/features/game/presentation/widgets/character_pool_panel.dart';
import 'package:anime_deduction_tower/features/game/presentation/widgets/guess_history.dart';
import 'package:anime_deduction_tower/features/game/presentation/widgets/hint_panel.dart';
import 'package:anime_deduction_tower/features/game/presentation/widgets/latest_public_event_card.dart';
import 'package:anime_deduction_tower/features/game/presentation/widgets/match_action_bar.dart';
import 'package:anime_deduction_tower/features/game/presentation/widgets/match_privacy_gate.dart';
import 'package:anime_deduction_tower/features/game/presentation/widgets/secret_trait_card.dart';
import 'package:anime_deduction_tower/features/game/presentation/widgets/tower_view.dart';
import 'package:anime_deduction_tower/features/game/presentation/widgets/turn_panel.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_button.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:anime_deduction_tower/shared/widgets/app_dialog.dart';
import 'package:anime_deduction_tower/shared/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MatchScreen extends ConsumerStatefulWidget {
  const MatchScreen({super.key});

  @override
  ConsumerState<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends ConsumerState<MatchScreen> {
  late final TextEditingController _guessController;
  String? _selectedCharacterId;
  String? _revealedPlayerId;
  bool _isSecretTraitVisible = false;
  bool _showPrivacyClearedCue = false;
  bool _showPoolLockOverlay = false;
  int _privacyCueSequenceId = 0;

  @override
  void initState() {
    super.initState();
    _guessController = TextEditingController();
  }

  @override
  void dispose() {
    _guessController.dispose();
    super.dispose();
  }

  void _selectCharacter(String characterId, String characterName) {
    setState(() {
      _selectedCharacterId = characterId;
      _guessController.text = characterName;
      _guessController.selection = TextSelection.collapsed(
        offset: _guessController.text.length,
      );
    });
  }

  void _clearCharacterSelection() {
    setState(() {
      _selectedCharacterId = null;
      _guessController.clear();
    });
  }

  void _revealCurrentTurn(String playerId) {
    final sequenceId = ++_privacyCueSequenceId;

    setState(() {
      _revealedPlayerId = playerId;
      _isSecretTraitVisible = false;
      _showPrivacyClearedCue = false;
      _showPoolLockOverlay = true;
    });

    Future<void>.delayed(const Duration(milliseconds: 650), () {
      if (!mounted || sequenceId != _privacyCueSequenceId) {
        return;
      }

      setState(() {
        _showPoolLockOverlay = false;
        _showPrivacyClearedCue = true;
      });
    });
  }

  void _dismissPrivacyClearedCue() {
    if (!_showPrivacyClearedCue) {
      return;
    }

    setState(() => _showPrivacyClearedCue = false);
  }

  void _toggleSecretTraitVisibility() {
    setState(() {
      _isSecretTraitVisible = !_isSecretTraitVisible;
    });
  }

  Future<void> _submitCharacterGuess(GameMatch match) async {
    try {
      final characters = await ref.read(charactersProvider.future);
      final categories = (await ref.read(validatedTraitCatalogProvider.future))
          .validCategories;
      final guessedCharacter = _resolveGuessedCharacter(match, characters);

      if (guessedCharacter == null) {
        _showMessage('Select a character from the pool or type an exact name.');
        return;
      }

      final result =
          ref.read(matchControllerProvider.notifier).submitCharacterGuess(
                characterId: guessedCharacter.id,
                characters: characters,
                categories: categories,
              );

      _clearCharacterSelection();

      if (!mounted) {
        return;
      }

      await AppDialog.showFeedback(
        context,
        title: result.isCorrect
            ? 'Character Guess Correct'
            : 'Character Guess Incorrect',
        message: result.message,
        isSuccess: result.isCorrect,
      );

      if (!mounted) {
        return;
      }

      _goToNextPhase(ref.read(matchControllerProvider));
    } catch (error) {
      _showMessage('$error');
    }
  }

  Future<void> _submitTraitGuess(TraitCategory guessedTrait) async {
    try {
      final categories = (await ref.read(validatedTraitCatalogProvider.future))
          .validCategories;
      final result =
          ref.read(matchControllerProvider.notifier).submitTraitGuess(
                guessedTraitId: guessedTrait.id,
                categories: categories,
              );

      if (!mounted) {
        return;
      }

      await AppDialog.showFeedback(
        context,
        title:
            result.isCorrect ? 'Trait Guess Correct' : 'Trait Guess Incorrect',
        message: result.message,
        isSuccess: result.isCorrect,
      );

      if (!mounted) {
        return;
      }

      _goToNextPhase(ref.read(matchControllerProvider));
    } catch (error) {
      _showMessage('$error');
    }
  }

  Future<void> _requestHint() async {
    try {
      final categories = (await ref.read(validatedTraitCatalogProvider.future))
          .validCategories;
      final hint = ref.read(matchControllerProvider.notifier).requestHint(
            categories: categories,
          );

      if (!mounted) {
        return;
      }

      await AppDialog.showInfo(
        context,
        title: 'Private Hint',
        message: hint,
      );

      if (!mounted) {
        return;
      }

      _goToNextPhase(ref.read(matchControllerProvider));
    } catch (error) {
      _showMessage('$error');
    }
  }

  Future<void> _openTraitGuessDialog(List<TraitCategory> categories) {
    return showDialog<void>(
      context: context,
      builder: (_) => CategoryGuessDialog(
        categories: categories,
        onTraitSelected: _submitTraitGuess,
      ),
    );
  }

  Future<void> _confirmSurrender() async {
    final shouldSurrender = await AppDialog.showConfirm(
      context,
      title: 'Surrender Match?',
      message:
          'This ends the match immediately and awards the win to the opponent.',
      confirmLabel: 'Surrender',
      cancelLabel: 'Keep Playing',
      isDanger: true,
    );

    if (!shouldSurrender || !mounted) {
      return;
    }

    ref.read(matchControllerProvider.notifier).surrenderCurrentPlayer();
    context.go(AppRoutes.result);
  }

  void _goToNextPhase(GameMatch? match) {
    if (match == null || !mounted) {
      return;
    }

    if (match.status == MatchStatus.completed || match.winnerId != null) {
      context.go(AppRoutes.result);
      return;
    }

    context.go(AppRoutes.turnTransition);
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    const lookup = MatchLookupHelper();
    const mapper = MatchPresentationMapper();

    ref.listen<GameMatch?>(matchControllerProvider, (previous, next) {
      if (next == null) {
        return;
      }

      final previousKey = previous == null
          ? null
          : '${previous.currentPlayerId}-${previous.turns.length}';
      final nextKey = '${next.currentPlayerId}-${next.turns.length}';

      if (previousKey != null && previousKey != nextKey && mounted) {
        _privacyCueSequenceId++;
        setState(() {
          _selectedCharacterId = null;
          _guessController.clear();
          _revealedPlayerId = null;
          _isSecretTraitVisible = false;
          _showPrivacyClearedCue = false;
          _showPoolLockOverlay = false;
        });
      }
    });

    final match = ref.watch(matchControllerProvider);
    final catalogAsync = ref.watch(validatedTraitCatalogProvider);
    final charactersAsync = ref.watch(charactersProvider);

    if (match == null) {
      return AppScaffold(
        title: 'Match',
        child: Center(
          child: AppCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('No Active Match', style: AppTextStyles.title),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  'Start a match from setup and secret trait selection first.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: 'Back to Setup',
                  icon: Icons.restart_alt,
                  onPressed: () => context.go(AppRoutes.setup),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final categories = catalogAsync.maybeWhen(
      data: (catalog) => catalog.validCategories,
      orElse: () => const <TraitCategory>[],
    );
    final characters = charactersAsync.maybeWhen(
      data: (data) => data,
      orElse: () => const <Character>[],
    );
    final isTurnRevealed = _revealedPlayerId == match.currentPlayerId;
    final currentPlayerTraitLabel = lookup.traitLabelForPlayer(
      categories,
      match.currentPlayer,
    );

    if (!isTurnRevealed) {
      return AppScaffold(
        title: 'Protected Turn',
        child: MatchPrivacyGate(
          currentPlayerName: match.currentPlayer.name,
          onReveal: () => _revealCurrentTurn(match.currentPlayerId),
        ),
      );
    }
    final historyEntries = mapper.buildTimelineEntries(
      match: match,
      categories: categories,
      characters: characters,
    );
    final latestPublicEvent = match.turns.isEmpty || historyEntries.isEmpty
        ? null
        : historyEntries.first;
    final selectedCharacterName = _selectedCharacterId == null
        ? null
        : lookup.findCharacterName(characters, _selectedCharacterId!);

    final latestEventCard = latestPublicEvent == null
        ? null
        : LatestPublicEventCard(latestPublicEvent: latestPublicEvent);

    return AppScaffold(
      title: 'Match',
      bottomBar: MatchActionBar(
        guessController: _guessController,
        selectedCharacterName: selectedCharacterName,
        canRequestHint:
            categories.isNotEmpty && match.currentPlayer.hintsRemaining > 0,
        canGuessTag: categories.isNotEmpty,
        onClearSelection: _clearCharacterSelection,
        onSubmitCharacterGuess: () => _submitCharacterGuess(match),
        onRequestHint: _requestHint,
        onGuessTag: () => _openTraitGuessDialog(categories),
        onSurrender: _confirmSurrender,
        onGuessChanged: () {
          _dismissPrivacyClearedCue();
          if (_selectedCharacterId != null) {
            setState(() => _selectedCharacterId = null);
          }
        },
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final useWideLayout = constraints.maxWidth >= 1100;

          final leftColumn = <Widget>[
            TurnPanel(
              currentPlayer: match.currentPlayer.name,
              hints: match.currentPlayer.hintsRemaining,
            ),
            const SizedBox(height: AppSpacing.md),
            SecretTraitCard(
              title: 'Your Secret Tag Reminder',
              value: currentPlayerTraitLabel ?? 'Tag unavailable',
              isRevealed: _isSecretTraitVisible,
              onToggleVisibility: _toggleSecretTraitVisibility,
            ),
            const SizedBox(height: AppSpacing.md),
            HintPanel(
              hint: match.currentPlayer.hintsRemaining > 0
                  ? 'Request a private hint about the opponent\'s secret tag. It consumes one hint, then the device passes to the next player.'
                  : 'No hints remain for this player. Use character and tag guesses to continue deducing the answer.',
              isActionAvailable: match.currentPlayer.hintsRemaining > 0,
            ),
            if (latestEventCard != null) ...[
              const SizedBox(height: AppSpacing.md),
              latestEventCard,
            ],
            const SizedBox(height: AppSpacing.md),
            GuessHistory(
              entries: historyEntries,
              collapsedCount: 4,
              emptyStateMessage: 'No public events recorded yet.',
              resetKey: '${match.currentPlayerId}-${match.turns.length}',
            ),
          ];

          final rightColumn = <Widget>[
            TowerView(
              label:
                  'Shared Character Pool • ${match.characterPoolIds.length} available',
            ),
            const SizedBox(height: AppSpacing.md),
            CharacterPoolPanel(
              availableCharacterIds: match.characterPoolIds,
              selectedCharacterId: _selectedCharacterId,
              privacyResetKey: '${match.currentPlayerId}-${match.turns.length}',
              showPrivacyClearedNotice: _showPrivacyClearedCue,
              showPrivacyLockOverlay: _showPoolLockOverlay,
              privacyPlayerName: match.currentPlayer.name,
              onDismissPrivacyNotice: _dismissPrivacyClearedCue,
              onCharacterSelected: (character) {
                _dismissPrivacyClearedCue();
                _selectCharacter(character.id, character.name);
              },
            ),
          ];

          if (useWideLayout) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 9,
                        child: Column(children: leftColumn),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        flex: 11,
                        child: Column(children: rightColumn),
                      ),
                    ],
                  ),
                  const SizedBox(height: 220),
                ],
              ),
            );
          }

          return ListView(
            children: [
              ...leftColumn,
              const SizedBox(height: AppSpacing.md),
              ...rightColumn,
              const SizedBox(height: 220),
            ],
          );
        },
      ),
    );
  }

  Character? _resolveGuessedCharacter(
    GameMatch match,
    List<Character> characters,
  ) {
    if (_selectedCharacterId != null) {
      return characters.firstWhere(
        (character) => character.id == _selectedCharacterId,
        orElse: () =>
            throw StateError('Selected character could not be found.'),
      );
    }

    final typedValue = _guessController.text.trim().toLowerCase();
    if (typedValue.isEmpty) {
      return null;
    }

    for (final character in characters) {
      final isInPool = match.characterPoolIds.contains(character.id);
      final isExactNameMatch = character.name.toLowerCase() == typedValue;
      if (isInPool && isExactNameMatch) {
        return character;
      }
    }

    return null;
  }
}
