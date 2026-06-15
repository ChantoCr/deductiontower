import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_participant.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_session.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/services/remote_match_preview_seed_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RemoteMatchPreviewSeedService', () {
    const service = RemoteMatchPreviewSeedService();

    final room = OnlineRoomSession(
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
      const TraitCategory(
        id: 'mentor',
        label: 'Mentor',
        tagId: 'mentor',
        difficulty: DifficultyLevel.medium,
        minCharacters: 2,
        hintType: 'role',
      ),
    ];

    test('builds deterministic preview seeds for host and guest', () {
      final seeds = service.buildSeeds(
        room: room,
        validCategories: categories,
      );

      expect(seeds, hasLength(2));
      expect(seeds.first.participantId, 'host_1');
      expect(seeds.first.userId, 'preview_user_host_1');
      expect(seeds.last.participantId, 'guest_1');
      expect(seeds.last.userId, 'preview_user_guest_1');
      expect(seeds.first.secretTraitId, isNotEmpty);
      expect(seeds.last.secretTraitId, isNotEmpty);
      expect(seeds.first.secretTraitId, isNot(seeds.last.secretTraitId));
    });

    test('uses provided participant user ids when building non-preview seeds', () {
      final seeds = service.buildSeeds(
        room: room,
        validCategories: categories,
        participantUserIds: const {
          'host_1': 'firebase_uid_host',
          'guest_1': 'firebase_uid_guest',
        },
      );

      expect(seeds.first.userId, 'firebase_uid_host');
      expect(seeds.last.userId, 'firebase_uid_guest');
    });

    test('reuses the only available category when just one valid category exists', () {
      final seeds = service.buildSeeds(
        room: room,
        validCategories: [categories.first],
      );

      expect(seeds.first.secretTraitId, 'black_hair');
      expect(seeds.last.secretTraitId, 'black_hair');
    });

    test('throws when both room participants are not available', () {
      final incompleteRoom = room.copyWith(
        participants: const [
          OnlineRoomParticipant(
            id: 'host_1',
            displayName: 'Host',
            role: OnlineRoomParticipantRole.host,
            connectionState: OnlineRoomParticipantConnectionState.connected,
            isLocalPlayer: true,
            isReady: true,
          ),
        ],
      );

      expect(
        () => service.buildSeeds(
          room: incompleteRoom,
          validCategories: categories,
        ),
        throwsStateError,
      );
    });
  });
}
