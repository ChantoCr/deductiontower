import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/models/character_import_validation_issue.dart';

class ExternalCharacterImportReviewEntry {
  const ExternalCharacterImportReviewEntry({
    required this.malId,
    required this.name,
    required this.tags,
    required this.suggestedTags,
    required this.issues,
    this.animeMalId,
    this.transformedId,
    this.resolvedSeries,
    this.animeSeriesTitle,
    this.seriesResolutionSource,
    this.difficulty,
    this.aliases = const [],
    this.sourceReference,
    this.reviewStatus = 'pending',
  });

  final int malId;
  final String name;
  final int? animeMalId;
  final String? transformedId;
  final String? resolvedSeries;
  final String? animeSeriesTitle;
  final String? seriesResolutionSource;
  final List<String> tags;
  final List<String> suggestedTags;
  final DifficultyLevel? difficulty;
  final List<String> aliases;
  final String? sourceReference;
  final String reviewStatus;
  final List<CharacterImportValidationIssue> issues;

  Map<String, dynamic> toJson() {
    return {
      'malId': malId,
      'name': name,
      'animeMalId': animeMalId,
      'transformedId': transformedId,
      'resolvedSeries': resolvedSeries,
      'animeSeriesTitle': animeSeriesTitle,
      'seriesResolutionSource': seriesResolutionSource,
      'tags': tags,
      'suggestedTags': suggestedTags,
      'difficulty': difficulty?.name,
      'aliases': aliases,
      'sourceReference': sourceReference,
      'reviewStatus': reviewStatus,
      'issues': issues.map((issue) => issue.toJson()).toList(),
    };
  }
}
