import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character_tag.dart';

abstract class CharacterRepository {
  Future<List<Character>> getCharacters();
  Future<List<CharacterTag>> getTags();
  Future<List<Character>> getCharactersByTag(String tagId);
}
