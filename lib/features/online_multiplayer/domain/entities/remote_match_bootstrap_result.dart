import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_bootstrap_payload.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_state.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_player_private_state.dart';

class RemoteMatchBootstrapResult {
  const RemoteMatchBootstrapResult({
    required this.payload,
    required this.publicState,
    required this.privatePlayerStates,
  });

  final RemoteMatchBootstrapPayload payload;
  final RemoteMatchPublicState publicState;
  final List<RemotePlayerPrivateState> privatePlayerStates;

  RemotePlayerPrivateState? privateStateFor(String participantId) {
    for (final privateState in privatePlayerStates) {
      if (privateState.participantId == participantId) {
        return privateState;
      }
    }

    return null;
  }
}
