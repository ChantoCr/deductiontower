import 'package:anime_deduction_tower/core/enums/online_player_action_status.dart';
import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';

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
}
