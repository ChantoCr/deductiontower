import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/core/enums/trait_type.dart';
import 'package:anime_deduction_tower/features/characters/data/models/character_tag_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CharacterTagModel', () {
    test('parses JSON into model and maps to entity', () {
      final model = CharacterTagModel.fromJson({
        'id': 'black_hair',
        'label': 'Black Hair',
        'type': 'appearance',
        'difficulty': 'easy',
      });

      final entity = model.toEntity();

      expect(model.id, 'black_hair');
      expect(model.type, TraitType.appearance);
      expect(entity.label, 'Black Hair');
      expect(entity.difficulty, DifficultyLevel.easy);
    });

    test('falls back to default enum values for unknown input', () {
      final model = CharacterTagModel.fromJson({
        'id': 'unknown_tag',
        'label': 'Unknown Tag',
        'type': 'invalid_type',
        'difficulty': 'invalid_difficulty',
      });

      expect(model.type, TraitType.appearance);
      expect(model.difficulty, DifficultyLevel.easy);
    });
  });
}
