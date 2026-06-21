import 'package:anime_deduction_tower/core/enums/match_end_reason.dart';
import 'package:anime_deduction_tower/core/enums/online_player_action_status.dart';
import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/player.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_action_resolution_authority.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_player_action.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_action_error_code.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_action_timeline_entry.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_screen_state.dart';

class RemoteMatchActionTimelineBuilder {
  const RemoteMatchActionTimelineBuilder();

  List<RemoteMatchActionTimelineEntry> build({
    required RemoteMatchScreenState screenState,
    required List<OnlinePlayerAction> actions,
  }) {
    final sortedActions = actions.toList(growable: false)
      ..sort(
        (left, right) => _timestampFor(right).compareTo(_timestampFor(left)),
      );

    return sortedActions
        .map(
          (action) => RemoteMatchActionTimelineEntry(
            actionId: action.actionId,
            participantId: action.submittedByParticipantId,
            participantName: _participantName(
              screenState.match.playerOne,
              screenState.match.playerTwo,
              action.submittedByParticipantId,
            ),
            actionType: action.actionType,
            status: action.status,
            shortLabel: _shortLabel(action),
            actionSummary: _actionSummary(screenState, action),
            resultSummary: _resultSummary(screenState, action),
            submittedValueLabel: _submittedValueLabel(screenState, action),
            primaryTimestamp: _timestampFor(action),
            createdAt: action.createdAt,
            resolvedAt: action.resolvedAt,
            resolvedByParticipantId: action.resolvedByParticipantId,
            resolvedByUserId: action.resolvedByUserId,
            resolutionSource: action.resolutionSource,
          ),
        )
        .toList(growable: false);
  }

  DateTime _timestampFor(OnlinePlayerAction action) {
    return action.resolvedAt ?? action.createdAt;
  }

  String _participantName(
    Player playerOne,
    Player playerTwo,
    String participantId,
  ) {
    if (playerOne.id == participantId) {
      return playerOne.name;
    }

    if (playerTwo.id == participantId) {
      return playerTwo.name;
    }

    return participantId;
  }

  String _shortLabel(OnlinePlayerAction action) {
    final prefix = switch (action.status) {
      OnlinePlayerActionStatus.pending => 'Pending',
      OnlinePlayerActionStatus.applied => 'Applied',
      OnlinePlayerActionStatus.rejected => 'Rejected',
    };

    final actionLabel = switch (action.actionType) {
      TurnActionType.guessCharacter => 'character guess',
      TurnActionType.guessTrait => 'trait guess',
      TurnActionType.requestHint => 'hint request',
      TurnActionType.surrender => 'surrender',
      TurnActionType.pass => 'pass action',
    };

    return '$prefix $actionLabel';
  }

  String _actionSummary(
    RemoteMatchScreenState screenState,
    OnlinePlayerAction action,
  ) {
    final participantName = _participantName(
      screenState.match.playerOne,
      screenState.match.playerTwo,
      action.submittedByParticipantId,
    );

    return switch (action.actionType) {
      TurnActionType.guessCharacter =>
        '$participantName guessed ${_submittedValueLabel(screenState, action) ?? 'an unknown character'}.',
      TurnActionType.guessTrait =>
        '$participantName guessed the trait ${_submittedValueLabel(screenState, action) ?? 'unknown trait'}.',
      TurnActionType.requestHint =>
        '$participantName requested a private hint.',
      TurnActionType.surrender => '$participantName surrendered the match.',
      TurnActionType.pass =>
        '$participantName submitted an unsupported pass action.',
    };
  }

  String _resultSummary(
    RemoteMatchScreenState screenState,
    OnlinePlayerAction action,
  ) {
    if (action.status == OnlinePlayerActionStatus.pending) {
      return 'Waiting for the current official queued-action resolver.';
    }

    if (action.status == OnlinePlayerActionStatus.rejected) {
      final reason = _rejectionReason(action.errorCode);
      final resolvedBy = action.resolutionSource?.label;
      if (resolvedBy == null) {
        return 'Rejected. $reason';
      }

      return 'Rejected. $reason Resolved by $resolvedBy.';
    }

    return switch (action.actionType) {
      TurnActionType.guessCharacter =>
        'Applied to the public match flow. Exact correctness is still owned by the existing match engine rather than this derived timeline view.',
      TurnActionType.guessTrait =>
        _traitGuessResultSummary(screenState, action),
      TurnActionType.requestHint =>
        'Applied. Private hint text stays outside the public timeline.',
      TurnActionType.surrender => _surrenderResultSummary(screenState, action),
      TurnActionType.pass =>
        'Applied. This action type should not normally appear in the current online rules.',
    };
  }

  String _traitGuessResultSummary(
    RemoteMatchScreenState screenState,
    OnlinePlayerAction action,
  ) {
    if (screenState.match.endReason == MatchEndReason.correctTraitGuess &&
        screenState.match.winnerId == action.submittedByParticipantId) {
      return 'Applied. The latest synced public match now shows a completed trait-guess win.';
    }

    return 'Applied to the public match flow. Exact correctness remains derived from the official match state, not this preview summary.';
  }

  String _surrenderResultSummary(
    RemoteMatchScreenState screenState,
    OnlinePlayerAction action,
  ) {
    if (screenState.match.endReason == MatchEndReason.surrender) {
      return 'Applied. The latest synced public match now shows a surrender result.';
    }

    return 'Applied to the public match flow.';
  }

  String? _submittedValueLabel(
    RemoteMatchScreenState screenState,
    OnlinePlayerAction action,
  ) {
    switch (action.actionType) {
      case TurnActionType.guessCharacter:
        final characterId = action.characterId;
        if (characterId == null) {
          return null;
        }

        return screenState.characterInPool(characterId)?.name ?? characterId;
      case TurnActionType.guessTrait:
        final traitId = action.traitId;
        if (traitId == null) {
          return null;
        }

        for (final category in screenState.categories) {
          if (category.id == traitId) {
            return category.label;
          }
        }

        return traitId;
      case TurnActionType.requestHint:
      case TurnActionType.surrender:
      case TurnActionType.pass:
        return null;
    }
  }

  String _rejectionReason(String? errorCode) {
    return switch (errorCode) {
      RemoteMatchActionErrorCode.matchNotInProgress =>
        'The match was no longer in progress.',
      RemoteMatchActionErrorCode.staleMatchVersion =>
        'The submitted match version was stale.',
      RemoteMatchActionErrorCode.notCurrentTurn =>
        'It was not that player\'s turn.',
      RemoteMatchActionErrorCode.userMismatch =>
        'The submitted user identity did not match the participant session.',
      RemoteMatchActionErrorCode.invalidCharacter =>
        'The chosen character was not valid for the shared pool.',
      RemoteMatchActionErrorCode.invalidTrait =>
        'The chosen trait was not valid.',
      RemoteMatchActionErrorCode.noHintsRemaining =>
        'No hints remained for that player.',
      RemoteMatchActionErrorCode.unsupportedAction =>
        'That action type is not supported by the current online rules.',
      _ => 'The action could not be applied.',
    };
  }
}
