import 'package:anime_deduction_tower/core/enums/ai_difficulty.dart';
import 'package:anime_deduction_tower/features/game/presentation/helpers/game_flow_copy_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GameFlowCopyHelper AI copy', () {
    const helper = GameFlowCopyHelper();

    test('describes ai setup flow without changing official rules', () {
      final description = helper.aiOpponentSetupDescription(
        aiName: 'Tower AI',
        difficulty: AiDifficulty.standard,
      );

      expect(description, contains('Tower AI'));
      expect(description, contains('auto-assigned hidden tag'));
      expect(description, contains('official match rules'));
    });

    test('describes hard ai live behavior and public visibility', () {
      final description = helper.aiOpponentLiveDescription(
        aiName: 'Tower AI',
        difficulty: AiDifficulty.hard,
      );

      expect(description, contains('hard difficulty'));
      expect(description, contains('public'));
      expect(description, contains('reasoning summary'));
    });

    test('describes ai result review with outcome context', () {
      final description = helper.aiOpponentResultDescription(
        aiName: 'Tower AI',
        difficulty: AiDifficulty.easy,
        aiWon: true,
      );

      expect(description, contains('won the duel'));
      expect(description, contains('easy difficulty'));
      expect(description, contains('analytics'));
    });
  });
}
