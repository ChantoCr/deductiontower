import 'package:anime_deduction_tower/core/enums/match_end_reason.dart';
import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_player_state.dart';

class RemoteMatchPublicState {
  const RemoteMatchPublicState({
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
  final List<RemoteMatchPublicPlayerState> playerStates;
  final String? winnerParticipantId;
  final MatchEndReason? endReason;
  final String? lastResolvedActionId;
  final int matchVersion;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isCompleted => status == MatchStatus.completed;

  RemoteMatchPublicPlayerState? get currentTurnPlayerState {
    return playerStateFor(currentTurnParticipantId);
  }

  RemoteMatchPublicPlayerState? playerStateFor(String participantId) {
    for (final playerState in playerStates) {
      if (playerState.participantId == participantId) {
        return playerState;
      }
    }

    return null;
  }

  RemoteMatchPublicState copyWith({
    MatchStatus? status,
    String? currentTurnParticipantId,
    int? turnNumber,
    List<String>? sharedCharacterPoolIds,
    List<RemoteMatchPublicPlayerState>? playerStates,
    String? winnerParticipantId,
    MatchEndReason? endReason,
    String? lastResolvedActionId,
    int? matchVersion,
    DateTime? updatedAt,
    bool clearWinnerParticipantId = false,
    bool clearEndReason = false,
  }) {
    return RemoteMatchPublicState(
      matchId: matchId,
      roomCode: roomCode,
      status: status ?? this.status,
      currentTurnParticipantId:
          currentTurnParticipantId ?? this.currentTurnParticipantId,
      turnNumber: turnNumber ?? this.turnNumber,
      sharedCharacterPoolIds: sharedCharacterPoolIds ?? this.sharedCharacterPoolIds,
      playerStates: playerStates ?? this.playerStates,
      winnerParticipantId: clearWinnerParticipantId
          ? null
          : winnerParticipantId ?? this.winnerParticipantId,
      endReason: clearEndReason ? null : endReason ?? this.endReason,
      lastResolvedActionId: lastResolvedActionId ?? this.lastResolvedActionId,
      matchVersion: matchVersion ?? this.matchVersion,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
