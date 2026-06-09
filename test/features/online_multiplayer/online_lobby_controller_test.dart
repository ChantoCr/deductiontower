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
      expect(session.localParticipant.displayName, 'Host Player');
      expect(controller.state.activeSession, isNotNull);
      expect(controller.state.joinCode, session.roomCode);
    });

    test('joins a mock guest room preview', () {
      controller.updateLobbyMode(OnlineLobbyMode.join);
      controller.updatePlayerName('Guest Player');
      controller.updateJoinCode('abc123');

      final session = controller.joinRoomPreview();

      expect(session.isHost, isFalse);
      expect(session.phase, OnlineRoomPhase.waitingForReady);
      expect(session.guestPlayerName, 'Guest Player');
      expect(session.localParticipant.displayName, 'Guest Player');
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

    test('toggles local readiness inside an active room preview', () {
      controller.updatePlayerName('Host Player');
      controller.createRoomPreview();

      final updated = controller.toggleLocalReady();

      expect(updated.localParticipant.isReady, isTrue);
      expect(controller.state.activeSession?.localParticipant.isReady, isTrue);
    });

    test('simulates a remote guest join in a host preview', () {
      controller.updatePlayerName('Host Player');
      controller.createRoomPreview();

      final updated = controller.simulateRemoteGuestJoin();

      expect(updated.guestPlayerName, 'Remote Guest');
      expect(updated.participants, hasLength(2));
      expect(controller.state.canSimulateRemoteGuestJoin, isFalse);
      expect(controller.state.canSimulateRemoteReadyToggle, isTrue);
    });

    test('toggles remote readiness inside an active preview room', () {
      controller.updatePlayerName('Host Player');
      controller.createRoomPreview();
      controller.simulateRemoteGuestJoin();

      final updated = controller.toggleRemoteReady();

      expect(updated.primaryRemoteParticipant?.isReady, isTrue);
      expect(controller.state.activeSession?.primaryRemoteParticipant?.isReady, isTrue);
    });

    test('throws when join preview code is incomplete', () {
      controller.updateLobbyMode(OnlineLobbyMode.join);
      controller.updatePlayerName('Guest Player');
      controller.updateJoinCode('abc1');

      expect(() => controller.joinRoomPreview(), throwsStateError);
    });

    test('throws when ready state is changed without an active session', () {
      expect(() => controller.toggleLocalReady(), throwsStateError);
    });

    test('throws when remote ready is toggled without a remote participant', () {
      controller.updatePlayerName('Host Player');
      controller.createRoomPreview();

      expect(() => controller.toggleRemoteReady(), throwsStateError);
    });
  });
}
