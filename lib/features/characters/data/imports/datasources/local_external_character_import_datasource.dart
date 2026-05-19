import 'package:anime_deduction_tower/core/constants/asset_paths.dart';
import 'package:anime_deduction_tower/core/utils/json_loader.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/models/external_anime_import_model.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/models/external_character_import_enrichment.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/models/external_character_import_model.dart';

class LocalExternalCharacterImportDataSource {
  LocalExternalCharacterImportDataSource({JsonLoader? jsonLoader})
      : _jsonLoader = jsonLoader ?? const JsonLoader();

  final JsonLoader _jsonLoader;

  Future<List<ExternalCharacterImportModel>> getSourceCharacters() async {
    final list = await _jsonLoader.loadList(AssetPaths.importCharactersSampleData);
    return list
        .map(
          (item) => ExternalCharacterImportModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  Future<Map<int, ExternalAnimeImportModel>> getAnimeSeriesByMalId() async {
    final list = await _jsonLoader.loadList(AssetPaths.importAnimeSampleData);
    final models = list
        .map((item) => ExternalAnimeImportModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return {
      for (final model in models) model.malId: model,
    };
  }

  Future<Map<int, ExternalCharacterImportEnrichment>> getEnrichments() async {
    final map = await _jsonLoader.loadMap(AssetPaths.importCharacterEnrichmentPreviewData);

    return map.map(
      (key, value) => MapEntry(
        int.parse(key),
        ExternalCharacterImportEnrichment.fromJson(value as Map<String, dynamic>),
      ),
    );
  }

  Future<Set<String>> getAllowedTagIds() async {
    final list = await _jsonLoader.loadList(AssetPaths.tagsData);
    return list
        .map((item) => (item as Map<String, dynamic>)['id'] as String)
        .toSet();
  }
}
