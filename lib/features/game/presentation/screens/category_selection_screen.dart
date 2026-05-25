import 'package:anime_deduction_tower/app/router.dart';
import 'package:anime_deduction_tower/features/characters/presentation/providers/character_providers.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
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

class CategorySelectionScreen extends ConsumerStatefulWidget {
  const CategorySelectionScreen({super.key});

  @override
  ConsumerState<CategorySelectionScreen> createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState
    extends ConsumerState<CategorySelectionScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final catalogAsync = ref.watch(validatedTraitCatalogProvider);
    final charactersAsync = ref.watch(charactersProvider);
    final selectionState = ref.watch(categorySelectionControllerProvider);
    final controller = ref.read(categorySelectionControllerProvider.notifier);

    return catalogAsync.when(
      data: (catalog) {
        final characterTagCounts = charactersAsync.maybeWhen(
          data: (characters) {
            final counts = <String, int>{};
            for (final character in characters) {
              for (final tag in character.tags) {
                counts[tag] = (counts[tag] ?? 0) + 1;
              }
            }
            return counts;
          },
          orElse: () => const <String, int>{},
        );

        final categories = [...catalog.validCategories]
          ..sort((a, b) => a.label.compareTo(b.label));

        final filteredCategories = categories.where((category) {
          final query = _searchQuery.trim().toLowerCase();
          if (query.isEmpty) {
            return true;
          }

          return category.label.toLowerCase().contains(query) ||
              category.hintType.toLowerCase().contains(query);
        }).toList();
        TraitCategory? selectedCategory;
        final selectedId = selectionState.currentSelectedTraitId;
        if (selectedId != null) {
          for (final category in categories) {
            if (category.id == selectedId) {
              selectedCategory = category;
              break;
            }
          }
        }

        return AppScaffold(
          title: 'Secret Tag Selection',
          bottomBar: _CategorySelectionActionBar(
            selectionState: selectionState,
            selectedCategory: selectedCategory,
            onConfirm: selectionState.canConfirmCurrentSelection
                ? () async {
                    if (selectionState.isSelectingPlayerOne) {
                      controller.confirmCurrentSelection();
                      await AppDialog.showInfo(
                        context,
                        title: 'Player 1 Tag Saved',
                        message:
                            'Pass the device to Player 2 and choose the next hidden tag.',
                      );
                      return;
                    }

                    controller.confirmCurrentSelection();
                  }
                : null,
            onContinue: selectionState.isComplete
                ? () => context.go(AppRoutes.turnTransition)
                : null,
            onReset: controller.reset,
          ),
          child: ListView(
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'PRIVATE PICK',
                        style: AppTextStyles.label,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const Text(
                      'Choose the hidden tag for this player.',
                      style: AppTextStyles.title,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      selectionState.isSelectingPlayerOne
                          ? 'Player 1 is choosing privately. Only the active player should be looking at the screen.'
                          : 'Player 2 is choosing privately. Keep the device hidden from the opponent.',
                      style: AppTextStyles.subtitle.copyWith(height: 1.45),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _SelectionPill(
                          icon: Icons.person_outline,
                          label: selectionState.isSelectingPlayerOne
                              ? 'Player 1'
                              : 'Player 2',
                        ),
                        _SelectionPill(
                          icon: Icons.style_outlined,
                          label: '${categories.length} playable tags',
                        ),
                        _SelectionPill(
                          icon: Icons.search,
                          label: '${filteredCategories.length} shown',
                        ),
                      ],
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
                      const Text(
                        'Catalog validation warnings',
                        style: AppTextStyles.title,
                      ),
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
              const SizedBox(height: AppSpacing.md),
              TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: const InputDecoration(
                  labelText: 'Search tags',
                  hintText: 'Search by tag label or hint type',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (filteredCategories.isEmpty)
                const AppCard(
                  child: Text('No tags match the current search.'),
                )
              else
                ...filteredCategories.map((category) {
                  final isSelected =
                      selectionState.currentSelectedTraitId == category.id;
                  final count = characterTagCounts[category.tagId] ?? 0;

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
                                    child: Text(
                                      category.label,
                                      style: AppTextStyles.title
                                          .copyWith(fontSize: 20),
                                    ),
                                  ),
                                  if (isSelected)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.success
                                            .withValues(alpha: 0.16),
                                        borderRadius:
                                            BorderRadius.circular(999),
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
                              const SizedBox(height: AppSpacing.sm),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  _SelectionMeta(
                                    label: 'Type',
                                    value: category.hintType,
                                  ),
                                  _SelectionMeta(
                                    label: 'Difficulty',
                                    value: category.difficulty.name,
                                  ),
                                  _SelectionMeta(
                                    label: 'Characters',
                                    value: '$count',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              const SizedBox(height: 200),
            ],
          ),
        );
      },
      loading: () => const AppScaffold(
        title: 'Secret Tag Selection',
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => AppScaffold(
        title: 'Secret Tag Selection',
        child: AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Failed to Load Tags', style: AppTextStyles.title),
              const SizedBox(height: AppSpacing.sm),
              Text('$error'),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectionPill extends StatelessWidget {
  const _SelectionPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.secondary),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _SelectionMeta extends StatelessWidget {
  const _SelectionMeta({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        '$label: $value',
        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _CategorySelectionActionBar extends StatelessWidget {
  const _CategorySelectionActionBar({
    required this.selectionState,
    required this.onReset,
    this.selectedCategory,
    this.onConfirm,
    this.onContinue,
  });

  final CategorySelectionState selectionState;
  final TraitCategory? selectedCategory;
  final VoidCallback? onConfirm;
  final VoidCallback? onContinue;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final statusText = selectedCategory == null
        ? 'No tag selected yet.'
        : 'Selected: ${selectedCategory!.label}';

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  selectionState.isComplete
                      ? 'Secret tags ready'
                      : selectionState.isSelectingPlayerOne
                          ? 'Player 1 selection'
                          : 'Player 2 selection',
                  style: AppTextStyles.title,
                ),
              ),
              if (selectedCategory != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    selectedCategory!.hintType,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(statusText, style: AppTextStyles.subtitle),
          const SizedBox(height: AppSpacing.md),
          if (!selectionState.isComplete)
            AppButton(
              label: selectionState.isSelectingPlayerOne
                  ? 'Lock Player 1 Tag'
                  : 'Save Player 2 Tag',
              icon: selectionState.isSelectingPlayerOne
                  ? Icons.lock_outline_rounded
                  : Icons.check_circle_outline_rounded,
              onPressed: onConfirm,
            )
          else ...[
            AppButton(
              label: 'Continue to Turn Transition',
              icon: Icons.swap_horiz_rounded,
              onPressed: onContinue,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton(
              label: 'Reset Secret Selection',
              icon: Icons.restart_alt_rounded,
              isPrimary: false,
              onPressed: onReset,
            ),
          ],
        ],
      ),
    );
  }
}
