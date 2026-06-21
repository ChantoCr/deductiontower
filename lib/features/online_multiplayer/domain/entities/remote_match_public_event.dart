import 'package:anime_deduction_tower/core/enums/online_player_action_status.dart';
import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_action_resolution_authority.dart';

class RemoteMatchPublicEvent {
  const RemoteMatchPublicEvent({
    required this.eventId,
    required this.roomCode,
    required this.matchId,
    required this.actionId,
    required this.participantId,
    required this.participantName,
    required this.actionType,
    required this.status,
    required this.shortLabel,
    required this.actionSummary,
    required this.resultSummary,
    required this.resultingMatchVersion,
    required this.createdAt,
    required this.publishedAt,
    this.submittedValueLabel,
    this.resolutionSource,
  });

  final String eventId;
  final String roomCode;
  final String matchId;
  final String actionId;
  final String participantId;
  final String participantName;
  final TurnActionType actionType;
  final OnlinePlayerActionStatus status;
  final String shortLabel;
  final String actionSummary;
  final String resultSummary;
  final String? submittedValueLabel;
  final int resultingMatchVersion;
  final DateTime createdAt;
  final DateTime publishedAt;
  final OnlineActionResolutionAuthority? resolutionSource;

  bool get isApplied => status == OnlinePlayerActionStatus.applied;

  bool get isRejected => status == OnlinePlayerActionStatus.rejected;
}
