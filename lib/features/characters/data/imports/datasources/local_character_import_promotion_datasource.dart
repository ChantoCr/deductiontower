import 'package:anime_deduction_tower/core/constants/asset_paths.dart';
import 'package:anime_deduction_tower/core/utils/json_loader.dart';
import 'package:anime_deduction_tower/features/characters/data/imports/models/character_import_approval_entry.dart';
import 'package:anime_deduction_tower/features/characters/data/models/character_model.dart';

class LocalCharacterImportPromotionDataSource {
  LocalCharacterImportPromotionDataSource({JsonLoader? jsonLoader})
      : _jsonLoader = jsonLoader ?? const JsonLoader();

  final JsonLoader _jsonLoader;

  Future<List<CharacterModel>> getCuratedCharacters() async {
    final list = await _jsonLoader.loadList(AssetPaths.charactersData);
    return list
        .map((item) => CharacterModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<CharacterModel>> getImportedPreviewCharacters() async {
    final list = await _jsonLoader.loadList(AssetPaths.importCharactersPreviewData);
    return list
        .map((item) => CharacterModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<CharacterImportApprovalEntry>> getApprovalEntries() async {
    final list = await _jsonLoader.loadList(AssetPaths.importCharactersApprovalData);
    return list
        .map(
          (item) => CharacterImportApprovalEntry.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  Future<Set<String>> getAllowedTagIds() async {
    final list = await _jsonLoader.loadList(AssetPaths.tagsData);
    return list
        .map((item) => (item as Map<String, dynamic>)['id'] as String)
        .toSet();
  }
}
