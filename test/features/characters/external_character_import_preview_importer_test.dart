import 'dart:convert';
import 'dart:io';

import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/datasources/local_external_character_import_datasource.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/models/external_anime_import_model.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/models/external_character_import_enrichment.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/models/external_character_import_model.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/services/external_character_import_preview_importer.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/services/external_character_import_preview_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExternalCharacterImportPreviewImporter', () {
    test('reads source and enrichment records then generates preview models', () async {
      final importer = ExternalCharacterImportPreviewImporter(
        dataSource: _FakeExternalCharacterImportDataSource(),
      );

      final models = await importer.generatePreviewModels();

      expect(models, hasLength(2));
      expect(models.first.id, 'sasuke_uchiha');
      expect(models.first.series, 'Naruto');
      expect(models.last.tags, ['villain', 'has_transformation', 'non_human']);
    });

    test('generated preview json matches the checked-in preview asset format', () async {
      const previewService = ExternalCharacterImportPreviewService();
      final sourceCharacters = await _readSourceCharacters(
        'assets/data/imports/mal_jikan_characters_sample.json',
      );
      final animeSeriesByMalId = await _readAnimeSeries(
        'assets/data/imports/mal_jikan_anime_sample.json',
      );
      final enrichments = await _readEnrichments(
        'assets/data/imports/mal_jikan_character_enrichment_preview.json',
      );
      final generatedJson = previewService.generatePreviewJsonString(
        sourceCharacters: sourceCharacters,
        enrichments: enrichments,
        allowedTagIds: await _readAllowedTagIds('assets/data/tags.json'),
        animeSeriesByMalId: animeSeriesByMalId,
      );
      final previewJson = await File(
        'assets/data/imports/characters_import_preview.json',
      ).readAsString();

      expect(
        jsonDecode(generatedJson),
        jsonDecode(previewJson),
      );
    });

    test('generated review queue json matches the checked-in review queue asset format', () async {
      const previewService = ExternalCharacterImportPreviewService();
      final sourceCharacters = await _readSourceCharacters(
        'assets/data/imports/mal_jikan_characters_sample.json',
      );
      final animeSeriesByMalId = await _readAnimeSeries(
        'assets/data/imports/mal_jikan_anime_sample.json',
      );
      final enrichments = await _readEnrichments(
        'assets/data/imports/mal_jikan_character_enrichment_preview.json',
      );
      final generatedJson = previewService.generateReviewQueueJsonString(
        sourceCharacters: sourceCharacters,
        enrichments: enrichments,
        allowedTagIds: await _readAllowedTagIds('assets/data/tags.json'),
        animeSeriesByMalId: animeSeriesByMalId,
      );
      final reviewQueueJson = await File(
        'assets/data/imports/characters_import_review_queue.json',
      ).readAsString();

      expect(
        jsonDecode(generatedJson),
        jsonDecode(reviewQueueJson),
      );
    });
  });
}

class _FakeExternalCharacterImportDataSource extends LocalExternalCharacterImportDataSource {
  _FakeExternalCharacterImportDataSource();

  @override
  Future<List<ExternalCharacterImportModel>> getSourceCharacters() async {
    return const [
      ExternalCharacterImportModel(
        malId: 13,
        name: 'Sasuke Uchiha',
        nameKanji: 'うちはサスケ',
        nicknames: ['Sasuke-kun'],
        favorites: 52745,
        about: 'Rival character',
      ),
      ExternalCharacterImportModel(
        malId: 2547,
        name: 'Frieza',
        nameKanji: 'フリーザ',
        nicknames: ['Freeza'],
        favorites: 18210,
        about: 'A famous villain',
      ),
    ];
  }

  @override
  Future<Map<int, ExternalAnimeImportModel>> getAnimeSeriesByMalId() async {
    return const {
      20: ExternalAnimeImportModel(malId: 20, title: 'Naruto'),
      223: ExternalAnimeImportModel(malId: 223, title: 'Dragon Ball'),
    };
  }

  @override
  Future<Map<int, ExternalCharacterImportEnrichment>> getEnrichments() async {
    return const {
      13: ExternalCharacterImportEnrichment(
        series: 'Naruto',
        animeMalId: 20,
        tags: ['black_hair', 'uses_sword', 'has_tragic_past'],
        difficulty: DifficultyLevel.medium,
      ),
      2547: ExternalCharacterImportEnrichment(
        series: '',
        animeMalId: 223,
        tags: ['villain', 'has_transformation', 'non_human'],
        difficulty: DifficultyLevel.medium,
      ),
    };
  }

  @override
  Future<Set<String>> getAllowedTagIds() async {
    return {
      'black_hair',
      'uses_sword',
      'has_tragic_past',
      'villain',
      'has_transformation',
      'non_human',
    };
  }
}

Future<List<ExternalCharacterImportModel>> _readSourceCharacters(String path) async {
  final raw = await File(path).readAsString();
  final list = jsonDecode(raw) as List<dynamic>;

  return list
      .map((item) => ExternalCharacterImportModel.fromJson(item as Map<String, dynamic>))
      .toList();
}

Future<Map<int, ExternalAnimeImportModel>> _readAnimeSeries(String path) async {
  final raw = await File(path).readAsString();
  final list = jsonDecode(raw) as List<dynamic>;
  final models = list
      .map((item) => ExternalAnimeImportModel.fromJson(item as Map<String, dynamic>))
      .toList();

  return {
    for (final model in models) model.malId: model,
  };
}

Future<Map<int, ExternalCharacterImportEnrichment>> _readEnrichments(String path) async {
  final raw = await File(path).readAsString();
  final map = jsonDecode(raw) as Map<String, dynamic>;

  return map.map(
    (key, value) => MapEntry(
      int.parse(key),
      ExternalCharacterImportEnrichment.fromJson(value as Map<String, dynamic>),
    ),
  );
}

Future<Set<String>> _readAllowedTagIds(String path) async {
  final raw = await File(path).readAsString();
  final list = jsonDecode(raw) as List<dynamic>;

  return list
      .map((item) => (item as Map<String, dynamic>)['id'] as String)
      .toSet();
}
