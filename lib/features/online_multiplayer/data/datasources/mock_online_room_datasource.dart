import 'dart:math';

import 'package:anime_deduction_tower/core/utils/id_generator.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/datasources/online_room_datasource.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_participant.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_session.dart';

class MockOnlineRoomDataSource implements OnlineRoomDataSource {
  MockOnlineRoomDataSource({Random? random}) : _random = random ?? Random();

  static const roomCodeLength = 6;
  static const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  final Random _random;

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
    );
    final guest = OnlineRoomParticipant(
      id: IdGenerator.next('online_guest'),
      displayName: guestPlayerName.trim(),
      role: OnlineRoomParticipantRole.guest,
      connectionState: OnlineRoomParticipantConnectionState.localPreview,
      isLocalPlayer: true,
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
      throw StateError('Use local readiness updates for the local participant.');
    }

    return _updateParticipantReady(
      session: session,
      participantId: participantId,
      isReady: isReady,
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
