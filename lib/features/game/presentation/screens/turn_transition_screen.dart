import 'package:anime_deduction_tower/app/router.dart';
import 'package:anime_deduction_tower/features/characters/presentation/providers/character_providers.dart';
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
    return AppScaffold(
      title: 'Pass the Phone',
      child: Center(
        child: AppCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Prepare the Next Player', style: AppTextStyles.title),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Use this protected screen before revealing the next secret trait or starting the match.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'Start Match',
                icon: Icons.play_circle_outline,
                onPressed: () async {
                  final selectionState = ref.read(categorySelectionControllerProvider);
                  final setupState = ref.read(gameSetupControllerProvider);

                  if (!selectionState.isComplete ||
                      selectionState.playerOneTraitId == null ||
                      selectionState.playerTwoTraitId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Complete secret trait selection before starting the match.'),
                      ),
                    );
                    return;
                  }

                  final catalog = await ref.read(validatedTraitCatalogProvider.future);
                  final characters = await ref.read(charactersProvider.future);

                  ref
                      .read(matchControllerProvider.notifier)
                      .initializeMatch(
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
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
