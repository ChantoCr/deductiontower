import 'package:anime_deduction_tower/app/router.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/category_selection_controller.dart';
import 'package:anime_deduction_tower/features/game/presentation/providers/trait_category_providers.dart';
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

class CategorySelectionScreen extends ConsumerWidget {
  const CategorySelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogAsync = ref.watch(validatedTraitCatalogProvider);
    final selectionState = ref.watch(categorySelectionControllerProvider);
    final controller = ref.read(categorySelectionControllerProvider.notifier);

    return AppScaffold(
      title: 'Secret Trait Selection',
      child: catalogAsync.when(
        data: (catalog) {
          final categories = catalog.validCategories;

          return ListView(
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Protected Selection Flow', style: AppTextStyles.title),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      selectionState.isSelectingPlayerOne
                          ? 'Player 1 is choosing a secret trait.'
                          : 'Player 2 is choosing a secret trait.',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Only validated categories are shown. Invalid categories are filtered out before selection.',
                      style: AppTextStyles.subtitle,
                    ),
                  ],
                ),
              ),
              if (catalog.hasIssues) ...[
                const SizedBox(height: AppSpacing.md),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Catalog Validation Warnings', style: AppTextStyles.title),
                      const SizedBox(height: AppSpacing.sm),
                      ...catalog.issues.map(
                        (issue) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text('• ${issue.message}'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              ...categories.map(
                (category) {
                  final isSelected = selectionState.currentSelectedTraitId == category.id;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () => controller.selectTrait(category.id),
                        child: AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(category.label, style: AppTextStyles.title),
                                  ),
                                  if (isSelected)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.success.withOpacity(0.16),
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                      child: const Text(
                                        'Selected',
                                        style: TextStyle(
                                          color: AppColors.success,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'Hint type: ${category.hintType}',
                                style: AppTextStyles.subtitle,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text('Difficulty: ${category.difficulty.name}'),
                              Text('Minimum characters: ${category.minCharacters}'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
              if (!selectionState.isComplete)
                AppButton(
                  label: selectionState.isSelectingPlayerOne
                      ? 'Lock Player 1 Trait'
                      : 'Save Player 2 Trait',
                  icon: selectionState.isSelectingPlayerOne
                      ? Icons.lock_outline
                      : Icons.check_circle_outline,
                  onPressed: selectionState.canConfirmCurrentSelection
                      ? () async {
                          if (selectionState.isSelectingPlayerOne) {
                            controller.confirmCurrentSelection();
                            await AppDialog.showInfo(
                              context,
                              title: 'Player 1 Trait Saved',
                              message:
                                  'Pass the device to Player 2 and select the next secret trait.',
                            );
                            if (!context.mounted) {
                              return;
                            }
                            return;
                          }

                          controller.confirmCurrentSelection();
                        }
                      : null,
                ),
              if (selectionState.isComplete) ...[
                AppButton(
                  label: 'Continue to Turn Transition',
                  icon: Icons.swap_horiz,
                  onPressed: () => context.go(AppRoutes.turnTransition),
                ),
                const SizedBox(height: AppSpacing.md),
                AppButton(
                  label: 'Reset Trait Selection',
                  icon: Icons.restart_alt,
                  isPrimary: false,
                  onPressed: controller.reset,
                ),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Failed to Load Categories', style: AppTextStyles.title),
              const SizedBox(height: AppSpacing.sm),
              Text('$error'),
            ],
          ),
        ),
      ),
    );
  }
}
