import 'package:anime_deduction_tower/features/characters/data/repositories/character_repository_impl.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character_tag.dart';
import 'package:anime_deduction_tower/features/characters/domain/repositories/character_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final characterRepositoryProvider = Provider<CharacterRepository>(
  (ref) => CharacterRepositoryImpl(),
);

final charactersProvider = FutureProvider<List<Character>>((ref) async {
  final repository = ref.watch(characterRepositoryProvider);
  return repository.getCharacters();
});

final characterTagsProvider = FutureProvider<List<CharacterTag>>((ref) async {
  final repository = ref.watch(characterRepositoryProvider);
  return repository.getTags();
});
