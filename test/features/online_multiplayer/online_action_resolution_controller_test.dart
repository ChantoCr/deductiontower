import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/core/enums/online_player_action_status.dart';
import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_action_resolution_authority.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_player_action.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_participant.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_session.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_action_resolution.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_bootstrap_payload.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_handoff_snapshot.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_event.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_player_state.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_state.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_player_private_state.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/repositories/online_room_repository.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/services/online_action_resolution_policy.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/services/remote_match_action_resolver.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/presentation/controllers/online_action_resolution_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OnlineActionResolutionController', () {
    final guestSession = OnlineRoomSession(
      roomCode: 'AB12CD',
      localParticipantId: 'guest_1',
      participants: const [
        OnlineRoomParticipant(
          id: 'host_1',
          displayName: 'Host',
          role: OnlineRoomParticipantRole.host,
          connectionState: OnlineRoomParticipantConnectionState.connected,
          isLocalPlayer: false,
          userId: 'firebase_uid_host',
          isReady: true,
        ),
        OnlineRoomParticipant(
          id: 'guest_1',
          displayName: 'Guest',
          role: OnlineRoomParticipantRole.guest,
          connectionState: OnlineRoomParticipantConnectionState.connected,
          isLocalPlayer: true,
          userId: 'firebase_uid_guest',
          isReady: true,
        ),
      ],
      phase: OnlineRoomPhase.readyToSync,
      createdAt: DateTime.parse('2026-06-16T10:00:00.000Z'),
    );

    final hostSession = OnlineRoomSession(
      roomCode: 'AB12CD',
      localParticipantId: 'host_1',
      participants: const [
        OnlineRoomParticipant(
          id: 'host_1',
          displayName: 'Host',
          role: OnlineRoomParticipantRole.host,
          connectionState: OnlineRoomParticipantConnectionState.connected,
          isLocalPlayer: true,
          userId: 'firebase_uid_host',
          isReady: true,
        ),
        OnlineRoomParticipant(
          id: 'guest_1',
          displayName: 'Guest',
          role: OnlineRoomParticipantRole.guest,
          connectionState: OnlineRoomParticipantConnectionState.connected,
          isLocalPlayer: false,
          userId: 'firebase_uid_guest',
          isReady: true,
        ),
      ],
      phase: OnlineRoomPhase.readyToSync,
      createdAt: DateTime.parse('2026-06-16T10:00:00.000Z'),
    );

    final pendingAction = OnlinePlayerAction(
      actionId: 'online_action_1',
      submittedByParticipantId: 'guest_1',
      submittedByUserId: 'firebase_uid_guest',
      actionType: TurnActionType.requestHint,
      expectedMatchVersion: 0,
      status: OnlinePlayerActionStatus.pending,
      createdAt: DateTime.parse('2026-06-16T10:01:00.000Z'),
    );

    test(
      'host-only authority rejects guest-side resolution before repository reads',
      () async {
        final repository = _TrackingOnlineRoomRepository();
        final controller = OnlineActionResolutionController(
          repository: repository,
          actionResolver: const RemoteMatchActionResolver(),
          resolutionPolicy: const OnlineActionResolutionPolicy(),
          resolutionAuthority: OnlineActionResolutionAuthority.hostClient,
          loadValidCategories: () async => const [],
          loadCharacters: () async => const [],
        );

        await expectLater(
          () => controller.resolveNextPendingAction(
            session: guestSession,
            roomCode: guestSession.roomCode,
            actions: [pendingAction],
          ),
          throwsA(
            isA<StateError>().having(
              (error) => error.toString(),
              'message',
              contains('not the current queued-action resolver'),
            ),
          ),
        );

        expect(repository.readMatchHandoffCalls, 0);
        expect(repository.persistActionResolutionCalls, 0);
      },
    );

    test(
      'backend authority rejects host-side local resolution before repository reads',
      () async {
        final repository = _TrackingOnlineRoomRepository();
        final controller = OnlineActionResolutionController(
          repository: repository,
          actionResolver: const RemoteMatchActionResolver(),
          resolutionPolicy: const OnlineActionResolutionPolicy(),
          resolutionAuthority: OnlineActionResolutionAuthority.backendService,
          loadValidCategories: () async => const [],
          loadCharacters: () async => const [],
        );

        await expectLater(
          () => controller.resolveNextPendingAction(
            session: hostSession,
            roomCode: hostSession.roomCode,
            actions: [pendingAction],
          ),
          throwsA(
            isA<StateError>().having(
              (error) => error.toString(),
              'message',
              contains('not the current queued-action resolver'),
            ),
          ),
        );

        expect(repository.readMatchHandoffCalls, 0);
        expect(repository.persistActionResolutionCalls, 0);
      },
    );

    test('host authority resolves the oldest pending action with host metadata',
        () async {
      final repository = _TrackingOnlineRoomRepository()
        ..handoffToReturn = _buildGuestHintHandoff();
      final controller = OnlineActionResolutionController(
        repository: repository,
        actionResolver: const RemoteMatchActionResolver(),
        resolutionPolicy: const OnlineActionResolutionPolicy(),
        resolutionAuthority: OnlineActionResolutionAuthority.hostClient,
        loadValidCategories: () async => _categories,
        loadCharacters: () async => _characters,
      );

      final resolution = await controller.resolveNextPendingAction(
        session: hostSession,
        roomCode: hostSession.roomCode,
        actions: [pendingAction],
      );

      expect(
        resolution.resolvedAction.resolutionSource,
        OnlineActionResolutionAuthority.hostClient,
      );
      expect(resolution.resolvedAction.resolvedByParticipantId, 'host_1');
      expect(
        resolution.resolvedAction.resolvedByUserId,
        'firebase_uid_host',
      );
      expect(resolution.publicEvent.shortLabel, 'Private hint granted');
      expect(
        repository.persistedResolution?.resolvedAction.resolutionSource,
        OnlineActionResolutionAuthority.hostClient,
      );
      expect(repository.readMatchHandoffCalls, 1);
      expect(repository.persistActionResolutionCalls, 1);
    });
  });
}

const _categories = [
  TraitCategory(
    id: 'black_hair',
    label: 'Black Hair',
    tagId: 'black_hair',
    difficulty: DifficultyLevel.easy,
    minCharacters: 2,
    hintType: 'appearance',
  ),
  TraitCategory(
    id: 'villain',
    label: 'Villain',
    tagId: 'villain',
    difficulty: DifficultyLevel.medium,
    minCharacters: 2,
    hintType: 'role',
  ),
];

const _characters = [
  Character(
    id: 'goku',
    name: 'Goku',
    series: 'Dragon Ball',
    tags: ['black_hair'],
    difficulty: DifficultyLevel.easy,
    popularity: 10,
  ),
  Character(
    id: 'frieza',
    name: 'Frieza',
    series: 'Dragon Ball',
    tags: ['villain'],
    difficulty: DifficultyLevel.easy,
    popularity: 9,
  ),
];

RemoteMatchHandoffSnapshot _buildGuestHintHandoff() {
  return RemoteMatchHandoffSnapshot(
    roomCode: 'AB12CD',
    localParticipantId: 'guest_1',
    bootstrapPayload: RemoteMatchBootstrapPayload(
      roomCode: 'AB12CD',
      matchId: 'match_AB12CD',
      hostParticipantId: 'host_1',
      guestParticipantId: 'guest_1',
      startingParticipantId: 'guest_1',
      hostPlayerName: 'Host',
      guestPlayerName: 'Guest',
      hintsPerPlayer: 2,
      hostSecretTraitId: 'black_hair',
      guestSecretTraitId: 'villain',
      sharedCharacterPoolIds: const ['goku', 'frieza'],
      createdAt: DateTime.parse('2026-06-16T10:00:00.000Z'),
    ),
    publicState: RemoteMatchPublicState(
      matchId: 'match_AB12CD',
      roomCode: 'AB12CD',
      status: MatchStatus.inProgress,
      currentTurnParticipantId: 'guest_1',
      turnNumber: 2,
      sharedCharacterPoolIds: const ['goku', 'frieza'],
      playerStates: const [
        RemoteMatchPublicPlayerState(
          participantId: 'host_1',
          displayName: 'Host',
          hintsRemaining: 2,
          characterGuessCount: 0,
          traitGuessCount: 0,
        ),
        RemoteMatchPublicPlayerState(
          participantId: 'guest_1',
          displayName: 'Guest',
          hintsRemaining: 2,
          characterGuessCount: 1,
          traitGuessCount: 0,
        ),
      ],
      matchVersion: 0,
      createdAt: DateTime.parse('2026-06-16T10:00:00.000Z'),
      updatedAt: DateTime.parse('2026-06-16T10:00:00.000Z'),
    ),
    privateState: RemotePlayerPrivateState(
      participantId: 'guest_1',
      userId: 'firebase_uid_guest',
      secretTraitId: 'villain',
      secretTraitLocked: true,
      hasViewedSecret: true,
      hintsUsed: 0,
      selectedAt: DateTime.parse('2026-06-16T10:00:00.000Z'),
      updatedAt: DateTime.parse('2026-06-16T10:00:00.000Z'),
    ),
  );
}

class _TrackingOnlineRoomRepository implements OnlineRoomRepository {
  int readMatchHandoffCalls = 0;
  int persistActionResolutionCalls = 0;
  RemoteMatchHandoffSnapshot? handoffToReturn;
  RemoteMatchActionResolution? persistedResolution;

  @override
  OnlineRoomSession createRoom({required String hostPlayerName}) {
    throw UnimplementedError();
  }

  @override
  Future<OnlineRoomSession> createRoomRealtime({
    required String hostPlayerName,
  }) {
    throw UnimplementedError();
  }

  @override
  OnlineRoomSession joinRoomPreview({
    required String roomCode,
    required String guestPlayerName,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<OnlineRoomSession> joinRoomRealtime({
    required String roomCode,
    required String guestPlayerName,
  }) {
    throw UnimplementedError();
  }

  @override
  String normalizeRoomCode(String value) {
    throw UnimplementedError();
  }

  @override
  Future<void> persistActionResolution({
    required String roomCode,
    required RemoteMatchActionResolution resolution,
  }) async {
    persistActionResolutionCalls += 1;
    persistedResolution = resolution;
  }

  @override
  Future<RemoteMatchHandoffSnapshot?> readMatchHandoff({
    required String roomCode,
    required String participantId,
  }) async {
    readMatchHandoffCalls += 1;
    return handoffToReturn;
  }

  @override
  OnlineRoomSession setLocalParticipantReady({
    required OnlineRoomSession session,
    required bool isReady,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<OnlineRoomSession> setLocalParticipantReadyRealtime({
    required OnlineRoomSession session,
    required bool isReady,
  }) {
    throw UnimplementedError();
  }

  @override
  OnlineRoomSession setRemoteParticipantReady({
    required OnlineRoomSession session,
    required String participantId,
    required bool isReady,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<OnlinePlayerAction> submitPlayerAction({
    required String roomCode,
    required OnlinePlayerAction action,
  }) {
    throw UnimplementedError();
  }

  @override
  OnlineRoomSession simulateRemoteGuestJoin({
    required OnlineRoomSession session,
    String guestPlayerName = 'Remote Guest',
  }) {
    throw UnimplementedError();
  }

  @override
  Stream<RemoteMatchHandoffSnapshot?> watchMatchHandoff({
    required String roomCode,
    required String participantId,
  }) {
    throw UnimplementedError();
  }

  @override
  Stream<List<OnlinePlayerAction>> watchPlayerActions(String roomCode) {
    throw UnimplementedError();
  }

  @override
  Stream<List<RemoteMatchPublicEvent>> watchPublicEvents(String roomCode) {
    throw UnimplementedError();
  }

  @override
  Stream<OnlineRoomSession> watchRoom(String roomCode) {
    throw UnimplementedError();
  }
}
