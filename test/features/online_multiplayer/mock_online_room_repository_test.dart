import 'dart:math';

import 'package:anime_deduction_tower/features/online_multiplayer/data/repositories/mock_online_room_repository_impl.dart';
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
      expect(session.phase, OnlineRoomPhase.readyToSync);
    });
  });
}
