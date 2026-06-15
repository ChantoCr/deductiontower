import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/services/remote_match_firestore_bundle_builder.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_participant.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_session.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_player_bootstrap_seed.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/services/remote_match_bootstrap_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RemoteMatchFirestoreBundleBuilder', () {
    const bootstrapService = RemoteMatchBootstrapService();
    const bundleBuilder = RemoteMatchFirestoreBundleBuilder();
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

    test('builds explicit Firestore docs for bootstrap, public, and private state', () {
      final bootstrapResult = bootstrapService.build(
        room: readyRoom,
        hintsPerPlayer: 2,
        playerSeeds: playerSeeds,
        categories: categories,
        characters: characters,
        matchId: 'match_AB12CD',
        createdAt: createdAt,
      );

      final bundle = bundleBuilder.build(bootstrapResult);

      expect(bundle.roomDocumentPatch['activeMatchId'], 'match_AB12CD');
      expect(bundle.roomDocumentPatch['bootstrapStatus'], 'ready');
      expect(
        bundle.roomDocumentPatch['bootstrapCreatedAt'],
        '2026-06-09T15:00:00.000Z',
      );

      expect(bundle.bootstrapDocument['roomCode'], 'AB12CD');
      expect(bundle.bootstrapDocument['hostSecretTraitId'], 'black_hair');
      expect(bundle.bootstrapDocument['guestSecretTraitId'], 'villain');

      expect(bundle.publicMatchDocument['matchId'], 'match_AB12CD');
      expect(bundle.publicMatchDocument['currentTurnParticipantId'], 'host_1');
      expect(
        bundle.publicMatchDocument['playerPublicState']['guest_1']['hintsRemaining'],
        2,
      );

      expect(bundle.privatePlayerDocuments.keys, {'host_1', 'guest_1'});
      expect(
        bundle.privatePlayerDocuments['host_1']?['userId'],
        'firebase_uid_host',
      );
      expect(
        bundle.privatePlayerDocuments['guest_1']?['secretTraitLocked'],
        isTrue,
      );
    });
  });
}
