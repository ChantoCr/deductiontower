import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_bootstrap_payload.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_state.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_player_private_state.dart';

class RemoteMatchHandoffSnapshot {
  const RemoteMatchHandoffSnapshot({
    required this.roomCode,
    required this.localParticipantId,
    this.bootstrapPayload,
    this.publicState,
    this.privateState,
  });

  final String roomCode;
  final String localParticipantId;
  final RemoteMatchBootstrapPayload? bootstrapPayload;
  final RemoteMatchPublicState? publicState;
  final RemotePlayerPrivateState? privateState;

  bool get hasBootstrapPayload => bootstrapPayload != null;
  bool get hasPublicState => publicState != null;
  bool get hasPrivateState => privateState != null;

  bool get isComplete =>
      hasBootstrapPayload && hasPublicState && hasPrivateState;

  String? get matchId => publicState?.matchId ?? bootstrapPayload?.matchId;
}
