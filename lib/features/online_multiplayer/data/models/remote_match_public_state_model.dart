import 'package:anime_deduction_tower/core/enums/match_end_reason.dart';
import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/models/remote_match_public_player_state_model.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_state.dart';

class RemoteMatchPublicStateModel {
  const RemoteMatchPublicStateModel({
    required this.matchId,
    required this.roomCode,
    required this.status,
    required this.currentTurnParticipantId,
    required this.turnNumber,
    required this.sharedCharacterPoolIds,
    required this.playerStates,
    required this.matchVersion,
    required this.createdAt,
    required this.updatedAt,
    this.winnerParticipantId,
    this.endReason,
    this.lastResolvedActionId,
  });

  final String matchId;
  final String roomCode;
  final MatchStatus status;
  final String currentTurnParticipantId;
  final int turnNumber;
  final List<String> sharedCharacterPoolIds;
  final List<RemoteMatchPublicPlayerStateModel> playerStates;
  final String? winnerParticipantId;
  final MatchEndReason? endReason;
  final String? lastResolvedActionId;
  final int matchVersion;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory RemoteMatchPublicStateModel.fromJson(Map<String, dynamic> json) {
    final rawPlayerStateJson = json['playerPublicState'] as Map<dynamic, dynamic>?;
    final playerStateJson = rawPlayerStateJson?.map(
          (key, value) => MapEntry(key.toString(), value),
        ) ??
        const <String, dynamic>{};

    return RemoteMatchPublicStateModel(
      matchId: json['matchId'] as String? ?? '',
      roomCode: json['roomCode'] as String? ?? '',
      status: _parseStatus(json['status'] as String?),
      currentTurnParticipantId:
          json['currentTurnParticipantId'] as String? ?? '',
      turnNumber: json['turnNumber'] as int? ?? 0,
      sharedCharacterPoolIds:
          (json['sharedCharacterPoolIds'] as List<dynamic>? ?? []).cast<String>(),
      playerStates: playerStateJson.entries.map((entry) {
        final rawValue = entry.value as Map<dynamic, dynamic>?;
        final value = rawValue?.map(
              (key, value) => MapEntry(key.toString(), value),
            ) ??
            const <String, dynamic>{};
        return RemoteMatchPublicPlayerStateModel.fromJson({
          'participantId': entry.key,
          ...value,
        });
      }).toList(),
      winnerParticipantId: json['winnerParticipantId'] as String?,
      endReason: _parseEndReason(json['endReason'] as String?),
      lastResolvedActionId: json['lastResolvedActionId'] as String?,
      matchVersion: json['matchVersion'] as int? ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  factory RemoteMatchPublicStateModel.fromEntity(RemoteMatchPublicState entity) {
    return RemoteMatchPublicStateModel(
      matchId: entity.matchId,
      roomCode: entity.roomCode,
      status: entity.status,
      currentTurnParticipantId: entity.currentTurnParticipantId,
      turnNumber: entity.turnNumber,
      sharedCharacterPoolIds: entity.sharedCharacterPoolIds,
      playerStates: entity.playerStates
          .map(RemoteMatchPublicPlayerStateModel.fromEntity)
          .toList(),
      winnerParticipantId: entity.winnerParticipantId,
      endReason: entity.endReason,
      lastResolvedActionId: entity.lastResolvedActionId,
      matchVersion: entity.matchVersion,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  RemoteMatchPublicState toEntity() {
    return RemoteMatchPublicState(
      matchId: matchId,
      roomCode: roomCode,
      status: status,
      currentTurnParticipantId: currentTurnParticipantId,
      turnNumber: turnNumber,
      sharedCharacterPoolIds: sharedCharacterPoolIds,
      playerStates: playerStates.map((playerState) => playerState.toEntity()).toList(),
      winnerParticipantId: winnerParticipantId,
      endReason: endReason,
      lastResolvedActionId: lastResolvedActionId,
      matchVersion: matchVersion,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matchId': matchId,
      'roomCode': roomCode,
      'status': status.name,
      'currentTurnParticipantId': currentTurnParticipantId,
      'turnNumber': turnNumber,
      'sharedCharacterPoolIds': sharedCharacterPoolIds,
      'playerPublicState': {
        for (final playerState in playerStates)
          playerState.participantId: {
            'displayName': playerState.displayName,
            'hintsRemaining': playerState.hintsRemaining,
            'characterGuessCount': playerState.characterGuessCount,
            'traitGuessCount': playerState.traitGuessCount,
          },
      },
      'winnerParticipantId': winnerParticipantId,
      'endReason': endReason?.name,
      'lastResolvedActionId': lastResolvedActionId,
      'matchVersion': matchVersion,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static MatchStatus _parseStatus(String? value) {
    switch (value) {
      case 'completed':
        return MatchStatus.completed;
      case 'inProgress':
        return MatchStatus.inProgress;
      case 'setup':
      case null:
        return MatchStatus.setup;
      default:
        return MatchStatus.setup;
    }
  }

  static MatchEndReason? _parseEndReason(String? value) {
    switch (value) {
      case 'correctTraitGuess':
        return MatchEndReason.correctTraitGuess;
      case 'surrender':
        return MatchEndReason.surrender;
      case null:
        return null;
      default:
        return null;
    }
  }
}
