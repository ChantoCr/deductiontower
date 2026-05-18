import 'package:anime_deduction_tower/core/enums/match_end_reason.dart';
import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/game_match.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/turn.dart';
import 'package:anime_deduction_tower/features/game/domain/services/match_rules_engine.dart';

class GameEngine {
  const GameEngine({this.matchRulesEngine = const MatchRulesEngine()});

  final MatchRulesEngine matchRulesEngine;

  GameMatch switchTurn(GameMatch match) {
    final nextPlayerId =
        match.currentPlayerId == match.playerOne.id ? match.playerTwo.id : match.playerOne.id;

    return match.copyWith(currentPlayerId: nextPlayerId);
  }

  GameMatch recordTurn(GameMatch match, Turn turn) {
    return match.copyWith(turns: [...match.turns, turn]);
  }

  GameMatch finishMatch({
    required GameMatch match,
    required String winnerId,
    required MatchEndReason endReason,
  }) {
    return match.copyWith(
      status: MatchStatus.completed,
      winnerId: winnerId,
      endReason: endReason,
    );
  }

  GameMatch surrenderMatch({
    required GameMatch match,
    required String surrenderingPlayerId,
  }) {
    final winnerId = surrenderingPlayerId == match.playerOne.id
        ? match.playerTwo.id
        : match.playerOne.id;

    return finishMatch(
      match: match,
      winnerId: winnerId,
      endReason: MatchEndReason.surrender,
    );
  }
}
