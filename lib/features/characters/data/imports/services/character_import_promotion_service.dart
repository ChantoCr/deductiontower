import 'dart:convert';

import 'package:anime_deduction_tower/features/characters/data/imports/models/character_import_approval_entry.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/models/character_import_promotion_report.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/models/character_import_validation_issue.dart';
import 'package:anime_deduction_tower/features/characters/data/models/character_model.dart';

class CharacterImportPromotionService {
  const CharacterImportPromotionService();

  CharacterImportPromotionReport buildPromotionReport({
    required List<CharacterModel> curatedCharacters,
    required List<CharacterModel> importedCharacters,
    required Set<String> allowedTagIds,
    List<CharacterImportApprovalEntry> approvalEntries = const [],
  }) {
    final curatedById = {
      for (final character in curatedCharacters) character.id: character,
    };
    final importedIds = importedCharacters.map((character) => character.id).toSet();
    final approvalById = {
      for (final entry in approvalEntries) entry.transformedId: entry,
    };
    final seenImportedIds = <String>{};
    final validImportedCharacters = <CharacterModel>[];
    final issues = <CharacterImportValidationIssue>[];

    for (final approvalEntry in approvalEntries) {
      if (!importedIds.contains(approvalEntry.transformedId)) {
        issues.add(
          CharacterImportValidationIssue(
            code: 'approval_missing_imported_character',
            message:
                'Approval entry references missing imported character: ${approvalEntry.transformedId}.',
            sourceMalId: approvalEntry.malId,
            characterId: approvalEntry.transformedId,
          ),
        );
      }
    }

    for (final character in importedCharacters) {
      final characterIssues = <CharacterImportValidationIssue>[];
      final approvalEntry = approvalById[character.id];

      if (approvalEntry == null) {
        characterIssues.add(
          CharacterImportValidationIssue(
            code: 'missing_approval_entry',
            message:
                'Imported character ${character.id} is not present in the approval asset and will not be promoted.',
            isBlocking: false,
            characterId: character.id,
            characterName: character.name,
          ),
        );
      } else if (!approvalEntry.isApproved) {
        characterIssues.add(
          CharacterImportValidationIssue(
            code: 'not_approved_for_promotion',
            message:
                'Imported character ${character.id} is marked ${approvalEntry.approvalStatus} and will not be promoted.',
            isBlocking: false,
            sourceMalId: approvalEntry.malId,
            characterId: character.id,
            characterName: character.name,
          ),
        );
      }

      if (!seenImportedIds.add(character.id)) {
        characterIssues.add(
          CharacterImportValidationIssue(
            code: 'duplicate_imported_id',
            message:
                'Duplicate imported character id detected during promotion: ${character.id}.',
            characterId: character.id,
            characterName: character.name,
          ),
        );
      }

      final curatedCharacter = curatedById[character.id];
      if (curatedCharacter != null) {
        if (_matchesCuratedCharacter(curatedCharacter, character)) {
          characterIssues.add(
            CharacterImportValidationIssue(
              code: 'already_in_runtime_catalog',
              message:
                  'Imported character ${character.id} already exists in the runtime catalog with matching data.',
              isBlocking: false,
              characterId: character.id,
              characterName: character.name,
            ),
          );
        } else {
          characterIssues.add(
            CharacterImportValidationIssue(
              code: 'curated_id_conflict',
              message:
                  'Imported character id conflicts with curated dataset: ${character.id}.',
              characterId: character.id,
              characterName: character.name,
            ),
          );
        }
      }

      for (final tag in character.tags) {
        if (!allowedTagIds.contains(tag)) {
          characterIssues.add(
            CharacterImportValidationIssue(
              code: 'invalid_tag',
              message:
                  'Imported character ${character.id} uses invalid tag "$tag" during promotion.',
              characterId: character.id,
              characterName: character.name,
              tagId: tag,
            ),
          );
        }
      }

      issues.addAll(characterIssues);
      if (_isApprovedAndValid(characterIssues)) {
        validImportedCharacters.add(character);
      }
    }

    return CharacterImportPromotionReport(
      promotedCharacters: [
        ...curatedCharacters,
        ...validImportedCharacters,
      ],
      issues: issues,
    );
  }

  List<CharacterModel> promote({
    required List<CharacterModel> curatedCharacters,
    required List<CharacterModel> importedCharacters,
    required Set<String> allowedTagIds,
    List<CharacterImportApprovalEntry> approvalEntries = const [],
  }) {
    final report = buildPromotionReport(
      curatedCharacters: curatedCharacters,
      importedCharacters: importedCharacters,
      allowedTagIds: allowedTagIds,
      approvalEntries: approvalEntries,
    );

    if (report.hasBlockingIssues) {
      throw StateError(report.issues.first.message);
    }

    return report.promotedCharacters;
  }

  String generatePromotedJsonString({
    required List<CharacterModel> curatedCharacters,
    required List<CharacterModel> importedCharacters,
    required Set<String> allowedTagIds,
    List<CharacterImportApprovalEntry> approvalEntries = const [],
  }) {
    final promoted = promote(
      curatedCharacters: curatedCharacters,
      importedCharacters: importedCharacters,
      allowedTagIds: allowedTagIds,
      approvalEntries: approvalEntries,
    );

    final jsonList = promoted.map((character) => character.toJson()).toList();
    return const JsonEncoder.withIndent('  ').convert(jsonList);
  }

  bool _isApprovedAndValid(List<CharacterImportValidationIssue> issues) {
    final hasBlockingIssues = issues.any((issue) => issue.isBlocking);
    final hasApprovalIssue = issues.any(
      (issue) => issue.code == 'missing_approval_entry' || issue.code == 'not_approved_for_promotion',
    );
    final alreadyInRuntime = issues.any((issue) => issue.code == 'already_in_runtime_catalog');

    return !hasBlockingIssues && !hasApprovalIssue && !alreadyInRuntime;
  }

  bool _matchesCuratedCharacter(CharacterModel curated, CharacterModel imported) {
    if (curated.id != imported.id ||
        curated.name != imported.name ||
        curated.series != imported.series ||
        curated.image != imported.image ||
        curated.difficulty != imported.difficulty ||
        curated.popularity != imported.popularity) {
      return false;
    }

    if (curated.tags.length != imported.tags.length) {
      return false;
    }

    for (var i = 0; i < curated.tags.length; i++) {
      if (curated.tags[i] != imported.tags[i]) {
        return false;
      }
    }

    return true;
  }
}
