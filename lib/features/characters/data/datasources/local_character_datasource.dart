import 'package:anime_deduction_tower/core/constants/asset_paths.dart';
import 'package:anime_deduction_tower/core/utils/json_loader.dart';
import 'package:anime_deduction_tower/features/characters/data/models/character_model.dart';
import 'package:anime_deduction_tower/features/characters/data/models/character_tag_model.dart';

class LocalCharacterDataSource {
  LocalCharacterDataSource({JsonLoader? jsonLoader})
      : _jsonLoader = jsonLoader ?? const JsonLoader();

  final JsonLoader _jsonLoader;

  Future<List<CharacterModel>> getCharacters() async {
    final list = await _jsonLoader.loadList(AssetPaths.charactersData);
    return list
        .map((item) => CharacterModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<CharacterTagModel>> getTags() async {
    final list = await _jsonLoader.loadList(AssetPaths.tagsData);
    return list
        .map((item) => CharacterTagModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
