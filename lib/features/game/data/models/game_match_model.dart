import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/features/game/data/models/player_model.dart';
import 'package:anime_deduction_tower/features/game/data/models/turn_model.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/game_match.dart';

class GameMatchModel {
  const GameMatchModel({
    required this.id,
    required this.playerOne,
    required this.playerTwo,
    required this.currentPlayerId,
    required this.turns,
    required this.status,
    this.winnerId,
  });

  final String id;
  final PlayerModel playerOne;
  final PlayerModel playerTwo;
  final String currentPlayerId;
  final List<TurnModel> turns;
  final MatchStatus status;
  final String? winnerId;

  GameMatch toEntity() {
    return GameMatch(
      id: id,
      playerOne: playerOne.toEntity(),
      playerTwo: playerTwo.toEntity(),
      currentPlayerId: currentPlayerId,
      turns: turns.map((turn) => turn.toEntity()).toList(),
      status: status,
      winnerId: winnerId,
    );
  }
}
