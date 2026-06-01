import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/core/enums/match_end_reason.dart';
import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/game_match.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/player.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/turn.dart';
import 'package:anime_deduction_tower/features/game/presentation/helpers/match_presentation_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MatchPresentationMapper', () {
    const mapper = MatchPresentationMapper();

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
    ];

    final match = GameMatch(
      id: 'match_1',
      playerOne: const Player(
        id: 'player_one',
        name: 'Akira',
        secretTraitId: 'black_hair',
        validCharacterIds: ['shadow_ninja'],
        hintsRemaining: 1,
      ),
      playerTwo: const Player(
        id: 'player_two',
        name: 'Ren',
        secretTraitId: 'villain',
        validCharacterIds: ['crimson_emperor'],
        hintsRemaining: 2,
      ),
      currentPlayerId: 'player_two',
      turns: [
        Turn(
          id: 'turn_1',
          playerId: 'player_one',
          actionType: TurnActionType.guessCharacter,
          value: 'shadow_ninja',
          wasCorrect: false,
          createdAt: DateTime(2025, 1, 1, 10),
        ),
        Turn(
          id: 'turn_2',
          playerId: 'player_two',
          actionType: TurnActionType.requestHint,
          value: 'Role hint',
          wasCorrect: false,
          createdAt: DateTime(2025, 1, 1, 10, 1),
        ),
        Turn(
          id: 'turn_3',
          playerId: 'player_two',
          actionType: TurnActionType.guessCharacter,
          value: 'crimson_emperor',
          wasCorrect: true,
          createdAt: DateTime(2025, 1, 1, 10, 2),
          publicNote: 'Standard AI used Crimson Emperor as a public split.',
        ),
        Turn(
          id: 'turn_4',
          playerId: 'player_one',
          actionType: TurnActionType.guessTrait,
          value: 'villain',
          wasCorrect: true,
          createdAt: DateTime(2025, 1, 1, 10, 3),
        ),
      ],
      status: MatchStatus.completed,
      characterPoolIds: const ['shadow_ninja', 'crimson_emperor'],
      winnerId: 'player_one',
      endReason: MatchEndReason.correctTraitGuess,
    );

    test('builds newest-first timeline entries with resolved labels', () {
      final entries = mapper.buildTimelineEntries(
        match: match,
        categories: categories,
        characters: characters,
      );

      expect(entries, hasLength(4));
      expect(entries.first.title, 'Akira guessed tag Villain');
      expect(entries.first.subtitle, 'The final tag guess was correct.');
      expect(entries[1].title, 'Ren guessed Crimson Emperor');
      expect(
        entries[1].detailNote,
        'Standard AI used Crimson Emperor as a public split.',
      );
      expect(entries[2].title, 'Ren requested a private hint');
      expect(entries.last.title, 'Akira guessed Shadow Ninja');
    });

    test('builds winner and loser comparison stats from turns', () {
      final comparison = mapper.buildResultComparison(match: match);

      expect(comparison.winner.playerName, 'Akira');
      expect(comparison.winner.won, isTrue);
      expect(comparison.winner.turnsTaken, 2);
      expect(comparison.winner.correctGuesses, 1);
      expect(comparison.winner.incorrectGuesses, 1);
      expect(comparison.winner.characterGuesses, 1);
      expect(comparison.winner.traitGuesses, 1);
      expect(comparison.winner.hintsUsed, 0);

      expect(comparison.loser.playerName, 'Ren');
      expect(comparison.loser.won, isFalse);
      expect(comparison.loser.turnsTaken, 2);
      expect(comparison.loser.correctGuesses, 1);
      expect(comparison.loser.incorrectGuesses, 0);
      expect(comparison.loser.characterGuesses, 1);
      expect(comparison.loser.traitGuesses, 0);
      expect(comparison.loser.hintsUsed, 1);
      expect(comparison.loser.surrendered, isFalse);
    });
  });
}
