import 'dart:math';

import 'package:anime_deduction_tower/core/enums/ai_difficulty.dart';
import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/core/enums/match_end_reason.dart';
import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/features/ai_opponent/domain/services/mock_ai_opponent_service.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/game/domain/services/game_engine.dart';
import 'package:anime_deduction_tower/features/game/domain/services/hint_engine.dart';
import 'package:anime_deduction_tower/features/game/domain/services/trait_filter_engine.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/match_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MatchController', () {
    final controller = MatchController(
      gameEngine: const GameEngine(),
      hintEngine: const HintEngine(),
      traitFilterEngine: const TraitFilterEngine(),
      aiOpponentService: MockAiOpponentService(random: Random(0)),
    );

    const categories = [
      TraitCategory(
        id: 'black_hair',
        label: 'Black Hair',
        tagId: 'black_hair',
        difficulty: DifficultyLevel.easy,
        minCharacters: 1,
        hintType: 'appearance',
      ),
      TraitCategory(
        id: 'villain',
        label: 'Villain',
        tagId: 'villain',
        difficulty: DifficultyLevel.easy,
        minCharacters: 1,
        hintType: 'role',
      ),
    ];

    const characters = [
      Character(
        id: 'shadow_ninja',
        name: 'Shadow Ninja',
        series: 'Original',
        tags: ['black_hair'],
        difficulty: DifficultyLevel.medium,
        popularity: 8,
      ),
      Character(
        id: 'crimson_emperor',
        name: 'Crimson Emperor',
        series: 'Original',
        tags: ['villain'],
        difficulty: DifficultyLevel.medium,
        popularity: 7,
      ),
      Character(
        id: 'abyss_duelist',
        name: 'Abyss Duelist',
        series: 'Original',
        tags: ['black_hair', 'villain'],
        difficulty: DifficultyLevel.medium,
        popularity: 8,
      ),
    ];

    setUp(() {
      controller.clear();
    });

    void initializeStandardMatch({
      int hintsPerPlayer = 2,
      bool playerTwoIsAi = false,
    }) {
      controller.initializeMatch(
        playerOneName: 'Player 1',
        playerTwoName: playerTwoIsAi ? 'Tower AI' : 'Player 2',
        hintsPerPlayer: hintsPerPlayer,
        playerOneTraitId: 'black_hair',
        playerTwoTraitId: 'villain',
        categories: categories,
        characters: characters,
        playerTwoIsAi: playerTwoIsAi,
      );
    }

    test('initializes a match with a shared character pool from both traits',
        () {
      initializeStandardMatch();

      final match = controller.state;

      expect(match, isNotNull);
      expect(match!.status, MatchStatus.inProgress);
      expect(
        match.playerOne.validCharacterIds,
        ['shadow_ninja', 'abyss_duelist'],
      );
      expect(
        match.playerTwo.validCharacterIds,
        ['crimson_emperor', 'abyss_duelist'],
      );
      expect(
        match.characterPoolIds,
        ['shadow_ninja', 'abyss_duelist', 'crimson_emperor'],
      );
    });

    test('submits a character guess and advances the turn', () {
      initializeStandardMatch();

      final result = controller.submitCharacterGuess(
        characterId: 'crimson_emperor',
        characters: characters,
        categories: categories,
      );

      expect(result.isCorrect, isTrue);
      expect(controller.state!.currentPlayerId, 'player_two');
      expect(controller.state!.turns.single.value, 'crimson_emperor');
    });

    test('submits an incorrect trait guess and keeps the match alive', () {
      initializeStandardMatch();

      final result = controller.submitTraitGuess(
        guessedTraitId: 'black_hair',
        categories: categories,
      );

      expect(result.isCorrect, isFalse);
      expect(controller.state!.status, MatchStatus.inProgress);
      expect(controller.state!.winnerId, isNull);
      expect(controller.state!.currentPlayerId, 'player_two');
    });

    test('submits a correct trait guess and completes the match', () {
      initializeStandardMatch();

      final result = controller.submitTraitGuess(
        guessedTraitId: 'villain',
        categories: categories,
      );

      expect(result.isCorrect, isTrue);
      expect(controller.state!.status, MatchStatus.completed);
      expect(controller.state!.winnerId, 'player_one');
      expect(controller.state!.endReason, MatchEndReason.correctTraitGuess);
    });

    test('requesting a hint consumes one hint and switches turn', () {
      initializeStandardMatch();

      final hint = controller.requestHint(categories: categories);

      expect(hint, contains('role'));
      expect(controller.state!.playerOne.hintsRemaining, 1);
      expect(controller.state!.currentPlayerId, 'player_two');
      expect(controller.state!.turns.single.actionType.name, 'requestHint');
    });

    test('requesting a hint with none remaining throws', () {
      initializeStandardMatch(hintsPerPlayer: 0);

      expect(
        () => controller.requestHint(categories: categories),
        throwsStateError,
      );
    });

    test('surrender completes the match and awards the opponent', () {
      initializeStandardMatch();

      controller.surrenderCurrentPlayer();

      expect(controller.state!.status, MatchStatus.completed);
      expect(controller.state!.winnerId, 'player_two');
      expect(controller.state!.endReason, MatchEndReason.surrender);
      expect(controller.state!.turns.single.actionType.name, 'surrender');
    });

    test('initializes an ai-controlled opponent when player-vs-ai is requested',
        () {
      initializeStandardMatch(playerTwoIsAi: true);

      expect(controller.state!.playerTwo.isAi, isTrue);
      expect(controller.state!.playerTwo.name, 'Tower AI');
    });

    test('runs an ai turn using the selected difficulty layer', () {
      initializeStandardMatch(playerTwoIsAi: true);
      controller.submitCharacterGuess(
        characterId: 'shadow_ninja',
        characters: characters,
        categories: categories,
      );

      final result = controller.runAiTurn(
        categories: categories,
        characters: characters,
        difficulty: AiDifficulty.standard,
      );

      expect(result.guessedValue, isNotEmpty);
      expect(result.message, contains('Standard AI'));
      expect(controller.state!.turns.last.publicNote, contains('Standard AI'));
      expect(controller.state!.currentPlayerId, 'player_one');
    });
  });
}
