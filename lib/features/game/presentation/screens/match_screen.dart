import 'package:anime_deduction_tower/app/router.dart';
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
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_button.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
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

  Future<void> _submitCharacterGuess(GameMatch match) async {
    final characters = await ref.read(charactersProvider.future);
    final categories = (await ref.read(validatedTraitCatalogProvider.future)).validCategories;
    final guessedCharacter = _resolveGuessedCharacter(match, characters);

    if (guessedCharacter == null) {
      _showMessage('Select a character from the pool or type an exact name.');
      return;
    }

    final result = ref.read(matchControllerProvider.notifier).submitCharacterGuess(
      characterId: guessedCharacter.id,
      characters: characters,
      categories: categories,
    );

    _clearCharacterSelection();
    _showMessage(result.message);
  }

  Future<void> _submitTraitGuess(TraitCategory guessedTrait) async {
    final categories = (await ref.read(validatedTraitCatalogProvider.future)).validCategories;
    final result = ref.read(matchControllerProvider.notifier).submitTraitGuess(
      guessedTraitId: guessedTrait.id,
      categories: categories,
    );

    _showMessage(result.message);

    final updatedMatch = ref.read(matchControllerProvider);
    if (updatedMatch?.winnerId != null && mounted) {
      context.go(AppRoutes.result);
    }
  }

  void _surrenderMatch() {
    ref.read(matchControllerProvider.notifier).surrenderCurrentPlayer();
    context.go(AppRoutes.result);
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
    final currentPlayerTraitLabel = _findTraitLabel(
      categories: categories,
      traitId: match.currentPlayer.secretTraitId,
    );

    return AppScaffold(
      title: 'Match',
      child: ListView(
        children: [
          TurnPanel(
            currentPlayer: match.currentPlayer.name,
            hints: match.currentPlayer.hintsRemaining,
          ),
          const SizedBox(height: AppSpacing.md),
          TowerView(label: 'Shared Character Pool • ${match.characterPoolIds.length} available'),
          const SizedBox(height: AppSpacing.md),
          SecretTraitCard(
            title: 'Your Secret Trait',
            value: currentPlayerTraitLabel ?? 'Trait unavailable',
          ),
          const SizedBox(height: AppSpacing.md),
          const HintPanel(hint: 'Hints will appear here once the real hint flow is connected.'),
          const SizedBox(height: AppSpacing.md),
          GuessHistory(
            items: _buildHistoryItems(
              turns: match.turns,
              characters: characters,
              categories: categories,
              match: match,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          CharacterPoolPanel(
            availableCharacterIds: match.characterPoolIds,
            selectedCharacterId: _selectedCharacterId,
            onCharacterSelected: (character) {
              _selectCharacter(character.id, character.name);
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _guessController,
            decoration: const InputDecoration(
              labelText: 'Enter a character guess',
              helperText: 'Tap a character in the pool to autofill this field.',
            ),
            onChanged: (_) {
              if (_selectedCharacterId != null) {
                setState(() => _selectedCharacterId = null);
              }
            },
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: 'Submit Character Guess',
            icon: Icons.check_circle_outline,
            onPressed: () => _submitCharacterGuess(match),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: 'Guess Secret Trait',
            icon: Icons.psychology_alt_outlined,
            onPressed: categories.isEmpty
                ? null
                : () => showDialog<void>(
                    context: context,
                    builder: (_) => CategoryGuessDialog(
                      categories: categories,
                      onTraitSelected: _submitTraitGuess,
                    ),
                  ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: 'Surrender Match',
            icon: Icons.flag_outlined,
            isPrimary: false,
            onPressed: _surrenderMatch,
          ),
        ],
      ),
    );
  }

  Character? _resolveGuessedCharacter(GameMatch match, List<Character> characters) {
    if (_selectedCharacterId != null) {
      return characters.firstWhere(
        (character) => character.id == _selectedCharacterId,
        orElse: () => throw StateError('Selected character could not be found.'),
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

    return turns.map((turn) {
      final playerName = turn.playerId == match.playerOne.id
          ? match.playerOne.name
          : match.playerTwo.name;

      switch (turn.actionType) {
        case TurnActionType.guessCharacter:
          final characterName = _findCharacterName(characters: characters, characterId: turn.value);
          final outcome = turn.wasCorrect ? 'correct' : 'wrong';
          return '$playerName guessed $characterName ($outcome)';
        case TurnActionType.guessTrait:
          final traitLabel = _findTraitLabel(categories: categories, traitId: turn.value) ?? turn.value;
          final outcome = turn.wasCorrect ? 'correct' : 'wrong';
          return '$playerName guessed trait $traitLabel ($outcome)';
        case TurnActionType.surrender:
          return '$playerName surrendered';
        case TurnActionType.requestHint:
          return '$playerName requested a hint';
        case TurnActionType.pass:
          return '$playerName passed the turn';
      }
    }).toList().reversed.toList();
  }

  String _findCharacterName({
    required List<Character> characters,
    required String characterId,
  }) {
    return characters
        .where((character) => character.id == characterId)
        .map((character) => character.name)
        .firstWhere(
          (_) => true,
          orElse: () => characterId,
        );
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
