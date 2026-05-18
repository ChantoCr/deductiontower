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

  void updatePlayerOneName(String value) {
    state = state.copyWith(
      playerOneName: _normalizeName(value, fallback: 'Player 1'),
    );
  }

  void updatePlayerTwoName(String value) {
    state = state.copyWith(
      playerTwoName: _normalizeName(value, fallback: 'Player 2'),
    );
  }

  void updatePlayerNames({required String playerOneName, required String playerTwoName}) {
    state = state.copyWith(
      playerOneName: _normalizeName(playerOneName, fallback: 'Player 1'),
      playerTwoName: _normalizeName(playerTwoName, fallback: 'Player 2'),
    );
  }

  void updateHints(int value) {
    final sanitizedHints = value.clamp(GameConstants.minHints, GameConstants.maxHints);
    state = state.copyWith(hints: sanitizedHints);
  }

  String _normalizeName(String value, {required String fallback}) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? fallback : trimmed;
  }
}

final gameSetupControllerProvider =
    StateNotifierProvider<GameSetupController, GameSetupState>(
  (ref) => GameSetupController(),
);
