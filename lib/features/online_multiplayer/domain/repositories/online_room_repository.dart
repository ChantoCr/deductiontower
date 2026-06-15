import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_player_action.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_session.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_handoff_snapshot.dart';

abstract class OnlineRoomRepository {
  String normalizeRoomCode(String value);

  OnlineRoomSession createRoom({required String hostPlayerName});

  OnlineRoomSession joinRoomPreview({
    required String roomCode,
    required String guestPlayerName,
  });

  OnlineRoomSession setLocalParticipantReady({
    required OnlineRoomSession session,
    required bool isReady,
  });

  OnlineRoomSession simulateRemoteGuestJoin({
    required OnlineRoomSession session,
    String guestPlayerName = 'Remote Guest',
  });

  OnlineRoomSession setRemoteParticipantReady({
    required OnlineRoomSession session,
    required String participantId,
    required bool isReady,
  });

  Future<OnlineRoomSession> createRoomRealtime({
    required String hostPlayerName,
  });

  Future<OnlineRoomSession> joinRoomRealtime({
    required String roomCode,
    required String guestPlayerName,
  });

  Future<OnlineRoomSession> setLocalParticipantReadyRealtime({
    required OnlineRoomSession session,
    required bool isReady,
  });

  Stream<OnlineRoomSession> watchRoom(String roomCode);

  Stream<RemoteMatchHandoffSnapshot?> watchMatchHandoff({
    required String roomCode,
    required String participantId,
  });

  Future<OnlinePlayerAction> submitPlayerAction({
    required String roomCode,
    required OnlinePlayerAction action,
  });

  Stream<List<OnlinePlayerAction>> watchPlayerActions(String roomCode);
}
