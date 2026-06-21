import 'package:anime_deduction_tower/core/enums/online_player_action_status.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_player_action.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_event.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_state.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_player_private_state.dart';

class RemoteMatchActionResolution {
  const RemoteMatchActionResolution({
    required this.baseMatchVersion,
    required this.publicState,
    required this.resolvedAction,
    required this.publicEvent,
    this.affectedPrivateState,
  });

  final int baseMatchVersion;
  final RemoteMatchPublicState publicState;
  final OnlinePlayerAction resolvedAction;
  final RemoteMatchPublicEvent publicEvent;
  final RemotePlayerPrivateState? affectedPrivateState;

  bool get wasApplied =>
      resolvedAction.status == OnlinePlayerActionStatus.applied;

  bool get wasRejected =>
      resolvedAction.status == OnlinePlayerActionStatus.rejected;
}
