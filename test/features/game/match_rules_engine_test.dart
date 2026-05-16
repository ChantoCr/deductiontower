import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/game/domain/services/match_rules_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MatchRulesEngine', () {
    const engine = MatchRulesEngine();
    const category = TraitCategory(
      id: 'villain',
      label: 'Villain',
      tagId: 'villain',
      difficulty: DifficultyLevel.easy,
      minCharacters: 1,
      hintType: 'role',
    );

    test('validates correct character guesses', () {
      const character = Character(
        id: 'crimson_emperor',
        name: 'Crimson Emperor',
        series: 'Original',
        tags: ['villain'],
        difficulty: DifficultyLevel.medium,
        popularity: 7,
      );

      expect(
        engine.isCharacterGuessCorrect(character: character, secretTrait: category),
        isTrue,
      );
    });

    test('validates incorrect trait guesses', () {
      expect(
        engine.isTraitGuessCorrect(guessedTraitId: 'black_hair', secretTrait: category),
        isFalse,
      );
    });
  });
}
