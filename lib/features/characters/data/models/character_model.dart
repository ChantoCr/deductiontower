import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';

class CharacterModel {
  const CharacterModel({
    required this.id,
    required this.name,
    required this.series,
    required this.tags,
    required this.difficulty,
    required this.popularity,
    this.image,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] as String,
      name: json['name'] as String,
      series: json['series'] as String? ?? 'Original',
      image: json['image'] as String?,
      tags: (json['tags'] as List<dynamic>).cast<String>(),
      difficulty: DifficultyLevel.fromValue(json['difficulty'] as String? ?? 'easy'),
      popularity: json['popularity'] as int? ?? 0,
    );
  }

  final String id;
  final String name;
  final String series;
  final String? image;
  final List<String> tags;
  final DifficultyLevel difficulty;
  final int popularity;

  Character toEntity() {
    return Character(
      id: id,
      name: name,
      series: series,
      image: image,
      tags: tags,
      difficulty: difficulty,
      popularity: popularity,
    );
  }
}
