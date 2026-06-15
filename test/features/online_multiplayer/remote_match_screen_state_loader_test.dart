import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_bootstrap_payload.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_handoff_snapshot.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_player_state.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_state.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_player_private_state.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/services/remote_match_screen_state_loader.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RemoteMatchScreenStateLoader', () {
    const loader = RemoteMatchScreenStateLoader();
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

    final handoff = RemoteMatchHandoffSnapshot(
      roomCode: 'AB12CD',
      localParticipantId: 'host_1',
      bootstrapPayload: RemoteMatchBootstrapPayload(
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
        createdAt: DateTime.parse('2026-06-09T12:00:00.000Z'),
      ),
      publicState: RemoteMatchPublicState(
        matchId: 'match_AB12CD',
        roomCode: 'AB12CD',
        status: MatchStatus.inProgress,
        currentTurnParticipantId: 'guest_1',
        turnNumber: 3,
        sharedCharacterPoolIds: const ['goku', 'vegeta', 'frieza'],
        playerStates: const [
          RemoteMatchPublicPlayerState(
            participantId: 'host_1',
            displayName: 'Host',
            hintsRemaining: 1,
            characterGuessCount: 2,
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
        matchVersion: 3,
        createdAt: DateTime.parse('2026-06-09T12:00:00.000Z'),
        updatedAt: DateTime.parse('2026-06-09T12:04:00.000Z'),
      ),
      privateState: RemotePlayerPrivateState(
        participantId: 'host_1',
        userId: 'firebase_uid_host',
        secretTraitId: 'black_hair',
        secretTraitLocked: true,
        hasViewedSecret: true,
        hintsUsed: 1,
        selectedAt: DateTime.parse('2026-06-09T12:00:00.000Z'),
        updatedAt: DateTime.parse('2026-06-09T12:04:00.000Z'),
      ),
    );

    test('builds a gameplay-ready remote screen state from persisted docs', () {
      final screenState = loader.load(
        handoff: handoff,
        categories: categories,
        characters: characters,
      );

      expect(screenState.roomCode, 'AB12CD');
      expect(screenState.match.id, 'match_AB12CD');
      expect(screenState.localPlayer.name, 'Host');
      expect(screenState.remotePlayer.name, 'Guest');
      expect(screenState.localSecretTrait.label, 'Black Hair');
      expect(screenState.match.currentPlayerId, 'guest_1');
      expect(screenState.isLocalPlayersTurn, isFalse);
      expect(screenState.sharedCharacterPoolSize, 3);
      expect(screenState.characterPool.map((character) => character.id), [
        'goku',
        'vegeta',
        'frieza',
      ]);
      expect(screenState.localPlayer.hintsRemaining, 1);
      expect(screenState.remotePlayer.validCharacterIds, ['vegeta', 'frieza']);
      expect(screenState.syncedAt.toIso8601String(), '2026-06-09T12:04:00.000Z');
    });

    test('throws when the local private secret does not align with the payload', () {
      final invalidHandoff = RemoteMatchHandoffSnapshot(
        roomCode: handoff.roomCode,
        localParticipantId: handoff.localParticipantId,
        bootstrapPayload: handoff.bootstrapPayload,
        publicState: handoff.publicState,
        privateState: RemotePlayerPrivateState(
          participantId: 'host_1',
          userId: 'firebase_uid_host',
          secretTraitId: 'villain',
          secretTraitLocked: true,
          hasViewedSecret: true,
          hintsUsed: 1,
          selectedAt: DateTime.parse('2026-06-09T12:00:00.000Z'),
          updatedAt: DateTime.parse('2026-06-09T12:04:00.000Z'),
        ),
      );

      expect(
        () => loader.load(
          handoff: invalidHandoff,
          categories: categories,
          characters: characters,
        ),
        throwsStateError,
      );
    });
  });
}
