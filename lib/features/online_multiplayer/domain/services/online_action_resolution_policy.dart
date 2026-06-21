import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_action_resolution_authority.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_session.dart';

class OnlineActionResolutionPolicy {
  const OnlineActionResolutionPolicy();

  bool canLocalClientResolveQueuedActions({
    required OnlineActionResolutionAuthority authority,
    required OnlineRoomSession? session,
  }) {
    if (session == null) {
      return false;
    }

    switch (authority) {
      case OnlineActionResolutionAuthority.hostClient:
        return session.isHost;
      case OnlineActionResolutionAuthority.manualDebugClient:
        return true;
      case OnlineActionResolutionAuthority.backendService:
        return false;
    }
  }

  String waitingLabel({
    required OnlineActionResolutionAuthority authority,
    required OnlineRoomSession? session,
  }) {
    switch (authority) {
      case OnlineActionResolutionAuthority.hostClient:
        if (session == null) {
          return 'Waiting for host resolver';
        }
        return session.isHost ? 'Host can resolve' : 'Waiting for host resolver';
      case OnlineActionResolutionAuthority.manualDebugClient:
        return 'Manual debug resolve only';
      case OnlineActionResolutionAuthority.backendService:
        return 'Waiting for backend resolver';
    }
  }
}
