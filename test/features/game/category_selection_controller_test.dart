import 'package:anime_deduction_tower/features/game/presentation/controllers/category_selection_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CategorySelectionController', () {
    test('stores player one selection and advances to player two', () {
      final controller = CategorySelectionController();

      controller.selectTrait('black_hair');
      controller.confirmCurrentSelection();

      expect(controller.state.playerOneTraitId, 'black_hair');
      expect(controller.state.currentPlayerNumber, 2);
      expect(controller.state.isSelectingPlayerOne, isFalse);
    });

    test('stores player two selection and completes the setup state', () {
      final controller = CategorySelectionController();

      controller.selectTrait('black_hair');
      controller.confirmCurrentSelection();
      controller.selectTrait('villain');

      expect(controller.state.playerOneTraitId, 'black_hair');
      expect(controller.state.playerTwoTraitId, 'villain');
      expect(controller.state.isComplete, isTrue);
    });

    test('supports single human secret selection in player-vs-ai mode', () {
      final controller = CategorySelectionController();

      controller.reset(isPlayerVsAi: true);
      controller.selectTrait('black_hair');
      controller.confirmCurrentSelection();

      expect(controller.state.isPlayerVsAi, isTrue);
      expect(controller.state.playerOneTraitId, 'black_hair');
      expect(controller.state.playerTwoTraitId, isNull);
      expect(controller.state.isComplete, isTrue);
    });

    test('resets back to the initial selection state', () {
      final controller = CategorySelectionController();

      controller.selectTrait('black_hair');
      controller.confirmCurrentSelection();
      controller.reset();

      expect(controller.state.currentPlayerNumber, 1);
      expect(controller.state.playerOneTraitId, isNull);
      expect(controller.state.playerTwoTraitId, isNull);
      expect(controller.state.isComplete, isFalse);
    });
  });
}
