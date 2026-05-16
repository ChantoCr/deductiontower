import 'package:anime_deduction_tower/features/game/data/datasources/local_game_datasource.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/game/domain/repositories/game_repository.dart';

class GameRepositoryImpl implements GameRepository {
  GameRepositoryImpl({LocalGameDataSource? dataSource})
      : _dataSource = dataSource ?? LocalGameDataSource();

  final LocalGameDataSource _dataSource;

  @override
  Future<List<TraitCategory>> getTraitCategories() async {
    final models = await _dataSource.getTraitCategories();
    return models.map((model) => model.toEntity()).toList();
  }
}
