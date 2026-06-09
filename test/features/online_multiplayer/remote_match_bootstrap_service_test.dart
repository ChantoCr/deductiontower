import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_participant.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_session.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_player_bootstrap_seed.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/services/remote_match_bootstrap_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RemoteMatchBootstrapService', () {
    const service = RemoteMatchBootstrapService();
    final createdAt = DateTime.parse('2026-06-09T15:00:00.000Z');

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
        popularity: 10,
      ),
      const Character(
        id: 'frieza',
        name: 'Frieza',
        series: 'Dragon Ball',
        tags: ['villain'],
        difficulty: DifficultyLevel.easy,
        popularity: 9,
      ),
    ];

    final readyRoom = OnlineRoomSession(
      roomCode: 'AB12CD',
      localParticipantId: 'host_1',
      participants: const [
        OnlineRoomParticipant(
          id: 'host_1',
          displayName: 'Host',
          role: OnlineRoomParticipantRole.host,
          connectionState: OnlineRoomParticipantConnectionState.connected,
          isLocalPlayer: true,
          isReady: true,
        ),
        OnlineRoomParticipant(
          id: 'guest_1',
          displayName: 'Guest',
          role: OnlineRoomParticipantRole.guest,
          connectionState: OnlineRoomParticipantConnectionState.connected,
          isLocalPlayer: false,
          isReady: true,
        ),
      ],
      phase: OnlineRoomPhase.readyToSync,
      createdAt: DateTime.parse('2026-06-09T14:00:00.000Z'),
    );

    final playerSeeds = const [
      RemotePlayerBootstrapSeed(
        participantId: 'host_1',
        userId: 'firebase_uid_host',
        secretTraitId: 'black_hair',
      ),
      RemotePlayerBootstrapSeed(
        participantId: 'guest_1',
        userId: 'firebase_uid_guest',
        secretTraitId: 'villain',
      ),
    ];

    test('builds remote bootstrap payload plus initial public and private states', () {
      final result = service.build(
        room: readyRoom,
        hintsPerPlayer: 2,
        playerSeeds: playerSeeds,
        categories: categories,
        characters: characters,
        matchId: 'match_AB12CD_001',
        createdAt: createdAt,
      );

      expect(result.payload.roomCode, 'AB12CD');
      expect(result.payload.matchId, 'match_AB12CD_001');
      expect(result.payload.canStartMatch, isTrue);
      expect(result.payload.startingParticipantId, 'host_1');
      expect(result.payload.sharedCharacterPoolIds, ['goku', 'vegeta', 'frieza']);

      expect(result.publicState.status, MatchStatus.inProgress);
      expect(result.publicState.currentTurnParticipantId, 'host_1');
      expect(result.publicState.turnNumber, 0);
      expect(result.publicState.matchVersion, 0);
      expect(result.publicState.playerStates, hasLength(2));
      expect(result.publicState.playerStateFor('guest_1')?.hintsRemaining, 2);

      expect(result.privatePlayerStates, hasLength(2));
      expect(result.privateStateFor('host_1')?.secretTraitId, 'black_hair');
      expect(result.privateStateFor('guest_1')?.secretTraitLocked, isTrue);
      expect(result.privateStateFor('guest_1')?.hasViewedSecret, isTrue);
    });

    test('supports an explicit starting participant override', () {
      final result = service.build(
        room: readyRoom,
        hintsPerPlayer: 1,
        playerSeeds: playerSeeds,
        categories: categories,
        characters: characters,
        startingParticipantId: 'guest_1',
        createdAt: createdAt,
      );

      expect(result.payload.startingParticipantId, 'guest_1');
      expect(result.publicState.currentTurnParticipantId, 'guest_1');
      expect(result.publicState.currentTurnPlayerState?.displayName, 'Guest');
    });

    test('throws when the room is not ready to sync', () {
      final notReadyRoom = readyRoom.copyWith(
        phase: OnlineRoomPhase.waitingForReady,
      );

      expect(
        () => service.build(
          room: notReadyRoom,
          hintsPerPlayer: 2,
          playerSeeds: playerSeeds,
          categories: categories,
          characters: characters,
        ),
        throwsStateError,
      );
    });

    test('throws when required participant secret data is missing', () {
      expect(
        () => service.build(
          room: readyRoom,
          hintsPerPlayer: 2,
          playerSeeds: const [
            RemotePlayerBootstrapSeed(
              participantId: 'host_1',
              userId: 'firebase_uid_host',
              secretTraitId: 'black_hair',
            ),
          ],
          categories: categories,
          characters: characters,
        ),
        throwsStateError,
      );
    });
  });
}
