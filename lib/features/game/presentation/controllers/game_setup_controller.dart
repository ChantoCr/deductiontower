import 'package:anime_deduction_tower/core/constants/game_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameSetupState {
  const GameSetupState({
    this.playerOneName = 'Player 1',
    this.playerTwoName = 'Player 2',
    this.hints = GameConstants.defaultHints,
  });

  final String playerOneName;
  final String playerTwoName;
  final int hints;

  GameSetupState copyWith({
    String? playerOneName,
    String? playerTwoName,
    int? hints,
  }) {
    return GameSetupState(
      playerOneName: playerOneName ?? this.playerOneName,
      playerTwoName: playerTwoName ?? this.playerTwoName,
      hints: hints ?? this.hints,
    );
  }
}

class GameSetupController extends StateNotifier<GameSetupState> {
  GameSetupController() : super(const GameSetupState());

  void updatePlayerNames({required String playerOneName, required String playerTwoName}) {
    state = state.copyWith(
      playerOneName: playerOneName,
      playerTwoName: playerTwoName,
    );
  }
}

final gameSetupControllerProvider =
    StateNotifierProvider<GameSetupController, GameSetupState>(
  (ref) => GameSetupController(),
);
