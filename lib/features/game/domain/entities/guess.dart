import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';

class Guess {
  const Guess({
    required this.id,
    required this.playerId,
    required this.actionType,
    required this.value,
  });

  final String id;
  final String playerId;
  final TurnActionType actionType;
  final String value;
}
