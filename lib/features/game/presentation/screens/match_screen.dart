import 'package:anime_deduction_tower/app/router.dart';
import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/characters/presentation/providers/character_providers.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/game_match.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/turn.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/match_controller.dart';
import 'package:anime_deduction_tower/features/game/presentation/providers/trait_category_providers.dart';
import 'package:anime_deduction_tower/features/game/presentation/widgets/category_guess_dialog.dart';
import 'package:anime_deduction_tower/features/game/presentation/widgets/character_pool_panel.dart';
import 'package:anime_deduction_tower/features/game/presentation/widgets/guess_history.dart';
import 'package:anime_deduction_tower/features/game/presentation/widgets/hint_panel.dart';
import 'package:anime_deduction_tower/features/game/presentation/widgets/secret_trait_card.dart';
import 'package:anime_deduction_tower/features/game/presentation/widgets/tower_view.dart';
import 'package:anime_deduction_tower/features/game/presentation/widgets/turn_panel.dart';
import 'package:anime_deduction_tower/shared/animations/pulse_animation.dart';
import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
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
    setState(() {
      _revealedPlayerId = playerId;
      _isSecretTraitVisible = false;
    });
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
    final shouldSurrender = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Surrender Match?'),
            content: const Text(
              'This ends the match immediately and awards the win to the opponent.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Surrender'),
              ),
            ],
          ),
        ) ??
        false;

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
    final currentPlayerTraitLabel = _findTraitLabel(
      categories: categories,
      traitId: match.currentPlayer.secretTraitId,
    );

    if (!isTurnRevealed) {
      return AppScaffold(
        title: 'Protected Turn',
        child: Center(
          child: AppCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PulseAnimation(
                  child: Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.visibility_off_outlined,
                      color: AppColors.secondary,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                const Text(
                  'Private Turn Protection',
                  style: AppTextStyles.title,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Only ${match.currentPlayer.name} should be looking at the screen right now.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  'Nothing private is shown until the active player explicitly reveals their turn.',
                  style: AppTextStyles.subtitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.82),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.14),
                    ),
                  ),
                  child: const Text(
                    'Protected reveal is intentionally separated from the live match tools.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.subtitle,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                AppButton(
                  label: 'Reveal ${match.currentPlayer.name}\'s Turn',
                  icon: Icons.visibility_outlined,
                  onPressed: () => _revealCurrentTurn(match.currentPlayerId),
                ),
              ],
            ),
          ),
        ),
      );
    }
    final historyItems = _buildHistoryItems(
      turns: match.turns,
      characters: characters,
      categories: categories,
      match: match,
    );
    final latestPublicEvent = match.turns.isEmpty ? null : historyItems.first;
    final selectedCharacterName = _selectedCharacterId == null
        ? null
        : _findCharacterName(
            characters: characters,
            characterId: _selectedCharacterId!,
          );

    final latestEventCard = latestPublicEvent == null
        ? null
        : _LatestEventCard(
            latestPublicEvent: latestPublicEvent,
            color: _latestEventColor(match),
          );

    return AppScaffold(
      title: 'Match',
      bottomBar: _MatchActionBar(
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
            ),
            if (latestEventCard != null) ...[
              const SizedBox(height: AppSpacing.md),
              latestEventCard,
            ],
            const SizedBox(height: AppSpacing.md),
            GuessHistory(items: historyItems),
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
              onCharacterSelected: (character) {
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

  List<String> _buildHistoryItems({
    required List<Turn> turns,
    required List<Character> characters,
    required List<TraitCategory> categories,
    required GameMatch match,
  }) {
    if (turns.isEmpty) {
      return const ['No turns recorded yet.'];
    }

    return turns
        .map((turn) {
          final playerName = turn.playerId == match.playerOne.id
              ? match.playerOne.name
              : match.playerTwo.name;

          switch (turn.actionType) {
            case TurnActionType.guessCharacter:
              final characterName = _findCharacterName(
                characters: characters,
                characterId: turn.value,
              );
              final outcome = turn.wasCorrect ? 'correct' : 'wrong';
              return '$playerName guessed $characterName ($outcome)';
            case TurnActionType.guessTrait:
              final traitLabel = _findTraitLabel(
                    categories: categories,
                    traitId: turn.value,
                  ) ??
                  turn.value;
              final outcome = turn.wasCorrect ? 'correct' : 'wrong';
              return '$playerName guessed trait $traitLabel ($outcome)';
            case TurnActionType.surrender:
              return '$playerName surrendered';
            case TurnActionType.requestHint:
              return '$playerName requested a private hint';
            case TurnActionType.pass:
              return '$playerName passed the turn';
          }
        })
        .toList()
        .reversed
        .toList();
  }

  Color _latestEventColor(GameMatch match) {
    if (match.turns.isEmpty) {
      return AppColors.text;
    }

    final lastTurn = match.turns.last;
    switch (lastTurn.actionType) {
      case TurnActionType.guessCharacter:
      case TurnActionType.guessTrait:
        return lastTurn.wasCorrect ? AppColors.success : AppColors.error;
      case TurnActionType.requestHint:
        return AppColors.secondary;
      case TurnActionType.surrender:
        return AppColors.accent;
      case TurnActionType.pass:
        return AppColors.muted;
    }
  }

  String _findCharacterName({
    required List<Character> characters,
    required String characterId,
  }) {
    for (final character in characters) {
      if (character.id == characterId) {
        return character.name;
      }
    }

    return characterId;
  }

  String? _findTraitLabel({
    required List<TraitCategory> categories,
    required String? traitId,
  }) {
    if (traitId == null) {
      return null;
    }

    for (final category in categories) {
      if (category.id == traitId) {
        return category.label;
      }
    }

    return null;
  }
}

class _LatestEventCard extends StatelessWidget {
  const _LatestEventCard({
    required this.latestPublicEvent,
    required this.color,
  });

  final String latestPublicEvent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Latest Public Event', style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.sm),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.96, end: 1),
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOut,
            builder: (context, value, child) => Transform.scale(
              scale: value,
              child: child,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: color.withValues(alpha: 0.25)),
              ),
              child: Text(
                latestPublicEvent,
                style: AppTextStyles.body.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchActionBar extends StatelessWidget {
  const _MatchActionBar({
    required this.guessController,
    required this.onGuessChanged,
    required this.onSubmitCharacterGuess,
    required this.onRequestHint,
    required this.onGuessTag,
    required this.onSurrender,
    required this.onClearSelection,
    required this.canRequestHint,
    required this.canGuessTag,
    this.selectedCharacterName,
  });

  final TextEditingController guessController;
  final VoidCallback onGuessChanged;
  final VoidCallback onSubmitCharacterGuess;
  final VoidCallback onRequestHint;
  final VoidCallback onGuessTag;
  final VoidCallback onSurrender;
  final VoidCallback onClearSelection;
  final bool canRequestHint;
  final bool canGuessTag;
  final String? selectedCharacterName;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useWideLayout = constraints.maxWidth >= 900;
        final utilityButtons = useWideLayout
            ? Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Request Hint',
                      icon: Icons.lightbulb_outline,
                      isPrimary: false,
                      onPressed: canRequestHint ? onRequestHint : null,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppButton(
                      label: 'Guess Tag',
                      icon: Icons.psychology_alt_outlined,
                      isPrimary: false,
                      onPressed: canGuessTag ? onGuessTag : null,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppButton(
                      label: 'Surrender Match',
                      icon: Icons.flag_outlined,
                      isPrimary: false,
                      onPressed: onSurrender,
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Request Hint',
                          icon: Icons.lightbulb_outline,
                          isPrimary: false,
                          onPressed: canRequestHint ? onRequestHint : null,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: AppButton(
                          label: 'Guess Tag',
                          icon: Icons.psychology_alt_outlined,
                          isPrimary: false,
                          onPressed: canGuessTag ? onGuessTag : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppButton(
                    label: 'Surrender Match',
                    icon: Icons.flag_outlined,
                    isPrimary: false,
                    onPressed: onSurrender,
                  ),
                ],
              );

        return AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text('Action Console', style: AppTextStyles.title),
                  ),
                  if (selectedCharacterName != null)
                    TextButton.icon(
                      onPressed: onClearSelection,
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text('Clear'),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                selectedCharacterName == null
                    ? 'Pick from the pool or type an exact character name, then submit without scrolling away from the action area.'
                    : 'Your selected guess is staged below and ready for submission.',
                style: AppTextStyles.subtitle,
              ),
              if (selectedCharacterName != null) ...[
                const SizedBox(height: AppSpacing.md),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.22),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          selectedCharacterName!,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: guessController,
                decoration: const InputDecoration(
                  labelText: 'Character guess',
                  helperText:
                      'Pool tap autofills this field. Exact name matching still works.',
                  prefixIcon: Icon(Icons.person_search_outlined),
                ),
                onChanged: (_) => onGuessChanged(),
              ),
              const SizedBox(height: AppSpacing.md),
              if (useWideLayout)
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: AppButton(
                        label: 'Submit Character Guess',
                        icon: Icons.check_circle_outline,
                        onPressed: onSubmitCharacterGuess,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(flex: 5, child: utilityButtons),
                  ],
                )
              else ...[
                AppButton(
                  label: 'Submit Character Guess',
                  icon: Icons.check_circle_outline,
                  onPressed: onSubmitCharacterGuess,
                ),
                const SizedBox(height: AppSpacing.sm),
                utilityButtons,
              ],
            ],
          ),
        );
      },
    );
  }
}
