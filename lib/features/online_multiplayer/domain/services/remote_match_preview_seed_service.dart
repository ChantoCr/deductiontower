import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_session.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_player_bootstrap_seed.dart';

class RemoteMatchPreviewSeedService {
  const RemoteMatchPreviewSeedService();

  List<RemotePlayerBootstrapSeed> buildSeeds({
    required OnlineRoomSession room,
    required List<TraitCategory> validCategories,
    Map<String, String> participantUserIds = const {},
  }) {
    final host = room.hostParticipant;
    final guest = room.guestParticipant;

    if (host == null || guest == null) {
      throw StateError(
        'Preview bootstrap seeds require both a host and a guest participant.',
      );
    }

    if (validCategories.isEmpty) {
      throw StateError(
        'Preview bootstrap seeds require at least one valid trait category.',
      );
    }

    final hostIndex = _seedIndex(room.roomCode, validCategories.length);
    final guestIndex = validCategories.length == 1
        ? hostIndex
        : (hostIndex + 1) % validCategories.length;

    final hostTrait = validCategories[hostIndex];
    final guestTrait = validCategories[guestIndex];

    return [
      RemotePlayerBootstrapSeed(
        participantId: host.id,
        userId: _resolveUserId(host.id, participantUserIds),
        secretTraitId: hostTrait.id,
      ),
      RemotePlayerBootstrapSeed(
        participantId: guest.id,
        userId: _resolveUserId(guest.id, participantUserIds),
        secretTraitId: guestTrait.id,
      ),
    ];
  }

  String _resolveUserId(
    String participantId,
    Map<String, String> participantUserIds,
  ) {
    final resolvedUserId = participantUserIds[participantId]?.trim();
    if (resolvedUserId != null && resolvedUserId.isNotEmpty) {
      return resolvedUserId;
    }

    return 'preview_user_$participantId';
  }

  int _seedIndex(String roomCode, int length) {
    final total = roomCode.codeUnits.fold<int>(0, (sum, code) => sum + code);
    return total % length;
  }
}
