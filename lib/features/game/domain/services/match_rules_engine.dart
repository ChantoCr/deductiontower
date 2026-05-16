import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/game_match.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';

class MatchRulesEngine {
  const MatchRulesEngine();

  bool isCharacterGuessCorrect({
    required Character character,
    required TraitCategory secretTrait,
  }) {
    return character.tags.contains(secretTrait.tagId);
  }

  bool isTraitGuessCorrect({
    required String guessedTraitId,
    required TraitCategory secretTrait,
  }) {
    return guessedTraitId == secretTrait.id;
  }

  bool hasWinner(GameMatch match) => match.winnerId != null;
}
