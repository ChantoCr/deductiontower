import 'package:anime_deduction_tower/core/constants/game_constants.dart';
import 'package:anime_deduction_tower/core/enums/ai_difficulty.dart';
import 'package:anime_deduction_tower/core/enums/game_mode.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/game_setup_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GameSetupController', () {
    test('updates player names with trimmed values', () {
      final controller = GameSetupController();

      controller.updatePlayerNames(
        playerOneName: '  Rei  ',
        playerTwoName: '  Asuka ',
      );

      expect(controller.state.playerOneName, 'Rei');
      expect(controller.state.playerTwoName, 'Asuka');
    });

    test('falls back to default names when inputs are blank', () {
      final controller = GameSetupController();

      controller.updatePlayerOneName('   ');
      controller.updatePlayerTwoName('');

      expect(controller.state.playerOneName, 'Player 1');
      expect(controller.state.playerTwoName, 'Player 2');
    });

    test('clamps hints into the supported range', () {
      final controller = GameSetupController();

      controller.updateHints(GameConstants.maxHints + 10);
      expect(controller.state.hints, GameConstants.maxHints);

      controller.updateHints(GameConstants.minHints - 10);
      expect(controller.state.hints, GameConstants.minHints);
    });

    test('switches into player-vs-ai mode with an ai default name', () {
      final controller = GameSetupController();

      controller.updateMatchMode(GameMode.playerVsAi);

      expect(controller.state.matchMode, GameMode.playerVsAi);
      expect(controller.state.playerTwoName, 'Tower AI');
      expect(controller.state.isPlayerVsAi, isTrue);
    });

    test('stores the selected ai difficulty independently from core rules', () {
      final controller = GameSetupController();

      controller.updateAiDifficulty(AiDifficulty.hard);

      expect(controller.state.aiDifficulty, AiDifficulty.hard);
      expect(controller.state.hints, GameConstants.defaultHints);
    });
  });
}
