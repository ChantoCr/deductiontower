import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';

class AiTurnDecision {
  const AiTurnDecision({
    required this.actionType,
    required this.value,
    required this.summary,
  });

  final TurnActionType actionType;
  final String value;
  final String summary;
}
