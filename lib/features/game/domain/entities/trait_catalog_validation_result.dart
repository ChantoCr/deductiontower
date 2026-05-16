import 'package:anime_deduction_tower/features/game/domain/entities/trait_catalog_validation_issue.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';

class TraitCatalogValidationResult {
  const TraitCatalogValidationResult({
    required this.validCategories,
    required this.issues,
  });

  final List<TraitCategory> validCategories;
  final List<TraitCatalogValidationIssue> issues;

  bool get hasIssues => issues.isNotEmpty;
}
