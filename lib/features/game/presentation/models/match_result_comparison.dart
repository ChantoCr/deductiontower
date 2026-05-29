class MatchResultComparison {
  const MatchResultComparison({
    required this.winner,
    required this.loser,
  });

  final PlayerResultStats winner;
  final PlayerResultStats loser;
}

class PlayerResultStats {
  const PlayerResultStats({
    required this.playerId,
    required this.playerName,
    required this.turnsTaken,
    required this.characterGuesses,
    required this.correctCharacterGuesses,
    required this.incorrectCharacterGuesses,
    required this.traitGuesses,
    required this.correctTraitGuesses,
    required this.incorrectTraitGuesses,
    required this.correctGuesses,
    required this.incorrectGuesses,
    required this.hintsUsed,
    required this.passCount,
    required this.surrendered,
    required this.won,
  });

  final String playerId;
  final String playerName;
  final int turnsTaken;
  final int characterGuesses;
  final int correctCharacterGuesses;
  final int incorrectCharacterGuesses;
  final int traitGuesses;
  final int correctTraitGuesses;
  final int incorrectTraitGuesses;
  final int correctGuesses;
  final int incorrectGuesses;
  final int hintsUsed;
  final int passCount;
  final bool surrendered;
  final bool won;
}
