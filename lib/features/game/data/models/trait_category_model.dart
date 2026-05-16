import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';

class TraitCategoryModel {
  const TraitCategoryModel({
    required this.id,
    required this.label,
    required this.tagId,
    required this.difficulty,
    required this.minCharacters,
    required this.hintType,
  });

  factory TraitCategoryModel.fromJson(Map<String, dynamic> json) {
    return TraitCategoryModel(
      id: json['id'] as String,
      label: json['label'] as String,
      tagId: json['tagId'] as String,
      difficulty: DifficultyLevel.fromValue(json['difficulty'] as String? ?? 'easy'),
      minCharacters: json['minCharacters'] as int? ?? 0,
      hintType: json['hintType'] as String? ?? 'appearance',
    );
  }

  final String id;
  final String label;
  final String tagId;
  final DifficultyLevel difficulty;
  final int minCharacters;
  final String hintType;

  TraitCategory toEntity() {
    return TraitCategory(
      id: id,
      label: label,
      tagId: tagId,
      difficulty: difficulty,
      minCharacters: minCharacters,
      hintType: hintType,
    );
  }
}
