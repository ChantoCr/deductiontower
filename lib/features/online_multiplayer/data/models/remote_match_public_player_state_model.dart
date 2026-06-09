import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_player_state.dart';

class RemoteMatchPublicPlayerStateModel {
  const RemoteMatchPublicPlayerStateModel({
    required this.participantId,
    required this.displayName,
    required this.hintsRemaining,
    required this.characterGuessCount,
    required this.traitGuessCount,
  });

  final String participantId;
  final String displayName;
  final int hintsRemaining;
  final int characterGuessCount;
  final int traitGuessCount;

  factory RemoteMatchPublicPlayerStateModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return RemoteMatchPublicPlayerStateModel(
      participantId: json['participantId'] as String? ?? '',
      displayName: json['displayName'] as String? ?? 'Unknown Player',
      hintsRemaining: json['hintsRemaining'] as int? ?? 0,
      characterGuessCount: json['characterGuessCount'] as int? ?? 0,
      traitGuessCount: json['traitGuessCount'] as int? ?? 0,
    );
  }

  factory RemoteMatchPublicPlayerStateModel.fromEntity(
    RemoteMatchPublicPlayerState entity,
  ) {
    return RemoteMatchPublicPlayerStateModel(
      participantId: entity.participantId,
      displayName: entity.displayName,
      hintsRemaining: entity.hintsRemaining,
      characterGuessCount: entity.characterGuessCount,
      traitGuessCount: entity.traitGuessCount,
    );
  }

  RemoteMatchPublicPlayerState toEntity() {
    return RemoteMatchPublicPlayerState(
      participantId: participantId,
      displayName: displayName,
      hintsRemaining: hintsRemaining,
      characterGuessCount: characterGuessCount,
      traitGuessCount: traitGuessCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participantId': participantId,
      'displayName': displayName,
      'hintsRemaining': hintsRemaining,
      'characterGuessCount': characterGuessCount,
      'traitGuessCount': traitGuessCount,
    };
  }
}
