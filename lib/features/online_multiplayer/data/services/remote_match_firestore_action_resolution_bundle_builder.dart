import 'package:anime_deduction_tower/features/online_multiplayer/data/models/online_player_action_model.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/models/remote_match_public_event_model.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/models/remote_match_public_state_model.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/models/remote_player_private_state_model.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_action_resolution.dart';

class RemoteMatchFirestoreActionResolutionBundle {
  const RemoteMatchFirestoreActionResolutionBundle({
    required this.publicMatchDocument,
    required this.actionDocument,
    required this.publicEventDocument,
    required this.publicEventId,
    this.privatePlayerDocument,
    this.privateParticipantId,
  });

  final Map<String, dynamic> publicMatchDocument;
  final Map<String, dynamic> actionDocument;
  final Map<String, dynamic> publicEventDocument;
  final String publicEventId;
  final Map<String, dynamic>? privatePlayerDocument;
  final String? privateParticipantId;
}

class RemoteMatchFirestoreActionResolutionBundleBuilder {
  const RemoteMatchFirestoreActionResolutionBundleBuilder();

  RemoteMatchFirestoreActionResolutionBundle build(
    RemoteMatchActionResolution resolution,
  ) {
    final affectedPrivateState = resolution.affectedPrivateState;

    return RemoteMatchFirestoreActionResolutionBundle(
      publicMatchDocument:
          RemoteMatchPublicStateModel.fromEntity(resolution.publicState)
              .toJson(),
      actionDocument:
          OnlinePlayerActionModel.fromEntity(resolution.resolvedAction)
              .toJson(),
      publicEventDocument:
          RemoteMatchPublicEventModel.fromEntity(resolution.publicEvent)
              .toJson(),
      publicEventId: resolution.publicEvent.eventId,
      privatePlayerDocument: affectedPrivateState == null
          ? null
          : RemotePlayerPrivateStateModel.fromEntity(affectedPrivateState)
              .toJson(),
      privateParticipantId: affectedPrivateState?.participantId,
    );
  }
}
