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

  @override
  Widget build(BuildContext context) {
    final charactersAsync = ref.watch(charactersProvider);

    return charactersAsync.when(
      data: (characters) {
        final pool = _buildPool(characters);
        Character? selectedCharacter;
        for (final item in pool) {
          if (item.id == widget.selectedCharacterId) {
            selectedCharacter = item;
            break;
          }
        }

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
                  _PoolInfoPill(label: '${pool.length} shown'),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Search the shared pool by character name or series, then tap a row to stage your next character guess instantly.',
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
              if (selectedCharacter != null) ...[
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Selected: ${selectedCharacter.name} • ${selectedCharacter.series}',
                          style: AppTextStyles.body
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 420,
                child: pool.isEmpty
                    ? const Center(
                        child: Text(
                          'No characters match the current pool search.',
                        ),
                      )
                    : ListView.separated(
                        itemCount: pool.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final character = pool[index];
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
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '★ ${character.popularity}',
                                          style: AppTextStyles.body.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          character.difficulty.name,
                                          style: AppTextStyles.subtitle
                                              .copyWith(fontSize: 13),
                                        ),
                                      ],
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

  List<Character> _buildPool(List<Character> characters) {
    final allowedIds = widget.availableCharacterIds?.toSet();
    final normalizedQuery = _searchQuery.trim().toLowerCase();

    final filtered = characters.where((character) {
      final isInPool = allowedIds == null ||
          allowedIds.isEmpty ||
          allowedIds.contains(character.id);
      final matchesQuery = normalizedQuery.isEmpty ||
          character.name.toLowerCase().contains(normalizedQuery) ||
          character.series.toLowerCase().contains(normalizedQuery);

      return isInPool && matchesQuery;
    }).toList()
      ..sort((first, second) => second.popularity.compareTo(first.popularity));

    return filtered;
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
