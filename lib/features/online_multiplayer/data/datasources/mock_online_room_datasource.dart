import 'dart:async';
import 'dart:math';

import 'package:anime_deduction_tower/core/utils/id_generator.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/datasources/online_room_datasource.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_player_action.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_participant.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_session.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_action_resolution.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_handoff_snapshot.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_event.dart';

class MockOnlineRoomDataSource implements OnlineRoomDataSource {
  MockOnlineRoomDataSource({Random? random}) : _random = random ?? Random();

  static const roomCodeLength = 6;
  static const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  final Random _random;
  final Map<String, OnlineRoomSession> _realtimeSessions = {};
  final Map<String, StreamController<OnlineRoomSession>> _roomControllers = {};
  final Map<String, List<OnlinePlayerAction>> _roomActions = {};
  final Map<String, StreamController<List<OnlinePlayerAction>>>
      _actionControllers = {};
  final Map<String, List<RemoteMatchPublicEvent>> _roomPublicEvents = {};
  final Map<String, StreamController<List<RemoteMatchPublicEvent>>>
      _publicEventControllers = {};

  @override
  String normalizeRoomCode(String value) {
    final uppercase = value.toUpperCase();
    final sanitized = uppercase.replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (sanitized.length <= roomCodeLength) {
      return sanitized;
    }

    return sanitized.substring(0, roomCodeLength);
  }

  @override
  OnlineRoomSession createRoom({required String hostPlayerName}) {
    final host = OnlineRoomParticipant(
      id: IdGenerator.next('online_host'),
      displayName: hostPlayerName.trim(),
      role: OnlineRoomParticipantRole.host,
      connectionState: OnlineRoomParticipantConnectionState.localPreview,
      isLocalPlayer: true,
      userId: 'mock_user_host',
    );

    return OnlineRoomSession(
      roomCode: _generateRoomCode(),
      localParticipantId: host.id,
      participants: [host],
      phase: OnlineRoomPhase.waitingForOpponent,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<OnlineRoomSession> createRoomRealtime({
    required String hostPlayerName,
  }) async {
    final previewSession = createRoom(hostPlayerName: hostPlayerName);
    final session = previewSession.copyWith(
      participants: previewSession.participants
          .map(
            (participant) => participant.copyWith(
              connectionState: OnlineRoomParticipantConnectionState.connected,
            ),
          )
          .toList(),
    );

    _persistRealtimeSession(session);
    return session;
  }

  @override
  OnlineRoomSession joinRoomPreview({
    required String roomCode,
    required String guestPlayerName,
  }) {
    final host = OnlineRoomParticipant(
      id: IdGenerator.next('online_host'),
      displayName: 'Remote Host',
      role: OnlineRoomParticipantRole.host,
      connectionState: OnlineRoomParticipantConnectionState.connected,
      isLocalPlayer: false,
      userId: 'mock_user_host',
    );
    final guest = OnlineRoomParticipant(
      id: IdGenerator.next('online_guest'),
      displayName: guestPlayerName.trim(),
      role: OnlineRoomParticipantRole.guest,
      connectionState: OnlineRoomParticipantConnectionState.localPreview,
      isLocalPlayer: true,
      userId: 'mock_user_guest',
    );

    return OnlineRoomSession(
      roomCode: normalizeRoomCode(roomCode),
      localParticipantId: guest.id,
      participants: [host, guest],
      phase: OnlineRoomPhase.waitingForReady,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<OnlineRoomSession> joinRoomRealtime({
    required String roomCode,
    required String guestPlayerName,
  }) async {
    final normalizedRoomCode = normalizeRoomCode(roomCode);
    final existingSession = _realtimeSessions[normalizedRoomCode];
    if (existingSession == null) {
      throw StateError('Mock realtime room $normalizedRoomCode was not found.');
    }

    if (existingSession.hasGuest) {
      throw StateError(
        'Mock realtime room $normalizedRoomCode is already full.',
      );
    }

    final guest = OnlineRoomParticipant(
      id: IdGenerator.next('online_guest'),
      displayName: guestPlayerName.trim(),
      role: OnlineRoomParticipantRole.guest,
      connectionState: OnlineRoomParticipantConnectionState.connected,
      isLocalPlayer: true,
      userId: 'mock_user_guest',
    );

    final updatedHostParticipants = existingSession.participants
        .map(
          (participant) => participant.copyWith(
            isLocalPlayer: false,
            connectionState: OnlineRoomParticipantConnectionState.connected,
          ),
        )
        .toList();

    final updatedSession = existingSession.copyWith(
      localParticipantId: guest.id,
      participants: [...updatedHostParticipants, guest],
      phase: OnlineRoomPhase.waitingForReady,
    );

    _persistRealtimeSession(updatedSession);
    return updatedSession;
  }

  @override
  OnlineRoomSession setLocalParticipantReady({
    required OnlineRoomSession session,
    required bool isReady,
  }) {
    return _updateParticipantReady(
      session: session,
      participantId: session.localParticipantId,
      isReady: isReady,
    );
  }

  @override
  Future<OnlineRoomSession> setLocalParticipantReadyRealtime({
    required OnlineRoomSession session,
    required bool isReady,
  }) async {
    final updated = _updateParticipantReady(
      session: session,
      participantId: session.localParticipantId,
      isReady: isReady,
    );
    _persistRealtimeSession(updated);
    return updated;
  }

  @override
  OnlineRoomSession simulateRemoteGuestJoin({
    required OnlineRoomSession session,
    String guestPlayerName = 'Remote Guest',
  }) {
    if (session.hasGuest) {
      return session;
    }

    final guest = OnlineRoomParticipant(
      id: IdGenerator.next('online_guest'),
      displayName: guestPlayerName.trim().isEmpty
          ? 'Remote Guest'
          : guestPlayerName.trim(),
      role: OnlineRoomParticipantRole.guest,
      connectionState: OnlineRoomParticipantConnectionState.connected,
      isLocalPlayer: false,
      userId: 'mock_user_guest',
    );

    final updatedHostParticipants = session.participants.map((participant) {
      if (participant.role == OnlineRoomParticipantRole.host) {
        return participant.copyWith(
          connectionState: participant.isLocalPlayer
              ? OnlineRoomParticipantConnectionState.localPreview
              : OnlineRoomParticipantConnectionState.connected,
        );
      }

      return participant;
    }).toList();

    final updatedSession = session.copyWith(
      participants: [...updatedHostParticipants, guest],
    );
    return updatedSession.copyWith(phase: _resolvePhase(updatedSession));
  }

  @override
  OnlineRoomSession setRemoteParticipantReady({
    required OnlineRoomSession session,
    required String participantId,
    required bool isReady,
  }) {
    final targetParticipant = session.participants.where(
      (participant) => participant.id == participantId,
    );
    if (targetParticipant.isEmpty) {
      throw StateError('Remote participant $participantId was not found.');
    }

    if (targetParticipant.first.isLocalPlayer) {
      throw StateError(
        'Use local readiness updates for the local participant.',
      );
    }

    return _updateParticipantReady(
      session: session,
      participantId: participantId,
      isReady: isReady,
    );
  }

  @override
  Stream<OnlineRoomSession> watchRoom(String roomCode) async* {
    final normalizedRoomCode = normalizeRoomCode(roomCode);
    final controller = _roomControllers.putIfAbsent(
      normalizedRoomCode,
      () => StreamController<OnlineRoomSession>.broadcast(),
    );

    final session = _realtimeSessions[normalizedRoomCode];
    if (session != null) {
      yield session;
    }

    yield* controller.stream;
  }

  @override
  Stream<RemoteMatchHandoffSnapshot?> watchMatchHandoff({
    required String roomCode,
    required String participantId,
  }) {
    return Stream.value(null);
  }

  @override
  Future<RemoteMatchHandoffSnapshot?> readMatchHandoff({
    required String roomCode,
    required String participantId,
  }) async {
    return null;
  }

  @override
  Future<OnlinePlayerAction> submitPlayerAction({
    required String roomCode,
    required OnlinePlayerAction action,
  }) async {
    final normalizedRoomCode = normalizeRoomCode(roomCode);
    final actions = [
      ...(_roomActions[normalizedRoomCode] ?? const <OnlinePlayerAction>[]),
    ];
    actions.insert(0, action);
    _roomActions[normalizedRoomCode] = actions;

    final controller = _actionControllers.putIfAbsent(
      normalizedRoomCode,
      () => StreamController<List<OnlinePlayerAction>>.broadcast(),
    );
    controller.add(List<OnlinePlayerAction>.unmodifiable(actions));
    return action;
  }

  @override
  Stream<List<OnlinePlayerAction>> watchPlayerActions(String roomCode) async* {
    final normalizedRoomCode = normalizeRoomCode(roomCode);
    final controller = _actionControllers.putIfAbsent(
      normalizedRoomCode,
      () => StreamController<List<OnlinePlayerAction>>.broadcast(),
    );

    yield List<OnlinePlayerAction>.unmodifiable(
      _roomActions[normalizedRoomCode] ?? const <OnlinePlayerAction>[],
    );
    yield* controller.stream;
  }

  @override
  Stream<List<RemoteMatchPublicEvent>> watchPublicEvents(
    String roomCode,
  ) async* {
    final normalizedRoomCode = normalizeRoomCode(roomCode);
    final controller = _publicEventControllers.putIfAbsent(
      normalizedRoomCode,
      () => StreamController<List<RemoteMatchPublicEvent>>.broadcast(),
    );

    yield List<RemoteMatchPublicEvent>.unmodifiable(
      _roomPublicEvents[normalizedRoomCode] ?? const <RemoteMatchPublicEvent>[],
    );
    yield* controller.stream;
  }

  @override
  Future<void> persistActionResolution({
    required String roomCode,
    required RemoteMatchActionResolution resolution,
  }) async {
    final normalizedRoomCode = normalizeRoomCode(roomCode);
    final actions = [
      ...(_roomActions[normalizedRoomCode] ?? const <OnlinePlayerAction>[]),
    ];
    final index = actions.indexWhere(
      (action) => action.actionId == resolution.resolvedAction.actionId,
    );
    if (index == -1) {
      throw StateError(
        'Mock queued action ${resolution.resolvedAction.actionId} was not found.',
      );
    }

    actions[index] = resolution.resolvedAction;
    actions.sort((left, right) => right.createdAt.compareTo(left.createdAt));
    _roomActions[normalizedRoomCode] = actions;

    final controller = _actionControllers.putIfAbsent(
      normalizedRoomCode,
      () => StreamController<List<OnlinePlayerAction>>.broadcast(),
    );
    controller.add(List<OnlinePlayerAction>.unmodifiable(actions));

    final publicEvents = [
      ...(_roomPublicEvents[normalizedRoomCode] ??
          const <RemoteMatchPublicEvent>[]),
      resolution.publicEvent,
    ]..sort(
        (left, right) => right.publishedAt.compareTo(left.publishedAt),
      );
    _roomPublicEvents[normalizedRoomCode] = publicEvents;

    final publicEventController = _publicEventControllers.putIfAbsent(
      normalizedRoomCode,
      () => StreamController<List<RemoteMatchPublicEvent>>.broadcast(),
    );
    publicEventController.add(
      List<RemoteMatchPublicEvent>.unmodifiable(publicEvents),
    );
  }

  OnlineRoomSession _updateParticipantReady({
    required OnlineRoomSession session,
    required String participantId,
    required bool isReady,
  }) {
    final updatedParticipants = session.participants.map((participant) {
      if (participant.id != participantId) {
        return participant;
      }

      return participant.copyWith(isReady: isReady);
    }).toList();

    final updatedSession = session.copyWith(participants: updatedParticipants);
    return updatedSession.copyWith(phase: _resolvePhase(updatedSession));
  }

  void _persistRealtimeSession(OnlineRoomSession session) {
    _realtimeSessions[session.roomCode] = session;
    final controller = _roomControllers.putIfAbsent(
      session.roomCode,
      () => StreamController<OnlineRoomSession>.broadcast(),
    );
    controller.add(session);
  }

  OnlineRoomPhase _resolvePhase(OnlineRoomSession session) {
    if (!session.hasGuest) {
      return OnlineRoomPhase.waitingForOpponent;
    }

    if (session.isEveryoneReady) {
      return OnlineRoomPhase.readyToSync;
    }

    return OnlineRoomPhase.waitingForReady;
  }

  String _generateRoomCode() {
    final buffer = StringBuffer();
    for (var index = 0; index < roomCodeLength; index++) {
      final charIndex = _random.nextInt(alphabet.length);
      buffer.write(alphabet[charIndex]);
    }

    return buffer.toString();
  }
}
