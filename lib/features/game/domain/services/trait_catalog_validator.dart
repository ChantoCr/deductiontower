import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character_tag.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_catalog_validation_issue.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_catalog_validation_result.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';

class TraitCatalogValidator {
  const TraitCatalogValidator();

  TraitCatalogValidationResult validate({
    required List<Character> characters,
    required List<CharacterTag> tags,
    required List<TraitCategory> categories,
  }) {
    final issues = <TraitCatalogValidationIssue>[];
    final validCategories = <TraitCategory>[];

    final tagIds = tags.map((tag) => tag.id).toList();
    final categoryIds = categories.map((category) => category.id).toList();
    final validTagIds = tagIds.toSet();
    final seenCategoryIds = <String>{};

    for (final duplicateTagId in _findDuplicateValues(tagIds)) {
      issues.add(
        TraitCatalogValidationIssue(
          code: 'duplicate_tag_id',
          message: 'Duplicate tag id found: $duplicateTagId',
        ),
      );
    }

    for (final duplicateCategoryId in _findDuplicateValues(categoryIds)) {
      issues.add(
        TraitCatalogValidationIssue(
          code: 'duplicate_category_id',
          message: 'Duplicate category id found: $duplicateCategoryId',
        ),
      );
    }

    for (final character in characters) {
      for (final tagId in character.tags) {
        if (!validTagIds.contains(tagId)) {
          issues.add(
            TraitCatalogValidationIssue(
              code: 'invalid_character_tag',
              message: 'Character ${character.id} uses missing tag: $tagId',
            ),
          );
        }
      }
    }

    for (final category in categories) {
      if (!seenCategoryIds.add(category.id)) {
        continue;
      }

      if (!validTagIds.contains(category.tagId)) {
        issues.add(
          TraitCatalogValidationIssue(
            code: 'missing_category_tag',
            message: 'Category ${category.id} references missing tag: ${category.tagId}',
          ),
        );
        continue;
      }

      final matchingCharacters = characters
          .where((character) => character.tags.contains(category.tagId))
          .length;

      if (matchingCharacters < category.minCharacters) {
        issues.add(
          TraitCatalogValidationIssue(
            code: 'not_enough_characters',
            message:
                'Category ${category.id} requires ${category.minCharacters} characters but only $matchingCharacters match.',
          ),
        );
        continue;
      }

      validCategories.add(category);
    }

    return TraitCatalogValidationResult(
      validCategories: validCategories,
      issues: issues,
    );
  }

  List<String> _findDuplicateValues(List<String> values) {
    final seen = <String>{};
    final duplicates = <String>{};

    for (final value in values) {
      if (!seen.add(value)) {
        duplicates.add(value);
      }
    }

    return duplicates.toList()..sort();
  }
}
