import 'dart:convert';
import 'dart:io';

import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/datasources/local_character_import_promotion_datasource.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/models/character_import_approval_entry.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/services/character_import_promotion_importer.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/services/character_import_promotion_service.dart';
import 'package:anime_deduction_tower/features/characters/data/models/character_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CharacterImportPromotionImporter', () {
    test('promotes only approved imported preview characters into gameplay-ready models', () async {
      final importer = CharacterImportPromotionImporter(
        dataSource: _FakeCharacterImportPromotionDataSource(),
      );

      final promoted = await importer.generatePromotedCharacters();

      expect(promoted, hasLength(2));
      expect(promoted.first.id, 'shadow_ninja');
      expect(promoted.last.id, 'sasuke_uchiha');
    });

    test('generated promotion json matches the checked-in promotion preview asset', () async {
      const service = CharacterImportPromotionService();
      final curatedCharacters = await _readCharacterModels('assets/data/characters.json');
      final importedCharacters = await _readCharacterModels(
        'assets/data/imports/characters_import_preview.json',
      );
      final approvalEntries = await _readApprovalEntries(
        'assets/data/imports/characters_import_approval.json',
      );
      final generatedJson = service.generatePromotedJsonString(
        curatedCharacters: curatedCharacters,
        importedCharacters: importedCharacters,
        approvalEntries: approvalEntries,
        allowedTagIds: await _readAllowedTagIds('assets/data/tags.json'),
      );
      final previewJson = await File(
        'assets/data/imports/characters_curated_promotion_preview.json',
      ).readAsString();

      expect(
        jsonDecode(generatedJson),
        jsonDecode(previewJson),
      );
    });
  });
}

class _FakeCharacterImportPromotionDataSource extends LocalCharacterImportPromotionDataSource {
  _FakeCharacterImportPromotionDataSource();

  @override
  Future<List<CharacterModel>> getCuratedCharacters() async {
    return const [
      CharacterModel(
        id: 'shadow_ninja',
        name: 'Shadow Ninja',
        series: 'Original',
        tags: ['black_hair'],
        difficulty: DifficultyLevel.medium,
        popularity: 8,
      ),
    ];
  }

  @override
  Future<List<CharacterModel>> getImportedPreviewCharacters() async {
    return const [
      CharacterModel(
        id: 'sasuke_uchiha',
        name: 'Sasuke Uchiha',
        series: 'Naruto',
        tags: ['black_hair', 'uses_sword'],
        difficulty: DifficultyLevel.medium,
        popularity: 9,
      ),
      CharacterModel(
        id: 'levi_ackerman',
        name: 'Levi Ackerman',
        series: 'Attack on Titan',
        tags: ['black_hair', 'uses_sword'],
        difficulty: DifficultyLevel.medium,
        popularity: 9,
      ),
    ];
  }

  @override
  Future<List<CharacterImportApprovalEntry>> getApprovalEntries() async {
    return const [
      CharacterImportApprovalEntry(
        malId: 13,
        transformedId: 'sasuke_uchiha',
        approvalStatus: 'approved',
      ),
      CharacterImportApprovalEntry(
        malId: 45627,
        transformedId: 'levi_ackerman',
        approvalStatus: 'pending',
      ),
    ];
  }

  @override
  Future<Set<String>> getAllowedTagIds() async {
    return {'black_hair', 'uses_sword'};
  }
}

Future<List<CharacterModel>> _readCharacterModels(String path) async {
  final raw = await File(path).readAsString();
  final list = jsonDecode(raw) as List<dynamic>;

  return list
      .map((item) => CharacterModel.fromJson(item as Map<String, dynamic>))
      .toList();
}

Future<List<CharacterImportApprovalEntry>> _readApprovalEntries(String path) async {
  final raw = await File(path).readAsString();
  final list = jsonDecode(raw) as List<dynamic>;

  return list
      .map(
        (item) => CharacterImportApprovalEntry.fromJson(item as Map<String, dynamic>),
      )
      .toList();
}

Future<Set<String>> _readAllowedTagIds(String path) async {
  final raw = await File(path).readAsString();
  final list = jsonDecode(raw) as List<dynamic>;

  return list
      .map((item) => (item as Map<String, dynamic>)['id'] as String)
      .toSet();
}
