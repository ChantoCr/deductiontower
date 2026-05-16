import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/core/enums/trait_type.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character_tag.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/game/domain/services/trait_catalog_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TraitCatalogValidator', () {
    const validator = TraitCatalogValidator();

    test('keeps only categories that reference valid tags and enough characters', () {
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
          id: 'storm_samurai',
          name: 'Storm Samurai',
          series: 'Original',
          tags: ['black_hair'],
          difficulty: DifficultyLevel.easy,
          popularity: 7,
        ),
      ];

      const tags = [
        CharacterTag(
          id: 'black_hair',
          label: 'Black Hair',
          type: TraitType.appearance,
          difficulty: DifficultyLevel.easy,
        ),
        CharacterTag(
          id: 'uses_sword',
          label: 'Uses Sword',
          type: TraitType.weapon,
          difficulty: DifficultyLevel.easy,
        ),
      ];

      const categories = [
        TraitCategory(
          id: 'black_hair',
          label: 'Black Hair',
          tagId: 'black_hair',
          difficulty: DifficultyLevel.easy,
          minCharacters: 2,
          hintType: 'appearance',
        ),
        TraitCategory(
          id: 'uses_sword',
          label: 'Uses Sword',
          tagId: 'uses_sword',
          difficulty: DifficultyLevel.easy,
          minCharacters: 2,
          hintType: 'weapon',
        ),
      ];

      final result = validator.validate(
        characters: characters,
        tags: tags,
        categories: categories,
      );

      expect(result.validCategories.map((category) => category.id), ['black_hair']);
      expect(result.issues.map((issue) => issue.code), contains('not_enough_characters'));
    });

    test('reports missing category tags and invalid character tags', () {
      const characters = [
        Character(
          id: 'void_beast',
          name: 'Void Beast',
          series: 'Original',
          tags: ['non_human'],
          difficulty: DifficultyLevel.medium,
          popularity: 7,
        ),
      ];

      const tags = [
        CharacterTag(
          id: 'villain',
          label: 'Villain',
          type: TraitType.role,
          difficulty: DifficultyLevel.easy,
        ),
      ];

      const categories = [
        TraitCategory(
          id: 'non_human',
          label: 'Non-Human',
          tagId: 'non_human',
          difficulty: DifficultyLevel.medium,
          minCharacters: 1,
          hintType: 'origin',
        ),
      ];

      final result = validator.validate(
        characters: characters,
        tags: tags,
        categories: categories,
      );

      expect(result.validCategories, isEmpty);
      expect(result.issues.map((issue) => issue.code), contains('invalid_character_tag'));
      expect(result.issues.map((issue) => issue.code), contains('missing_category_tag'));
    });
  });
}
