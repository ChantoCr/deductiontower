import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/game_match.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/player.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_player_private_state.dart';

class RemoteMatchScreenState {
  const RemoteMatchScreenState({
    required this.roomCode,
    required this.match,
    required this.localPrivateState,
    required this.localSecretTrait,
    required this.categories,
    required this.characterPool,
    required this.matchVersion,
    required this.syncedAt,
    this.lastResolvedActionId,
  });

  final String roomCode;
  final GameMatch match;
  final RemotePlayerPrivateState localPrivateState;
  final TraitCategory localSecretTrait;
  final List<TraitCategory> categories;
  final List<Character> characterPool;
  final int matchVersion;
  final DateTime syncedAt;
  final String? lastResolvedActionId;

  String get localParticipantId => localPrivateState.participantId;

  Player get localPlayer =>
      match.playerOne.id == localParticipantId ? match.playerOne : match.playerTwo;

  Player get remotePlayer =>
      match.playerOne.id == localParticipantId ? match.playerTwo : match.playerOne;

  bool get isLocalPlayersTurn => match.currentPlayerId == localParticipantId;

  bool get canQueueLocalAction =>
      match.status == MatchStatus.inProgress && isLocalPlayersTurn;

  int get sharedCharacterPoolSize => characterPool.length;

  TraitCategory? traitForPlayer(Player player) {
    final secretTraitId = player.secretTraitId;
    if (secretTraitId == null) {
      return null;
    }

    for (final category in categories) {
      if (category.id == secretTraitId) {
        return category;
      }
    }

    return null;
  }

  Character? characterInPool(String characterId) {
    for (final character in characterPool) {
      if (character.id == characterId) {
        return character;
      }
    }

    return null;
  }
}
