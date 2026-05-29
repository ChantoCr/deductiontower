import 'dart:math';

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
      );

      expect(decision.actionType, TurnActionType.guessTrait);
      expect(decision.value, 'black_hair');
    });
  });
}
