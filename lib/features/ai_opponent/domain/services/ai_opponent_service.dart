import 'package:anime_deduction_tower/core/enums/ai_difficulty.dart';
import 'package:anime_deduction_tower/features/ai_opponent/domain/entities/ai_turn_decision.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/game_match.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';

abstract class AiOpponentService {
  const AiOpponentService();

  String chooseSecretTraitId({
    required List<TraitCategory> categories,
    String? excludedTraitId,
  });

  AiTurnDecision chooseTurn({
    required GameMatch match,
    required List<TraitCategory> categories,
    required List<Character> characters,
    required AiDifficulty difficulty,
  });
}
