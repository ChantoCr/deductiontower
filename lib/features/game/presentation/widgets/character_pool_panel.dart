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
  late final TextEditingController _searchController;
  late final TextEditingController _seriesSearchController;

  String _searchQuery = '';
  String _seriesSearchQuery = '';
  String? _selectedSeries;
  DifficultyLevel? _selectedDifficulty;
  String? _hoveredCharacterId;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _seriesSearchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _seriesSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final charactersAsync = ref.watch(charactersProvider);

    return charactersAsync.when(
      data: (characters) {
        final allPool = _buildAllowedPool(characters);
        final filteredPool = _applyFilters(allPool);
        final selectedCharacter = _findSelectedCharacter(allPool);
        final seriesOptions = _buildSeriesOptions(allPool);
        final visibleSeriesOptions = _buildVisibleSeriesOptions(seriesOptions);
        final isShowingLimitedSeries =
            _seriesSearchQuery.trim().isEmpty && seriesOptions.length > 12;

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
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  labelText: 'Search pool',
                  hintText: 'Search by character name or series',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.trim().isEmpty
                      ? null
                      : IconButton(
                          onPressed: _clearSearchQuery,
                          icon: const Icon(Icons.close),
                        ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Text(
                    'Series filters',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  if (seriesOptions.isNotEmpty)
                    _PoolInfoPill(label: '${seriesOptions.length} series'),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _seriesSearchController,
                onChanged: (value) =>
                    setState(() => _seriesSearchQuery = value),
                decoration: InputDecoration(
                  labelText: 'Find a series chip',
                  hintText: 'Search the pool series list',
                  prefixIcon: const Icon(Icons.filter_alt_outlined),
                  suffixIcon: _seriesSearchQuery.trim().isEmpty
                      ? null
                      : IconButton(
                          onPressed: _clearSeriesSearchQuery,
                          icon: const Icon(Icons.close),
                        ),
                ),
              ),
              if (isShowingLimitedSeries) ...[
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  'Showing the top 12 series by pool count. Search above to reveal more series chips.',
                  style: AppTextStyles.subtitle,
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                child: visibleSeriesOptions.isEmpty
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.12),
                          ),
                        ),
                        child: const Text(
                          'No series chips match the current series search.',
                          style: AppTextStyles.subtitle,
                        ),
                      )
                    : ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 168),
                        child: SingleChildScrollView(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              ChoiceChip(
                                label: Text('All series • ${allPool.length}'),
                                selected: _selectedSeries == null,
                                onSelected: (_) =>
                                    setState(() => _selectedSeries = null),
                              ),
                              ...visibleSeriesOptions.map(
                                (series) => ChoiceChip(
                                  label: Text(
                                    '${series.label} • ${series.count}',
                                  ),
                                  selected: _selectedSeries == series.label,
                                  onSelected: (_) => setState(
                                    () => _selectedSeries =
                                        _selectedSeries == series.label
                                            ? null
                                            : series.label,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                  curve: Curves.easeOutCubic,
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
                          final isHovered = _hoveredCharacterId == character.id;

                          return MouseRegion(
                            onEnter: (_) => setState(
                              () => _hoveredCharacterId = character.id,
                            ),
                            onExit: (_) {
                              if (_hoveredCharacterId == character.id) {
                                setState(() => _hoveredCharacterId = null);
                              }
                            },
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(18),
                                onTap: () =>
                                    widget.onCharacterSelected?.call(character),
                                child: AnimatedScale(
                                  duration: const Duration(milliseconds: 160),
                                  curve: Curves.easeOutCubic,
                                  scale: isHovered ? 1.01 : 1,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    curve: Curves.easeOutCubic,
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primary
                                              .withValues(alpha: 0.16)
                                          : isHovered
                                              ? AppColors.primary
                                                  .withValues(alpha: 0.08)
                                              : AppColors.surface
                                                  .withValues(alpha: 0.72),
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.secondary
                                                .withValues(alpha: 0.45)
                                            : isHovered
                                                ? AppColors.secondary
                                                    .withValues(alpha: 0.26)
                                                : AppColors.primary
                                                    .withValues(alpha: 0.12),
                                      ),
                                      boxShadow: isHovered
                                          ? [
                                              BoxShadow(
                                                color: AppColors.secondary
                                                    .withValues(alpha: 0.12),
                                                blurRadius: 16,
                                                offset: const Offset(0, 8),
                                              ),
                                            ]
                                          : const [],
                                    ),
                                    child: Row(
                                      children: [
                                        AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 180),
                                          curve: Curves.easeOutCubic,
                                          width: 42,
                                          height: 42,
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? AppColors.secondary
                                                    .withValues(alpha: 0.18)
                                                : isHovered
                                                    ? AppColors.secondary
                                                        .withValues(alpha: 0.12)
                                                    : AppColors.primary
                                                        .withValues(
                                                        alpha: 0.12,
                                                      ),
                                            borderRadius:
                                                BorderRadius.circular(14),
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
                                                style:
                                                    AppTextStyles.body.copyWith(
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
                                                  if (!isSelected)
                                                    _InlineMetaChip(
                                                      label: isHovered
                                                          ? 'Tap to stage'
                                                          : 'Pool pick',
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: AppSpacing.sm),
                                        AnimatedSwitcher(
                                          duration:
                                              const Duration(milliseconds: 160),
                                          child: Icon(
                                            isSelected
                                                ? Icons.check_circle
                                                : isHovered
                                                    ? Icons.touch_app_rounded
                                                    : Icons
                                                        .arrow_forward_ios_rounded,
                                            key: ValueKey(
                                              '${character.id}-$isSelected-$isHovered',
                                            ),
                                            size: isSelected ? 20 : 18,
                                            color: isSelected
                                                ? AppColors.secondary
                                                : isHovered
                                                    ? AppColors.secondary
                                                    : AppColors.muted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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

  void _clearSearchQuery() {
    _searchController.clear();
    setState(() => _searchQuery = '');
  }

  void _clearSeriesSearchQuery() {
    _seriesSearchController.clear();
    setState(() => _seriesSearchQuery = '');
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

  List<_SeriesOption> _buildSeriesOptions(List<Character> pool) {
    final counts = <String, int>{};
    for (final character in pool) {
      counts[character.series] = (counts[character.series] ?? 0) + 1;
    }

    final entries = counts.entries.map((entry) {
      return _SeriesOption(label: entry.key, count: entry.value);
    }).toList()
      ..sort((a, b) {
        final countComparison = b.count.compareTo(a.count);
        if (countComparison != 0) {
          return countComparison;
        }
        return a.label.compareTo(b.label);
      });

    return entries;
  }

  List<_SeriesOption> _buildVisibleSeriesOptions(List<_SeriesOption> options) {
    final normalizedQuery = _seriesSearchQuery.trim().toLowerCase();
    final filtered = normalizedQuery.isEmpty
        ? options.take(12).toList()
        : options
            .where(
              (option) => option.label.toLowerCase().contains(normalizedQuery),
            )
            .take(24)
            .toList();

    final selectedSeries = _selectedSeries;
    if (selectedSeries == null) {
      return filtered;
    }

    final containsSelected =
        filtered.any((option) => option.label == selectedSeries);
    if (containsSelected) {
      return filtered;
    }

    for (final option in options) {
      if (option.label == selectedSeries) {
        return [option, ...filtered];
      }
    }

    return filtered;
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

class _SeriesOption {
  const _SeriesOption({required this.label, required this.count});

  final String label;
  final int count;
}
