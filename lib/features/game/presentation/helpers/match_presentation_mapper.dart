import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/game_match.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/player.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/game/presentation/helpers/match_lookup_helper.dart';
import 'package:anime_deduction_tower/features/game/presentation/models/guess_history_entry.dart';
import 'package:anime_deduction_tower/features/game/presentation/models/match_result_comparison.dart';
import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:flutter/material.dart';

class MatchPresentationMapper {
  const MatchPresentationMapper({this.lookup = const MatchLookupHelper()});

  final MatchLookupHelper lookup;

  List<GuessHistoryEntry> buildTimelineEntries({
    required GameMatch match,
    required List<TraitCategory> categories,
    required List<Character> characters,
  }) {
    return match.turns.reversed.map((turn) {
      final playerName = lookup.playerNameFor(match, turn.playerId);

      switch (turn.actionType) {
        case TurnActionType.guessCharacter:
          final characterName =
              lookup.findCharacterName(characters, turn.value);
          return GuessHistoryEntry(
            title: '$playerName guessed $characterName',
            subtitle: turn.wasCorrect
                ? 'The character matched the hidden tag.'
                : 'The character did not match the hidden tag.',
            icon: turn.wasCorrect
                ? Icons.check_circle_outline
                : Icons.cancel_outlined,
            color: turn.wasCorrect ? AppColors.success : AppColors.error,
            actionType: turn.actionType,
            playerName: playerName,
            wasCorrect: turn.wasCorrect,
          );
        case TurnActionType.guessTrait:
          final traitLabel =
              lookup.findTraitLabel(categories, turn.value) ?? turn.value;
          return GuessHistoryEntry(
            title: '$playerName guessed tag $traitLabel',
            subtitle: turn.wasCorrect
                ? 'The final tag guess was correct.'
                : 'The final tag guess was incorrect.',
            icon: turn.wasCorrect
                ? Icons.emoji_events_outlined
                : Icons.psychology_alt_outlined,
            color: turn.wasCorrect ? AppColors.success : AppColors.error,
            actionType: turn.actionType,
            playerName: playerName,
            wasCorrect: turn.wasCorrect,
          );
        case TurnActionType.requestHint:
          return GuessHistoryEntry(
            title: '$playerName requested a private hint',
            subtitle: 'A hidden clue was consumed to continue the deduction.',
            icon: Icons.lightbulb_outline,
            color: AppColors.secondary,
            actionType: turn.actionType,
            playerName: playerName,
          );
        case TurnActionType.surrender:
          return GuessHistoryEntry(
            title: '$playerName surrendered',
            subtitle: 'The opponent won immediately by surrender.',
            icon: Icons.flag_outlined,
            color: AppColors.accent,
            actionType: turn.actionType,
            playerName: playerName,
          );
        case TurnActionType.pass:
          return GuessHistoryEntry(
            title: '$playerName passed the turn',
            subtitle: 'Control moved to the next player.',
            icon: Icons.swap_horiz_rounded,
            color: AppColors.muted,
            actionType: turn.actionType,
            playerName: playerName,
          );
      }
    }).toList();
  }

  MatchResultComparison buildResultComparison({required GameMatch match}) {
    final winner = lookup.winnerPlayer(match);
    final loser = lookup.loserPlayer(match);

    return MatchResultComparison(
      winner: _buildPlayerStats(match: match, player: winner, won: true),
      loser: _buildPlayerStats(match: match, player: loser, won: false),
    );
  }

  PlayerResultStats _buildPlayerStats({
    required GameMatch match,
    required Player player,
    required bool won,
  }) {
    final turns =
        match.turns.where((turn) => turn.playerId == player.id).toList();
    final characterGuesses = turns
        .where((turn) => turn.actionType == TurnActionType.guessCharacter)
        .toList();
    final traitGuesses = turns
        .where((turn) => turn.actionType == TurnActionType.guessTrait)
        .toList();
    final correctCharacterGuesses =
        characterGuesses.where((turn) => turn.wasCorrect).length;
    final incorrectCharacterGuesses =
        characterGuesses.where((turn) => !turn.wasCorrect).length;
    final correctTraitGuesses =
        traitGuesses.where((turn) => turn.wasCorrect).length;
    final incorrectTraitGuesses =
        traitGuesses.where((turn) => !turn.wasCorrect).length;
    final hintsUsed = turns
        .where((turn) => turn.actionType == TurnActionType.requestHint)
        .length;
    final passCount =
        turns.where((turn) => turn.actionType == TurnActionType.pass).length;
    final surrendered =
        turns.any((turn) => turn.actionType == TurnActionType.surrender);

    return PlayerResultStats(
      playerId: player.id,
      playerName: player.name,
      turnsTaken: turns.length,
      characterGuesses: characterGuesses.length,
      correctCharacterGuesses: correctCharacterGuesses,
      incorrectCharacterGuesses: incorrectCharacterGuesses,
      traitGuesses: traitGuesses.length,
      correctTraitGuesses: correctTraitGuesses,
      incorrectTraitGuesses: incorrectTraitGuesses,
      correctGuesses: correctCharacterGuesses + correctTraitGuesses,
      incorrectGuesses: incorrectCharacterGuesses + incorrectTraitGuesses,
      hintsUsed: hintsUsed,
      passCount: passCount,
      surrendered: surrendered,
      won: won,
    );
  }
}
