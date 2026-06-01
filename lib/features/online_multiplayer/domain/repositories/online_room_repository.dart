import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_session.dart';

abstract class OnlineRoomRepository {
  String normalizeRoomCode(String value);

  OnlineRoomSession createRoom({required String hostPlayerName});

  OnlineRoomSession joinRoomPreview({
    required String roomCode,
    required String guestPlayerName,
  });
}
