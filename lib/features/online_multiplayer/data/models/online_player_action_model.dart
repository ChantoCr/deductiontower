import 'package:anime_deduction_tower/core/enums/online_player_action_status.dart';
import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_player_action.dart';

class OnlinePlayerActionModel {
  const OnlinePlayerActionModel({
    required this.actionId,
    required this.submittedByParticipantId,
    required this.submittedByUserId,
    required this.actionType,
    required this.expectedMatchVersion,
    required this.createdAt,
    this.characterId,
    this.traitId,
    this.status = OnlinePlayerActionStatus.pending,
    this.errorCode,
    this.resolvedAt,
  });

  final String actionId;
  final String submittedByParticipantId;
  final String submittedByUserId;
  final TurnActionType actionType;
  final String? characterId;
  final String? traitId;
  final int expectedMatchVersion;
  final OnlinePlayerActionStatus status;
  final String? errorCode;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  factory OnlinePlayerActionModel.fromJson(Map<String, dynamic> json) {
    final payload = json['payload'] as Map<String, dynamic>? ?? const {};

    return OnlinePlayerActionModel(
      actionId: json['actionId'] as String? ?? '',
      submittedByParticipantId:
          json['submittedByParticipantId'] as String? ?? '',
      submittedByUserId: json['submittedByUserId'] as String? ?? '',
      actionType: _parseActionType(json['actionType'] as String?),
      characterId: payload['characterId'] as String?,
      traitId: payload['traitId'] as String?,
      expectedMatchVersion: json['expectedMatchVersion'] as int? ?? 0,
      status: _parseStatus(json['status'] as String?),
      errorCode: json['errorCode'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      resolvedAt: DateTime.tryParse(json['resolvedAt'] as String? ?? ''),
    );
  }

  factory OnlinePlayerActionModel.fromEntity(OnlinePlayerAction entity) {
    return OnlinePlayerActionModel(
      actionId: entity.actionId,
      submittedByParticipantId: entity.submittedByParticipantId,
      submittedByUserId: entity.submittedByUserId,
      actionType: entity.actionType,
      characterId: entity.characterId,
      traitId: entity.traitId,
      expectedMatchVersion: entity.expectedMatchVersion,
      status: entity.status,
      errorCode: entity.errorCode,
      createdAt: entity.createdAt,
      resolvedAt: entity.resolvedAt,
    );
  }

  OnlinePlayerAction toEntity() {
    return OnlinePlayerAction(
      actionId: actionId,
      submittedByParticipantId: submittedByParticipantId,
      submittedByUserId: submittedByUserId,
      actionType: actionType,
      characterId: characterId,
      traitId: traitId,
      expectedMatchVersion: expectedMatchVersion,
      status: status,
      errorCode: errorCode,
      createdAt: createdAt,
      resolvedAt: resolvedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'actionId': actionId,
      'submittedByParticipantId': submittedByParticipantId,
      'submittedByUserId': submittedByUserId,
      'actionType': actionType.name,
      'payload': _buildPayload(),
      'expectedMatchVersion': expectedMatchVersion,
      'status': status.name,
      'errorCode': errorCode,
      'createdAt': createdAt.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> _buildPayload() {
    switch (actionType) {
      case TurnActionType.guessCharacter:
        return {
          'characterId': characterId,
        };
      case TurnActionType.guessTrait:
        return {
          'traitId': traitId,
        };
      case TurnActionType.requestHint:
      case TurnActionType.surrender:
      case TurnActionType.pass:
        return const {};
    }
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
}
