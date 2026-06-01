import 'dart:math';

import 'package:anime_deduction_tower/core/enums/ai_difficulty.dart';
import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/core/enums/player_control_type.dart';
import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';
import 'package:anime_deduction_tower/features/ai_opponent/domain/services/mock_ai_opponent_service.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/game_match.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/player.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/turn.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MockAiOpponentService', () {
    final service = MockAiOpponentService(random: Random(0));

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
        popularity: 9,
      ),
    ];

    test(
        'chooses an ai secret trait while avoiding the human trait when possible',
        () {
      final chosenTraitId = service.chooseSecretTraitId(
        categories: categories,
        excludedTraitId: 'black_hair',
      );

      expect(chosenTraitId, 'villain');
    });

    test(
        'guesses the final remaining candidate trait after public evidence narrows it down',
        () {
      final match = GameMatch(
        id: 'match_1',
        playerOne: const Player(
          id: 'player_one',
          name: 'Player 1',
          secretTraitId: 'black_hair',
          validCharacterIds: ['shadow_ninja', 'abyss_duelist'],
          hintsRemaining: 2,
        ),
        playerTwo: const Player(
          id: 'player_two',
          name: 'Tower AI',
          secretTraitId: 'villain',
          validCharacterIds: ['crimson_emperor', 'abyss_duelist'],
          hintsRemaining: 2,
          controlType: PlayerControlType.ai,
        ),
        currentPlayerId: 'player_two',
        turns: [
          Turn(
            id: 'turn_1',
            playerId: 'player_two',
            actionType: TurnActionType.guessCharacter,
            value: 'shadow_ninja',
            wasCorrect: true,
            createdAt: DateTime(2026, 1, 1),
          ),
          Turn(
            id: 'turn_2',
            playerId: 'player_two',
            actionType: TurnActionType.guessCharacter,
            value: 'crimson_emperor',
            wasCorrect: false,
            createdAt: DateTime(2026, 1, 2),
          ),
        ],
        status: MatchStatus.inProgress,
        characterPoolIds: ['shadow_ninja', 'crimson_emperor', 'abyss_duelist'],
      );

      final decision = service.chooseTurn(
        match: match,
        categories: categories,
        characters: characters,
        difficulty: AiDifficulty.standard,
      );

      expect(decision.actionType, TurnActionType.guessTrait);
      expect(decision.value, 'black_hair');
      expect(decision.summary, contains('Standard AI'));
    });

    test('prefers a more informative public probe on hard difficulty', () {
      const extraCategories = [
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
        TraitCategory(
          id: 'uses_sword',
          label: 'Uses Sword',
          tagId: 'uses_sword',
          difficulty: DifficultyLevel.easy,
          minCharacters: 1,
          hintType: 'weapon',
        ),
      ];

      const extraCharacters = [
        Character(
          id: 'balanced_probe',
          name: 'Balanced Probe',
          series: 'Original',
          tags: ['black_hair', 'villain'],
          difficulty: DifficultyLevel.medium,
          popularity: 6,
        ),
        Character(
          id: 'popular_but_flat',
          name: 'Popular but Flat',
          series: 'Original',
          tags: ['black_hair', 'villain', 'uses_sword'],
          difficulty: DifficultyLevel.medium,
          popularity: 10,
        ),
      ];

      final match = GameMatch(
        id: 'match_2',
        playerOne: const Player(
          id: 'player_one',
          name: 'Player 1',
          secretTraitId: 'black_hair',
          validCharacterIds: ['balanced_probe', 'popular_but_flat'],
          hintsRemaining: 2,
        ),
        playerTwo: const Player(
          id: 'player_two',
          name: 'Tower AI',
          secretTraitId: 'villain',
          validCharacterIds: ['balanced_probe', 'popular_but_flat'],
          hintsRemaining: 2,
          controlType: PlayerControlType.ai,
        ),
        currentPlayerId: 'player_two',
        turns: const [],
        status: MatchStatus.inProgress,
        characterPoolIds: ['balanced_probe', 'popular_but_flat'],
      );

      final decision = service.chooseTurn(
        match: match,
        categories: extraCategories,
        characters: extraCharacters,
        difficulty: AiDifficulty.hard,
      );

      expect(decision.actionType, TurnActionType.guessCharacter);
      expect(decision.value, 'balanced_probe');
      expect(decision.summary, contains('Hard AI used Balanced Probe'));
    });

    test(
        'hard difficulty commits sooner when the remaining public probe is useless',
        () {
      const extraCategories = [
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

      const flatCharacters = [
        Character(
          id: 'prior_flat_probe',
          name: 'Prior Flat Probe',
          series: 'Original',
          tags: ['black_hair', 'villain'],
          difficulty: DifficultyLevel.medium,
          popularity: 7,
        ),
        Character(
          id: 'flat_probe',
          name: 'Flat Probe',
          series: 'Original',
          tags: ['black_hair', 'villain'],
          difficulty: DifficultyLevel.medium,
          popularity: 9,
        ),
      ];

      final match = GameMatch(
        id: 'match_3',
        playerOne: const Player(
          id: 'player_one',
          name: 'Player 1',
          secretTraitId: 'black_hair',
          validCharacterIds: ['prior_flat_probe', 'flat_probe'],
          hintsRemaining: 2,
        ),
        playerTwo: const Player(
          id: 'player_two',
          name: 'Tower AI',
          secretTraitId: 'villain',
          validCharacterIds: ['prior_flat_probe', 'flat_probe'],
          hintsRemaining: 2,
          controlType: PlayerControlType.ai,
        ),
        currentPlayerId: 'player_two',
        turns: [
          Turn(
            id: 'turn_1',
            playerId: 'player_two',
            actionType: TurnActionType.guessCharacter,
            value: 'prior_flat_probe',
            wasCorrect: true,
            createdAt: DateTime(2026, 1, 1),
          ),
        ],
        status: MatchStatus.inProgress,
        characterPoolIds: ['prior_flat_probe', 'flat_probe'],
      );

      final hardDecision = service.chooseTurn(
        match: match,
        categories: extraCategories,
        characters: flatCharacters,
        difficulty: AiDifficulty.hard,
      );
      final easyDecision = service.chooseTurn(
        match: match,
        categories: extraCategories,
        characters: flatCharacters,
        difficulty: AiDifficulty.easy,
      );

      expect(hardDecision.actionType, TurnActionType.guessTrait);
      expect(easyDecision.actionType, TurnActionType.guessCharacter);
    });
  });
}
