import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/game/domain/services/trait_filter_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TraitFilterEngine', () {
    test('filters characters that contain the selected trait tag', () {
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
      ];

      const category = TraitCategory(
        id: 'black_hair',
        label: 'Black Hair',
        tagId: 'black_hair',
        difficulty: DifficultyLevel.easy,
        minCharacters: 1,
        hintType: 'appearance',
      );

      const engine = TraitFilterEngine();

      final result = engine.filterCharactersByTrait(characters, category);

      expect(result.map((character) => character.id), ['shadow_ninja']);
    });
  });
}
