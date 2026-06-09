import 'package:anime_deduction_tower/core/enums/player_control_type.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/player.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/game/domain/services/game_engine.dart';
import 'package:anime_deduction_tower/features/game/domain/services/trait_filter_engine.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_participant.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_session.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_bootstrap_payload.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_bootstrap_result.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_player_state.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_state.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_player_bootstrap_seed.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_player_private_state.dart';

class RemoteMatchBootstrapService {
  const RemoteMatchBootstrapService({
    this.gameEngine = const GameEngine(),
    this.traitFilterEngine = const TraitFilterEngine(),
  });

  final GameEngine gameEngine;
  final TraitFilterEngine traitFilterEngine;

  RemoteMatchBootstrapResult build({
    required OnlineRoomSession room,
    required int hintsPerPlayer,
    required List<RemotePlayerBootstrapSeed> playerSeeds,
    required List<TraitCategory> categories,
    required List<Character> characters,
    String? matchId,
    String? startingParticipantId,
    DateTime? createdAt,
  }) {
    if (!room.hasGuest) {
      throw StateError('A remote match requires both a host and a guest participant.');
    }

    if (!room.isEveryoneReady || room.phase != OnlineRoomPhase.readyToSync) {
      throw StateError('Only ready-to-sync rooms can bootstrap a remote match.');
    }

    if (hintsPerPlayer < 0) {
      throw StateError('Hints per player cannot be negative.');
    }

    final host = room.hostParticipant;
    final guest = room.guestParticipant;
    if (host == null || guest == null) {
      throw StateError('Host and guest participants must both exist before bootstrapping.');
    }

    final hostSeed = _findSeed(playerSeeds, host.id);
    final guestSeed = _findSeed(playerSeeds, guest.id);
    final hostTrait = _findTraitById(categories, hostSeed.secretTraitId);
    final guestTrait = _findTraitById(categories, guestSeed.secretTraitId);

    final hostValidCharacters = traitFilterEngine.filterCharactersByTrait(
      characters,
      hostTrait,
    );
    final guestValidCharacters = traitFilterEngine.filterCharactersByTrait(
      characters,
      guestTrait,
    );

    final sharedCharacterPoolIds = <String>{
      ...hostValidCharacters.map((character) => character.id),
      ...guestValidCharacters.map((character) => character.id),
    }.toList();

    if (sharedCharacterPoolIds.isEmpty) {
      throw StateError('A remote match cannot start without a shared character pool.');
    }

    final resolvedStartingParticipantId = startingParticipantId ?? host.id;
    if (resolvedStartingParticipantId != host.id &&
        resolvedStartingParticipantId != guest.id) {
      throw StateError('Starting participant must belong to the ready room.');
    }

    final createdAtValue = createdAt ?? DateTime.now();

    final initialMatch = gameEngine.createMatch(
      playerOne: _buildPlayer(
        participant: host,
        secretTraitId: hostTrait.id,
        validCharacterIds: hostValidCharacters.map((character) => character.id).toList(),
        hintsPerPlayer: hintsPerPlayer,
      ),
      playerTwo: _buildPlayer(
        participant: guest,
        secretTraitId: guestTrait.id,
        validCharacterIds: guestValidCharacters.map((character) => character.id).toList(),
        hintsPerPlayer: hintsPerPlayer,
      ),
      characterPoolIds: sharedCharacterPoolIds,
      matchId: matchId,
      startingPlayerId: resolvedStartingParticipantId,
    );

    final payload = RemoteMatchBootstrapPayload(
      roomCode: room.roomCode,
      matchId: initialMatch.id,
      hostParticipantId: host.id,
      guestParticipantId: guest.id,
      startingParticipantId: initialMatch.currentPlayerId,
      hostPlayerName: host.displayName,
      guestPlayerName: guest.displayName,
      hintsPerPlayer: hintsPerPlayer,
      hostSecretTraitId: hostTrait.id,
      guestSecretTraitId: guestTrait.id,
      sharedCharacterPoolIds: initialMatch.characterPoolIds,
      createdAt: createdAtValue,
    );

    final publicState = RemoteMatchPublicState(
      matchId: initialMatch.id,
      roomCode: room.roomCode,
      status: initialMatch.status,
      currentTurnParticipantId: initialMatch.currentPlayerId,
      turnNumber: initialMatch.turns.length,
      sharedCharacterPoolIds: initialMatch.characterPoolIds,
      playerStates: [
        RemoteMatchPublicPlayerState(
          participantId: initialMatch.playerOne.id,
          displayName: initialMatch.playerOne.name,
          hintsRemaining: initialMatch.playerOne.hintsRemaining,
          characterGuessCount: 0,
          traitGuessCount: 0,
        ),
        RemoteMatchPublicPlayerState(
          participantId: initialMatch.playerTwo.id,
          displayName: initialMatch.playerTwo.name,
          hintsRemaining: initialMatch.playerTwo.hintsRemaining,
          characterGuessCount: 0,
          traitGuessCount: 0,
        ),
      ],
      matchVersion: 0,
      createdAt: createdAtValue,
      updatedAt: createdAtValue,
    );

    final privatePlayerStates = [
      _buildPrivateState(
        seed: hostSeed,
        createdAt: createdAtValue,
      ),
      _buildPrivateState(
        seed: guestSeed,
        createdAt: createdAtValue,
      ),
    ];

    return RemoteMatchBootstrapResult(
      payload: payload,
      publicState: publicState,
      privatePlayerStates: privatePlayerStates,
    );
  }

  Player _buildPlayer({
    required OnlineRoomParticipant participant,
    required String secretTraitId,
    required List<String> validCharacterIds,
    required int hintsPerPlayer,
  }) {
    return Player(
      id: participant.id,
      name: participant.displayName,
      secretTraitId: secretTraitId,
      validCharacterIds: validCharacterIds,
      hintsRemaining: hintsPerPlayer,
      controlType: PlayerControlType.human,
    );
  }

  RemotePlayerPrivateState _buildPrivateState({
    required RemotePlayerBootstrapSeed seed,
    required DateTime createdAt,
  }) {
    return RemotePlayerPrivateState(
      participantId: seed.participantId,
      userId: seed.userId,
      secretTraitId: seed.secretTraitId,
      secretTraitLocked: true,
      hasViewedSecret: seed.hasViewedSecret,
      hintsUsed: 0,
      selectedAt: createdAt,
      updatedAt: createdAt,
    );
  }

  RemotePlayerBootstrapSeed _findSeed(
    List<RemotePlayerBootstrapSeed> playerSeeds,
    String participantId,
  ) {
    for (final playerSeed in playerSeeds) {
      if (playerSeed.participantId == participantId) {
        if (!playerSeed.isComplete) {
          throw StateError(
            'Participant $participantId is missing required bootstrap secret data.',
          );
        }
        return playerSeed;
      }
    }

    throw StateError(
      'Participant $participantId is missing a bootstrap seed.',
    );
  }

  TraitCategory _findTraitById(
    List<TraitCategory> categories,
    String traitId,
  ) {
    for (final category in categories) {
      if (category.id == traitId) {
        return category;
      }
    }

    throw StateError('Trait category $traitId was not found.');
  }
}
