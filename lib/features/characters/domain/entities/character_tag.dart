import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/core/enums/trait_type.dart';

class CharacterTag {
  const CharacterTag({
    required this.id,
    required this.label,
    required this.type,
    required this.difficulty,
  });

  final String id;
  final String label;
  final TraitType type;
  final DifficultyLevel difficulty;
}
