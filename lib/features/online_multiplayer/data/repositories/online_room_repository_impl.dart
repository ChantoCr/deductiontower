import 'package:anime_deduction_tower/features/online_multiplayer/data/datasources/online_room_datasource.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_player_action.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_session.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_action_resolution.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_handoff_snapshot.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_event.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/repositories/online_room_repository.dart';

class OnlineRoomRepositoryImpl implements OnlineRoomRepository {
  OnlineRoomRepositoryImpl({required OnlineRoomDataSource dataSource})
      : _dataSource = dataSource;

  final OnlineRoomDataSource _dataSource;

  @override
  String normalizeRoomCode(String value) {
    return _dataSource.normalizeRoomCode(value);
  }

  @override
  OnlineRoomSession createRoom({required String hostPlayerName}) {
    return _dataSource.createRoom(hostPlayerName: hostPlayerName);
  }

  @override
  OnlineRoomSession joinRoomPreview({
    required String roomCode,
    required String guestPlayerName,
  }) {
    return _dataSource.joinRoomPreview(
      roomCode: roomCode,
      guestPlayerName: guestPlayerName,
    );
  }

  @override
  OnlineRoomSession setLocalParticipantReady({
    required OnlineRoomSession session,
    required bool isReady,
  }) {
    return _dataSource.setLocalParticipantReady(
      session: session,
      isReady: isReady,
    );
  }

  @override
  OnlineRoomSession simulateRemoteGuestJoin({
    required OnlineRoomSession session,
    String guestPlayerName = 'Remote Guest',
  }) {
    return _dataSource.simulateRemoteGuestJoin(
      session: session,
      guestPlayerName: guestPlayerName,
    );
  }

  @override
  OnlineRoomSession setRemoteParticipantReady({
    required OnlineRoomSession session,
    required String participantId,
    required bool isReady,
  }) {
    return _dataSource.setRemoteParticipantReady(
      session: session,
      participantId: participantId,
      isReady: isReady,
    );
  }

  @override
  Future<OnlineRoomSession> createRoomRealtime({
    required String hostPlayerName,
  }) {
    return _dataSource.createRoomRealtime(hostPlayerName: hostPlayerName);
  }

  @override
  Future<OnlineRoomSession> joinRoomRealtime({
    required String roomCode,
    required String guestPlayerName,
  }) {
    return _dataSource.joinRoomRealtime(
      roomCode: roomCode,
      guestPlayerName: guestPlayerName,
    );
  }

  @override
  Future<OnlineRoomSession> setLocalParticipantReadyRealtime({
    required OnlineRoomSession session,
    required bool isReady,
  }) {
    return _dataSource.setLocalParticipantReadyRealtime(
      session: session,
      isReady: isReady,
    );
  }

  @override
  Stream<OnlineRoomSession> watchRoom(String roomCode) {
    return _dataSource.watchRoom(roomCode);
  }

  @override
  Stream<RemoteMatchHandoffSnapshot?> watchMatchHandoff({
    required String roomCode,
    required String participantId,
  }) {
    return _dataSource.watchMatchHandoff(
      roomCode: roomCode,
      participantId: participantId,
    );
  }

  @override
  Future<RemoteMatchHandoffSnapshot?> readMatchHandoff({
    required String roomCode,
    required String participantId,
  }) {
    return _dataSource.readMatchHandoff(
      roomCode: roomCode,
      participantId: participantId,
    );
  }

  @override
  Future<OnlinePlayerAction> submitPlayerAction({
    required String roomCode,
    required OnlinePlayerAction action,
  }) {
    return _dataSource.submitPlayerAction(
      roomCode: roomCode,
      action: action,
    );
  }

  @override
  Stream<List<OnlinePlayerAction>> watchPlayerActions(String roomCode) {
    return _dataSource.watchPlayerActions(roomCode);
  }

  @override
  Stream<List<RemoteMatchPublicEvent>> watchPublicEvents(String roomCode) {
    return _dataSource.watchPublicEvents(roomCode);
  }

  @override
  Future<void> persistActionResolution({
    required String roomCode,
    required RemoteMatchActionResolution resolution,
  }) {
    return _dataSource.persistActionResolution(
      roomCode: roomCode,
      resolution: resolution,
    );
  }
}
