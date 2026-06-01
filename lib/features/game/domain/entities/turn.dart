import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';

class Turn {
  const Turn({
    required this.id,
    required this.playerId,
    required this.actionType,
    required this.value,
    required this.wasCorrect,
    required this.createdAt,
    this.publicNote,
  });

  final String id;
  final String playerId;
  final TurnActionType actionType;
  final String value;
  final bool wasCorrect;
  final DateTime createdAt;
  final String? publicNote;
}
