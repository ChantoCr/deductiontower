import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';

class HintEngine {
  const HintEngine();

  String generateHint(TraitCategory category) {
    return 'The hidden trait is related to ${category.hintType} and is ${category.difficulty.name} difficulty.';
  }
}
