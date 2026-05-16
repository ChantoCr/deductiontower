import 'package:anime_deduction_tower/features/game/domain/entities/player.dart';

class PlayerModel {
  const PlayerModel({
    required this.id,
    required this.name,
    required this.validCharacterIds,
    required this.lives,
    required this.hintsRemaining,
    this.secretTraitId,
  });

  final String id;
  final String name;
  final String? secretTraitId;
  final List<String> validCharacterIds;
  final int lives;
  final int hintsRemaining;

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      secretTraitId: json['secretTraitId'] as String?,
      validCharacterIds: (json['validCharacterIds'] as List<dynamic>? ?? []).cast<String>(),
      lives: json['lives'] as int? ?? 3,
      hintsRemaining: json['hintsRemaining'] as int? ?? 2,
    );
  }

  Player toEntity() {
    return Player(
      id: id,
      name: name,
      secretTraitId: secretTraitId,
      validCharacterIds: validCharacterIds,
      lives: lives,
      hintsRemaining: hintsRemaining,
    );
  }
}
