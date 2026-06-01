import 'package:anime_deduction_tower/core/constants/game_constants.dart';
import 'package:anime_deduction_tower/core/enums/ai_difficulty.dart';
import 'package:anime_deduction_tower/core/enums/game_mode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameSetupState {
  const GameSetupState({
    this.playerOneName = 'Player 1',
    this.playerTwoName = 'Player 2',
    this.hints = GameConstants.defaultHints,
    this.matchMode = GameMode.localMultiplayer,
    this.aiDifficulty = AiDifficulty.standard,
  });

  final String playerOneName;
  final String playerTwoName;
  final int hints;
  final GameMode matchMode;
  final AiDifficulty aiDifficulty;

  bool get isPlayerVsAi => matchMode == GameMode.playerVsAi;
  bool get isLocalMultiplayer => matchMode == GameMode.localMultiplayer;

  GameSetupState copyWith({
    String? playerOneName,
    String? playerTwoName,
    int? hints,
    GameMode? matchMode,
    AiDifficulty? aiDifficulty,
  }) {
    return GameSetupState(
      playerOneName: playerOneName ?? this.playerOneName,
      playerTwoName: playerTwoName ?? this.playerTwoName,
      hints: hints ?? this.hints,
      matchMode: matchMode ?? this.matchMode,
      aiDifficulty: aiDifficulty ?? this.aiDifficulty,
    );
  }
}

class GameSetupController extends StateNotifier<GameSetupState> {
  GameSetupController() : super(const GameSetupState());

  static const _defaultPlayerOneName = 'Player 1';
  static const _defaultPlayerTwoName = 'Player 2';
  static const _defaultAiName = 'Tower AI';

  void updatePlayerOneName(String value) {
    state = state.copyWith(
      playerOneName: _normalizeName(value, fallback: _defaultPlayerOneName),
    );
  }

  void updatePlayerTwoName(String value) {
    state = state.copyWith(
      playerTwoName: _normalizeName(
        value,
        fallback: state.isPlayerVsAi ? _defaultAiName : _defaultPlayerTwoName,
      ),
    );
  }

  void updatePlayerNames({
    required String playerOneName,
    required String playerTwoName,
  }) {
    state = state.copyWith(
      playerOneName: _normalizeName(
        playerOneName,
        fallback: _defaultPlayerOneName,
      ),
      playerTwoName: _normalizeName(
        playerTwoName,
        fallback: state.isPlayerVsAi ? _defaultAiName : _defaultPlayerTwoName,
      ),
    );
  }

  void updateMatchMode(GameMode mode) {
    if (mode == state.matchMode) {
      return;
    }

    var playerTwoName = state.playerTwoName;
    if (mode == GameMode.playerVsAi && playerTwoName == _defaultPlayerTwoName) {
      playerTwoName = _defaultAiName;
    }

    if (mode == GameMode.localMultiplayer && playerTwoName == _defaultAiName) {
      playerTwoName = _defaultPlayerTwoName;
    }

    state = state.copyWith(
      matchMode: mode,
      playerTwoName: playerTwoName,
    );
  }

  void updateAiDifficulty(AiDifficulty difficulty) {
    state = state.copyWith(aiDifficulty: difficulty);
  }

  void updateHints(int value) {
    final sanitizedHints =
        value.clamp(GameConstants.minHints, GameConstants.maxHints);
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
