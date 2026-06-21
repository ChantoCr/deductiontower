import 'package:anime_deduction_tower/core/enums/online_player_action_status.dart';
import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_action_resolution_authority.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_event.dart';

class RemoteMatchPublicEventModel {
  const RemoteMatchPublicEventModel({
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

  factory RemoteMatchPublicEventModel.fromJson(Map<String, dynamic> json) {
    return RemoteMatchPublicEventModel(
      eventId: json['eventId'] as String? ?? '',
      roomCode: json['roomCode'] as String? ?? '',
      matchId: json['matchId'] as String? ?? '',
      actionId: json['actionId'] as String? ?? '',
      participantId: json['participantId'] as String? ?? '',
      participantName: json['participantName'] as String? ?? '',
      actionType: _parseActionType(json['actionType'] as String?),
      status: _parseStatus(json['status'] as String?),
      shortLabel: json['shortLabel'] as String? ?? '',
      actionSummary: json['actionSummary'] as String? ?? '',
      resultSummary: json['resultSummary'] as String? ?? '',
      submittedValueLabel: json['submittedValueLabel'] as String?,
      resultingMatchVersion: json['resultingMatchVersion'] as int? ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      publishedAt: DateTime.tryParse(json['publishedAt'] as String? ?? '') ??
          DateTime.now(),
      resolutionSource: _parseResolutionSource(
        json['resolutionSource'] as String?,
      ),
    );
  }

  factory RemoteMatchPublicEventModel.fromEntity(
    RemoteMatchPublicEvent entity,
  ) {
    return RemoteMatchPublicEventModel(
      eventId: entity.eventId,
      roomCode: entity.roomCode,
      matchId: entity.matchId,
      actionId: entity.actionId,
      participantId: entity.participantId,
      participantName: entity.participantName,
      actionType: entity.actionType,
      status: entity.status,
      shortLabel: entity.shortLabel,
      actionSummary: entity.actionSummary,
      resultSummary: entity.resultSummary,
      submittedValueLabel: entity.submittedValueLabel,
      resultingMatchVersion: entity.resultingMatchVersion,
      createdAt: entity.createdAt,
      publishedAt: entity.publishedAt,
      resolutionSource: entity.resolutionSource,
    );
  }

  RemoteMatchPublicEvent toEntity() {
    return RemoteMatchPublicEvent(
      eventId: eventId,
      roomCode: roomCode,
      matchId: matchId,
      actionId: actionId,
      participantId: participantId,
      participantName: participantName,
      actionType: actionType,
      status: status,
      shortLabel: shortLabel,
      actionSummary: actionSummary,
      resultSummary: resultSummary,
      submittedValueLabel: submittedValueLabel,
      resultingMatchVersion: resultingMatchVersion,
      createdAt: createdAt,
      publishedAt: publishedAt,
      resolutionSource: resolutionSource,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'roomCode': roomCode,
      'matchId': matchId,
      'actionId': actionId,
      'participantId': participantId,
      'participantName': participantName,
      'actionType': actionType.name,
      'status': status.name,
      'shortLabel': shortLabel,
      'actionSummary': actionSummary,
      'resultSummary': resultSummary,
      'submittedValueLabel': submittedValueLabel,
      'resultingMatchVersion': resultingMatchVersion,
      'createdAt': createdAt.toIso8601String(),
      'publishedAt': publishedAt.toIso8601String(),
      'resolutionSource': resolutionSource?.name,
    };
  }

  static TurnActionType _parseActionType(String? value) {
    switch (value) {
      case 'guessTrait':
        return TurnActionType.guessTrait;
      case 'requestHint':
        return TurnActionType.requestHint;
      case 'surrender':
        return TurnActionType.surrender;
      case 'pass':
        return TurnActionType.pass;
      case 'guessCharacter':
      case null:
        return TurnActionType.guessCharacter;
      default:
        return TurnActionType.guessCharacter;
    }
  }

  static OnlinePlayerActionStatus _parseStatus(String? value) {
    switch (value) {
      case 'applied':
        return OnlinePlayerActionStatus.applied;
      case 'rejected':
        return OnlinePlayerActionStatus.rejected;
      case 'pending':
      case null:
        return OnlinePlayerActionStatus.pending;
      default:
        return OnlinePlayerActionStatus.pending;
    }
  }

  static OnlineActionResolutionAuthority? _parseResolutionSource(
    String? value,
  ) {
    switch (value) {
      case 'hostClient':
        return OnlineActionResolutionAuthority.hostClient;
      case 'manualDebugClient':
        return OnlineActionResolutionAuthority.manualDebugClient;
      case 'backendService':
        return OnlineActionResolutionAuthority.backendService;
      case null:
        return null;
      default:
        return null;
    }
  }
}
