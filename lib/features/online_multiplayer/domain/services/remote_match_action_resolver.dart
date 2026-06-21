import 'package:anime_deduction_tower/core/enums/match_end_reason.dart';
import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/core/enums/online_player_action_status.dart';
import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/game_match.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/player.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/game/domain/services/game_engine.dart';
import 'package:anime_deduction_tower/features/game/domain/services/hint_engine.dart';
import 'package:anime_deduction_tower/features/game/domain/services/trait_filter_engine.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_action_resolution_authority.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_player_action.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_action_error_code.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_action_resolution.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_bootstrap_payload.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_event.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_player_state.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_state.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_player_private_state.dart';

class RemoteMatchActionResolver {
  const RemoteMatchActionResolver({
    this.gameEngine = const GameEngine(),
    this.hintEngine = const HintEngine(),
    this.traitFilterEngine = const TraitFilterEngine(),
  });

  final GameEngine gameEngine;
  final HintEngine hintEngine;
  final TraitFilterEngine traitFilterEngine;

  RemoteMatchActionResolution resolve({
    required RemoteMatchBootstrapPayload payload,
    required RemoteMatchPublicState publicState,
    required RemotePlayerPrivateState privateState,
    required OnlinePlayerAction action,
    required List<TraitCategory> categories,
    required List<Character> characters,
    required String resolvedByParticipantId,
    required String resolvedByUserId,
    required OnlineActionResolutionAuthority resolutionSource,
    DateTime? resolvedAt,
  }) {
    if (!action.isPending) {
      throw StateError('Only pending online player actions can be resolved.');
    }

    if (payload.roomCode != publicState.roomCode ||
        payload.matchId != publicState.matchId) {
      throw StateError(
        'Bootstrap payload and public state do not describe the same match.',
      );
    }

    if (privateState.participantId != action.submittedByParticipantId) {
      throw StateError(
        'The supplied private state does not belong to the action participant.',
      );
    }

    final resolvedAtValue = resolvedAt ?? DateTime.now().toUtc();

    if (publicState.status != MatchStatus.inProgress) {
      return _reject(
        payload: payload,
        publicState: publicState,
        action: action,
        categories: categories,
        characters: characters,
        errorCode: RemoteMatchActionErrorCode.matchNotInProgress,
        resolvedByParticipantId: resolvedByParticipantId,
        resolvedByUserId: resolvedByUserId,
        resolutionSource: resolutionSource,
        resolvedAt: resolvedAtValue,
      );
    }

    if (action.expectedMatchVersion != publicState.matchVersion) {
      return _reject(
        payload: payload,
        publicState: publicState,
        action: action,
        categories: categories,
        characters: characters,
        errorCode: RemoteMatchActionErrorCode.staleMatchVersion,
        resolvedByParticipantId: resolvedByParticipantId,
        resolvedByUserId: resolvedByUserId,
        resolutionSource: resolutionSource,
        resolvedAt: resolvedAtValue,
      );
    }

    if (publicState.currentTurnParticipantId !=
        action.submittedByParticipantId) {
      return _reject(
        payload: payload,
        publicState: publicState,
        action: action,
        categories: categories,
        characters: characters,
        errorCode: RemoteMatchActionErrorCode.notCurrentTurn,
        resolvedByParticipantId: resolvedByParticipantId,
        resolvedByUserId: resolvedByUserId,
        resolutionSource: resolutionSource,
        resolvedAt: resolvedAtValue,
      );
    }

    if (privateState.userId != action.submittedByUserId) {
      return _reject(
        payload: payload,
        publicState: publicState,
        action: action,
        categories: categories,
        characters: characters,
        errorCode: RemoteMatchActionErrorCode.userMismatch,
        resolvedByParticipantId: resolvedByParticipantId,
        resolvedByUserId: resolvedByUserId,
        resolutionSource: resolutionSource,
        resolvedAt: resolvedAtValue,
      );
    }

    final hostPublicState = _requirePlayerState(
      publicState,
      payload.hostParticipantId,
    );
    final guestPublicState = _requirePlayerState(
      publicState,
      payload.guestParticipantId,
    );
    final hostTrait = _findTraitById(categories, payload.hostSecretTraitId);
    final guestTrait = _findTraitById(categories, payload.guestSecretTraitId);
    final actingParticipantId = action.submittedByParticipantId;
    final opponentTrait = actingParticipantId == payload.hostParticipantId
        ? guestTrait
        : hostTrait;

    final match = _buildMatch(
      payload: payload,
      publicState: publicState,
      hostPublicState: hostPublicState,
      guestPublicState: guestPublicState,
      hostTrait: hostTrait,
      guestTrait: guestTrait,
      characters: characters,
    );

    switch (action.actionType) {
      case TurnActionType.guessCharacter:
        final character = _findSharedPoolCharacter(
          publicState: publicState,
          characters: characters,
          characterId: action.characterId,
        );
        if (character == null) {
          return _reject(
            payload: payload,
            publicState: publicState,
            action: action,
            categories: categories,
            characters: characters,
            errorCode: RemoteMatchActionErrorCode.invalidCharacter,
            resolvedByParticipantId: resolvedByParticipantId,
            resolvedByUserId: resolvedByUserId,
            resolutionSource: resolutionSource,
            resolvedAt: resolvedAtValue,
          );
        }

        final updatedMatch = gameEngine.resolveCharacterGuess(
          match: match,
          guessedCharacter: character,
          opponentSecretTrait: opponentTrait,
          createdAt: action.createdAt,
        );

        return _apply(
          payload: payload,
          previousPublicState: publicState,
          updatedMatch: updatedMatch,
          action: action,
          categories: categories,
          characters: characters,
          resolvedAt: resolvedAtValue,
          characterGuessParticipantId: actingParticipantId,
          resolvedByParticipantId: resolvedByParticipantId,
          resolvedByUserId: resolvedByUserId,
          resolutionSource: resolutionSource,
        );
      case TurnActionType.guessTrait:
        final guessedTraitId = action.traitId;
        if (guessedTraitId == null || !_hasTrait(categories, guessedTraitId)) {
          return _reject(
            payload: payload,
            publicState: publicState,
            action: action,
            categories: categories,
            characters: characters,
            errorCode: RemoteMatchActionErrorCode.invalidTrait,
            resolvedByParticipantId: resolvedByParticipantId,
            resolvedByUserId: resolvedByUserId,
            resolutionSource: resolutionSource,
            resolvedAt: resolvedAtValue,
          );
        }

        final updatedMatch = gameEngine.resolveTraitGuess(
          match: match,
          guessedTraitId: guessedTraitId,
          opponentSecretTrait: opponentTrait,
          createdAt: action.createdAt,
        );

        return _apply(
          payload: payload,
          previousPublicState: publicState,
          updatedMatch: updatedMatch,
          action: action,
          categories: categories,
          characters: characters,
          resolvedAt: resolvedAtValue,
          traitGuessParticipantId: actingParticipantId,
          resolvedByParticipantId: resolvedByParticipantId,
          resolvedByUserId: resolvedByUserId,
          resolutionSource: resolutionSource,
        );
      case TurnActionType.requestHint:
        final actingPublicState = _requirePlayerState(
          publicState,
          actingParticipantId,
        );
        if (actingPublicState.hintsRemaining <= 0) {
          return _reject(
            payload: payload,
            publicState: publicState,
            action: action,
            categories: categories,
            characters: characters,
            errorCode: RemoteMatchActionErrorCode.noHintsRemaining,
            resolvedByParticipantId: resolvedByParticipantId,
            resolvedByUserId: resolvedByUserId,
            resolutionSource: resolutionSource,
            resolvedAt: resolvedAtValue,
          );
        }

        final hintText = hintEngine.generateHint(opponentTrait);
        final updatedMatch = gameEngine.resolveHintRequest(
          match: match,
          hintMessage: hintText,
          createdAt: action.createdAt,
        );
        final updatedPrivateState = privateState.copyWith(
          hintsUsed: privateState.hintsUsed + 1,
          lastPrivateHintText: hintText,
          updatedAt: resolvedAtValue,
        );

        return _apply(
          payload: payload,
          previousPublicState: publicState,
          updatedMatch: updatedMatch,
          action: action,
          categories: categories,
          characters: characters,
          resolvedAt: resolvedAtValue,
          affectedPrivateState: updatedPrivateState,
          resolvedByParticipantId: resolvedByParticipantId,
          resolvedByUserId: resolvedByUserId,
          resolutionSource: resolutionSource,
        );
      case TurnActionType.surrender:
        final updatedMatch = gameEngine.surrenderMatch(
          match: match,
          surrenderingPlayerId: actingParticipantId,
          createdAt: action.createdAt,
        );

        return _apply(
          payload: payload,
          previousPublicState: publicState,
          updatedMatch: updatedMatch,
          action: action,
          categories: categories,
          characters: characters,
          resolvedAt: resolvedAtValue,
          resolvedByParticipantId: resolvedByParticipantId,
          resolvedByUserId: resolvedByUserId,
          resolutionSource: resolutionSource,
        );
      case TurnActionType.pass:
        return _reject(
          payload: payload,
          publicState: publicState,
          action: action,
          categories: categories,
          characters: characters,
          errorCode: RemoteMatchActionErrorCode.unsupportedAction,
          resolvedByParticipantId: resolvedByParticipantId,
          resolvedByUserId: resolvedByUserId,
          resolutionSource: resolutionSource,
          resolvedAt: resolvedAtValue,
        );
    }
  }

  GameMatch _buildMatch({
    required RemoteMatchBootstrapPayload payload,
    required RemoteMatchPublicState publicState,
    required RemoteMatchPublicPlayerState hostPublicState,
    required RemoteMatchPublicPlayerState guestPublicState,
    required TraitCategory hostTrait,
    required TraitCategory guestTrait,
    required List<Character> characters,
  }) {
    final hostValidCharacterIds = traitFilterEngine
        .filterCharactersByTrait(characters, hostTrait)
        .map((character) => character.id)
        .toList(growable: false);
    final guestValidCharacterIds = traitFilterEngine
        .filterCharactersByTrait(characters, guestTrait)
        .map((character) => character.id)
        .toList(growable: false);

    return GameMatch(
      id: publicState.matchId,
      playerOne: Player(
        id: payload.hostParticipantId,
        name: hostPublicState.displayName,
        secretTraitId: payload.hostSecretTraitId,
        validCharacterIds: hostValidCharacterIds,
        hintsRemaining: hostPublicState.hintsRemaining,
      ),
      playerTwo: Player(
        id: payload.guestParticipantId,
        name: guestPublicState.displayName,
        secretTraitId: payload.guestSecretTraitId,
        validCharacterIds: guestValidCharacterIds,
        hintsRemaining: guestPublicState.hintsRemaining,
      ),
      currentPlayerId: publicState.currentTurnParticipantId,
      turns: const [],
      status: publicState.status,
      characterPoolIds: publicState.sharedCharacterPoolIds,
      winnerId: publicState.winnerParticipantId,
      endReason: publicState.endReason,
    );
  }

  RemoteMatchActionResolution _apply({
    required RemoteMatchBootstrapPayload payload,
    required RemoteMatchPublicState previousPublicState,
    required GameMatch updatedMatch,
    required OnlinePlayerAction action,
    required List<TraitCategory> categories,
    required List<Character> characters,
    required DateTime resolvedAt,
    required String resolvedByParticipantId,
    required String resolvedByUserId,
    required OnlineActionResolutionAuthority resolutionSource,
    RemotePlayerPrivateState? affectedPrivateState,
    String? characterGuessParticipantId,
    String? traitGuessParticipantId,
  }) {
    final updatedPublicState = previousPublicState.copyWith(
      status: updatedMatch.status,
      currentTurnParticipantId: updatedMatch.currentPlayerId,
      turnNumber: previousPublicState.turnNumber + 1,
      playerStates: previousPublicState.playerStates.map((playerState) {
        final updatedPlayer =
            playerState.participantId == updatedMatch.playerOne.id
                ? updatedMatch.playerOne
                : updatedMatch.playerTwo;
        final isCharacterActor =
            playerState.participantId == characterGuessParticipantId;
        final isTraitActor =
            playerState.participantId == traitGuessParticipantId;

        return playerState.copyWith(
          hintsRemaining: updatedPlayer.hintsRemaining,
          characterGuessCount:
              playerState.characterGuessCount + (isCharacterActor ? 1 : 0),
          traitGuessCount: playerState.traitGuessCount + (isTraitActor ? 1 : 0),
        );
      }).toList(growable: false),
      winnerParticipantId: updatedMatch.winnerId,
      endReason: updatedMatch.endReason,
      lastResolvedActionId: action.actionId,
      matchVersion: previousPublicState.matchVersion + 1,
      updatedAt: resolvedAt,
    );

    final resolvedAction = action.copyWith(
      status: OnlinePlayerActionStatus.applied,
      resolvedByParticipantId: resolvedByParticipantId,
      resolvedByUserId: resolvedByUserId,
      resolutionSource: resolutionSource,
      resolvedAt: resolvedAt,
      clearErrorCode: true,
    );

    return RemoteMatchActionResolution(
      baseMatchVersion: previousPublicState.matchVersion,
      publicState: updatedPublicState,
      resolvedAction: resolvedAction,
      publicEvent: _buildPublicEvent(
        payload: payload,
        publicState: updatedPublicState,
        resolvedAction: resolvedAction,
        categories: categories,
        characters: characters,
        updatedMatch: updatedMatch,
      ),
      affectedPrivateState: affectedPrivateState,
    );
  }

  RemoteMatchActionResolution _reject({
    required RemoteMatchBootstrapPayload payload,
    required RemoteMatchPublicState publicState,
    required OnlinePlayerAction action,
    required List<TraitCategory> categories,
    required List<Character> characters,
    required String errorCode,
    required String resolvedByParticipantId,
    required String resolvedByUserId,
    required OnlineActionResolutionAuthority resolutionSource,
    required DateTime resolvedAt,
  }) {
    final updatedPublicState = publicState.copyWith(
      lastResolvedActionId: action.actionId,
      updatedAt: resolvedAt,
    );
    final resolvedAction = action.copyWith(
      status: OnlinePlayerActionStatus.rejected,
      errorCode: errorCode,
      resolvedByParticipantId: resolvedByParticipantId,
      resolvedByUserId: resolvedByUserId,
      resolutionSource: resolutionSource,
      resolvedAt: resolvedAt,
    );

    return RemoteMatchActionResolution(
      baseMatchVersion: publicState.matchVersion,
      publicState: updatedPublicState,
      resolvedAction: resolvedAction,
      publicEvent: _buildPublicEvent(
        payload: payload,
        publicState: updatedPublicState,
        resolvedAction: resolvedAction,
        categories: categories,
        characters: characters,
      ),
    );
  }

  RemoteMatchPublicEvent _buildPublicEvent({
    required RemoteMatchBootstrapPayload payload,
    required RemoteMatchPublicState publicState,
    required OnlinePlayerAction resolvedAction,
    required List<TraitCategory> categories,
    required List<Character> characters,
    GameMatch? updatedMatch,
  }) {
    final participantName = _participantName(
      publicState: publicState,
      payload: payload,
      participantId: resolvedAction.submittedByParticipantId,
    );
    final submittedValueLabel = _submittedValueLabel(
      action: resolvedAction,
      categories: categories,
      characters: characters,
    );

    return RemoteMatchPublicEvent(
      eventId: resolvedAction.actionId,
      roomCode: payload.roomCode,
      matchId: payload.matchId,
      actionId: resolvedAction.actionId,
      participantId: resolvedAction.submittedByParticipantId,
      participantName: participantName,
      actionType: resolvedAction.actionType,
      status: resolvedAction.status,
      shortLabel: _shortLabel(
        resolvedAction: resolvedAction,
        updatedMatch: updatedMatch,
      ),
      actionSummary: _actionSummary(
        participantName: participantName,
        resolvedAction: resolvedAction,
        submittedValueLabel: submittedValueLabel,
      ),
      resultSummary: _resultSummary(
        resolvedAction: resolvedAction,
        updatedMatch: updatedMatch,
      ),
      submittedValueLabel: submittedValueLabel,
      resultingMatchVersion: publicState.matchVersion,
      createdAt: resolvedAction.createdAt,
      publishedAt: resolvedAction.resolvedAt ?? resolvedAction.createdAt,
      resolutionSource: resolvedAction.resolutionSource,
    );
  }

  String _participantName({
    required RemoteMatchPublicState publicState,
    required RemoteMatchBootstrapPayload payload,
    required String participantId,
  }) {
    final playerState = publicState.playerStateFor(participantId);
    if (playerState != null) {
      return playerState.displayName;
    }

    if (participantId == payload.hostParticipantId) {
      return payload.hostPlayerName;
    }

    if (participantId == payload.guestParticipantId) {
      return payload.guestPlayerName;
    }

    return participantId;
  }

  String _shortLabel({
    required OnlinePlayerAction resolvedAction,
    required GameMatch? updatedMatch,
  }) {
    if (resolvedAction.status == OnlinePlayerActionStatus.rejected) {
      return switch (resolvedAction.actionType) {
        TurnActionType.guessCharacter => 'Rejected character guess',
        TurnActionType.guessTrait => 'Rejected trait guess',
        TurnActionType.requestHint => 'Rejected hint request',
        TurnActionType.surrender => 'Rejected surrender',
        TurnActionType.pass => 'Rejected pass action',
      };
    }

    final latestTurn = updatedMatch?.turns.isNotEmpty == true
        ? updatedMatch!.turns.last
        : null;

    return switch (resolvedAction.actionType) {
      TurnActionType.guessCharacter => latestTurn?.wasCorrect == true
          ? 'Correct character guess'
          : 'Incorrect character guess',
      TurnActionType.guessTrait => latestTurn?.wasCorrect == true
          ? 'Correct trait guess'
          : 'Incorrect trait guess',
      TurnActionType.requestHint => 'Private hint granted',
      TurnActionType.surrender => 'Surrender resolved',
      TurnActionType.pass => 'Unsupported pass action',
    };
  }

  String _actionSummary({
    required String participantName,
    required OnlinePlayerAction resolvedAction,
    required String? submittedValueLabel,
  }) {
    return switch (resolvedAction.actionType) {
      TurnActionType.guessCharacter =>
        '$participantName guessed ${submittedValueLabel ?? 'an unknown character'}.',
      TurnActionType.guessTrait =>
        '$participantName guessed the trait ${submittedValueLabel ?? 'unknown trait'}.',
      TurnActionType.requestHint =>
        '$participantName requested a private hint.',
      TurnActionType.surrender => '$participantName surrendered the match.',
      TurnActionType.pass =>
        '$participantName submitted an unsupported pass action.',
    };
  }

  String _resultSummary({
    required OnlinePlayerAction resolvedAction,
    required GameMatch? updatedMatch,
  }) {
    if (resolvedAction.status == OnlinePlayerActionStatus.rejected) {
      return 'Rejected. ${_rejectionReason(resolvedAction.errorCode)}';
    }

    final latestTurn = updatedMatch?.turns.isNotEmpty == true
        ? updatedMatch!.turns.last
        : null;

    return switch (resolvedAction.actionType) {
      TurnActionType.guessCharacter => latestTurn?.wasCorrect == true
          ? 'Correct character guess. Turn passed to the opponent.'
          : 'Incorrect character guess. Turn passed to the opponent.',
      TurnActionType.guessTrait => latestTurn?.wasCorrect == true
          ? 'Correct trait guess. Match ended immediately.'
          : 'Incorrect trait guess. Turn passed to the opponent.',
      TurnActionType.requestHint =>
        'Private hint delivered. The exact hint text stays outside public event docs.',
      TurnActionType.surrender =>
        updatedMatch?.endReason == MatchEndReason.surrender
            ? 'Match ended by surrender.'
            : 'Surrender was applied to the public match flow.',
      TurnActionType.pass =>
        'This action type is not supported by the current online rules.',
    };
  }

  String? _submittedValueLabel({
    required OnlinePlayerAction action,
    required List<TraitCategory> categories,
    required List<Character> characters,
  }) {
    switch (action.actionType) {
      case TurnActionType.guessCharacter:
        final characterId = action.characterId;
        if (characterId == null) {
          return null;
        }

        for (final character in characters) {
          if (character.id == characterId) {
            return character.name;
          }
        }

        return characterId;
      case TurnActionType.guessTrait:
        final traitId = action.traitId;
        if (traitId == null) {
          return null;
        }

        for (final category in categories) {
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

  RemoteMatchPublicPlayerState _requirePlayerState(
    RemoteMatchPublicState publicState,
    String participantId,
  ) {
    final playerState = publicState.playerStateFor(participantId);
    if (playerState == null) {
      throw StateError(
        'Public player state for participant $participantId was not found.',
      );
    }

    return playerState;
  }

  TraitCategory _findTraitById(List<TraitCategory> categories, String traitId) {
    for (final category in categories) {
      if (category.id == traitId) {
        return category;
      }
    }

    throw StateError('Trait category $traitId was not found.');
  }

  bool _hasTrait(List<TraitCategory> categories, String traitId) {
    for (final category in categories) {
      if (category.id == traitId) {
        return true;
      }
    }

    return false;
  }

  Character? _findSharedPoolCharacter({
    required RemoteMatchPublicState publicState,
    required List<Character> characters,
    required String? characterId,
  }) {
    if (characterId == null ||
        !publicState.sharedCharacterPoolIds.contains(characterId)) {
      return null;
    }

    for (final character in characters) {
      if (character.id == characterId) {
        return character;
      }
    }

    return null;
  }
}
