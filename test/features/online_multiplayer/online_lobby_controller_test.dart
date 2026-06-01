import 'dart:math';

import 'package:anime_deduction_tower/features/online_multiplayer/data/repositories/mock_online_room_repository_impl.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_session.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/presentation/controllers/online_lobby_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OnlineLobbyController', () {
    late OnlineLobbyController controller;

    setUp(() {
      controller = OnlineLobbyController(
        repository: MockOnlineRoomRepositoryImpl(random: Random(2)),
      );
    });

    test('stores trimmed player names and normalized join codes', () {
      controller.updatePlayerName('  Rei  ');
      controller.updateJoinCode(' ab-12_cd34 ');

      expect(controller.state.playerName, 'Rei');
      expect(controller.state.joinCode, 'AB12CD');
    });

    test('switches lobby mode and clears stale session previews', () {
      controller.updatePlayerName('Host Player');
      controller.createRoomPreview();

      controller.updateLobbyMode(OnlineLobbyMode.join);

      expect(controller.state.lobbyMode, OnlineLobbyMode.join);
      expect(controller.state.activeSession, isNull);
      expect(controller.state.canCreateRoom, isFalse);
    });

    test('creates a mock host room preview', () {
      controller.updatePlayerName('Host Player');

      final session = controller.createRoomPreview();

      expect(session.isHost, isTrue);
      expect(session.phase, OnlineRoomPhase.waitingForOpponent);
      expect(controller.state.activeSession, isNotNull);
      expect(controller.state.joinCode, session.roomCode);
    });

    test('joins a mock guest room preview', () {
      controller.updateLobbyMode(OnlineLobbyMode.join);
      controller.updatePlayerName('Guest Player');
      controller.updateJoinCode('abc123');

      final session = controller.joinRoomPreview();

      expect(session.isHost, isFalse);
      expect(session.phase, OnlineRoomPhase.readyToSync);
      expect(session.guestPlayerName, 'Guest Player');
      expect(controller.state.activeSession?.roomCode, 'ABC123');
      expect(controller.state.lobbyMode, OnlineLobbyMode.join);
    });

    test('requires join mode before the join action becomes available', () {
      controller.updatePlayerName('Guest Player');
      controller.updateJoinCode('abc123');

      expect(controller.state.canJoinRoom, isFalse);

      controller.updateLobbyMode(OnlineLobbyMode.join);

      expect(controller.state.canJoinRoom, isTrue);
    });

    test('throws when join preview code is incomplete', () {
      controller.updateLobbyMode(OnlineLobbyMode.join);
      controller.updatePlayerName('Guest Player');
      controller.updateJoinCode('abc1');

      expect(() => controller.joinRoomPreview(), throwsStateError);
    });
  });
}
