import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/features/characters/presentation/controllers/character_library_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CharacterLibraryController', () {
    test('toggles tag selection on and off', () {
      final controller = CharacterLibraryController();

      controller.selectTag('black_hair');
      expect(controller.state.selectedTagId, 'black_hair');

      controller.selectTag('black_hair');
      expect(controller.state.selectedTagId, isNull);
    });

    test('toggles difficulty selection on and off', () {
      final controller = CharacterLibraryController();

      controller.selectDifficulty(DifficultyLevel.medium);
      expect(controller.state.selectedDifficulty, DifficultyLevel.medium);

      controller.selectDifficulty(DifficultyLevel.medium);
      expect(controller.state.selectedDifficulty, isNull);
    });

    test('stores trimmed search query', () {
      final controller = CharacterLibraryController();

      controller.setSearchQuery('  naruto  ');

      expect(controller.state.searchQuery, 'naruto');
      expect(controller.state.hasFilters, isTrue);
    });

    test('clears all filters', () {
      final controller = CharacterLibraryController();

      controller.selectTag('villain');
      controller.selectDifficulty(DifficultyLevel.hard);
      controller.setSearchQuery('goku');
      controller.clearFilters();

      expect(controller.state.selectedTagId, isNull);
      expect(controller.state.selectedDifficulty, isNull);
      expect(controller.state.searchQuery, isEmpty);
      expect(controller.state.hasFilters, isFalse);
    });
  });
}
