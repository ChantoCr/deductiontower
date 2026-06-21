import 'package:anime_deduction_tower/core/enums/online_player_action_status.dart';
import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_action_resolution_authority.dart';

class OnlinePlayerAction {
  const OnlinePlayerAction({
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
    this.resolvedByParticipantId,
    this.resolvedByUserId,
    this.resolutionSource,
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
  final String? resolvedByParticipantId;
  final String? resolvedByUserId;
  final OnlineActionResolutionAuthority? resolutionSource;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  bool get isPending => status == OnlinePlayerActionStatus.pending;

  bool get targetsCharacter => actionType == TurnActionType.guessCharacter;

  bool get targetsTrait => actionType == TurnActionType.guessTrait;

  String get submittedValue {
    switch (actionType) {
      case TurnActionType.guessCharacter:
        return characterId ?? '';
      case TurnActionType.guessTrait:
        return traitId ?? '';
      case TurnActionType.requestHint:
      case TurnActionType.surrender:
      case TurnActionType.pass:
        return '';
    }
  }

  OnlinePlayerAction copyWith({
    String? characterId,
    String? traitId,
    OnlinePlayerActionStatus? status,
    String? errorCode,
    String? resolvedByParticipantId,
    String? resolvedByUserId,
    OnlineActionResolutionAuthority? resolutionSource,
    DateTime? resolvedAt,
    bool clearErrorCode = false,
    bool clearResolvedByParticipantId = false,
    bool clearResolvedByUserId = false,
    bool clearResolutionSource = false,
  }) {
    return OnlinePlayerAction(
      actionId: actionId,
      submittedByParticipantId: submittedByParticipantId,
      submittedByUserId: submittedByUserId,
      actionType: actionType,
      characterId: characterId ?? this.characterId,
      traitId: traitId ?? this.traitId,
      expectedMatchVersion: expectedMatchVersion,
      status: status ?? this.status,
      errorCode: clearErrorCode ? null : errorCode ?? this.errorCode,
      resolvedByParticipantId: clearResolvedByParticipantId
          ? null
          : resolvedByParticipantId ?? this.resolvedByParticipantId,
      resolvedByUserId: clearResolvedByUserId
          ? null
          : resolvedByUserId ?? this.resolvedByUserId,
      resolutionSource: clearResolutionSource
          ? null
          : resolutionSource ?? this.resolutionSource,
      createdAt: createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }
}
