import 'package:anime_deduction_tower/core/constants/asset_paths.dart';
import 'package:anime_deduction_tower/core/utils/json_loader.dart';
import 'package:anime_deduction_tower/features/game/data/models/trait_category_model.dart';

class LocalGameDataSource {
  LocalGameDataSource({JsonLoader? jsonLoader})
      : _jsonLoader = jsonLoader ?? const JsonLoader();

  final JsonLoader _jsonLoader;

  Future<List<TraitCategoryModel>> getTraitCategories() async {
    final list = await _jsonLoader.loadList(AssetPaths.categoriesData);
    return list
        .map((item) => TraitCategoryModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
