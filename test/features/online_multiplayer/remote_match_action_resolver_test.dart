import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/core/enums/match_end_reason.dart';
import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_action_resolution_authority.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_player_action.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_action_error_code.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_bootstrap_payload.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_player_state.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_state.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_player_private_state.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/services/remote_match_action_resolver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RemoteMatchActionResolver', () {
    const resolver = RemoteMatchActionResolver();
    final categories = [
      const TraitCategory(
        id: 'black_hair',
        label: 'Black Hair',
        tagId: 'black_hair',
        difficulty: DifficultyLevel.easy,
        minCharacters: 2,
        hintType: 'appearance',
      ),
      const TraitCategory(
        id: 'villain',
        label: 'Villain',
        tagId: 'villain',
        difficulty: DifficultyLevel.medium,
        minCharacters: 2,
        hintType: 'role',
      ),
    ];

    final characters = [
      const Character(
        id: 'goku',
        name: 'Goku',
        series: 'Dragon Ball',
        tags: ['black_hair', 'hero'],
        difficulty: DifficultyLevel.easy,
        popularity: 10,
      ),
      const Character(
        id: 'vegeta',
        name: 'Vegeta',
        series: 'Dragon Ball',
        tags: ['black_hair', 'villain'],
        difficulty: DifficultyLevel.easy,
        popularity: 9,
      ),
      const Character(
        id: 'frieza',
        name: 'Frieza',
        series: 'Dragon Ball',
        tags: ['villain'],
        difficulty: DifficultyLevel.easy,
        popularity: 8,
      ),
    ];

    final payload = RemoteMatchBootstrapPayload(
      roomCode: 'AB12CD',
      matchId: 'match_AB12CD',
      hostParticipantId: 'host_1',
      guestParticipantId: 'guest_1',
      startingParticipantId: 'host_1',
      hostPlayerName: 'Host',
      guestPlayerName: 'Guest',
      hintsPerPlayer: 2,
      hostSecretTraitId: 'black_hair',
      guestSecretTraitId: 'villain',
      sharedCharacterPoolIds: const ['goku', 'vegeta', 'frieza'],
      createdAt: DateTime.parse('2026-06-15T09:00:00.000Z'),
    );

    final publicState = RemoteMatchPublicState(
      matchId: 'match_AB12CD',
      roomCode: 'AB12CD',
      status: MatchStatus.inProgress,
      currentTurnParticipantId: 'host_1',
      turnNumber: 2,
      sharedCharacterPoolIds: const ['goku', 'vegeta', 'frieza'],
      playerStates: const [
        RemoteMatchPublicPlayerState(
          participantId: 'host_1',
          displayName: 'Host',
          hintsRemaining: 2,
          characterGuessCount: 1,
          traitGuessCount: 0,
        ),
        RemoteMatchPublicPlayerState(
          participantId: 'guest_1',
          displayName: 'Guest',
          hintsRemaining: 2,
          characterGuessCount: 0,
          traitGuessCount: 0,
        ),
      ],
      matchVersion: 2,
      createdAt: DateTime.parse('2026-06-15T09:00:00.000Z'),
      updatedAt: DateTime.parse('2026-06-15T09:02:00.000Z'),
    );

    final hostPrivateState = RemotePlayerPrivateState(
      participantId: 'host_1',
      userId: 'firebase_uid_host',
      secretTraitId: 'black_hair',
      secretTraitLocked: true,
      hasViewedSecret: true,
      hintsUsed: 0,
      selectedAt: DateTime.parse('2026-06-15T09:00:00.000Z'),
      updatedAt: DateTime.parse('2026-06-15T09:02:00.000Z'),
    );

    test('applies a character guess and advances the public turn state', () {
      final action = OnlinePlayerAction(
        actionId: 'online_action_1',
        submittedByParticipantId: 'host_1',
        submittedByUserId: 'firebase_uid_host',
        actionType: TurnActionType.guessCharacter,
        characterId: 'vegeta',
        expectedMatchVersion: 2,
        createdAt: DateTime.parse('2026-06-15T09:03:00.000Z'),
      );

      final resolution = resolver.resolve(
        payload: payload,
        publicState: publicState,
        privateState: hostPrivateState,
        action: action,
        categories: categories,
        characters: characters,
        resolvedByParticipantId: 'host_1',
        resolvedByUserId: 'firebase_uid_host',
        resolutionSource: OnlineActionResolutionAuthority.hostClient,
        resolvedAt: DateTime.parse('2026-06-15T09:03:05.000Z'),
      );

      expect(resolution.wasApplied, isTrue);
      expect(resolution.baseMatchVersion, 2);
      expect(resolution.publicState.currentTurnParticipantId, 'guest_1');
      expect(resolution.publicState.turnNumber, 3);
      expect(resolution.publicState.matchVersion, 3);
      expect(resolution.publicState.lastResolvedActionId, 'online_action_1');
      expect(
        resolution.publicState.playerStateFor('host_1')?.characterGuessCount,
        2,
      );
      expect(resolution.affectedPrivateState, isNull);
      expect(resolution.publicEvent.shortLabel, 'Correct character guess');
      expect(
        resolution.publicEvent.resultSummary,
        'Correct character guess. Turn passed to the opponent.',
      );
      expect(resolution.publicEvent.submittedValueLabel, 'Vegeta');
      expect(resolution.resolvedAction.resolvedByParticipantId, 'host_1');
      expect(resolution.resolvedAction.resolvedByUserId, 'firebase_uid_host');
      expect(
        resolution.resolvedAction.resolutionSource,
        OnlineActionResolutionAuthority.hostClient,
      );
    });

    test('applies a hint request and updates both public and private state',
        () {
      final action = OnlinePlayerAction(
        actionId: 'online_action_2',
        submittedByParticipantId: 'host_1',
        submittedByUserId: 'firebase_uid_host',
        actionType: TurnActionType.requestHint,
        expectedMatchVersion: 2,
        createdAt: DateTime.parse('2026-06-15T09:03:00.000Z'),
      );

      final resolution = resolver.resolve(
        payload: payload,
        publicState: publicState,
        privateState: hostPrivateState,
        action: action,
        categories: categories,
        characters: characters,
        resolvedByParticipantId: 'host_1',
        resolvedByUserId: 'firebase_uid_host',
        resolutionSource: OnlineActionResolutionAuthority.hostClient,
        resolvedAt: DateTime.parse('2026-06-15T09:03:05.000Z'),
      );

      expect(resolution.wasApplied, isTrue);
      expect(resolution.publicState.currentTurnParticipantId, 'guest_1');
      expect(resolution.publicState.turnNumber, 3);
      expect(
        resolution.publicState.playerStateFor('host_1')?.hintsRemaining,
        1,
      );
      expect(resolution.affectedPrivateState?.hintsUsed, 1);
      expect(
        resolution.affectedPrivateState?.lastPrivateHintText,
        'The hidden trait is related to role and is medium difficulty.',
      );
      expect(resolution.publicEvent.shortLabel, 'Private hint granted');
      expect(
        resolution.publicEvent.resultSummary,
        'Private hint delivered. The exact hint text stays outside public event docs.',
      );
      expect(resolution.resolvedAction.resolvedByParticipantId, 'host_1');
      expect(resolution.resolvedAction.resolvedByUserId, 'firebase_uid_host');
      expect(
        resolution.resolvedAction.resolutionSource,
        OnlineActionResolutionAuthority.hostClient,
      );
    });

    test('rejects an action with a stale expected match version', () {
      final action = OnlinePlayerAction(
        actionId: 'online_action_3',
        submittedByParticipantId: 'host_1',
        submittedByUserId: 'firebase_uid_host',
        actionType: TurnActionType.guessTrait,
        traitId: 'villain',
        expectedMatchVersion: 1,
        createdAt: DateTime.parse('2026-06-15T09:03:00.000Z'),
      );

      final resolution = resolver.resolve(
        payload: payload,
        publicState: publicState,
        privateState: hostPrivateState,
        action: action,
        categories: categories,
        characters: characters,
        resolvedByParticipantId: 'host_1',
        resolvedByUserId: 'firebase_uid_host',
        resolutionSource: OnlineActionResolutionAuthority.hostClient,
        resolvedAt: DateTime.parse('2026-06-15T09:03:05.000Z'),
      );

      expect(resolution.wasRejected, isTrue);
      expect(
        resolution.resolvedAction.errorCode,
        RemoteMatchActionErrorCode.staleMatchVersion,
      );
      expect(resolution.publicState.matchVersion, 2);
      expect(resolution.publicState.turnNumber, 2);
      expect(resolution.publicState.currentTurnParticipantId, 'host_1');
      expect(resolution.publicState.lastResolvedActionId, 'online_action_3');
      expect(resolution.affectedPrivateState, isNull);
      expect(resolution.publicEvent.shortLabel, 'Rejected trait guess');
      expect(
        resolution.publicEvent.resultSummary,
        'Rejected. The submitted match version was stale.',
      );
      expect(resolution.resolvedAction.resolvedByParticipantId, 'host_1');
      expect(resolution.resolvedAction.resolvedByUserId, 'firebase_uid_host');
      expect(
        resolution.resolvedAction.resolutionSource,
        OnlineActionResolutionAuthority.hostClient,
      );
    });

    test('applies surrender and finishes the match for the opponent', () {
      final action = OnlinePlayerAction(
        actionId: 'online_action_4',
        submittedByParticipantId: 'host_1',
        submittedByUserId: 'firebase_uid_host',
        actionType: TurnActionType.surrender,
        expectedMatchVersion: 2,
        createdAt: DateTime.parse('2026-06-15T09:03:00.000Z'),
      );

      final resolution = resolver.resolve(
        payload: payload,
        publicState: publicState,
        privateState: hostPrivateState,
        action: action,
        categories: categories,
        characters: characters,
        resolvedByParticipantId: 'host_1',
        resolvedByUserId: 'firebase_uid_host',
        resolutionSource: OnlineActionResolutionAuthority.hostClient,
        resolvedAt: DateTime.parse('2026-06-15T09:03:05.000Z'),
      );

      expect(resolution.wasApplied, isTrue);
      expect(resolution.publicState.status, MatchStatus.completed);
      expect(resolution.publicState.winnerParticipantId, 'guest_1');
      expect(resolution.publicState.endReason, MatchEndReason.surrender);
      expect(resolution.publicState.matchVersion, 3);
      expect(resolution.publicState.turnNumber, 3);
      expect(resolution.publicEvent.shortLabel, 'Surrender resolved');
      expect(resolution.publicEvent.resultSummary, 'Match ended by surrender.');
      expect(resolution.resolvedAction.resolvedByParticipantId, 'host_1');
      expect(resolution.resolvedAction.resolvedByUserId, 'firebase_uid_host');
      expect(
        resolution.resolvedAction.resolutionSource,
        OnlineActionResolutionAuthority.hostClient,
      );
    });
  });
}
