import 'package:anime_deduction_tower/app/router.dart';
import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/features/characters/presentation/providers/character_providers.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/game_match.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/category_selection_controller.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/game_setup_controller.dart';
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

class TurnTransitionScreen extends ConsumerWidget {
  const TurnTransitionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final match = ref.watch(matchControllerProvider);
    final isExistingMatch = match != null;
    final isCompletedMatch = match?.status == MatchStatus.completed;

    final title = isCompletedMatch
        ? 'Match Complete'
        : isExistingMatch
            ? 'Pass the Device'
            : 'Prepare the First Player';

    final description = isCompletedMatch
        ? 'The match has ended. Open the result screen to review the winner, end reason, and turn summary.'
        : isExistingMatch
            ? 'Hand the device to ${match.currentPlayer.name}. Their private tag reminder and guessing tools will appear on the next screen.'
            : 'Use this protected screen before revealing the first hidden tag and starting the live match.';

    final buttonLabel = isCompletedMatch
        ? 'View Result'
        : isExistingMatch
            ? 'Continue Match'
            : 'Start Match';

    return AppScaffold(
      title: 'Pass the Phone',
      child: Center(
        child: AppCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: AppTextStyles.title),
              const SizedBox(height: AppSpacing.md),
              Text(
                description,
                textAlign: TextAlign.center,
              ),
              if (isExistingMatch && !isCompletedMatch) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Turns played: ${match.turns.length} • Pool size: ${match.characterPoolIds.length}',
                  style: AppTextStyles.subtitle,
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: buttonLabel,
                icon: isCompletedMatch
                    ? Icons.emoji_events_outlined
                    : isExistingMatch
                        ? Icons.visibility_outlined
                        : Icons.play_circle_outline,
                onPressed: () => _handleContinue(context, ref, match: match),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleContinue(
    BuildContext context,
    WidgetRef ref, {
    required GameMatch? match,
  }) async {
    if (match != null) {
      if (match.status == MatchStatus.completed) {
        context.go(AppRoutes.result);
        return;
      }

      context.go(AppRoutes.match);
      return;
    }

    final selectionState = ref.read(categorySelectionControllerProvider);
    final setupState = ref.read(gameSetupControllerProvider);

    if (!selectionState.isComplete ||
        selectionState.playerOneTraitId == null ||
        selectionState.playerTwoTraitId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Complete secret tag selection before starting the match.'),
        ),
      );
      return;
    }

    final catalog = await ref.read(validatedTraitCatalogProvider.future);
    final characters = await ref.read(charactersProvider.future);

    ref.read(matchControllerProvider.notifier).initializeMatch(
          playerOneName: setupState.playerOneName,
          playerTwoName: setupState.playerTwoName,
          hintsPerPlayer: setupState.hints,
          playerOneTraitId: selectionState.playerOneTraitId!,
          playerTwoTraitId: selectionState.playerTwoTraitId!,
          categories: catalog.validCategories,
          characters: characters,
        );

    if (!context.mounted) {
      return;
    }

    context.go(AppRoutes.match);
  }
}
