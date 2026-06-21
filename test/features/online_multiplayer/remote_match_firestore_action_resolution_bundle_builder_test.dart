import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/core/enums/online_player_action_status.dart';
import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_action_resolution_authority.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/services/remote_match_firestore_action_resolution_bundle_builder.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_player_action.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_action_resolution.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_event.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_player_state.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_state.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_player_private_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RemoteMatchFirestoreActionResolutionBundleBuilder', () {
    const builder = RemoteMatchFirestoreActionResolutionBundleBuilder();

    test('builds explicit Firestore docs for action resolution updates', () {
      final resolution = RemoteMatchActionResolution(
        baseMatchVersion: 2,
        publicState: RemoteMatchPublicState(
          matchId: 'match_AB12CD',
          roomCode: 'AB12CD',
          status: MatchStatus.inProgress,
          currentTurnParticipantId: 'guest_1',
          turnNumber: 3,
          sharedCharacterPoolIds: const ['goku', 'vegeta', 'frieza'],
          playerStates: const [
            RemoteMatchPublicPlayerState(
              participantId: 'host_1',
              displayName: 'Host',
              hintsRemaining: 1,
              characterGuessCount: 1,
              traitGuessCount: 0,
            ),
            RemoteMatchPublicPlayerState(
              participantId: 'guest_1',
              displayName: 'Guest',
              hintsRemaining: 2,
              characterGuessCount: 0,
              traitGuessCount: 0,
            ),
          ],
          lastResolvedActionId: 'online_action_2',
          matchVersion: 3,
          createdAt: DateTime.parse('2026-06-15T09:00:00.000Z'),
          updatedAt: DateTime.parse('2026-06-15T09:03:05.000Z'),
        ),
        resolvedAction: OnlinePlayerAction(
          actionId: 'online_action_2',
          submittedByParticipantId: 'host_1',
          submittedByUserId: 'firebase_uid_host',
          actionType: TurnActionType.requestHint,
          expectedMatchVersion: 2,
          status: OnlinePlayerActionStatus.applied,
          resolvedByParticipantId: 'host_1',
          resolvedByUserId: 'firebase_uid_host',
          resolutionSource: OnlineActionResolutionAuthority.hostClient,
          createdAt: DateTime.parse('2026-06-15T09:03:00.000Z'),
          resolvedAt: DateTime.parse('2026-06-15T09:03:05.000Z'),
        ),
        publicEvent: RemoteMatchPublicEvent(
          eventId: 'online_action_2',
          roomCode: 'AB12CD',
          matchId: 'match_AB12CD',
          actionId: 'online_action_2',
          participantId: 'host_1',
          participantName: 'Host',
          actionType: TurnActionType.requestHint,
          status: OnlinePlayerActionStatus.applied,
          shortLabel: 'Private hint granted',
          actionSummary: 'Host requested a private hint.',
          resultSummary:
              'Private hint delivered. The exact hint text stays outside public event docs.',
          resultingMatchVersion: 3,
          createdAt: DateTime.parse('2026-06-15T09:03:00.000Z'),
          publishedAt: DateTime.parse('2026-06-15T09:03:05.000Z'),
          resolutionSource: OnlineActionResolutionAuthority.hostClient,
        ),
        affectedPrivateState: RemotePlayerPrivateState(
          participantId: 'host_1',
          userId: 'firebase_uid_host',
          secretTraitId: 'black_hair',
          secretTraitLocked: true,
          hasViewedSecret: true,
          hintsUsed: 1,
          lastPrivateHintText:
              'The hidden trait is related to role and is medium difficulty.',
          selectedAt: DateTime.parse('2026-06-15T09:00:00.000Z'),
          updatedAt: DateTime.parse('2026-06-15T09:03:05.000Z'),
        ),
      );

      final bundle = builder.build(resolution);

      expect(bundle.publicMatchDocument['matchVersion'], 3);
      expect(
        bundle.publicMatchDocument['lastResolvedActionId'],
        'online_action_2',
      );
      expect(bundle.actionDocument['status'], 'applied');
      expect(bundle.actionDocument['expectedMatchVersion'], 2);
      expect(bundle.actionDocument['resolvedByParticipantId'], 'host_1');
      expect(bundle.publicEventId, 'online_action_2');
      expect(
        bundle.publicEventDocument['shortLabel'],
        'Private hint granted',
      );
      expect(bundle.publicEventDocument['resultingMatchVersion'], 3);
      expect(bundle.actionDocument['resolvedByUserId'], 'firebase_uid_host');
      expect(bundle.actionDocument['resolutionSource'], 'hostClient');
      expect(bundle.privateParticipantId, 'host_1');
      expect(bundle.privatePlayerDocument?['hintsUsed'], 1);
      expect(
        bundle.privatePlayerDocument?['lastPrivateHintText'],
        'The hidden trait is related to role and is medium difficulty.',
      );
    });
  });
}
