import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/guess.dart';

class GuessModel {
  const GuessModel({
    required this.id,
    required this.playerId,
    required this.actionType,
    required this.value,
  });

  final String id;
  final String playerId;
  final TurnActionType actionType;
  final String value;

  factory GuessModel.fromJson(Map<String, dynamic> json) {
    return GuessModel(
      id: json['id'] as String,
      playerId: json['playerId'] as String,
      actionType: TurnActionType.values.firstWhere(
        (type) => type.name == json['actionType'],
        orElse: () => TurnActionType.guessCharacter,
      ),
      value: json['value'] as String? ?? '',
    );
  }

  Guess toEntity() {
    return Guess(
      id: id,
      playerId: playerId,
      actionType: actionType,
      value: value,
    );
  }
}
