import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/characters/presentation/providers/character_providers.dart';
import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CharacterPoolPanel extends ConsumerStatefulWidget {
  const CharacterPoolPanel({
    super.key,
    this.availableCharacterIds,
    this.selectedCharacterId,
    this.onCharacterSelected,
  });

  final List<String>? availableCharacterIds;
  final String? selectedCharacterId;
  final ValueChanged<Character>? onCharacterSelected;

  @override
  ConsumerState<CharacterPoolPanel> createState() => _CharacterPoolPanelState();
}

class _CharacterPoolPanelState extends ConsumerState<CharacterPoolPanel> {
  String _searchQuery = '';
  String? _selectedSeries;
  DifficultyLevel? _selectedDifficulty;

  @override
  Widget build(BuildContext context) {
    final charactersAsync = ref.watch(charactersProvider);

    return charactersAsync.when(
      data: (characters) {
        final allPool = _buildAllowedPool(characters);
        final filteredPool = _applyFilters(allPool);
        final selectedCharacter = _findSelectedCharacter(allPool);
        final seriesOptions = _buildSeriesOptions(allPool);

        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Character Pool Browser',
                      style: AppTextStyles.title,
                    ),
                  ),
                  _PoolInfoPill(label: '${filteredPool.length} shown'),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Search the shared pool by character name or series, then narrow the list with series and difficulty chips before staging your next guess.',
                style: AppTextStyles.subtitle.copyWith(height: 1.45),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  labelText: 'Search pool',
                  hintText: 'Search by character name or series',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.trim().isEmpty
                      ? null
                      : IconButton(
                          onPressed: () => setState(() => _searchQuery = ''),
                          icon: const Icon(Icons.close),
                        ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Series filters',
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.sm),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: const Text('All series'),
                        selected: _selectedSeries == null,
                        onSelected: (_) =>
                            setState(() => _selectedSeries = null),
                      ),
                    ),
                    ...seriesOptions.map(
                      (series) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(series),
                          selected: _selectedSeries == series,
                          onSelected: (_) => setState(
                            () => _selectedSeries =
                                _selectedSeries == series ? null : series,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Difficulty filters',
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('All difficulties'),
                    selected: _selectedDifficulty == null,
                    onSelected: (_) =>
                        setState(() => _selectedDifficulty = null),
                  ),
                  ...DifficultyLevel.values.map(
                    (difficulty) => ChoiceChip(
                      label: Text(_formatDifficulty(difficulty)),
                      selected: _selectedDifficulty == difficulty,
                      onSelected: (_) => setState(
                        () => _selectedDifficulty =
                            _selectedDifficulty == difficulty
                                ? null
                                : difficulty,
                      ),
                    ),
                  ),
                ],
              ),
              if (selectedCharacter != null) ...[
                const SizedBox(height: AppSpacing.md),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.24),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current staged guess',
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${selectedCharacter.name} • ${selectedCharacter.series}',
                              style: AppTextStyles.subtitle.copyWith(
                                color: AppColors.text,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'The action console below stays pinned, so you can submit this guess without scrolling away from the pool.',
                              style:
                                  AppTextStyles.subtitle.copyWith(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 440,
                child: filteredPool.isEmpty
                    ? const Center(
                        child: Text(
                          'No characters match the current pool filters.',
                        ),
                      )
                    : ListView.separated(
                        itemCount: filteredPool.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final character = filteredPool[index];
                          final isSelected =
                              widget.selectedCharacterId == character.id;

                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: () =>
                                  widget.onCharacterSelected?.call(character),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                          .withValues(alpha: 0.16)
                                      : AppColors.surface
                                          .withValues(alpha: 0.72),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.secondary
                                            .withValues(alpha: 0.45)
                                        : AppColors.primary
                                            .withValues(alpha: 0.12),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 42,
                                      height: 42,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.secondary
                                                .withValues(alpha: 0.18)
                                            : AppColors.primary
                                                .withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${index + 1}',
                                        style: AppTextStyles.body.copyWith(
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.md),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            character.name,
                                            style: AppTextStyles.body.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            character.series,
                                            style: AppTextStyles.subtitle,
                                          ),
                                          const SizedBox(height: 6),
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 6,
                                            children: [
                                              _InlineMetaChip(
                                                label: _formatDifficulty(
                                                  character.difficulty,
                                                ),
                                              ),
                                              _InlineMetaChip(
                                                label:
                                                    '★ ${character.popularity}',
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    Icon(
                                      isSelected
                                          ? Icons.check_circle
                                          : Icons.arrow_forward_ios_rounded,
                                      size: isSelected ? 20 : 16,
                                      color: isSelected
                                          ? AppColors.secondary
                                          : AppColors.muted,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
      loading: () => const AppCard(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (error, stackTrace) => AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Failed to Load Character Pool',
              style: AppTextStyles.title,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text('$error'),
          ],
        ),
      ),
    );
  }

  List<Character> _buildAllowedPool(List<Character> characters) {
    final allowedIds = widget.availableCharacterIds?.toSet();

    final filtered = characters.where((character) {
      return allowedIds == null ||
          allowedIds.isEmpty ||
          allowedIds.contains(character.id);
    }).toList()
      ..sort((first, second) => second.popularity.compareTo(first.popularity));

    return filtered;
  }

  List<Character> _applyFilters(List<Character> characters) {
    final normalizedQuery = _searchQuery.trim().toLowerCase();

    return characters.where((character) {
      final matchesQuery = normalizedQuery.isEmpty ||
          character.name.toLowerCase().contains(normalizedQuery) ||
          character.series.toLowerCase().contains(normalizedQuery);
      final matchesSeries =
          _selectedSeries == null || character.series == _selectedSeries;
      final matchesDifficulty = _selectedDifficulty == null ||
          character.difficulty == _selectedDifficulty;

      return matchesQuery && matchesSeries && matchesDifficulty;
    }).toList();
  }

  Character? _findSelectedCharacter(List<Character> pool) {
    final selectedId = widget.selectedCharacterId;
    if (selectedId == null) {
      return null;
    }

    for (final item in pool) {
      if (item.id == selectedId) {
        return item;
      }
    }

    return null;
  }

  List<String> _buildSeriesOptions(List<Character> pool) {
    final counts = <String, int>{};
    for (final character in pool) {
      counts[character.series] = (counts[character.series] ?? 0) + 1;
    }

    final entries = counts.entries.toList()
      ..sort((a, b) {
        final countComparison = b.value.compareTo(a.value);
        if (countComparison != 0) {
          return countComparison;
        }
        return a.key.compareTo(b.key);
      });

    return entries.take(12).map((entry) => entry.key).toList();
  }

  String _formatDifficulty(DifficultyLevel difficulty) {
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

class _PoolInfoPill extends StatelessWidget {
  const _PoolInfoPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _InlineMetaChip extends StatelessWidget {
  const _InlineMetaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.subtitle.copyWith(fontSize: 12),
      ),
    );
  }
}
