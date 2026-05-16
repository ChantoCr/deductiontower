import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/game/domain/services/hint_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HintEngine', () {
    test('returns a short hint without revealing the exact label', () {
      const engine = HintEngine();
      const category = TraitCategory(
        id: 'black_hair',
        label: 'Black Hair',
        tagId: 'black_hair',
        difficulty: DifficultyLevel.easy,
        minCharacters: 1,
        hintType: 'appearance',
      );

      final hint = engine.generateHint(category);

      expect(hint, contains('appearance'));
      expect(hint, isNot(contains('Black Hair')));
    });
  });
}
