import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';

class CharacterLibraryFilter {
  const CharacterLibraryFilter();

  List<Character> apply({
    required List<Character> characters,
    String? tagId,
    DifficultyLevel? difficulty,
    String searchQuery = '',
  }) {
    final normalizedQuery = searchQuery.trim().toLowerCase();

    return characters.where((character) {
      final matchesTag = tagId == null || character.tags.contains(tagId);
      final matchesDifficulty =
          difficulty == null || character.difficulty == difficulty;
      final matchesSearch =
          normalizedQuery.isEmpty ||
          character.name.toLowerCase().contains(normalizedQuery) ||
          character.series.toLowerCase().contains(normalizedQuery);

      return matchesTag && matchesDifficulty && matchesSearch;
    }).toList();
  }
}
