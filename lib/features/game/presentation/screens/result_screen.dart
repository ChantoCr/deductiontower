import 'package:anime_deduction_tower/app/router.dart';
import 'package:anime_deduction_tower/core/enums/match_end_reason.dart';
import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/characters/presentation/providers/character_providers.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/turn.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/match_controller.dart';
import 'package:anime_deduction_tower/features/game/presentation/providers/trait_category_providers.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_button.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:anime_deduction_tower/shared/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final match = ref.watch(matchControllerProvider);
    final categories = ref.watch(validatedTraitCatalogProvider).maybeWhen(
      data: (catalog) => catalog.validCategories,
      orElse: () => const <TraitCategory>[],
    );
    final characters = ref.watch(charactersProvider).maybeWhen(
      data: (data) => data,
      orElse: () => const <Character>[],
    );

    if (match == null) {
      return AppScaffold(
        title: 'Result',
        child: Center(
          child: AppCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('No Result Available', style: AppTextStyles.title),
                const SizedBox(height: AppSpacing.sm),
                const Text('Start and complete a match to see the final result screen.'),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: 'Back Home',
                  icon: Icons.home_outlined,
                  onPressed: () => context.go(AppRoutes.home),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final winnerName = match.winnerId == match.playerOne.id
        ? match.playerOne.name
        : match.winnerId == match.playerTwo.id
        ? match.playerTwo.name
        : 'No winner';

    final playerOneTrait = _findTraitLabel(categories, match.playerOne.secretTraitId);
    final playerTwoTrait = _findTraitLabel(categories, match.playerTwo.secretTraitId);
    final timelineItems = _buildTimelineItems(
      turns: match.turns,
      categories: categories,
      characters: characters,
      playerOneName: match.playerOne.name,
      playerTwoName: match.playerTwo.name,
      playerOneId: match.playerOne.id,
    );

    return AppScaffold(
      title: 'Result',
      child: ListView(
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Winner: $winnerName', style: AppTextStyles.title),
                const SizedBox(height: AppSpacing.sm),
                Text('Win Reason: ${_endReasonLabel(match.endReason)}'),
                Text('Player 1 Trait: ${playerOneTrait ?? 'Unknown'}'),
                Text('Player 2 Trait: ${playerTwoTrait ?? 'Unknown'}'),
                Text('Turns: ${match.turns.length}'),
                Text('Character Pool Size: ${match.characterPoolIds.length}'),
                Text('Player 1 Hints Remaining: ${match.playerOne.hintsRemaining}'),
                Text('Player 2 Hints Remaining: ${match.playerTwo.hintsRemaining}'),
              ],
            ),
          ),
          if (timelineItems.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Turn Timeline', style: AppTextStyles.title),
                  const SizedBox(height: AppSpacing.sm),
                  ...timelineItems.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: Text('• $item'),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'Rematch Setup',
            icon: Icons.restart_alt,
            onPressed: () {
              ref.read(matchControllerProvider.notifier).clear();
              context.go(AppRoutes.setup);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: 'Back Home',
            icon: Icons.home_outlined,
            onPressed: () {
              ref.read(matchControllerProvider.notifier).clear();
              context.go(AppRoutes.home);
            },
            isPrimary: false,
          ),
        ],
      ),
    );
  }

  List<String> _buildTimelineItems({
    required List<Turn> turns,
    required List<TraitCategory> categories,
    required List<Character> characters,
    required String playerOneName,
    required String playerTwoName,
    required String playerOneId,
  }) {
    return turns.reversed.take(6).map((turn) {
      final playerName = turn.playerId == playerOneId ? playerOneName : playerTwoName;

      switch (turn.actionType) {
        case TurnActionType.guessCharacter:
          final characterName = _findCharacterName(characters, turn.value);
          final outcome = turn.wasCorrect ? 'correct' : 'wrong';
          return '$playerName guessed $characterName ($outcome)';
        case TurnActionType.guessTrait:
          final traitLabel = _findTraitLabel(categories, turn.value) ?? turn.value;
          final outcome = turn.wasCorrect ? 'correct' : 'wrong';
          return '$playerName guessed trait $traitLabel ($outcome)';
        case TurnActionType.requestHint:
          return '$playerName requested a private hint';
        case TurnActionType.surrender:
          return '$playerName surrendered';
        case TurnActionType.pass:
          return '$playerName passed the turn';
      }
    }).toList();
  }

  String _findCharacterName(List<Character> characters, String characterId) {
    for (final character in characters) {
      if (character.id == characterId) {
        return character.name;
      }
    }

    return characterId;
  }

  String? _findTraitLabel(List<TraitCategory> categories, String? traitId) {
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

  String _endReasonLabel(MatchEndReason? endReason) {
    switch (endReason) {
      case MatchEndReason.correctTraitGuess:
        return 'Correct secret trait guess';
      case MatchEndReason.surrender:
        return 'Surrender';
      case null:
        return 'Match ended';
    }
  }
}
