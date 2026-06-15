import 'package:anime_deduction_tower/features/online_multiplayer/data/models/remote_match_bootstrap_payload_model.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/models/remote_match_public_state_model.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/models/remote_player_private_state_model.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_bootstrap_result.dart';

class RemoteMatchFirestoreBootstrapBundle {
  const RemoteMatchFirestoreBootstrapBundle({
    required this.roomDocumentPatch,
    required this.bootstrapDocument,
    required this.publicMatchDocument,
    required this.privatePlayerDocuments,
  });

  final Map<String, dynamic> roomDocumentPatch;
  final Map<String, dynamic> bootstrapDocument;
  final Map<String, dynamic> publicMatchDocument;
  final Map<String, Map<String, dynamic>> privatePlayerDocuments;
}

class RemoteMatchFirestoreBundleBuilder {
  const RemoteMatchFirestoreBundleBuilder();

  RemoteMatchFirestoreBootstrapBundle build(
    RemoteMatchBootstrapResult result,
  ) {
    return RemoteMatchFirestoreBootstrapBundle(
      roomDocumentPatch: {
        'activeMatchId': result.payload.matchId,
        'bootstrapStatus': 'ready',
        'bootstrapCreatedAt': result.payload.createdAt.toIso8601String(),
      },
      bootstrapDocument:
          RemoteMatchBootstrapPayloadModel.fromEntity(result.payload).toJson(),
      publicMatchDocument:
          RemoteMatchPublicStateModel.fromEntity(result.publicState).toJson(),
      privatePlayerDocuments: {
        for (final privateState in result.privatePlayerStates)
          privateState.participantId:
              RemotePlayerPrivateStateModel.fromEntity(privateState).toJson(),
      },
    );
  }
}
