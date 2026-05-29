import 'package:anime_deduction_tower/core/enums/player_control_type.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/player.dart';

class PlayerModel {
  const PlayerModel({
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

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      secretTraitId: json['secretTraitId'] as String?,
      validCharacterIds:
          (json['validCharacterIds'] as List<dynamic>? ?? []).cast<String>(),
      hintsRemaining: json['hintsRemaining'] as int? ?? 2,
      controlType: _parseControlType(json['controlType'] as String?),
    );
  }

  Player toEntity() {
    return Player(
      id: id,
      name: name,
      secretTraitId: secretTraitId,
      validCharacterIds: validCharacterIds,
      hintsRemaining: hintsRemaining,
      controlType: controlType,
    );
  }

  static PlayerControlType _parseControlType(String? value) {
    switch (value) {
      case 'ai':
        return PlayerControlType.ai;
      case 'human':
      case null:
        return PlayerControlType.human;
      default:
        return PlayerControlType.human;
    }
  }
}
