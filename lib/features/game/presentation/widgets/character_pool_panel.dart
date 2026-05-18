import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/characters/presentation/providers/character_providers.dart';
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

        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Character Pool', style: AppTextStyles.title),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Browse available guesses or search by character name before locking in a turn. Tap a name to fill your current guess automatically.',
                style: AppTextStyles.body,
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: const InputDecoration(
                  labelText: 'Search names in the pool',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text('${pool.length} characters available', style: AppTextStyles.subtitle),
              const SizedBox(height: AppSpacing.sm),
              if (pool.isEmpty)
                const Text('No characters match the current pool search.')
              else
                ...pool.map(
                  (character) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      selected: widget.selectedCharacterId == character.id,
                      selectedTileColor: Theme.of(context).colorScheme.primary.withAlpha(24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: Text(character.name),
                      subtitle: Text(character.series),
                      trailing: Text('★ ${character.popularity}'),
                      onTap: () => widget.onCharacterSelected?.call(character),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
      loading: () => const AppCard(child: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Failed to Load Character Pool', style: AppTextStyles.title),
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
      final isInPool = allowedIds == null || allowedIds.isEmpty || allowedIds.contains(character.id);
      final matchesQuery = normalizedQuery.isEmpty ||
          character.name.toLowerCase().contains(normalizedQuery);

      return isInPool && matchesQuery;
    }).toList()
      ..sort((first, second) => second.popularity.compareTo(first.popularity));

    return filtered;
  }
}
