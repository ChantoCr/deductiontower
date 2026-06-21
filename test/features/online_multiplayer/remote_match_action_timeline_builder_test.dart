import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/core/enums/match_end_reason.dart';
import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/core/enums/online_player_action_status.dart';
import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/game_match.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/player.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_action_resolution_authority.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_player_action.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_screen_state.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_player_private_state.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/services/remote_match_action_timeline_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RemoteMatchActionTimelineBuilder', () {
    const builder = RemoteMatchActionTimelineBuilder();

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

    final pool = [
      const Character(
        id: 'goku',
        name: 'Goku',
        series: 'Dragon Ball',
        tags: ['black_hair'],
        difficulty: DifficultyLevel.easy,
        popularity: 10,
      ),
      const Character(
        id: 'frieza',
        name: 'Frieza',
        series: 'Dragon Ball',
        tags: ['villain'],
        difficulty: DifficultyLevel.easy,
        popularity: 9,
      ),
    ];

    RemoteMatchScreenState buildScreenState({
      MatchStatus status = MatchStatus.inProgress,
      String currentPlayerId = 'guest_1',
      String? winnerId,
      MatchEndReason? endReason,
    }) {
      return RemoteMatchScreenState(
        roomCode: 'AB12CD',
        match: GameMatch(
          id: 'match_AB12CD',
          playerOne: const Player(
            id: 'host_1',
            name: 'Host',
            secretTraitId: 'black_hair',
            validCharacterIds: ['goku'],
            hintsRemaining: 1,
          ),
          playerTwo: const Player(
            id: 'guest_1',
            name: 'Guest',
            secretTraitId: 'villain',
            validCharacterIds: ['frieza'],
            hintsRemaining: 2,
          ),
          currentPlayerId: currentPlayerId,
          turns: const [],
          status: status,
          characterPoolIds: const ['goku', 'frieza'],
          winnerId: winnerId,
          endReason: endReason,
        ),
        localPrivateState: RemotePlayerPrivateState(
          participantId: 'host_1',
          userId: 'firebase_uid_host',
          secretTraitId: 'black_hair',
          secretTraitLocked: true,
          hasViewedSecret: true,
          hintsUsed: 1,
          selectedAt: DateTime.parse('2026-06-16T12:00:00.000Z'),
          updatedAt: DateTime.parse('2026-06-16T12:02:00.000Z'),
        ),
        localSecretTrait: categories.first,
        categories: categories,
        characterPool: pool,
        matchVersion: 3,
        syncedAt: DateTime.parse('2026-06-16T12:02:00.000Z'),
        lastResolvedActionId: 'action_2',
      );
    }

    test('maps action ids to public-safe character and trait labels', () {
      final entries = builder.build(
        screenState: buildScreenState(),
        actions: [
          OnlinePlayerAction(
            actionId: 'action_1',
            submittedByParticipantId: 'host_1',
            submittedByUserId: 'firebase_uid_host',
            actionType: TurnActionType.guessCharacter,
            characterId: 'goku',
            expectedMatchVersion: 2,
            status: OnlinePlayerActionStatus.applied,
            createdAt: DateTime.parse('2026-06-16T12:01:00.000Z'),
            resolvedAt: DateTime.parse('2026-06-16T12:01:10.000Z'),
            resolvedByParticipantId: 'host_1',
            resolvedByUserId: 'firebase_uid_host',
            resolutionSource: OnlineActionResolutionAuthority.hostClient,
          ),
          OnlinePlayerAction(
            actionId: 'action_2',
            submittedByParticipantId: 'guest_1',
            submittedByUserId: 'firebase_uid_guest',
            actionType: TurnActionType.guessTrait,
            traitId: 'black_hair',
            expectedMatchVersion: 3,
            status: OnlinePlayerActionStatus.pending,
            createdAt: DateTime.parse('2026-06-16T12:02:00.000Z'),
          ),
        ],
      );

      expect(entries.first.actionId, 'action_2');
      expect(entries.first.shortLabel, 'Pending trait guess');
      expect(
        entries.first.actionSummary,
        'Guest guessed the trait Black Hair.',
      );
      expect(
        entries.first.resultSummary,
        'Waiting for the current official queued-action resolver.',
      );
      expect(entries.last.shortLabel, 'Applied character guess');
      expect(entries.last.actionSummary, 'Host guessed Goku.');
      expect(entries.last.submittedValueLabel, 'Goku');
      expect(
        entries.last.resultSummary,
        'Applied to the public match flow. Exact correctness is still owned by the existing match engine rather than this derived timeline view.',
      );
    });

    test('maps rejected actions to readable public rejection text', () {
      final entries = builder.build(
        screenState: buildScreenState(),
        actions: [
          OnlinePlayerAction(
            actionId: 'action_3',
            submittedByParticipantId: 'guest_1',
            submittedByUserId: 'firebase_uid_guest',
            actionType: TurnActionType.requestHint,
            expectedMatchVersion: 4,
            status: OnlinePlayerActionStatus.rejected,
            errorCode: 'no_hints_remaining',
            createdAt: DateTime.parse('2026-06-16T12:03:00.000Z'),
            resolvedAt: DateTime.parse('2026-06-16T12:03:08.000Z'),
            resolvedByParticipantId: 'host_1',
            resolvedByUserId: 'firebase_uid_host',
            resolutionSource: OnlineActionResolutionAuthority.hostClient,
          ),
        ],
      );

      expect(entries.single.shortLabel, 'Rejected hint request');
      expect(entries.single.actionSummary, 'Guest requested a private hint.');
      expect(
        entries.single.resultSummary,
        'Rejected. No hints remained for that player. Resolved by Host client resolves actions.',
      );
    });

    test('highlights completed trait-guess wins and surrender endings', () {
      final traitWinEntries = builder.build(
        screenState: buildScreenState(
          status: MatchStatus.completed,
          winnerId: 'host_1',
          endReason: MatchEndReason.correctTraitGuess,
        ),
        actions: [
          OnlinePlayerAction(
            actionId: 'action_4',
            submittedByParticipantId: 'host_1',
            submittedByUserId: 'firebase_uid_host',
            actionType: TurnActionType.guessTrait,
            traitId: 'villain',
            expectedMatchVersion: 4,
            status: OnlinePlayerActionStatus.applied,
            createdAt: DateTime.parse('2026-06-16T12:04:00.000Z'),
            resolvedAt: DateTime.parse('2026-06-16T12:04:03.000Z'),
          ),
        ],
      );

      expect(
        traitWinEntries.single.resultSummary,
        'Applied. The latest synced public match now shows a completed trait-guess win.',
      );

      final surrenderEntries = builder.build(
        screenState: buildScreenState(
          status: MatchStatus.completed,
          winnerId: 'guest_1',
          endReason: MatchEndReason.surrender,
        ),
        actions: [
          OnlinePlayerAction(
            actionId: 'action_5',
            submittedByParticipantId: 'host_1',
            submittedByUserId: 'firebase_uid_host',
            actionType: TurnActionType.surrender,
            expectedMatchVersion: 4,
            status: OnlinePlayerActionStatus.applied,
            createdAt: DateTime.parse('2026-06-16T12:05:00.000Z'),
            resolvedAt: DateTime.parse('2026-06-16T12:05:02.000Z'),
          ),
        ],
      );

      expect(
        surrenderEntries.single.resultSummary,
        'Applied. The latest synced public match now shows a surrender result.',
      );
    });
  });
}
