import 'package:anime_deduction_tower/features/characters/presentation/providers/character_providers.dart';
import 'package:anime_deduction_tower/features/game/data/repositories/game_repository_impl.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_catalog_validation_result.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/game/domain/repositories/game_repository.dart';
import 'package:anime_deduction_tower/features/game/domain/services/trait_catalog_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final gameRepositoryProvider = Provider<GameRepository>(
  (ref) => GameRepositoryImpl(),
);

final traitCatalogValidatorProvider = Provider<TraitCatalogValidator>(
  (ref) => const TraitCatalogValidator(),
);

final traitCategoriesProvider = FutureProvider<List<TraitCategory>>((ref) async {
  final repository = ref.watch(gameRepositoryProvider);
  return repository.getTraitCategories();
});

final validatedTraitCatalogProvider =
    FutureProvider<TraitCatalogValidationResult>((ref) async {
  final validator = ref.watch(traitCatalogValidatorProvider);
  final characters = await ref.watch(charactersProvider.future);
  final tags = await ref.watch(characterTagsProvider.future);
  final categories = await ref.watch(traitCategoriesProvider.future);

  return validator.validate(
    characters: characters,
    tags: tags,
    categories: categories,
  );
});
