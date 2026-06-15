import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/game_match.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/player.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/game/domain/services/trait_filter_engine.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_bootstrap_payload.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_handoff_snapshot.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_player_state.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_screen_state.dart';

class RemoteMatchScreenStateLoader {
  const RemoteMatchScreenStateLoader({
    this.traitFilterEngine = const TraitFilterEngine(),
  });

  final TraitFilterEngine traitFilterEngine;

  RemoteMatchScreenState load({
    required RemoteMatchHandoffSnapshot handoff,
    required List<TraitCategory> categories,
    required List<Character> characters,
  }) {
    if (!handoff.isComplete) {
      throw StateError(
        'Remote match screen state requires complete bootstrap, public, and private docs.',
      );
    }

    final payload = handoff.bootstrapPayload!;
    final publicState = handoff.publicState!;
    final privateState = handoff.privateState!;

    if (payload.roomCode != handoff.roomCode ||
        publicState.roomCode != handoff.roomCode) {
      throw StateError('Room-code mismatch detected while loading remote match state.');
    }

    if (payload.matchId != publicState.matchId) {
      throw StateError('Bootstrap and public match ids do not align.');
    }

    if (privateState.participantId != handoff.localParticipantId) {
      throw StateError('Local private state does not belong to the requested participant.');
    }

    if (!_sameIds(
      payload.sharedCharacterPoolIds,
      publicState.sharedCharacterPoolIds,
    )) {
      throw StateError('Bootstrap and public shared character pools do not align.');
    }

    final hostPublicState = _findPublicPlayerState(
      publicState.playerStates,
      payload.hostParticipantId,
    );
    final guestPublicState = _findPublicPlayerState(
      publicState.playerStates,
      payload.guestParticipantId,
    );

    final hostTrait = _findTraitById(categories, payload.hostSecretTraitId);
    final guestTrait = _findTraitById(categories, payload.guestSecretTraitId);
    final localTraitId = _traitIdForParticipant(
      payload: payload,
      participantId: handoff.localParticipantId,
    );

    if (localTraitId != privateState.secretTraitId) {
      throw StateError('Local private secret does not align with the bootstrap payload.');
    }

    final hostValidCharacterIds = traitFilterEngine
        .filterCharactersByTrait(characters, hostTrait)
        .map((character) => character.id)
        .toList(growable: false);
    final guestValidCharacterIds = traitFilterEngine
        .filterCharactersByTrait(characters, guestTrait)
        .map((character) => character.id)
        .toList(growable: false);
    final characterPool = _resolveCharacterPool(
      poolIds: publicState.sharedCharacterPoolIds,
      characters: characters,
    );

    final match = GameMatch(
      id: publicState.matchId,
      playerOne: _buildPlayer(
        publicState: hostPublicState,
        secretTraitId: payload.hostSecretTraitId,
        validCharacterIds: hostValidCharacterIds,
      ),
      playerTwo: _buildPlayer(
        publicState: guestPublicState,
        secretTraitId: payload.guestSecretTraitId,
        validCharacterIds: guestValidCharacterIds,
      ),
      currentPlayerId: publicState.currentTurnParticipantId,
      turns: const [],
      status: publicState.status,
      characterPoolIds: publicState.sharedCharacterPoolIds,
      winnerId: publicState.winnerParticipantId,
      endReason: publicState.endReason,
    );

    return RemoteMatchScreenState(
      roomCode: handoff.roomCode,
      match: match,
      localPrivateState: privateState,
      localSecretTrait: _findTraitById(categories, localTraitId),
      categories: categories,
      characterPool: characterPool,
      matchVersion: publicState.matchVersion,
      syncedAt: publicState.updatedAt,
      lastResolvedActionId: publicState.lastResolvedActionId,
    );
  }

  Player _buildPlayer({
    required RemoteMatchPublicPlayerState publicState,
    required String secretTraitId,
    required List<String> validCharacterIds,
  }) {
    return Player(
      id: publicState.participantId,
      name: publicState.displayName,
      secretTraitId: secretTraitId,
      validCharacterIds: validCharacterIds,
      hintsRemaining: publicState.hintsRemaining,
    );
  }

  RemoteMatchPublicPlayerState _findPublicPlayerState(
    List<RemoteMatchPublicPlayerState> playerStates,
    String participantId,
  ) {
    for (final playerState in playerStates) {
      if (playerState.participantId == participantId) {
        return playerState;
      }
    }

    throw StateError('Public player state for participant $participantId was not found.');
  }

  TraitCategory _findTraitById(List<TraitCategory> categories, String traitId) {
    for (final category in categories) {
      if (category.id == traitId) {
        return category;
      }
    }

    throw StateError('Trait category $traitId was not found.');
  }

  String _traitIdForParticipant({
    required RemoteMatchBootstrapPayload payload,
    required String participantId,
  }) {
    if (participantId == payload.hostParticipantId) {
      return payload.hostSecretTraitId;
    }

    if (participantId == payload.guestParticipantId) {
      return payload.guestSecretTraitId;
    }

    throw StateError('Participant $participantId does not belong to the bootstrap payload.');
  }

  List<Character> _resolveCharacterPool({
    required List<String> poolIds,
    required List<Character> characters,
  }) {
    final pool = <Character>[];

    for (final characterId in poolIds) {
      Character? resolvedCharacter;
      for (final character in characters) {
        if (character.id == characterId) {
          resolvedCharacter = character;
          break;
        }
      }

      if (resolvedCharacter == null) {
        throw StateError(
          'Character $characterId from the remote shared pool was not found locally.',
        );
      }

      pool.add(resolvedCharacter);
    }

    return pool;
  }

  bool _sameIds(List<String> left, List<String> right) {
    if (left.length != right.length) {
      return false;
    }

    final leftSet = left.toSet();
    final rightSet = right.toSet();
    if (leftSet.length != rightSet.length) {
      return false;
    }

    for (final value in leftSet) {
      if (!rightSet.contains(value)) {
        return false;
      }
    }

    return true;
  }
}
