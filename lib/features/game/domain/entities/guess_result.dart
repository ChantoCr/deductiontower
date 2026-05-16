import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';

class GuessResult {
  const GuessResult({
    required this.isCorrect,
    required this.message,
    required this.guessedValue,
    required this.actionType,
  });

  final bool isCorrect;
  final String message;
  final String guessedValue;
  final TurnActionType actionType;
}
