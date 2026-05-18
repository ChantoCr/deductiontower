import 'package:anime_deduction_tower/app/router.dart';
import 'package:anime_deduction_tower/core/enums/match_end_reason.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
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
