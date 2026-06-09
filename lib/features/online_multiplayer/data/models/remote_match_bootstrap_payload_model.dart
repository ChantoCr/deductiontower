import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_bootstrap_payload.dart';

class RemoteMatchBootstrapPayloadModel {
  const RemoteMatchBootstrapPayloadModel({
    required this.roomCode,
    required this.matchId,
    required this.hostParticipantId,
    required this.guestParticipantId,
    required this.startingParticipantId,
    required this.hostPlayerName,
    required this.guestPlayerName,
    required this.hintsPerPlayer,
    required this.hostSecretTraitId,
    required this.guestSecretTraitId,
    required this.sharedCharacterPoolIds,
    required this.createdAt,
  });

  final String roomCode;
  final String matchId;
  final String hostParticipantId;
  final String guestParticipantId;
  final String startingParticipantId;
  final String hostPlayerName;
  final String guestPlayerName;
  final int hintsPerPlayer;
  final String hostSecretTraitId;
  final String guestSecretTraitId;
  final List<String> sharedCharacterPoolIds;
  final DateTime createdAt;

  factory RemoteMatchBootstrapPayloadModel.fromJson(Map<String, dynamic> json) {
    return RemoteMatchBootstrapPayloadModel(
      roomCode: json['roomCode'] as String? ?? '',
      matchId: json['matchId'] as String? ?? '',
      hostParticipantId: json['hostParticipantId'] as String? ?? '',
      guestParticipantId: json['guestParticipantId'] as String? ?? '',
      startingParticipantId: json['startingParticipantId'] as String? ?? '',
      hostPlayerName: json['hostPlayerName'] as String? ?? '',
      guestPlayerName: json['guestPlayerName'] as String? ?? '',
      hintsPerPlayer: json['hintsPerPlayer'] as int? ?? 0,
      hostSecretTraitId: json['hostSecretTraitId'] as String? ?? '',
      guestSecretTraitId: json['guestSecretTraitId'] as String? ?? '',
      sharedCharacterPoolIds:
          (json['sharedCharacterPoolIds'] as List<dynamic>? ?? []).cast<String>(),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  factory RemoteMatchBootstrapPayloadModel.fromEntity(
    RemoteMatchBootstrapPayload entity,
  ) {
    return RemoteMatchBootstrapPayloadModel(
      roomCode: entity.roomCode,
      matchId: entity.matchId,
      hostParticipantId: entity.hostParticipantId,
      guestParticipantId: entity.guestParticipantId,
      startingParticipantId: entity.startingParticipantId,
      hostPlayerName: entity.hostPlayerName,
      guestPlayerName: entity.guestPlayerName,
      hintsPerPlayer: entity.hintsPerPlayer,
      hostSecretTraitId: entity.hostSecretTraitId,
      guestSecretTraitId: entity.guestSecretTraitId,
      sharedCharacterPoolIds: entity.sharedCharacterPoolIds,
      createdAt: entity.createdAt,
    );
  }

  RemoteMatchBootstrapPayload toEntity() {
    return RemoteMatchBootstrapPayload(
      roomCode: roomCode,
      matchId: matchId,
      hostParticipantId: hostParticipantId,
      guestParticipantId: guestParticipantId,
      startingParticipantId: startingParticipantId,
      hostPlayerName: hostPlayerName,
      guestPlayerName: guestPlayerName,
      hintsPerPlayer: hintsPerPlayer,
      hostSecretTraitId: hostSecretTraitId,
      guestSecretTraitId: guestSecretTraitId,
      sharedCharacterPoolIds: sharedCharacterPoolIds,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomCode': roomCode,
      'matchId': matchId,
      'hostParticipantId': hostParticipantId,
      'guestParticipantId': guestParticipantId,
      'startingParticipantId': startingParticipantId,
      'hostPlayerName': hostPlayerName,
      'guestPlayerName': guestPlayerName,
      'hintsPerPlayer': hintsPerPlayer,
      'hostSecretTraitId': hostSecretTraitId,
      'guestSecretTraitId': guestSecretTraitId,
      'sharedCharacterPoolIds': sharedCharacterPoolIds,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
