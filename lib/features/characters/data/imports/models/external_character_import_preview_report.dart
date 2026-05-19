import 'package:anime_deduction_tower/features/characters/data/imports/models/character_import_validation_issue.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/models/external_character_import_review_entry.dart';
import 'package:anime_deduction_tower/features/characters/data/models/character_model.dart';

class ExternalCharacterImportPreviewReport {
  const ExternalCharacterImportPreviewReport({
    required this.previewModels,
    required this.issues,
    required this.reviewQueue,
  });

  final List<CharacterModel> previewModels;
  final List<CharacterImportValidationIssue> issues;
  final List<ExternalCharacterImportReviewEntry> reviewQueue;

  bool get hasBlockingIssues => issues.any((issue) => issue.isBlocking);
}
