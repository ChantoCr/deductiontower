import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';

class CharacterLibraryFilter {
  const CharacterLibraryFilter();

  List<Character> apply({
    required List<Character> characters,
    String? tagId,
    DifficultyLevel? difficulty,
  }) {
    return characters.where((character) {
      final matchesTag = tagId == null || character.tags.contains(tagId);
      final matchesDifficulty =
          difficulty == null || character.difficulty == difficulty;

      return matchesTag && matchesDifficulty;
    }).toList();
  }
}
