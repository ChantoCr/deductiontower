import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/core/enums/online_player_action_status.dart';
import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/services/remote_match_backend_authority_service.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_action_resolution_authority.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_player_action.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_action_resolution.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_bootstrap_payload.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_handoff_snapshot.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_player_state.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_state.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_player_private_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RemoteMatchBackendAuthorityService', () {
    test('resolves the oldest pending action with backend metadata', () async {
      final store = _FakeBackendAuthorityStore(
        handoff: _buildGuestHintHandoff(),
        actions: [
          OnlinePlayerAction(
            actionId: 'online_action_1',
            submittedByParticipantId: 'guest_1',
            submittedByUserId: 'firebase_uid_guest',
            actionType: TurnActionType.requestHint,
            expectedMatchVersion: 0,
            status: OnlinePlayerActionStatus.pending,
            createdAt: DateTime.parse('2026-06-16T10:01:00.000Z'),
          ),
          OnlinePlayerAction(
            actionId: 'online_action_2',
            submittedByParticipantId: 'guest_1',
            submittedByUserId: 'firebase_uid_guest',
            actionType: TurnActionType.requestHint,
            expectedMatchVersion: 0,
            status: OnlinePlayerActionStatus.pending,
            createdAt: DateTime.parse('2026-06-16T10:02:00.000Z'),
          ),
        ],
      );
      final service = RemoteMatchBackendAuthorityService(
        loadValidCategories: () async => _categories,
        loadCharacters: () async => _characters,
      );

      final resolution = await service.resolveOldestPendingAction(
        roomCode: 'AB12CD',
        store: store,
      );

      expect(resolution, isNotNull);
      expect(resolution!.resolvedAction.actionId, 'online_action_1');
      expect(
        resolution.resolvedAction.resolutionSource,
        OnlineActionResolutionAuthority.backendService,
      );
      expect(
        resolution.resolvedAction.resolvedByParticipantId,
        RemoteMatchBackendAuthorityService.resolverParticipantId,
      );
      expect(
        resolution.resolvedAction.resolvedByUserId,
        RemoteMatchBackendAuthorityService.resolverUserId,
      );
      expect(resolution.publicEvent.shortLabel, 'Private hint granted');
      expect(store.persistedResolutions, hasLength(1));
      expect(
        store.persistedResolutions.single.resolvedAction.status,
        OnlinePlayerActionStatus.applied,
      );
    });

    test('returns null when no pending action is available', () async {
      final store = _FakeBackendAuthorityStore(
        handoff: _buildGuestHintHandoff(),
        actions: const [],
      );
      final service = RemoteMatchBackendAuthorityService(
        loadValidCategories: () async => _categories,
        loadCharacters: () async => _characters,
      );

      final resolution = await service.resolveOldestPendingAction(
        roomCode: 'AB12CD',
        store: store,
      );

      expect(resolution, isNull);
      expect(store.persistedResolutions, isEmpty);
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

class _FakeBackendAuthorityStore implements RemoteMatchBackendAuthorityStore {
  _FakeBackendAuthorityStore({
    required List<OnlinePlayerAction> actions,
    required this.handoff,
  }) : _actions = [...actions];

  final List<OnlinePlayerAction> _actions;
  final RemoteMatchHandoffSnapshot handoff;
  final List<RemoteMatchActionResolution> persistedResolutions = [];

  @override
  Future<void> persistActionResolution({
    required String roomCode,
    required RemoteMatchActionResolution resolution,
  }) async {
    persistedResolutions.add(resolution);
    final index = _actions.indexWhere(
      (action) => action.actionId == resolution.resolvedAction.actionId,
    );
    if (index != -1) {
      _actions[index] = resolution.resolvedAction;
    }
  }

  @override
  Future<RemoteMatchHandoffSnapshot?> readMatchHandoff({
    required String roomCode,
    required String participantId,
  }) async {
    return handoff;
  }

  @override
  Future<OnlinePlayerAction?> readOldestPendingAction(String roomCode) async {
    final pendingActions = _actions
        .where((action) => action.status == OnlinePlayerActionStatus.pending)
        .toList()
      ..sort((left, right) => left.createdAt.compareTo(right.createdAt));

    if (pendingActions.isEmpty) {
      return null;
    }

    return pendingActions.first;
  }
}
