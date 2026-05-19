import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/models/external_anime_import_model.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/models/external_character_import_enrichment.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/models/external_character_import_model.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/services/external_character_import_preview_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExternalCharacterImportPreviewService', () {
    const service = ExternalCharacterImportPreviewService();

    test('throws when two imported records normalize to the same id', () {
      const sourceCharacters = [
        ExternalCharacterImportModel(
          malId: 1,
          name: 'A-B',
          nicknames: [],
          favorites: 10,
        ),
        ExternalCharacterImportModel(
          malId: 2,
          name: 'A B',
          nicknames: [],
          favorites: 20,
        ),
      ];
      const enrichments = {
        1: ExternalCharacterImportEnrichment(
          series: 'Test',
          tags: ['black_hair'],
          difficulty: DifficultyLevel.easy,
        ),
        2: ExternalCharacterImportEnrichment(
          series: 'Test',
          tags: ['black_hair'],
          difficulty: DifficultyLevel.easy,
        ),
      };

      expect(
        () => service.generatePreviewModels(
          sourceCharacters: sourceCharacters,
          enrichments: enrichments,
          allowedTagIds: {'black_hair'},
        ),
        throwsStateError,
      );
    });

    test('reports duplicate source mal ids in a structured preview report', () {
      const sourceCharacters = [
        ExternalCharacterImportModel(
          malId: 13,
          name: 'Sasuke Uchiha',
          nicknames: [],
          favorites: 10,
        ),
        ExternalCharacterImportModel(
          malId: 13,
          name: 'Sasuke Uchiha Duplicate',
          nicknames: [],
          favorites: 12,
        ),
      ];
      const enrichments = {
        13: ExternalCharacterImportEnrichment(
          series: 'Naruto',
          tags: ['black_hair'],
          difficulty: DifficultyLevel.easy,
        ),
      };

      final report = service.buildPreviewReport(
        sourceCharacters: sourceCharacters,
        enrichments: enrichments,
        allowedTagIds: {'black_hair'},
      );

      expect(report.hasBlockingIssues, isTrue);
      expect(
        report.issues.where((issue) => issue.code == 'duplicate_source_mal_id'),
        hasLength(2),
      );
      expect(report.previewModels, isEmpty);
    });

    test('reports invalid tags instead of only throwing', () {
      const sourceCharacters = [
        ExternalCharacterImportModel(
          malId: 13,
          name: 'Sasuke Uchiha',
          nicknames: [],
          favorites: 10,
        ),
      ];
      const enrichments = {
        13: ExternalCharacterImportEnrichment(
          series: 'Naruto',
          tags: ['invalid_tag'],
          difficulty: DifficultyLevel.easy,
        ),
      };

      final report = service.buildPreviewReport(
        sourceCharacters: sourceCharacters,
        enrichments: enrichments,
        allowedTagIds: {'black_hair', 'villain'},
      );

      expect(report.hasBlockingIssues, isTrue);
      expect(report.issues.single.code, 'invalid_tag');
      expect(report.reviewQueue.single.issues.single.tagId, 'invalid_tag');
    });

    test('uses anime series mapping and tag suggestions in the review queue', () {
      const sourceCharacters = [
        ExternalCharacterImportModel(
          malId: 5,
          name: 'Monkey D. Luffy',
          nicknames: [],
          favorites: 90314,
          about: 'A black-haired lead character with several transformation-like forms.',
        ),
      ];
      const enrichments = {
        5: ExternalCharacterImportEnrichment(
          series: '',
          animeMalId: 21,
          tags: ['has_transformation'],
          difficulty: DifficultyLevel.easy,
        ),
      };
      const animeSeriesByMalId = {
        21: ExternalAnimeImportModel(
          malId: 21,
          title: 'One Piece',
          titleEnglish: 'One Piece',
        ),
      };

      final report = service.buildPreviewReport(
        sourceCharacters: sourceCharacters,
        enrichments: enrichments,
        allowedTagIds: {'black_hair', 'protagonist', 'has_transformation'},
        animeSeriesByMalId: animeSeriesByMalId,
      );

      expect(report.hasBlockingIssues, isFalse);
      expect(report.previewModels.single.series, 'One Piece');
      expect(report.reviewQueue.single.seriesResolutionSource, 'anime_lookup');
      expect(report.reviewQueue.single.suggestedTags, ['black_hair', 'protagonist']);
    });

    test('reports enrichment and anime series mismatches without blocking preview output', () {
      const sourceCharacters = [
        ExternalCharacterImportModel(
          malId: 465,
          name: 'Vegeta',
          nicknames: [],
          favorites: 36550,
          about: 'A proud Saiyan warrior.',
        ),
      ];
      const enrichments = {
        465: ExternalCharacterImportEnrichment(
          series: 'Dragon Ball Z',
          animeMalId: 223,
          tags: ['has_transformation'],
          difficulty: DifficultyLevel.medium,
        ),
      };
      const animeSeriesByMalId = {
        223: ExternalAnimeImportModel(
          malId: 223,
          title: 'Dragon Ball',
          titleEnglish: 'Dragon Ball',
        ),
      };

      final report = service.buildPreviewReport(
        sourceCharacters: sourceCharacters,
        enrichments: enrichments,
        allowedTagIds: {'has_transformation', 'non_human'},
        animeSeriesByMalId: animeSeriesByMalId,
      );

      expect(report.hasBlockingIssues, isFalse);
      expect(report.previewModels.single.series, 'Dragon Ball Z');
      expect(report.reviewQueue.single.animeSeriesTitle, 'Dragon Ball');
      expect(report.reviewQueue.single.seriesResolutionSource, 'enrichment');
      expect(report.issues.single.code, 'series_mismatch');
    });
  });
}
