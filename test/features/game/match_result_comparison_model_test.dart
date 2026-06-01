import 'package:anime_deduction_tower/features/game/presentation/models/match_result_comparison.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlayerResultStats', () {
    const stats = PlayerResultStats(
      playerId: 'player_two',
      playerName: 'Tower AI',
      turnsTaken: 4,
      characterGuesses: 3,
      correctCharacterGuesses: 2,
      incorrectCharacterGuesses: 1,
      traitGuesses: 1,
      correctTraitGuesses: 0,
      incorrectTraitGuesses: 1,
      correctGuesses: 2,
      incorrectGuesses: 2,
      hintsUsed: 1,
      passCount: 0,
      surrendered: false,
      won: false,
    );

    test('computes resolved guess counts and accuracy rates', () {
      expect(stats.resolvedGuesses, 4);
      expect(stats.overallAccuracy, 0.5);
      expect(stats.characterGuessAccuracy, closeTo(2 / 3, 0.0001));
    });

    test('detects when a player used a final tag read', () {
      expect(stats.usedFinalTagRead, isTrue);
    });

    test('returns null accuracy when no guesses were resolved', () {
      const emptyStats = PlayerResultStats(
        playerId: 'player_one',
        playerName: 'Player 1',
        turnsTaken: 0,
        characterGuesses: 0,
        correctCharacterGuesses: 0,
        incorrectCharacterGuesses: 0,
        traitGuesses: 0,
        correctTraitGuesses: 0,
        incorrectTraitGuesses: 0,
        correctGuesses: 0,
        incorrectGuesses: 0,
        hintsUsed: 0,
        passCount: 0,
        surrendered: false,
        won: false,
      );

      expect(emptyStats.resolvedGuesses, 0);
      expect(emptyStats.overallAccuracy, isNull);
      expect(emptyStats.characterGuessAccuracy, isNull);
      expect(emptyStats.usedFinalTagRead, isFalse);
    });
  });
}
