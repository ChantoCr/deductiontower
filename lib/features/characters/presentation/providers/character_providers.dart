import 'package:anime_deduction_tower/features/characters/data/repositories/character_repository_impl.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character_tag.dart';
import 'package:anime_deduction_tower/features/characters/domain/repositories/character_repository.dart';
import 'package:anime_deduction_tower/features/characters/domain/services/character_library_filter.dart';
import 'package:anime_deduction_tower/features/characters/presentation/controllers/character_library_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final characterRepositoryProvider = Provider<CharacterRepository>(
  (ref) => CharacterRepositoryImpl(),
);

final characterLibraryFilterProvider = Provider<CharacterLibraryFilter>(
  (ref) => const CharacterLibraryFilter(),
);

final charactersProvider = FutureProvider<List<Character>>((ref) async {
  final repository = ref.watch(characterRepositoryProvider);
  return repository.getCharacters();
});

final characterTagsProvider = FutureProvider<List<CharacterTag>>((ref) async {
  final repository = ref.watch(characterRepositoryProvider);
  return repository.getTags();
});

final filteredCharactersProvider = FutureProvider<List<Character>>((ref) async {
  final filter = ref.watch(characterLibraryFilterProvider);
  final state = ref.watch(characterLibraryControllerProvider);
  final characters = await ref.watch(charactersProvider.future);

  return filter.apply(
    characters: characters,
    tagId: state.selectedTagId,
    difficulty: state.selectedDifficulty,
  );
});
