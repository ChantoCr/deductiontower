import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';

class ExternalCharacterImportEnrichment {
  const ExternalCharacterImportEnrichment({
    required this.series,
    required this.tags,
    required this.difficulty,
    this.animeMalId,
    this.aliases = const [],
    this.sourceReference,
    this.importNotes,
    this.image,
  });

  factory ExternalCharacterImportEnrichment.fromJson(Map<String, dynamic> json) {
    return ExternalCharacterImportEnrichment(
      series: json['series'] as String? ?? 'Unknown',
      tags: (json['tags'] as List<dynamic>? ?? const []).cast<String>(),
      difficulty: DifficultyLevel.fromValue(json['difficulty'] as String? ?? 'easy'),
      animeMalId: json['animeMalId'] as int?,
      aliases: (json['aliases'] as List<dynamic>? ?? const []).cast<String>(),
      sourceReference: json['sourceReference'] as String?,
      importNotes: json['importNotes'] as String?,
      image: json['image'] as String?,
    );
  }

  final String series;
  final List<String> tags;
  final DifficultyLevel difficulty;
  final int? animeMalId;
  final List<String> aliases;
  final String? sourceReference;
  final String? importNotes;
  final String? image;

  Map<String, dynamic> toJson() {
    return {
      'series': series,
      'tags': tags,
      'difficulty': difficulty.name,
      'animeMalId': animeMalId,
      'aliases': aliases,
      'sourceReference': sourceReference,
      'importNotes': importNotes,
      'image': image,
    };
  }
}
