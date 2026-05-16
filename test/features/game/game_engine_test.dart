import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/game_match.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/player.dart';
import 'package:anime_deduction_tower/features/game/domain/services/game_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GameEngine', () {
    test('switches the active player', () {
      const match = GameMatch(
        id: 'match_1',
        playerOne: Player(
          id: 'player_one',
          name: 'Player 1',
          validCharacterIds: [],
          lives: 3,
          hintsRemaining: 2,
        ),
        playerTwo: Player(
          id: 'player_two',
          name: 'Player 2',
          validCharacterIds: [],
          lives: 3,
          hintsRemaining: 2,
        ),
        currentPlayerId: 'player_one',
        turns: [],
        status: MatchStatus.inProgress,
      );

      const engine = GameEngine();
      final updatedMatch = engine.switchTurn(match);

      expect(updatedMatch.currentPlayerId, 'player_two');
    });
  });
}
