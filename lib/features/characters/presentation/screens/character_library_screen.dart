import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/features/characters/presentation/controllers/character_library_controller.dart';
import 'package:anime_deduction_tower/features/characters/presentation/providers/character_providers.dart';
import 'package:anime_deduction_tower/features/characters/presentation/widgets/character_card.dart';
import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_button.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:anime_deduction_tower/shared/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CharacterLibraryScreen extends ConsumerWidget {
  const CharacterLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(characterTagsProvider);
    final charactersAsync = ref.watch(filteredCharactersProvider);
    final filterState = ref.watch(characterLibraryControllerProvider);
    final controller = ref.read(characterLibraryControllerProvider.notifier);

    return AppScaffold(
      title: 'Character Library',
      child: tagsAsync.when(
        data: (tags) => charactersAsync.when(
          data: (characters) => ListView(
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Character Data Library', style: AppTextStyles.title),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Showing ${characters.length} characters from the local JSON catalog.',
                      style: AppTextStyles.body,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextField(
                      onChanged: controller.setSearchQuery,
                      decoration: InputDecoration(
                        hintText: 'Search by name or series',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: AppColors.surface.withValues(alpha: 0.65),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const Text('Filter by Tag', style: AppTextStyles.subtitle),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tags
                          .map(
                            (tag) => FilterChip(
                              label: Text(tag.label),
                              selected: filterState.selectedTagId == tag.id,
                              onSelected: (_) => controller.selectTag(tag.id),
                              selectedColor: AppColors.secondary.withValues(alpha: 0.18),
                              side: BorderSide.none,
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const Text('Filter by Difficulty', style: AppTextStyles.subtitle),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: DifficultyLevel.values
                          .map(
                            (difficulty) => FilterChip(
                              label: Text(_labelForDifficulty(difficulty)),
                              selected: filterState.selectedDifficulty == difficulty,
                              onSelected: (_) => controller.selectDifficulty(difficulty),
                              selectedColor: AppColors.primary.withValues(alpha: 0.18),
                              side: BorderSide.none,
                            ),
                          )
                          .toList(),
                    ),
                    if (filterState.hasFilters) ...[
                      const SizedBox(height: AppSpacing.lg),
                      AppButton(
                        label: 'Clear Filters',
                        icon: Icons.filter_alt_off_outlined,
                        isPrimary: false,
                        onPressed: controller.clearFilters,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (characters.isEmpty)
                const AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('No Characters Found', style: AppTextStyles.title),
                      SizedBox(height: AppSpacing.sm),
                      Text('Try changing the selected tag or difficulty filters.'),
                    ],
                  ),
                )
              else
                ...characters.map(
                  (character) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: CharacterCard(character: character),
                  ),
                ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Failed to Load Characters', style: AppTextStyles.title),
                const SizedBox(height: AppSpacing.sm),
                Text('$error'),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => AppCard(
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

  static String _labelForDifficulty(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return 'Easy';
      case DifficultyLevel.medium:
        return 'Medium';
      case DifficultyLevel.hard:
        return 'Hard';
    }
  }
}
