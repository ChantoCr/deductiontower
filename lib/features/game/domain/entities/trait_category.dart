import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';

class TraitCategory {
  const TraitCategory({
    required this.id,
    required this.label,
    required this.tagId,
    required this.difficulty,
    required this.minCharacters,
    required this.hintType,
  });

  final String id;
  final String label;
  final String tagId;
  final DifficultyLevel difficulty;
  final int minCharacters;
  final String hintType;
}
