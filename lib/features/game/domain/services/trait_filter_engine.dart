import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';

class TraitFilterEngine {
  const TraitFilterEngine();

  List<Character> filterCharactersByTrait(
    List<Character> characters,
    TraitCategory category,
  ) {
    return characters.where((character) => character.tags.contains(category.tagId)).toList();
  }
}
