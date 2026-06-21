import 'package:anime_deduction_tower/core/enums/match_end_reason.dart';
import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/core/enums/online_player_action_status.dart';
import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/models/online_player_action_model.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_action_resolution_authority.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/models/remote_match_bootstrap_payload_model.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/models/remote_match_public_event_model.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/models/remote_match_public_state_model.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/models/remote_player_private_state_model.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_handoff_snapshot.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RemoteMatchBootstrapPayloadModel', () {
    test('parses JSON into model and reports a playable bootstrap payload', () {
      final model = RemoteMatchBootstrapPayloadModel.fromJson({
        'roomCode': 'AB12CD',
        'matchId': 'match_AB12CD_001',
        'hostParticipantId': 'host_1',
        'guestParticipantId': 'guest_1',
        'startingParticipantId': 'host_1',
        'hostPlayerName': 'Host',
        'guestPlayerName': 'Guest',
        'hintsPerPlayer': 2,
        'hostSecretTraitId': 'black_hair',
        'guestSecretTraitId': 'villain',
        'sharedCharacterPoolIds': ['goku', 'vegeta'],
        'createdAt': '2026-06-09T12:00:00.000Z',
      });

      final entity = model.toEntity();

      expect(model.roomCode, 'AB12CD');
      expect(entity.participantIds, ['host_1', 'guest_1']);
      expect(entity.canStartMatch, isTrue);
      expect(model.toJson()['sharedCharacterPoolIds'], ['goku', 'vegeta']);
    });

    test('uses safe defaults when optional values are missing', () {
      final model = RemoteMatchBootstrapPayloadModel.fromJson(const {});

      expect(model.roomCode, '');
      expect(model.hintsPerPlayer, 0);
      expect(model.sharedCharacterPoolIds, isEmpty);
      expect(model.toEntity().canStartMatch, isFalse);
    });
  });

  group('RemoteMatchPublicStateModel', () {
    test('parses public player state maps into a readable entity', () {
      final model = RemoteMatchPublicStateModel.fromJson({
        'matchId': 'match_AB12CD_001',
        'roomCode': 'AB12CD',
        'status': 'inProgress',
        'currentTurnParticipantId': 'guest_1',
        'turnNumber': 4,
        'sharedCharacterPoolIds': ['goku', 'vegeta'],
        'playerPublicState': {
          'host_1': {
            'displayName': 'Host',
            'hintsRemaining': 1,
            'characterGuessCount': 2,
            'traitGuessCount': 0,
          },
          'guest_1': {
            'displayName': 'Guest',
            'hintsRemaining': 2,
            'characterGuessCount': 1,
            'traitGuessCount': 1,
          },
        },
        'winnerParticipantId': null,
        'endReason': null,
        'lastResolvedActionId': 'act_004',
        'matchVersion': 4,
        'createdAt': '2026-06-09T12:00:00.000Z',
        'updatedAt': '2026-06-09T12:01:00.000Z',
      });

      final entity = model.toEntity();
      final encoded = model.toJson();

      expect(model.status, MatchStatus.inProgress);
      expect(entity.currentTurnPlayerState?.displayName, 'Guest');
      expect(entity.playerStateFor('host_1')?.totalGuessCount, 2);
      expect(encoded['playerPublicState']['guest_1']['traitGuessCount'], 1);
    });

    test('falls back to safe defaults for unknown status values', () {
      final model = RemoteMatchPublicStateModel.fromJson({
        'status': 'unknown',
        'playerPublicState': const {},
      });

      expect(model.status, MatchStatus.setup);
      expect(model.toEntity().isCompleted, isFalse);
    });

    test('keeps completion metadata when a remote match is over', () {
      final model = RemoteMatchPublicStateModel.fromJson({
        'matchId': 'match_AB12CD_001',
        'roomCode': 'AB12CD',
        'status': 'completed',
        'currentTurnParticipantId': 'host_1',
        'turnNumber': 7,
        'sharedCharacterPoolIds': ['goku'],
        'playerPublicState': const {},
        'winnerParticipantId': 'host_1',
        'endReason': 'surrender',
        'matchVersion': 7,
        'createdAt': '2026-06-09T12:00:00.000Z',
        'updatedAt': '2026-06-09T12:05:00.000Z',
      });

      final entity = model.toEntity();

      expect(entity.isCompleted, isTrue);
      expect(entity.winnerParticipantId, 'host_1');
      expect(entity.endReason, MatchEndReason.surrender);
    });
  });

  group('RemotePlayerPrivateStateModel', () {
    test('parses private player state and exposes private-hint helpers', () {
      final model = RemotePlayerPrivateStateModel.fromJson({
        'participantId': 'host_1',
        'userId': 'firebase_uid_host',
        'secretTraitId': 'black_hair',
        'secretTraitLocked': true,
        'hasViewedSecret': true,
        'hintsUsed': 1,
        'lastPrivateHintText': 'The hidden trait is appearance-based.',
        'selectedAt': '2026-06-09T12:00:00.000Z',
        'updatedAt': '2026-06-09T12:03:00.000Z',
      });

      final entity = model.toEntity();

      expect(entity.hasSecretAssigned, isTrue);
      expect(entity.hasPrivateHint, isTrue);
      expect(model.toJson()['hintsUsed'], 1);
    });

    test('uses safe defaults when optional values are missing', () {
      final model = RemotePlayerPrivateStateModel.fromJson(const {});

      expect(model.secretTraitId, '');
      expect(model.secretTraitLocked, isFalse);
      expect(model.toEntity().hasPrivateHint, isFalse);
    });
  });

  group('RemoteMatchHandoffSnapshot', () {
    test(
        'reports reconnect readiness only when bootstrap public and private docs exist',
        () {
      final payload = RemoteMatchBootstrapPayloadModel.fromJson({
        'roomCode': 'AB12CD',
        'matchId': 'match_AB12CD',
        'hostParticipantId': 'host_1',
        'guestParticipantId': 'guest_1',
        'startingParticipantId': 'host_1',
        'hostPlayerName': 'Host',
        'guestPlayerName': 'Guest',
        'hintsPerPlayer': 2,
        'hostSecretTraitId': 'black_hair',
        'guestSecretTraitId': 'villain',
        'sharedCharacterPoolIds': ['goku', 'vegeta'],
        'createdAt': '2026-06-09T12:00:00.000Z',
      }).toEntity();
      final publicState = RemoteMatchPublicStateModel.fromJson({
        'matchId': 'match_AB12CD',
        'roomCode': 'AB12CD',
        'status': 'inProgress',
        'currentTurnParticipantId': 'host_1',
        'turnNumber': 0,
        'sharedCharacterPoolIds': ['goku', 'vegeta'],
        'playerPublicState': const {},
        'matchVersion': 0,
        'createdAt': '2026-06-09T12:00:00.000Z',
        'updatedAt': '2026-06-09T12:00:00.000Z',
      }).toEntity();
      final privateState = RemotePlayerPrivateStateModel.fromJson({
        'participantId': 'host_1',
        'userId': 'firebase_uid_host',
        'secretTraitId': 'black_hair',
        'secretTraitLocked': true,
        'hasViewedSecret': true,
        'hintsUsed': 0,
        'selectedAt': '2026-06-09T12:00:00.000Z',
        'updatedAt': '2026-06-09T12:00:00.000Z',
      }).toEntity();

      final partial = RemoteMatchHandoffSnapshot(
        roomCode: 'AB12CD',
        localParticipantId: 'host_1',
        bootstrapPayload: payload,
      );
      final complete = RemoteMatchHandoffSnapshot(
        roomCode: 'AB12CD',
        localParticipantId: 'host_1',
        bootstrapPayload: payload,
        publicState: publicState,
        privateState: privateState,
      );

      expect(partial.hasBootstrapPayload, isTrue);
      expect(partial.hasPublicState, isFalse);
      expect(partial.isComplete, isFalse);
      expect(complete.hasPrivateState, isTrue);
      expect(complete.isComplete, isTrue);
      expect(complete.matchId, 'match_AB12CD');
    });
  });

  group('RemoteMatchPublicEventModel', () {
    test('parses a canonical public event contract and preserves labels', () {
      final model = RemoteMatchPublicEventModel.fromJson({
        'eventId': 'event_001',
        'roomCode': 'AB12CD',
        'matchId': 'match_AB12CD',
        'actionId': 'act_005',
        'participantId': 'host_1',
        'participantName': 'Host',
        'actionType': 'guessTrait',
        'status': 'applied',
        'shortLabel': 'Correct trait guess',
        'actionSummary': 'Host guessed the trait Villain.',
        'resultSummary': 'Correct trait guess. Match ended immediately.',
        'submittedValueLabel': 'Villain',
        'resultingMatchVersion': 5,
        'createdAt': '2026-06-17T12:05:00.000Z',
        'publishedAt': '2026-06-17T12:05:02.000Z',
        'resolutionSource': 'hostClient',
      });

      final entity = model.toEntity();
      final encoded = model.toJson();

      expect(entity.isApplied, isTrue);
      expect(entity.submittedValueLabel, 'Villain');
      expect(entity.resultingMatchVersion, 5);
      expect(
        entity.resolutionSource,
        OnlineActionResolutionAuthority.hostClient,
      );
      expect(encoded['shortLabel'], 'Correct trait guess');
    });

    test('falls back to safe defaults for unknown public event values', () {
      final model = RemoteMatchPublicEventModel.fromJson(const {});

      expect(model.eventId, '');
      expect(model.actionType, TurnActionType.guessCharacter);
      expect(model.status, OnlinePlayerActionStatus.pending);
      expect(model.toEntity().submittedValueLabel, isNull);
    });
  });

  group('OnlinePlayerActionModel', () {
    test('parses a remote character guess action and preserves payload data',
        () {
      final model = OnlinePlayerActionModel.fromJson({
        'actionId': 'act_004',
        'submittedByParticipantId': 'guest_1',
        'submittedByUserId': 'firebase_uid_guest',
        'actionType': 'guessCharacter',
        'payload': {
          'characterId': 'levi',
        },
        'expectedMatchVersion': 3,
        'status': 'pending',
        'createdAt': '2026-06-09T12:04:00.000Z',
      });

      final entity = model.toEntity();
      final encoded = model.toJson();

      expect(model.actionType, TurnActionType.guessCharacter);
      expect(entity.targetsCharacter, isTrue);
      expect(entity.submittedValue, 'levi');
      expect(encoded['payload']['characterId'], 'levi');
    });

    test('parses a remote trait guess action and preserves resolver status',
        () {
      final model = OnlinePlayerActionModel.fromJson({
        'actionId': 'act_005',
        'submittedByParticipantId': 'host_1',
        'submittedByUserId': 'firebase_uid_host',
        'actionType': 'guessTrait',
        'payload': {
          'traitId': 'villain',
        },
        'expectedMatchVersion': 4,
        'status': 'applied',
        'errorCode': null,
        'resolvedByParticipantId': 'host_1',
        'resolvedByUserId': 'firebase_uid_host',
        'resolutionSource': 'hostClient',
        'createdAt': '2026-06-09T12:05:00.000Z',
        'resolvedAt': '2026-06-09T12:05:02.000Z',
      });

      final entity = model.toEntity();

      expect(entity.targetsTrait, isTrue);
      expect(entity.submittedValue, 'villain');
      expect(entity.status, OnlinePlayerActionStatus.applied);
      expect(entity.resolvedByParticipantId, 'host_1');
      expect(entity.resolvedByUserId, 'firebase_uid_host');
      expect(
        entity.resolutionSource,
        OnlineActionResolutionAuthority.hostClient,
      );
      expect(entity.resolvedAt, isNotNull);
    });

    test('falls back to a safe default action type and status', () {
      final model = OnlinePlayerActionModel.fromJson({
        'actionType': 'unknown',
        'status': 'unknown',
      });

      expect(model.actionType, TurnActionType.guessCharacter);
      expect(model.status, OnlinePlayerActionStatus.pending);
      expect(model.toEntity().submittedValue, '');
    });
  });
}
