import 'package:anime_deduction_tower/core/enums/match_end_reason.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/game_match.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/player.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/turn.dart';

class MatchLookupHelper {
  const MatchLookupHelper();

  bool isAiMatch(GameMatch match) =>
      match.playerOne.isAi || match.playerTwo.isAi;

  Player? aiPlayer(GameMatch match) {
    if (match.playerOne.isAi) {
      return match.playerOne;
    }

    if (match.playerTwo.isAi) {
      return match.playerTwo;
    }

    return null;
  }

  String? aiPlayerName(GameMatch match) => aiPlayer(match)?.name;

  Turn? latestAiTurn(GameMatch match) {
    final ai = aiPlayer(match);
    if (ai == null) {
      return null;
    }

    for (final turn in match.turns.reversed) {
      if (turn.playerId == ai.id) {
        return turn;
      }
    }

    return null;
  }

  Player winnerPlayer(GameMatch match) {
    if (match.winnerId == match.playerTwo.id) {
      return match.playerTwo;
    }

    return match.playerOne;
  }

  Player loserPlayer(GameMatch match) {
    final winner = winnerPlayer(match);
    return winner.id == match.playerOne.id ? match.playerTwo : match.playerOne;
  }

  String winnerName(GameMatch match) => winnerPlayer(match).name;

  String loserName(GameMatch match) => loserPlayer(match).name;

  String playerNameFor(GameMatch match, String playerId) {
    return playerId == match.playerOne.id
        ? match.playerOne.name
        : match.playerTwo.name;
  }

  String findCharacterName(List<Character> characters, String characterId) {
    for (final character in characters) {
      if (character.id == characterId) {
        return character.name;
      }
    }

    return characterId;
  }

  String? findTraitLabel(List<TraitCategory> categories, String? traitId) {
    if (traitId == null) {
      return null;
    }

    for (final category in categories) {
      if (category.id == traitId) {
        return category.label;
      }
    }

    return null;
  }

  String? traitLabelForPlayer(List<TraitCategory> categories, Player player) {
    return findTraitLabel(categories, player.secretTraitId);
  }

  String endReasonLabel(MatchEndReason? endReason) {
    switch (endReason) {
      case MatchEndReason.correctTraitGuess:
        return 'Victory by correct secret tag guess';
      case MatchEndReason.surrender:
        return 'Victory by surrender';
      case null:
        return 'Match ended';
    }
  }
}
