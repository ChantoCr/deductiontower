import 'package:anime_deduction_tower/features/online_multiplayer/data/datasources/mock_online_room_datasource.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/datasources/online_room_datasource.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_player_action.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_session.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_handoff_snapshot.dart';

class SupabaseOnlineRoomPreviewDataSource implements OnlineRoomDataSource {
  SupabaseOnlineRoomPreviewDataSource({
    MockOnlineRoomDataSource? previewDataSource,
  }) : _previewDataSource = previewDataSource ?? MockOnlineRoomDataSource();

  final MockOnlineRoomDataSource _previewDataSource;

  @override
  String normalizeRoomCode(String value) {
    return _previewDataSource.normalizeRoomCode(value);
  }

  @override
  OnlineRoomSession createRoom({required String hostPlayerName}) {
    return _previewDataSource.createRoom(hostPlayerName: hostPlayerName);
  }

  @override
  OnlineRoomSession joinRoomPreview({
    required String roomCode,
    required String guestPlayerName,
  }) {
    return _previewDataSource.joinRoomPreview(
      roomCode: roomCode,
      guestPlayerName: guestPlayerName,
    );
  }

  @override
  OnlineRoomSession setLocalParticipantReady({
    required OnlineRoomSession session,
    required bool isReady,
  }) {
    return _previewDataSource.setLocalParticipantReady(
      session: session,
      isReady: isReady,
    );
  }

  @override
  OnlineRoomSession simulateRemoteGuestJoin({
    required OnlineRoomSession session,
    String guestPlayerName = 'Remote Guest',
  }) {
    return _previewDataSource.simulateRemoteGuestJoin(
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
    return _previewDataSource.setRemoteParticipantReady(
      session: session,
      participantId: participantId,
      isReady: isReady,
    );
  }

  @override
  Future<OnlineRoomSession> createRoomRealtime({
    required String hostPlayerName,
  }) {
    return _previewDataSource.createRoomRealtime(
      hostPlayerName: hostPlayerName,
    );
  }

  @override
  Future<OnlineRoomSession> joinRoomRealtime({
    required String roomCode,
    required String guestPlayerName,
  }) {
    return _previewDataSource.joinRoomRealtime(
      roomCode: roomCode,
      guestPlayerName: guestPlayerName,
    );
  }

  @override
  Future<OnlineRoomSession> setLocalParticipantReadyRealtime({
    required OnlineRoomSession session,
    required bool isReady,
  }) {
    return _previewDataSource.setLocalParticipantReadyRealtime(
      session: session,
      isReady: isReady,
    );
  }

  @override
  Stream<OnlineRoomSession> watchRoom(String roomCode) {
    return _previewDataSource.watchRoom(roomCode);
  }

  @override
  Stream<RemoteMatchHandoffSnapshot?> watchMatchHandoff({
    required String roomCode,
    required String participantId,
  }) {
    return _previewDataSource.watchMatchHandoff(
      roomCode: roomCode,
      participantId: participantId,
    );
  }

  @override
  Future<OnlinePlayerAction> submitPlayerAction({
    required String roomCode,
    required OnlinePlayerAction action,
  }) {
    return _previewDataSource.submitPlayerAction(
      roomCode: roomCode,
      action: action,
    );
  }

  @override
  Stream<List<OnlinePlayerAction>> watchPlayerActions(String roomCode) {
    return _previewDataSource.watchPlayerActions(roomCode);
  }
}
