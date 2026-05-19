import 'package:anime_deduction_tower/features/characters/data/imports/models/character_import_validation_issue.dart';
import 'package:anime_deduction_tower/features/characters/data/models/character_model.dart';

class CharacterImportPromotionReport {
  const CharacterImportPromotionReport({
    required this.promotedCharacters,
    required this.issues,
  });

  final List<CharacterModel> promotedCharacters;
  final List<CharacterImportValidationIssue> issues;

  bool get hasBlockingIssues => issues.any((issue) => issue.isBlocking);
}
