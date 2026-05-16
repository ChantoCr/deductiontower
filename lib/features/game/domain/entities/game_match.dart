import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/player.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/turn.dart';

class GameMatch {
  const GameMatch({
    required this.id,
    required this.playerOne,
    required this.playerTwo,
    required this.currentPlayerId,
    required this.turns,
    required this.status,
    this.winnerId,
  });

  final String id;
  final Player playerOne;
  final Player playerTwo;
  final String currentPlayerId;
  final List<Turn> turns;
  final MatchStatus status;
  final String? winnerId;

  Player get currentPlayer =>
      currentPlayerId == playerOne.id ? playerOne : playerTwo;

  Player get waitingPlayer =>
      currentPlayerId == playerOne.id ? playerTwo : playerOne;

  GameMatch copyWith({
    Player? playerOne,
    Player? playerTwo,
    String? currentPlayerId,
    List<Turn>? turns,
    MatchStatus? status,
    String? winnerId,
  }) {
    return GameMatch(
      id: id,
      playerOne: playerOne ?? this.playerOne,
      playerTwo: playerTwo ?? this.playerTwo,
      currentPlayerId: currentPlayerId ?? this.currentPlayerId,
      turns: turns ?? this.turns,
      status: status ?? this.status,
      winnerId: winnerId ?? this.winnerId,
    );
  }
}
