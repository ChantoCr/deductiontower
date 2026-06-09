import 'dart:math';

import 'package:anime_deduction_tower/features/online_multiplayer/data/repositories/mock_online_room_repository_impl.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_participant.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_session.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MockOnlineRoomRepositoryImpl', () {
    final repository = MockOnlineRoomRepositoryImpl(random: Random(1));

    test('normalizes room codes to uppercase alphanumeric values', () {
      final normalized = repository.normalizeRoomCode(' ab-12_cd34 ');

      expect(normalized, 'AB12CD');
    });

    test('creates a mock host room with a 6-character code', () {
      final session = repository.createRoom(hostPlayerName: 'Host');

      expect(session.roomCode, hasLength(6));
      expect(session.hostPlayerName, 'Host');
      expect(session.isHost, isTrue);
      expect(session.phase, OnlineRoomPhase.waitingForOpponent);
      expect(session.guestPlayerName, isNull);
      expect(session.participants, hasLength(1));
      expect(
        session.localParticipant.role,
        OnlineRoomParticipantRole.host,
      );
    });

    test('builds a join preview room for a guest player', () {
      final session = repository.joinRoomPreview(
        roomCode: 'a1b2c3',
        guestPlayerName: 'Guest',
      );

      expect(session.roomCode, 'A1B2C3');
      expect(session.hostPlayerName, 'Remote Host');
      expect(session.guestPlayerName, 'Guest');
      expect(session.isHost, isFalse);
      expect(session.phase, OnlineRoomPhase.waitingForReady);
      expect(session.participants, hasLength(2));
      expect(
        session.localParticipant.role,
        OnlineRoomParticipantRole.guest,
      );
    });

    test('updates local readiness without changing waiting-for-opponent rooms',
        () {
      final session = repository.createRoom(hostPlayerName: 'Host');

      final updated = repository.setLocalParticipantReady(
        session: session,
        isReady: true,
      );

      expect(updated.localParticipant.isReady, isTrue);
      expect(updated.phase, OnlineRoomPhase.waitingForOpponent);
    });

    test('simulates a remote guest joining a host preview room', () {
      final session = repository.createRoom(hostPlayerName: 'Host');

      final updated = repository.simulateRemoteGuestJoin(
        session: session,
        guestPlayerName: 'Remote Guest',
      );

      expect(updated.participants, hasLength(2));
      expect(updated.guestPlayerName, 'Remote Guest');
      expect(updated.primaryRemoteParticipant?.isLocalPlayer, isFalse);
      expect(updated.phase, OnlineRoomPhase.waitingForReady);
    });

    test('updates remote readiness and promotes a full ready lobby into ready-to-sync phase', () {
      final session = repository.joinRoomPreview(
        roomCode: 'a1b2c3',
        guestPlayerName: 'Guest',
      );
      final remoteParticipant = session.primaryRemoteParticipant;

      final remoteReady = repository.setRemoteParticipantReady(
        session: session,
        participantId: remoteParticipant!.id,
        isReady: true,
      );
      final updated = repository.setLocalParticipantReady(
        session: remoteReady,
        isReady: true,
      );

      expect(remoteReady.primaryRemoteParticipant?.isReady, isTrue);
      expect(updated.localParticipant.isReady, isTrue);
      expect(updated.isEveryoneReady, isTrue);
      expect(updated.phase, OnlineRoomPhase.readyToSync);
    });

    test('supports mock realtime room creation and watching', () async {
      final session = await repository.createRoomRealtime(hostPlayerName: 'Host');
      final watchedSession = await repository.watchRoom(session.roomCode).first;

      expect(session.roomCode, hasLength(6));
      expect(watchedSession.roomCode, session.roomCode);
      expect(watchedSession.localParticipant.displayName, 'Host');
      expect(watchedSession.phase, OnlineRoomPhase.waitingForOpponent);
    });

    test('supports mock realtime ready updates', () async {
      final session = await repository.createRoomRealtime(hostPlayerName: 'Host');

      final updated = await repository.setLocalParticipantReadyRealtime(
        session: session,
        isReady: true,
      );

      expect(updated.localParticipant.isReady, isTrue);
      expect(updated.phase, OnlineRoomPhase.waitingForOpponent);
    });
  });
}
