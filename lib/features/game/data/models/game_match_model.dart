import 'package:anime_deduction_tower/core/enums/match_end_reason.dart';
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
    this.characterPoolIds = const [],
    this.winnerId,
    this.endReason,
  });

  final String id;
  final PlayerModel playerOne;
  final PlayerModel playerTwo;
  final String currentPlayerId;
  final List<TurnModel> turns;
  final MatchStatus status;
  final List<String> characterPoolIds;
  final String? winnerId;
  final MatchEndReason? endReason;

  GameMatch toEntity() {
    return GameMatch(
      id: id,
      playerOne: playerOne.toEntity(),
      playerTwo: playerTwo.toEntity(),
      currentPlayerId: currentPlayerId,
      turns: turns.map((turn) => turn.toEntity()).toList(),
      status: status,
      characterPoolIds: characterPoolIds,
      winnerId: winnerId,
      endReason: endReason,
    );
  }
}
