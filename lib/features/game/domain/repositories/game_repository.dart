import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';

abstract class GameRepository {
  Future<List<TraitCategory>> getTraitCategories();
}
