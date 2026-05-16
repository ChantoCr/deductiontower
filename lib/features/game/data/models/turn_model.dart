import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/turn.dart';

class TurnModel {
  const TurnModel({
    required this.id,
    required this.playerId,
    required this.actionType,
    required this.value,
    required this.wasCorrect,
    required this.createdAt,
  });

  final String id;
  final String playerId;
  final TurnActionType actionType;
  final String value;
  final bool wasCorrect;
  final DateTime createdAt;

  factory TurnModel.fromJson(Map<String, dynamic> json) {
    return TurnModel(
      id: json['id'] as String,
      playerId: json['playerId'] as String,
      actionType: TurnActionType.values.firstWhere(
        (type) => type.name == json['actionType'],
        orElse: () => TurnActionType.pass,
      ),
      value: json['value'] as String? ?? '',
      wasCorrect: json['wasCorrect'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Turn toEntity() {
    return Turn(
      id: id,
      playerId: playerId,
      actionType: actionType,
      value: value,
      wasCorrect: wasCorrect,
      createdAt: createdAt,
    );
  }
}
