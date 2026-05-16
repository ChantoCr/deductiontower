import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/core/enums/trait_type.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character_tag.dart';

class CharacterTagModel {
  const CharacterTagModel({
    required this.id,
    required this.label,
    required this.type,
    required this.difficulty,
  });

  factory CharacterTagModel.fromJson(Map<String, dynamic> json) {
    return CharacterTagModel(
      id: json['id'] as String,
      label: json['label'] as String,
      type: TraitType.fromValue(json['type'] as String? ?? 'appearance'),
      difficulty: DifficultyLevel.fromValue(json['difficulty'] as String? ?? 'easy'),
    );
  }

  final String id;
  final String label;
  final TraitType type;
  final DifficultyLevel difficulty;

  CharacterTag toEntity() {
    return CharacterTag(
      id: id,
      label: label,
      type: type,
      difficulty: difficulty,
    );
  }
}
