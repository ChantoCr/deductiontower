import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_session.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/repositories/online_room_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum OnlineLobbyMode {
  host,
  join,
}

class OnlineLobbyState {
  const OnlineLobbyState({
    this.playerName = 'Player 1',
    this.joinCode = '',
    this.lobbyMode = OnlineLobbyMode.host,
    this.activeSession,
  });

  final String playerName;
  final String joinCode;
  final OnlineLobbyMode lobbyMode;
  final OnlineRoomSession? activeSession;

  bool get isHostMode => lobbyMode == OnlineLobbyMode.host;
  bool get isJoinMode => lobbyMode == OnlineLobbyMode.join;

  bool get canCreateRoom => isHostMode && playerName.trim().isNotEmpty;
  bool get canJoinRoom =>
      isJoinMode && playerName.trim().isNotEmpty && joinCode.trim().length == 6;

  OnlineLobbyState copyWith({
    String? playerName,
    String? joinCode,
    OnlineLobbyMode? lobbyMode,
    OnlineRoomSession? activeSession,
    bool clearSession = false,
  }) {
    return OnlineLobbyState(
      playerName: playerName ?? this.playerName,
      joinCode: joinCode ?? this.joinCode,
      lobbyMode: lobbyMode ?? this.lobbyMode,
      activeSession: clearSession ? null : activeSession ?? this.activeSession,
    );
  }
}

class OnlineLobbyController extends StateNotifier<OnlineLobbyState> {
  OnlineLobbyController({required OnlineRoomRepository repository})
      : _repository = repository,
        super(const OnlineLobbyState());

  final OnlineRoomRepository _repository;

  void updatePlayerName(String value) {
    state = state.copyWith(playerName: _normalizeName(value));
  }

  void updateJoinCode(String value) {
    state = state.copyWith(joinCode: _repository.normalizeRoomCode(value));
  }

  void updateLobbyMode(OnlineLobbyMode mode) {
    if (mode == state.lobbyMode) {
      return;
    }

    state = state.copyWith(
      lobbyMode: mode,
      clearSession: true,
    );
  }

  OnlineRoomSession createRoomPreview() {
    final normalizedName = _normalizeName(state.playerName);
    if (normalizedName.isEmpty) {
      throw StateError('Player name is required before creating a room.');
    }

    final session = _repository.createRoom(hostPlayerName: normalizedName);
    state = state.copyWith(
      playerName: normalizedName,
      joinCode: session.roomCode,
      lobbyMode: OnlineLobbyMode.host,
      activeSession: session,
    );
    return session;
  }

  OnlineRoomSession joinRoomPreview() {
    final normalizedName = _normalizeName(state.playerName);
    if (normalizedName.isEmpty) {
      throw StateError('Player name is required before joining a room.');
    }

    final normalizedCode = _repository.normalizeRoomCode(state.joinCode);
    if (normalizedCode.length != 6) {
      throw StateError('Enter a 6-character room code to preview joining.');
    }

    final session = _repository.joinRoomPreview(
      roomCode: normalizedCode,
      guestPlayerName: normalizedName,
    );
    state = state.copyWith(
      playerName: normalizedName,
      joinCode: normalizedCode,
      lobbyMode: OnlineLobbyMode.join,
      activeSession: session,
    );
    return session;
  }

  void clearSession() {
    state = state.copyWith(clearSession: true);
  }

  String _normalizeName(String value) {
    return value.trim();
  }
}
