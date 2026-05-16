import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/core/enums/trait_type.dart';
import 'package:anime_deduction_tower/features/characters/data/datasources/local_character_datasource.dart';
import 'package:anime_deduction_tower/features/characters/data/models/character_model.dart';
import 'package:anime_deduction_tower/features/characters/data/models/character_tag_model.dart';
import 'package:anime_deduction_tower/features/characters/data/repositories/character_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CharacterRepositoryImpl', () {
    test('returns only characters matching a requested tag', () async {
      final repository = CharacterRepositoryImpl(
        dataSource: _FakeLocalCharacterDataSource(),
      );

      final characters = await repository.getCharactersByTag('black_hair');

      expect(characters.length, 2);
      expect(characters.every((character) => character.tags.contains('black_hair')), isTrue);
    });

    test('maps tag models into domain entities', () async {
      final repository = CharacterRepositoryImpl(
        dataSource: _FakeLocalCharacterDataSource(),
      );

      final tags = await repository.getTags();

      expect(tags, hasLength(2));
      expect(tags.first.id, 'black_hair');
      expect(tags.first.type, TraitType.appearance);
    });
  });
}

class _FakeLocalCharacterDataSource extends LocalCharacterDataSource {
  _FakeLocalCharacterDataSource();

  @override
  Future<List<CharacterModel>> getCharacters() async {
    return const [
      CharacterModel(
        id: 'shadow_ninja',
        name: 'Shadow Ninja',
        series: 'Original',
        tags: ['black_hair', 'uses_sword'],
        difficulty: DifficultyLevel.medium,
        popularity: 8,
      ),
      CharacterModel(
        id: 'solar_fighter',
        name: 'Solar Fighter',
        series: 'Original',
        tags: ['protagonist'],
        difficulty: DifficultyLevel.easy,
        popularity: 9,
      ),
      CharacterModel(
        id: 'storm_samurai',
        name: 'Storm Samurai',
        series: 'Original',
        tags: ['black_hair'],
        difficulty: DifficultyLevel.easy,
        popularity: 7,
      ),
    ];
  }

  @override
  Future<List<CharacterTagModel>> getTags() async {
    return const [
      CharacterTagModel(
        id: 'black_hair',
        label: 'Black Hair',
        type: TraitType.appearance,
        difficulty: DifficultyLevel.easy,
      ),
      CharacterTagModel(
        id: 'uses_sword',
        label: 'Uses Sword',
        type: TraitType.weapon,
        difficulty: DifficultyLevel.easy,
      ),
    ];
  }
}
