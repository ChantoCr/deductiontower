import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/features/characters/data/models/character_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CharacterModel', () {
    test('parses JSON into model and maps to entity', () {
      final model = CharacterModel.fromJson({
        'id': 'shadow_ninja',
        'name': 'Shadow Ninja',
        'series': 'Original',
        'image': 'assets/images/placeholders/shadow_ninja.png',
        'tags': ['black_hair', 'uses_sword'],
        'difficulty': 'medium',
        'popularity': 8,
      });

      final entity = model.toEntity();

      expect(model.id, 'shadow_ninja');
      expect(model.difficulty, DifficultyLevel.medium);
      expect(entity.name, 'Shadow Ninja');
      expect(entity.tags, ['black_hair', 'uses_sword']);
    });

    test('uses safe defaults when optional JSON values are missing', () {
      final model = CharacterModel.fromJson({
        'id': 'mystery_fighter',
        'name': 'Mystery Fighter',
        'tags': <String>[],
      });

      expect(model.series, 'Original');
      expect(model.difficulty, DifficultyLevel.easy);
      expect(model.popularity, 0);
      expect(model.image, isNull);
    });
  });
}
