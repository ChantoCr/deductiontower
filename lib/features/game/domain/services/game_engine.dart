import 'package:anime_deduction_tower/core/enums/match_end_reason.dart';
import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';
import 'package:anime_deduction_tower/core/utils/id_generator.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/game_match.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/player.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/turn.dart';
import 'package:anime_deduction_tower/features/game/domain/services/match_rules_engine.dart';

class GameEngine {
  const GameEngine({this.matchRulesEngine = const MatchRulesEngine()});

  final MatchRulesEngine matchRulesEngine;

  GameMatch createMatch({
    required Player playerOne,
    required Player playerTwo,
    required List<String> characterPoolIds,
    String? matchId,
    String? startingPlayerId,
  }) {
    return GameMatch(
      id: matchId ?? IdGenerator.next('match'),
      playerOne: playerOne,
      playerTwo: playerTwo,
      currentPlayerId: startingPlayerId ?? playerOne.id,
      turns: const [],
      status: MatchStatus.inProgress,
      characterPoolIds: characterPoolIds,
    );
  }

  GameMatch switchTurn(GameMatch match) {
    final nextPlayerId =
        match.currentPlayerId == match.playerOne.id ? match.playerTwo.id : match.playerOne.id;

    return match.copyWith(currentPlayerId: nextPlayerId);
  }

  GameMatch recordTurn(GameMatch match, Turn turn) {
    return match.copyWith(turns: [...match.turns, turn]);
  }

  GameMatch resolveCharacterGuess({
    required GameMatch match,
    required Character guessedCharacter,
    required TraitCategory opponentSecretTrait,
    DateTime? createdAt,
  }) {
    final wasCorrect = matchRulesEngine.isCharacterGuessCorrect(
      character: guessedCharacter,
      secretTrait: opponentSecretTrait,
    );

    final turn = Turn(
      id: IdGenerator.next('turn'),
      playerId: match.currentPlayerId,
      actionType: TurnActionType.guessCharacter,
      value: guessedCharacter.id,
      wasCorrect: wasCorrect,
      createdAt: createdAt ?? DateTime.now(),
    );

    final updatedMatch = recordTurn(match, turn);
    return switchTurn(updatedMatch);
  }

  GameMatch resolveTraitGuess({
    required GameMatch match,
    required String guessedTraitId,
    required TraitCategory opponentSecretTrait,
    DateTime? createdAt,
  }) {
    final wasCorrect = matchRulesEngine.isTraitGuessCorrect(
      guessedTraitId: guessedTraitId,
      secretTrait: opponentSecretTrait,
    );

    final updatedMatch = recordTurn(
      match,
      Turn(
        id: IdGenerator.next('turn'),
        playerId: match.currentPlayerId,
        actionType: TurnActionType.guessTrait,
        value: guessedTraitId,
        wasCorrect: wasCorrect,
        createdAt: createdAt ?? DateTime.now(),
      ),
    );

    if (wasCorrect) {
      return finishMatch(
        match: updatedMatch,
        winnerId: match.currentPlayerId,
        endReason: MatchEndReason.correctTraitGuess,
      );
    }

    return switchTurn(updatedMatch);
  }

  GameMatch resolveHintRequest({
    required GameMatch match,
    required String hintMessage,
    DateTime? createdAt,
  }) {
    final currentPlayer = match.currentPlayer;
    if (currentPlayer.hintsRemaining <= 0) {
      throw StateError('Current player has no hints remaining.');
    }

    final updatedCurrentPlayer = currentPlayer.copyWith(
      hintsRemaining: currentPlayer.hintsRemaining - 1,
    );

    final matchWithConsumedHint = _replacePlayer(
      match: match,
      updatedPlayer: updatedCurrentPlayer,
    );

    final updatedMatch = recordTurn(
      matchWithConsumedHint,
      Turn(
        id: IdGenerator.next('turn'),
        playerId: currentPlayer.id,
        actionType: TurnActionType.requestHint,
        value: hintMessage,
        wasCorrect: false,
        createdAt: createdAt ?? DateTime.now(),
      ),
    );

    return switchTurn(updatedMatch);
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
    DateTime? createdAt,
  }) {
    final updatedMatch = recordTurn(
      match,
      Turn(
        id: IdGenerator.next('turn'),
        playerId: surrenderingPlayerId,
        actionType: TurnActionType.surrender,
        value: surrenderingPlayerId,
        wasCorrect: false,
        createdAt: createdAt ?? DateTime.now(),
      ),
    );

    final winnerId = surrenderingPlayerId == match.playerOne.id
        ? match.playerTwo.id
        : match.playerOne.id;

    return finishMatch(
      match: updatedMatch,
      winnerId: winnerId,
      endReason: MatchEndReason.surrender,
    );
  }

  GameMatch _replacePlayer({
    required GameMatch match,
    required Player updatedPlayer,
  }) {
    if (updatedPlayer.id == match.playerOne.id) {
      return match.copyWith(playerOne: updatedPlayer);
    }

    if (updatedPlayer.id == match.playerTwo.id) {
      return match.copyWith(playerTwo: updatedPlayer);
    }

    throw StateError('Player ${updatedPlayer.id} does not belong to this match.');
  }
}
