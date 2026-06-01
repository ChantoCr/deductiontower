import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/core/enums/match_end_reason.dart';
import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/player.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/game/domain/services/game_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GameEngine', () {
    const engine = GameEngine();
    const playerOne = Player(
      id: 'player_one',
      name: 'Player 1',
      secretTraitId: 'black_hair',
      validCharacterIds: ['shadow_ninja'],
      hintsRemaining: 2,
    );
    const playerTwo = Player(
      id: 'player_two',
      name: 'Player 2',
      secretTraitId: 'villain',
      validCharacterIds: ['crimson_emperor'],
      hintsRemaining: 2,
    );
    const opponentTrait = TraitCategory(
      id: 'villain',
      label: 'Villain',
      tagId: 'villain',
      difficulty: DifficultyLevel.easy,
      minCharacters: 1,
      hintType: 'role',
    );
    const guessedCharacter = Character(
      id: 'crimson_emperor',
      name: 'Crimson Emperor',
      series: 'Original',
      tags: ['villain'],
      difficulty: DifficultyLevel.medium,
      popularity: 7,
    );
    const wrongCharacter = Character(
      id: 'shadow_ninja',
      name: 'Shadow Ninja',
      series: 'Original',
      tags: ['black_hair'],
      difficulty: DifficultyLevel.medium,
      popularity: 8,
    );

    final match = engine.createMatch(
      matchId: 'match_1',
      playerOne: playerOne,
      playerTwo: playerTwo,
      characterPoolIds: const ['shadow_ninja', 'crimson_emperor'],
    );

    test('creates a match with the provided shared character pool', () {
      expect(match.status, MatchStatus.inProgress);
      expect(match.currentPlayerId, 'player_one');
      expect(match.characterPoolIds, ['shadow_ninja', 'crimson_emperor']);
    });

    test('switches the active player', () {
      final updatedMatch = engine.switchTurn(match);

      expect(updatedMatch.currentPlayerId, 'player_two');
    });

    test('records and resolves a correct character guess', () {
      final updatedMatch = engine.resolveCharacterGuess(
        match: match,
        guessedCharacter: guessedCharacter,
        opponentSecretTrait: opponentTrait,
        publicNote: 'AI used a balanced public probe.',
      );

      expect(updatedMatch.turns, hasLength(1));
      expect(updatedMatch.turns.single.wasCorrect, isTrue);
      expect(
        updatedMatch.turns.single.publicNote,
        'AI used a balanced public probe.',
      );
      expect(updatedMatch.currentPlayerId, 'player_two');
    });

    test('records and resolves an incorrect character guess', () {
      final updatedMatch = engine.resolveCharacterGuess(
        match: match,
        guessedCharacter: wrongCharacter,
        opponentSecretTrait: opponentTrait,
      );

      expect(updatedMatch.turns, hasLength(1));
      expect(updatedMatch.turns.single.wasCorrect, isFalse);
      expect(updatedMatch.currentPlayerId, 'player_two');
    });

    test('finishes the match with a correct trait guess', () {
      final updatedMatch = engine.resolveTraitGuess(
        match: match,
        guessedTraitId: 'villain',
        opponentSecretTrait: opponentTrait,
      );

      expect(updatedMatch.status, MatchStatus.completed);
      expect(updatedMatch.winnerId, 'player_one');
      expect(updatedMatch.endReason, MatchEndReason.correctTraitGuess);
      expect(updatedMatch.turns.single.wasCorrect, isTrue);
    });

    test('switches turn after an incorrect trait guess', () {
      final updatedMatch = engine.resolveTraitGuess(
        match: match,
        guessedTraitId: 'black_hair',
        opponentSecretTrait: opponentTrait,
      );

      expect(updatedMatch.status, MatchStatus.inProgress);
      expect(updatedMatch.winnerId, isNull);
      expect(updatedMatch.turns.single.wasCorrect, isFalse);
      expect(updatedMatch.currentPlayerId, 'player_two');
    });

    test('consumes a hint and switches turn', () {
      final updatedMatch = engine.resolveHintRequest(
        match: match,
        hintMessage: 'The trait is related to role.',
      );

      expect(updatedMatch.playerOne.hintsRemaining, 1);
      expect(updatedMatch.turns.single.value, 'The trait is related to role.');
      expect(updatedMatch.currentPlayerId, 'player_two');
    });

    test('throws when current player has no hints remaining', () {
      final emptyHintMatch = engine.createMatch(
        matchId: 'match_2',
        playerOne: playerOne.copyWith(hintsRemaining: 0),
        playerTwo: playerTwo,
        characterPoolIds: const ['shadow_ninja', 'crimson_emperor'],
      );

      expect(
        () => engine.resolveHintRequest(
          match: emptyHintMatch,
          hintMessage: 'No hint should be granted.',
        ),
        throwsStateError,
      );
    });

    test('finishes the match by surrender and records the action', () {
      final updatedMatch = engine.surrenderMatch(
        match: match,
        surrenderingPlayerId: 'player_one',
      );

      expect(updatedMatch.status, MatchStatus.completed);
      expect(updatedMatch.winnerId, 'player_two');
      expect(updatedMatch.endReason, MatchEndReason.surrender);
      expect(updatedMatch.turns.single.playerId, 'player_one');
    });
  });
}
