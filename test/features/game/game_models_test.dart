import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/core/enums/player_control_type.dart';
import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';
import 'package:anime_deduction_tower/features/game/data/models/game_match_model.dart';
import 'package:anime_deduction_tower/features/game/data/models/guess_model.dart';
import 'package:anime_deduction_tower/features/game/data/models/player_model.dart';
import 'package:anime_deduction_tower/features/game/data/models/trait_category_model.dart';
import 'package:anime_deduction_tower/features/game/data/models/turn_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TraitCategoryModel', () {
    test('parses JSON into model and entity', () {
      final model = TraitCategoryModel.fromJson({
        'id': 'villain',
        'label': 'Villain',
        'tagId': 'villain',
        'difficulty': 'easy',
        'minCharacters': 5,
        'hintType': 'role',
      });

      final entity = model.toEntity();

      expect(model.id, 'villain');
      expect(model.difficulty, DifficultyLevel.easy);
      expect(entity.tagId, 'villain');
      expect(entity.hintType, 'role');
    });
  });

  group('PlayerModel', () {
    test('parses JSON into model and entity', () {
      final model = PlayerModel.fromJson({
        'id': 'player_one',
        'name': 'Player 1',
        'secretTraitId': 'black_hair',
        'validCharacterIds': ['shadow_ninja'],
        'hintsRemaining': 2,
        'controlType': 'ai',
      });

      final entity = model.toEntity();

      expect(model.secretTraitId, 'black_hair');
      expect(entity.validCharacterIds, ['shadow_ninja']);
      expect(entity.hintsRemaining, 2);
      expect(entity.controlType, PlayerControlType.ai);
    });

    test('uses default values when optional fields are missing', () {
      final model = PlayerModel.fromJson({
        'id': 'player_two',
        'name': 'Player 2',
      });

      expect(model.validCharacterIds, isEmpty);
      expect(model.hintsRemaining, 2);
      expect(model.controlType, PlayerControlType.human);
    });
  });

  group('TurnModel', () {
    test('parses JSON into model and entity', () {
      final model = TurnModel.fromJson({
        'id': 'turn_1',
        'playerId': 'player_one',
        'actionType': 'guessCharacter',
        'value': 'shadow_ninja',
        'wasCorrect': true,
        'createdAt': '2026-05-16T00:00:00.000Z',
      });

      final entity = model.toEntity();

      expect(model.actionType, TurnActionType.guessCharacter);
      expect(entity.wasCorrect, isTrue);
      expect(entity.value, 'shadow_ninja');
    });

    test('falls back to pass action when input is unknown', () {
      final model = TurnModel.fromJson({
        'id': 'turn_2',
        'playerId': 'player_two',
        'actionType': 'unknown',
      });

      expect(model.actionType, TurnActionType.pass);
      expect(model.value, '');
      expect(model.wasCorrect, isFalse);
    });
  });

  group('GuessModel', () {
    test('parses JSON into model and entity', () {
      final model = GuessModel.fromJson({
        'id': 'guess_1',
        'playerId': 'player_one',
        'actionType': 'guessTrait',
        'value': 'villain',
      });

      final entity = model.toEntity();

      expect(model.actionType, TurnActionType.guessTrait);
      expect(entity.value, 'villain');
    });

    test('falls back to guessCharacter when input is unknown', () {
      final model = GuessModel.fromJson({
        'id': 'guess_2',
        'playerId': 'player_two',
        'actionType': 'unknown',
      });

      expect(model.actionType, TurnActionType.guessCharacter);
      expect(model.value, '');
    });
  });

  group('GameMatchModel', () {
    test('maps nested models into a domain entity', () {
      final match = GameMatchModel(
        id: 'match_1',
        playerOne: PlayerModel.fromJson({
          'id': 'player_one',
          'name': 'Player 1',
          'validCharacterIds': ['shadow_ninja'],
        }),
        playerTwo: PlayerModel.fromJson({
          'id': 'player_two',
          'name': 'Player 2',
          'validCharacterIds': ['void_beast'],
        }),
        currentPlayerId: 'player_one',
        characterPoolIds: const ['shadow_ninja', 'void_beast'],
        turns: [
          TurnModel.fromJson({
            'id': 'turn_1',
            'playerId': 'player_one',
            'actionType': 'guessCharacter',
            'value': 'shadow_ninja',
            'wasCorrect': true,
            'createdAt': '2026-05-16T00:00:00.000Z',
          }),
        ],
        status: MatchStatus.inProgress,
      );

      final entity = match.toEntity();

      expect(entity.id, 'match_1');
      expect(entity.currentPlayerId, 'player_one');
      expect(entity.turns, hasLength(1));
      expect(entity.status, MatchStatus.inProgress);
      expect(entity.playerOne.name, 'Player 1');
      expect(entity.characterPoolIds, ['shadow_ninja', 'void_beast']);
    });
  });
}
