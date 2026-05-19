import 'dart:convert';
import 'dart:io';

import 'package:anime_deduction_tower/core/constants/asset_paths.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/models/character_import_approval_entry.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/models/external_anime_import_model.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/models/external_character_import_enrichment.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/models/external_character_import_model.dart';
import 'package:anime_deduction_tower/features/characters/data/models/character_model.dart';

Future<List<ExternalCharacterImportModel>> readSourceCharacters() async {
  final raw = await File(AssetPaths.importCharactersSampleData).readAsString();
  final list = jsonDecode(raw) as List<dynamic>;

  return list
      .map((item) => ExternalCharacterImportModel.fromJson(item as Map<String, dynamic>))
      .toList();
}

Future<Map<int, ExternalAnimeImportModel>> readAnimeSeriesByMalId() async {
  final raw = await File(AssetPaths.importAnimeSampleData).readAsString();
  final list = jsonDecode(raw) as List<dynamic>;
  final models = list
      .map((item) => ExternalAnimeImportModel.fromJson(item as Map<String, dynamic>))
      .toList();

  return {
    for (final model in models) model.malId: model,
  };
}

Future<Map<int, ExternalCharacterImportEnrichment>> readEnrichments() async {
  final raw = await File(AssetPaths.importCharacterEnrichmentPreviewData).readAsString();
  final map = jsonDecode(raw) as Map<String, dynamic>;

  return map.map(
    (key, value) => MapEntry(
      int.parse(key),
      ExternalCharacterImportEnrichment.fromJson(value as Map<String, dynamic>),
    ),
  );
}

Future<Set<String>> readAllowedTagIds() async {
  final raw = await File(AssetPaths.tagsData).readAsString();
  final list = jsonDecode(raw) as List<dynamic>;

  return list
      .map((item) => (item as Map<String, dynamic>)['id'] as String)
      .toSet();
}

Future<List<CharacterModel>> readCuratedCharacters() async {
  final raw = await File(AssetPaths.charactersData).readAsString();
  final list = jsonDecode(raw) as List<dynamic>;

  return list
      .map((item) => CharacterModel.fromJson(item as Map<String, dynamic>))
      .toList();
}

Future<List<CharacterModel>> readImportedPreviewCharacters() async {
  final raw = await File(AssetPaths.importCharactersPreviewData).readAsString();
  final list = jsonDecode(raw) as List<dynamic>;

  return list
      .map((item) => CharacterModel.fromJson(item as Map<String, dynamic>))
      .toList();
}

Future<List<CharacterImportApprovalEntry>> readApprovalEntries() async {
  final raw = await File(AssetPaths.importCharactersApprovalData).readAsString();
  final list = jsonDecode(raw) as List<dynamic>;

  return list
      .map(
        (item) => CharacterImportApprovalEntry.fromJson(item as Map<String, dynamic>),
      )
      .toList();
}
