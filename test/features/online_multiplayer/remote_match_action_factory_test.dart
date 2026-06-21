import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/game_match.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/player.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_screen_state.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_player_private_state.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/services/remote_match_action_factory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RemoteMatchActionFactory', () {
    const factory = RemoteMatchActionFactory();

    final categories = [
      const TraitCategory(
        id: 'black_hair',
        label: 'Black Hair',
        tagId: 'black_hair',
        difficulty: DifficultyLevel.easy,
        minCharacters: 2,
        hintType: 'appearance',
      ),
      const TraitCategory(
        id: 'villain',
        label: 'Villain',
        tagId: 'villain',
        difficulty: DifficultyLevel.medium,
        minCharacters: 2,
        hintType: 'role',
      ),
    ];

    final characters = [
      const Character(
        id: 'goku',
        name: 'Goku',
        series: 'Dragon Ball',
        tags: ['black_hair', 'hero'],
        difficulty: DifficultyLevel.easy,
        popularity: 10,
      ),
      const Character(
        id: 'vegeta',
        name: 'Vegeta',
        series: 'Dragon Ball',
        tags: ['black_hair', 'villain'],
        difficulty: DifficultyLevel.easy,
        popularity: 9,
      ),
    ];

    final screenState = RemoteMatchScreenState(
      roomCode: 'AB12CD',
      match: const GameMatch(
        id: 'match_AB12CD',
        playerOne: Player(
          id: 'host_1',
          name: 'Host',
          secretTraitId: 'black_hair',
          validCharacterIds: ['goku', 'vegeta'],
          hintsRemaining: 2,
        ),
        playerTwo: Player(
          id: 'guest_1',
          name: 'Guest',
          secretTraitId: 'villain',
          validCharacterIds: ['vegeta'],
          hintsRemaining: 2,
        ),
        currentPlayerId: 'host_1',
        turns: [],
        status: MatchStatus.inProgress,
        characterPoolIds: ['goku', 'vegeta'],
      ),
      localPrivateState: RemotePlayerPrivateState(
        participantId: 'host_1',
        userId: 'firebase_uid_host',
        secretTraitId: 'black_hair',
        secretTraitLocked: true,
        hasViewedSecret: true,
        hintsUsed: 0,
        selectedAt: DateTime.parse('2026-06-15T10:00:00.000Z'),
        updatedAt: DateTime.parse('2026-06-15T10:00:00.000Z'),
      ),
      localSecretTrait: categories.first,
      categories: categories,
      characterPool: characters,
      matchVersion: 3,
      syncedAt: DateTime.parse('2026-06-15T10:05:00.000Z'),
      lastResolvedActionId: 'online_action_3',
    );

    test('builds a queued hint request for the local participant', () {
      final action = factory.buildHintRequestAction(
        screenState: screenState,
        actionId: 'online_action_4',
        createdAt: DateTime.parse('2026-06-15T10:06:00.000Z'),
      );

      expect(action.actionId, 'online_action_4');
      expect(action.submittedByParticipantId, 'host_1');
      expect(action.submittedByUserId, 'firebase_uid_host');
      expect(action.actionType, TurnActionType.requestHint);
      expect(action.expectedMatchVersion, 3);
    });

    test('builds a character guess only for shared-pool characters', () {
      final action = factory.buildCharacterGuessAction(
        screenState: screenState,
        characterId: 'vegeta',
        actionId: 'online_action_5',
      );

      expect(action.actionType, TurnActionType.guessCharacter);
      expect(action.characterId, 'vegeta');
      expect(action.submittedValue, 'vegeta');
    });

    test('throws when queuing a character outside the shared pool', () {
      expect(
        () => factory.buildCharacterGuessAction(
          screenState: screenState,
          characterId: 'frieza',
        ),
        throwsStateError,
      );
    });
  });
}
