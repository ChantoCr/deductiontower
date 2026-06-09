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

  bool get canSimulateRemoteGuestJoin =>
      activeSession != null &&
      activeSession!.isHost &&
      !activeSession!.hasGuest;

  bool get canSimulateRemoteReadyToggle =>
      activeSession?.primaryRemoteParticipant != null;

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

  OnlineRoomSession toggleLocalReady() {
    final session = _requireActiveSession(
      errorMessage:
          'Create or join a room preview before changing ready state.',
    );

    final updatedSession = _repository.setLocalParticipantReady(
      session: session,
      isReady: !session.localParticipant.isReady,
    );

    state = state.copyWith(activeSession: updatedSession);
    return updatedSession;
  }

  OnlineRoomSession simulateRemoteGuestJoin({
    String guestPlayerName = 'Remote Guest',
  }) {
    final session = _requireActiveSession(
      errorMessage: 'Create a host room preview before simulating a guest join.',
    );
    if (!session.isHost) {
      throw StateError('Remote guest join simulation is only available in host previews.');
    }

    final updatedSession = _repository.simulateRemoteGuestJoin(
      session: session,
      guestPlayerName: guestPlayerName,
    );

    state = state.copyWith(activeSession: updatedSession);
    return updatedSession;
  }

  OnlineRoomSession toggleRemoteReady() {
    final session = _requireActiveSession(
      errorMessage:
          'Create or join a room preview before changing remote ready state.',
    );
    final remoteParticipant = session.primaryRemoteParticipant;
    if (remoteParticipant == null) {
      throw StateError('No remote participant is available to simulate yet.');
    }

    final updatedSession = _repository.setRemoteParticipantReady(
      session: session,
      participantId: remoteParticipant.id,
      isReady: !remoteParticipant.isReady,
    );

    state = state.copyWith(activeSession: updatedSession);
    return updatedSession;
  }

  void clearSession() {
    state = state.copyWith(clearSession: true);
  }

  OnlineRoomSession _requireActiveSession({required String errorMessage}) {
    final session = state.activeSession;
    if (session == null) {
      throw StateError(errorMessage);
    }

    return session;
  }

  String _normalizeName(String value) {
    return value.trim();
  }
}
