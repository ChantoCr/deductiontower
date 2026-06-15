import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';
import 'package:anime_deduction_tower/core/utils/id_generator.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_player_action.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_screen_state.dart';

class RemoteMatchActionFactory {
  const RemoteMatchActionFactory();

  OnlinePlayerAction buildCharacterGuessAction({
    required RemoteMatchScreenState screenState,
    required String characterId,
    String? actionId,
    DateTime? createdAt,
  }) {
    _validateCanQueue(screenState);
    final character = screenState.characterInPool(characterId);
    if (character == null) {
      throw StateError(
        'Character $characterId is not part of the shared remote pool.',
      );
    }

    return _buildBaseAction(
      screenState: screenState,
      actionType: TurnActionType.guessCharacter,
      actionId: actionId,
      createdAt: createdAt,
      characterId: character.id,
    );
  }

  OnlinePlayerAction buildTraitGuessAction({
    required RemoteMatchScreenState screenState,
    required String traitId,
    String? actionId,
    DateTime? createdAt,
  }) {
    _validateCanQueue(screenState);
    _findTrait(screenState.categories, traitId);

    return _buildBaseAction(
      screenState: screenState,
      actionType: TurnActionType.guessTrait,
      actionId: actionId,
      createdAt: createdAt,
      traitId: traitId,
    );
  }

  OnlinePlayerAction buildHintRequestAction({
    required RemoteMatchScreenState screenState,
    String? actionId,
    DateTime? createdAt,
  }) {
    _validateCanQueue(screenState);
    if (screenState.localPlayer.hintsRemaining <= 0) {
      throw StateError('The local player has no remote hints remaining.');
    }

    return _buildBaseAction(
      screenState: screenState,
      actionType: TurnActionType.requestHint,
      actionId: actionId,
      createdAt: createdAt,
    );
  }

  OnlinePlayerAction buildSurrenderAction({
    required RemoteMatchScreenState screenState,
    String? actionId,
    DateTime? createdAt,
  }) {
    _validateCanQueue(screenState);

    return _buildBaseAction(
      screenState: screenState,
      actionType: TurnActionType.surrender,
      actionId: actionId,
      createdAt: createdAt,
    );
  }

  OnlinePlayerAction _buildBaseAction({
    required RemoteMatchScreenState screenState,
    required TurnActionType actionType,
    String? actionId,
    DateTime? createdAt,
    String? characterId,
    String? traitId,
  }) {
    return OnlinePlayerAction(
      actionId: actionId ?? IdGenerator.next('online_action'),
      submittedByParticipantId: screenState.localParticipantId,
      submittedByUserId: screenState.localPrivateState.userId,
      actionType: actionType,
      characterId: characterId,
      traitId: traitId,
      expectedMatchVersion: screenState.matchVersion,
      createdAt: createdAt ?? DateTime.now().toUtc(),
    );
  }

  void _validateCanQueue(RemoteMatchScreenState screenState) {
    if (!screenState.canQueueLocalAction) {
      throw StateError(
        'Remote actions can only be queued while the match is active and it is the local player\'s turn.',
      );
    }
  }

  TraitCategory _findTrait(List<TraitCategory> categories, String traitId) {
    for (final category in categories) {
      if (category.id == traitId) {
        return category;
      }
    }

    throw StateError('Trait category $traitId was not found.');
  }
}
