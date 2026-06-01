import 'dart:math';

import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_session.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/repositories/online_room_repository.dart';

class MockOnlineRoomRepositoryImpl implements OnlineRoomRepository {
  MockOnlineRoomRepositoryImpl({Random? random}) : _random = random ?? Random();

  static const _roomCodeLength = 6;
  static const _alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  final Random _random;

  @override
  String normalizeRoomCode(String value) {
    final uppercase = value.toUpperCase();
    final sanitized = uppercase.replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (sanitized.length <= _roomCodeLength) {
      return sanitized;
    }

    return sanitized.substring(0, _roomCodeLength);
  }

  @override
  OnlineRoomSession createRoom({required String hostPlayerName}) {
    return OnlineRoomSession(
      roomCode: _generateRoomCode(),
      hostPlayerName: hostPlayerName.trim(),
      isHost: true,
      phase: OnlineRoomPhase.waitingForOpponent,
      createdAt: DateTime.now(),
    );
  }

  @override
  OnlineRoomSession joinRoomPreview({
    required String roomCode,
    required String guestPlayerName,
  }) {
    return OnlineRoomSession(
      roomCode: normalizeRoomCode(roomCode),
      hostPlayerName: 'Remote Host',
      guestPlayerName: guestPlayerName.trim(),
      isHost: false,
      phase: OnlineRoomPhase.readyToSync,
      createdAt: DateTime.now(),
    );
  }

  String _generateRoomCode() {
    final buffer = StringBuffer();
    for (var index = 0; index < _roomCodeLength; index++) {
      final charIndex = _random.nextInt(_alphabet.length);
      buffer.write(_alphabet[charIndex]);
    }

    return buffer.toString();
  }
}
