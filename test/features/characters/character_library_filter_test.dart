import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/characters/domain/services/character_library_filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CharacterLibraryFilter', () {
    const filter = CharacterLibraryFilter();
    const characters = [
      Character(
        id: 'shadow_ninja',
        name: 'Shadow Ninja',
        series: 'Original',
        tags: ['black_hair', 'uses_sword'],
        difficulty: DifficultyLevel.medium,
        popularity: 8,
      ),
      Character(
        id: 'solar_fighter',
        name: 'Solar Fighter',
        series: 'Original',
        tags: ['protagonist'],
        difficulty: DifficultyLevel.easy,
        popularity: 9,
      ),
      Character(
        id: 'eclipse_dragon',
        name: 'Eclipse Dragon',
        series: 'Original',
        tags: ['villain', 'non_human'],
        difficulty: DifficultyLevel.hard,
        popularity: 9,
      ),
    ];

    test('filters by tag', () {
      final result = filter.apply(
        characters: characters,
        tagId: 'villain',
      );

      expect(result.map((character) => character.id), ['eclipse_dragon']);
    });

    test('filters by difficulty', () {
      final result = filter.apply(
        characters: characters,
        difficulty: DifficultyLevel.easy,
      );

      expect(result.map((character) => character.id), ['solar_fighter']);
    });

    test('filters by tag and difficulty together', () {
      final result = filter.apply(
        characters: characters,
        tagId: 'black_hair',
        difficulty: DifficultyLevel.medium,
      );

      expect(result.map((character) => character.id), ['shadow_ninja']);
    });
  });
}
