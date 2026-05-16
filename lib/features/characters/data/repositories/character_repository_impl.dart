import 'package:anime_deduction_tower/features/characters/data/datasources/local_character_datasource.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character_tag.dart';
import 'package:anime_deduction_tower/features/characters/domain/repositories/character_repository.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  CharacterRepositoryImpl({LocalCharacterDataSource? dataSource})
      : _dataSource = dataSource ?? LocalCharacterDataSource();

  final LocalCharacterDataSource _dataSource;

  @override
  Future<List<Character>> getCharacters() async {
    final models = await _dataSource.getCharacters();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<CharacterTag>> getTags() async {
    final models = await _dataSource.getTags();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<Character>> getCharactersByTag(String tagId) async {
    final characters = await getCharacters();
    return characters.where((character) => character.tags.contains(tagId)).toList();
  }
}
