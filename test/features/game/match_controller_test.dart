import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/core/enums/match_end_reason.dart';
import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/game/domain/services/game_engine.dart';
import 'package:anime_deduction_tower/features/game/domain/services/trait_filter_engine.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/match_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MatchController', () {
    final controller = MatchController(
      gameEngine: const GameEngine(),
      traitFilterEngine: const TraitFilterEngine(),
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

    test('initializes a match with a shared character pool from both traits', () {
      controller.initializeMatch(
        playerOneName: 'Player 1',
        playerTwoName: 'Player 2',
        hintsPerPlayer: 2,
        playerOneTraitId: 'black_hair',
        playerTwoTraitId: 'villain',
        categories: categories,
        characters: characters,
      );

      final match = controller.state;

      expect(match, isNotNull);
      expect(match!.status, MatchStatus.inProgress);
      expect(match.playerOne.validCharacterIds, ['shadow_ninja', 'abyss_duelist']);
      expect(match.playerTwo.validCharacterIds, ['crimson_emperor', 'abyss_duelist']);
      expect(match.characterPoolIds, ['shadow_ninja', 'abyss_duelist', 'crimson_emperor']);
    });

    test('submits a correct trait guess and completes the match', () {
      controller.initializeMatch(
        playerOneName: 'Player 1',
        playerTwoName: 'Player 2',
        hintsPerPlayer: 2,
        playerOneTraitId: 'black_hair',
        playerTwoTraitId: 'villain',
        categories: categories,
        characters: characters,
      );

      final result = controller.submitTraitGuess(
        guessedTraitId: 'villain',
        categories: categories,
      );

      expect(result.isCorrect, isTrue);
      expect(controller.state!.status, MatchStatus.completed);
      expect(controller.state!.winnerId, 'player_one');
      expect(controller.state!.endReason, MatchEndReason.correctTraitGuess);
    });

    test('surrender completes the match and awards the opponent', () {
      controller.initializeMatch(
        playerOneName: 'Player 1',
        playerTwoName: 'Player 2',
        hintsPerPlayer: 2,
        playerOneTraitId: 'black_hair',
        playerTwoTraitId: 'villain',
        categories: categories,
        characters: characters,
      );

      controller.surrenderCurrentPlayer();

      expect(controller.state!.status, MatchStatus.completed);
      expect(controller.state!.winnerId, 'player_two');
      expect(controller.state!.endReason, MatchEndReason.surrender);
      expect(controller.state!.turns.single.actionType.name, 'surrender');
    });
  });
}
