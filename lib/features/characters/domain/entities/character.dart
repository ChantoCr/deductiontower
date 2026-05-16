import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';

class Character {
  const Character({
    required this.id,
    required this.name,
    required this.series,
    required this.tags,
    required this.difficulty,
    required this.popularity,
    this.image,
  });

  final String id;
  final String name;
  final String series;
  final String? image;
  final List<String> tags;
  final DifficultyLevel difficulty;
  final int popularity;
}
