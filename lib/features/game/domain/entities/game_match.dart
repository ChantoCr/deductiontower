import 'package:anime_deduction_tower/core/enums/match_end_reason.dart';
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
    this.characterPoolIds = const [],
    this.winnerId,
    this.endReason,
  });

  final String id;
  final Player playerOne;
  final Player playerTwo;
  final String currentPlayerId;
  final List<Turn> turns;
  final MatchStatus status;
  final List<String> characterPoolIds;
  final String? winnerId;
  final MatchEndReason? endReason;

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
    List<String>? characterPoolIds,
    String? winnerId,
    MatchEndReason? endReason,
  }) {
    return GameMatch(
      id: id,
      playerOne: playerOne ?? this.playerOne,
      playerTwo: playerTwo ?? this.playerTwo,
      currentPlayerId: currentPlayerId ?? this.currentPlayerId,
      turns: turns ?? this.turns,
      status: status ?? this.status,
      characterPoolIds: characterPoolIds ?? this.characterPoolIds,
      winnerId: winnerId ?? this.winnerId,
      endReason: endReason ?? this.endReason,
    );
  }
}
