import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/models/character_import_approval_entry.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/services/character_import_promotion_service.dart';
import 'package:anime_deduction_tower/features/characters/data/models/character_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CharacterImportPromotionService', () {
    const service = CharacterImportPromotionService();

    const curatedCharacters = [
      CharacterModel(
        id: 'shadow_ninja',
        name: 'Shadow Ninja',
        series: 'Original',
        tags: ['black_hair'],
        difficulty: DifficultyLevel.medium,
        popularity: 8,
      ),
    ];

    test('merges curated and approved imported characters into gameplay-ready models', () {
      const importedCharacters = [
        CharacterModel(
          id: 'sasuke_uchiha',
          name: 'Sasuke Uchiha',
          series: 'Naruto',
          tags: ['black_hair', 'uses_sword'],
          difficulty: DifficultyLevel.medium,
          popularity: 9,
        ),
      ];
      const approvalEntries = [
        CharacterImportApprovalEntry(
          malId: 13,
          transformedId: 'sasuke_uchiha',
          approvalStatus: 'approved',
        ),
      ];

      final promoted = service.promote(
        curatedCharacters: curatedCharacters,
        importedCharacters: importedCharacters,
        approvalEntries: approvalEntries,
        allowedTagIds: {'black_hair', 'uses_sword'},
      );

      expect(promoted, hasLength(2));
      expect(promoted.last.id, 'sasuke_uchiha');
    });

    test('skips imported characters that are pending approval', () {
      const importedCharacters = [
        CharacterModel(
          id: 'levi_ackerman',
          name: 'Levi Ackerman',
          series: 'Attack on Titan',
          tags: ['black_hair', 'uses_sword'],
          difficulty: DifficultyLevel.medium,
          popularity: 9,
        ),
      ];
      const approvalEntries = [
        CharacterImportApprovalEntry(
          malId: 45627,
          transformedId: 'levi_ackerman',
          approvalStatus: 'pending',
        ),
      ];

      final report = service.buildPromotionReport(
        curatedCharacters: curatedCharacters,
        importedCharacters: importedCharacters,
        approvalEntries: approvalEntries,
        allowedTagIds: {'black_hair', 'uses_sword'},
      );

      expect(report.hasBlockingIssues, isFalse);
      expect(report.promotedCharacters, hasLength(1));
      expect(report.issues.single.code, 'not_approved_for_promotion');
    });

    test('reports missing approval entries and does not promote the character', () {
      const importedCharacters = [
        CharacterModel(
          id: 'ichigo_kurosaki',
          name: 'Ichigo Kurosaki',
          series: 'Bleach',
          tags: ['uses_sword'],
          difficulty: DifficultyLevel.easy,
          popularity: 8,
        ),
      ];

      final report = service.buildPromotionReport(
        curatedCharacters: curatedCharacters,
        importedCharacters: importedCharacters,
        allowedTagIds: {'uses_sword'},
      );

      expect(report.hasBlockingIssues, isFalse);
      expect(report.promotedCharacters, hasLength(1));
      expect(report.issues.single.code, 'missing_approval_entry');
    });

    test('reports approval entries that reference missing imported characters', () {
      const approvalEntries = [
        CharacterImportApprovalEntry(
          malId: 999,
          transformedId: 'missing_character',
          approvalStatus: 'approved',
        ),
      ];

      final report = service.buildPromotionReport(
        curatedCharacters: curatedCharacters,
        importedCharacters: const [],
        approvalEntries: approvalEntries,
        allowedTagIds: {'black_hair'},
      );

      expect(report.hasBlockingIssues, isTrue);
      expect(report.issues.single.code, 'approval_missing_imported_character');
    });

    test('treats identical imported characters already merged into runtime as non-blocking', () {
      const importedCharacters = [
        CharacterModel(
          id: 'shadow_ninja',
          name: 'Shadow Ninja',
          series: 'Original',
          tags: ['black_hair'],
          difficulty: DifficultyLevel.medium,
          popularity: 8,
        ),
      ];
      const approvalEntries = [
        CharacterImportApprovalEntry(
          transformedId: 'shadow_ninja',
          approvalStatus: 'approved',
        ),
      ];

      final report = service.buildPromotionReport(
        curatedCharacters: curatedCharacters,
        importedCharacters: importedCharacters,
        approvalEntries: approvalEntries,
        allowedTagIds: {'black_hair'},
      );

      expect(report.hasBlockingIssues, isFalse);
      expect(report.promotedCharacters, hasLength(1));
      expect(report.issues.single.code, 'already_in_runtime_catalog');
    });

    test('reports curated conflicts in a structured promotion report', () {
      const importedCharacters = [
        CharacterModel(
          id: 'shadow_ninja',
          name: 'Shadow Ninja Clone',
          series: 'Imported',
          tags: ['black_hair'],
          difficulty: DifficultyLevel.easy,
          popularity: 5,
        ),
      ];
      const approvalEntries = [
        CharacterImportApprovalEntry(
          transformedId: 'shadow_ninja',
          approvalStatus: 'approved',
        ),
      ];

      final report = service.buildPromotionReport(
        curatedCharacters: curatedCharacters,
        importedCharacters: importedCharacters,
        approvalEntries: approvalEntries,
        allowedTagIds: {'black_hair'},
      );

      expect(report.hasBlockingIssues, isTrue);
      expect(report.issues.single.code, 'curated_id_conflict');
    });

    test('reports duplicate imported ids in a structured promotion report', () {
      const importedCharacters = [
        CharacterModel(
          id: 'sasuke_uchiha',
          name: 'Sasuke Uchiha',
          series: 'Naruto',
          tags: ['black_hair'],
          difficulty: DifficultyLevel.medium,
          popularity: 9,
        ),
        CharacterModel(
          id: 'sasuke_uchiha',
          name: 'Sasuke Uchiha Duplicate',
          series: 'Naruto',
          tags: ['black_hair'],
          difficulty: DifficultyLevel.medium,
          popularity: 9,
        ),
      ];
      const approvalEntries = [
        CharacterImportApprovalEntry(
          transformedId: 'sasuke_uchiha',
          approvalStatus: 'approved',
        ),
      ];

      final report = service.buildPromotionReport(
        curatedCharacters: curatedCharacters,
        importedCharacters: importedCharacters,
        approvalEntries: approvalEntries,
        allowedTagIds: {'black_hair'},
      );

      expect(report.hasBlockingIssues, isTrue);
      expect(
        report.issues.where((issue) => issue.code == 'duplicate_imported_id'),
        hasLength(1),
      );
    });

    test('reports invalid imported tags in a structured promotion report', () {
      const importedCharacters = [
        CharacterModel(
          id: 'sasuke_uchiha',
          name: 'Sasuke Uchiha',
          series: 'Naruto',
          tags: ['invalid_tag'],
          difficulty: DifficultyLevel.medium,
          popularity: 9,
        ),
      ];
      const approvalEntries = [
        CharacterImportApprovalEntry(
          transformedId: 'sasuke_uchiha',
          approvalStatus: 'approved',
        ),
      ];

      final report = service.buildPromotionReport(
        curatedCharacters: curatedCharacters,
        importedCharacters: importedCharacters,
        approvalEntries: approvalEntries,
        allowedTagIds: {'black_hair'},
      );

      expect(report.hasBlockingIssues, isTrue);
      expect(report.issues.single.code, 'invalid_tag');
      expect(report.issues.single.tagId, 'invalid_tag');
    });
  });
}
