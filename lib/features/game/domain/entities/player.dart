import 'package:anime_deduction_tower/core/enums/player_control_type.dart';

class Player {
  const Player({
    required this.id,
    required this.name,
    required this.validCharacterIds,
    required this.hintsRemaining,
    this.secretTraitId,
    this.controlType = PlayerControlType.human,
  });

  final String id;
  final String name;
  final String? secretTraitId;
  final List<String> validCharacterIds;
  final int hintsRemaining;
  final PlayerControlType controlType;

  bool get isAi => controlType == PlayerControlType.ai;

  Player copyWith({
    String? secretTraitId,
    List<String>? validCharacterIds,
    int? hintsRemaining,
    PlayerControlType? controlType,
  }) {
    return Player(
      id: id,
      name: name,
      secretTraitId: secretTraitId ?? this.secretTraitId,
      validCharacterIds: validCharacterIds ?? this.validCharacterIds,
      hintsRemaining: hintsRemaining ?? this.hintsRemaining,
      controlType: controlType ?? this.controlType,
    );
  }
}
