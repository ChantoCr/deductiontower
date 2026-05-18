import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';

class ExternalCharacterImportEnrichment {
  const ExternalCharacterImportEnrichment({
    required this.series,
    required this.tags,
    required this.difficulty,
    this.image,
  });

  factory ExternalCharacterImportEnrichment.fromJson(Map<String, dynamic> json) {
    return ExternalCharacterImportEnrichment(
      series: json['series'] as String? ?? 'Unknown',
      tags: (json['tags'] as List<dynamic>? ?? const []).cast<String>(),
      difficulty: DifficultyLevel.fromValue(json['difficulty'] as String? ?? 'easy'),
      image: json['image'] as String?,
    );
  }

  final String series;
  final List<String> tags;
  final DifficultyLevel difficulty;
  final String? image;

  Map<String, dynamic> toJson() {
    return {
      'series': series,
      'tags': tags,
      'difficulty': difficulty.name,
      'image': image,
    };
  }
}
