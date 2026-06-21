import 'package:anime_deduction_tower/core/enums/online_player_action_status.dart';
import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_action_resolution_authority.dart';

class RemoteMatchActionTimelineEntry {
  const RemoteMatchActionTimelineEntry({
    required this.actionId,
    required this.participantId,
    required this.participantName,
    required this.actionType,
    required this.status,
    required this.shortLabel,
    required this.actionSummary,
    required this.resultSummary,
    required this.primaryTimestamp,
    required this.createdAt,
    this.submittedValueLabel,
    this.resolvedAt,
    this.resolvedByParticipantId,
    this.resolvedByUserId,
    this.resolutionSource,
  });

  final String actionId;
  final String participantId;
  final String participantName;
  final TurnActionType actionType;
  final OnlinePlayerActionStatus status;
  final String shortLabel;
  final String actionSummary;
  final String resultSummary;
  final String? submittedValueLabel;
  final DateTime primaryTimestamp;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String? resolvedByParticipantId;
  final String? resolvedByUserId;
  final OnlineActionResolutionAuthority? resolutionSource;

  bool get isPending => status == OnlinePlayerActionStatus.pending;

  bool get isApplied => status == OnlinePlayerActionStatus.applied;

  bool get isRejected => status == OnlinePlayerActionStatus.rejected;
}
