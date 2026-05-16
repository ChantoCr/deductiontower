import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/features/game/data/datasources/local_game_datasource.dart';
import 'package:anime_deduction_tower/features/game/data/models/trait_category_model.dart';
import 'package:anime_deduction_tower/features/game/data/repositories/game_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GameRepositoryImpl', () {
    test('maps local category models into domain entities', () async {
      final repository = GameRepositoryImpl(
        dataSource: _FakeLocalGameDataSource(),
      );

      final categories = await repository.getTraitCategories();

      expect(categories, hasLength(2));
      expect(categories.first.id, 'black_hair');
      expect(categories.first.minCharacters, 5);
      expect(categories.last.hintType, 'role');
    });
  });
}

class _FakeLocalGameDataSource extends LocalGameDataSource {
  _FakeLocalGameDataSource();

  @override
  Future<List<TraitCategoryModel>> getTraitCategories() async {
    return const [
      TraitCategoryModel(
        id: 'black_hair',
        label: 'Black Hair',
        tagId: 'black_hair',
        difficulty: DifficultyLevel.easy,
        minCharacters: 5,
        hintType: 'appearance',
      ),
      TraitCategoryModel(
        id: 'villain',
        label: 'Villain',
        tagId: 'villain',
        difficulty: DifficultyLevel.easy,
        minCharacters: 5,
        hintType: 'role',
      ),
    ];
  }
}
