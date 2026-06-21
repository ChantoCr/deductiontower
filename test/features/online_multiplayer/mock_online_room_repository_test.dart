import 'dart:math';

import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/core/enums/online_player_action_status.dart';
import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/repositories/mock_online_room_repository_impl.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_player_action.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_participant.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_session.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_action_resolution.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_event.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_player_state.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_state.dart';
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

    test(
        'updates remote readiness and promotes a full ready lobby into ready-to-sync phase',
        () {
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
      final session =
          await repository.createRoomRealtime(hostPlayerName: 'Host');
      final watchedSession = await repository.watchRoom(session.roomCode).first;

      expect(session.roomCode, hasLength(6));
      expect(watchedSession.roomCode, session.roomCode);
      expect(watchedSession.localParticipant.displayName, 'Host');
      expect(watchedSession.phase, OnlineRoomPhase.waitingForOpponent);
    });

    test('supports mock realtime ready updates', () async {
      final session =
          await repository.createRoomRealtime(hostPlayerName: 'Host');

      final updated = await repository.setLocalParticipantReadyRealtime(
        session: session,
        isReady: true,
      );

      expect(updated.localParticipant.isReady, isTrue);
      expect(updated.phase, OnlineRoomPhase.waitingForOpponent);
    });

    test('returns no persisted handoff docs in mock mode', () async {
      final session =
          await repository.createRoomRealtime(hostPlayerName: 'Host');
      final handoff = await repository
          .watchMatchHandoff(
            roomCode: session.roomCode,
            participantId: session.localParticipantId,
          )
          .first;

      expect(handoff, isNull);
    });

    test('stores and watches queued online player actions in mock mode',
        () async {
      final session =
          await repository.createRoomRealtime(hostPlayerName: 'Host');
      final action = OnlinePlayerAction(
        actionId: 'online_action_1',
        submittedByParticipantId: session.localParticipantId,
        submittedByUserId: 'mock_user_host',
        actionType: TurnActionType.requestHint,
        expectedMatchVersion: 0,
        createdAt: DateTime.parse('2026-06-15T10:00:00.000Z'),
      );

      await repository.submitPlayerAction(
        roomCode: session.roomCode,
        action: action,
      );

      final watchedActions =
          await repository.watchPlayerActions(session.roomCode).first;

      expect(watchedActions, hasLength(1));
      expect(watchedActions.first.actionId, 'online_action_1');
      expect(watchedActions.first.actionType, TurnActionType.requestHint);
    });

    test('persists resolved action statuses in mock mode', () async {
      final session =
          await repository.createRoomRealtime(hostPlayerName: 'Host');
      final action = OnlinePlayerAction(
        actionId: 'online_action_2',
        submittedByParticipantId: session.localParticipantId,
        submittedByUserId: 'mock_user_host',
        actionType: TurnActionType.requestHint,
        expectedMatchVersion: 0,
        createdAt: DateTime.parse('2026-06-15T10:05:00.000Z'),
      );

      await repository.submitPlayerAction(
        roomCode: session.roomCode,
        action: action,
      );

      await repository.persistActionResolution(
        roomCode: session.roomCode,
        resolution: RemoteMatchActionResolution(
          baseMatchVersion: 0,
          publicState: RemoteMatchPublicState(
            matchId: 'match_${session.roomCode}',
            roomCode: session.roomCode,
            status: MatchStatus.inProgress,
            currentTurnParticipantId: session.localParticipantId,
            turnNumber: 1,
            sharedCharacterPoolIds: const [],
            playerStates: [
              RemoteMatchPublicPlayerState(
                participantId: session.localParticipantId,
                displayName: session.localParticipant.displayName,
                hintsRemaining: 1,
                characterGuessCount: 0,
                traitGuessCount: 0,
              ),
            ],
            lastResolvedActionId: 'online_action_2',
            matchVersion: 1,
            createdAt: DateTime.parse('2026-06-15T10:00:00.000Z'),
            updatedAt: DateTime.parse('2026-06-15T10:05:05.000Z'),
          ),
          resolvedAction: action.copyWith(
            status: OnlinePlayerActionStatus.applied,
            resolvedAt: DateTime.parse('2026-06-15T10:05:05.000Z'),
          ),
          publicEvent: RemoteMatchPublicEvent(
            eventId: 'online_action_2',
            roomCode: session.roomCode,
            matchId: 'match_${session.roomCode}',
            actionId: 'online_action_2',
            participantId: session.localParticipantId,
            participantName: session.localParticipant.displayName,
            actionType: TurnActionType.requestHint,
            status: OnlinePlayerActionStatus.applied,
            shortLabel: 'Private hint granted',
            actionSummary:
                '${session.localParticipant.displayName} requested a private hint.',
            resultSummary:
                'Private hint delivered. The exact hint text stays outside public event docs.',
            resultingMatchVersion: 1,
            createdAt: DateTime.parse('2026-06-15T10:05:00.000Z'),
            publishedAt: DateTime.parse('2026-06-15T10:05:05.000Z'),
          ),
        ),
      );

      final watchedActions =
          await repository.watchPlayerActions(session.roomCode).first;
      final watchedEvents =
          await repository.watchPublicEvents(session.roomCode).first;

      expect(watchedActions, hasLength(1));
      expect(watchedActions.first.status, OnlinePlayerActionStatus.applied);
      expect(watchedActions.first.resolvedAt, isNotNull);
      expect(watchedEvents, hasLength(1));
      expect(watchedEvents.first.shortLabel, 'Private hint granted');
      expect(watchedEvents.first.resultingMatchVersion, 1);
    });
  });
}
