import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';
import 'package:flutter/material.dart';

class GuessHistoryEntry {
  const GuessHistoryEntry({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.actionType,
    required this.playerName,
    this.wasCorrect,
    this.detailNote,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final TurnActionType actionType;
  final String playerName;
  final bool? wasCorrect;
  final String? detailNote;

  bool get isCharacterGuess => actionType == TurnActionType.guessCharacter;

  bool get isTraitGuess => actionType == TurnActionType.guessTrait;

  bool get isCorrectGuess =>
      wasCorrect == true && (isCharacterGuess || isTraitGuess);

  bool get isIncorrectGuess =>
      wasCorrect == false && (isCharacterGuess || isTraitGuess);

  bool get isUtilityEvent =>
      actionType == TurnActionType.requestHint ||
      actionType == TurnActionType.pass ||
      actionType == TurnActionType.surrender;
}
