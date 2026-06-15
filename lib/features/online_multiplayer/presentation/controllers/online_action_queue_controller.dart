import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_player_action.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_screen_state.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/repositories/online_room_repository.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/services/remote_match_action_factory.dart';

class OnlineActionQueueController {
  const OnlineActionQueueController({
    required OnlineRoomRepository repository,
    required RemoteMatchActionFactory actionFactory,
  })  : _repository = repository,
        _actionFactory = actionFactory;

  final OnlineRoomRepository _repository;
  final RemoteMatchActionFactory _actionFactory;

  Future<OnlinePlayerAction> queueHintRequest(
    RemoteMatchScreenState screenState,
  ) {
    final action = _actionFactory.buildHintRequestAction(
      screenState: screenState,
    );
    return _repository.submitPlayerAction(
      roomCode: screenState.roomCode,
      action: action,
    );
  }

  Future<OnlinePlayerAction> queueSurrender(
    RemoteMatchScreenState screenState,
  ) {
    final action = _actionFactory.buildSurrenderAction(
      screenState: screenState,
    );
    return _repository.submitPlayerAction(
      roomCode: screenState.roomCode,
      action: action,
    );
  }

  Future<OnlinePlayerAction> queueCharacterGuess({
    required RemoteMatchScreenState screenState,
    required String characterId,
  }) {
    final action = _actionFactory.buildCharacterGuessAction(
      screenState: screenState,
      characterId: characterId,
    );
    return _repository.submitPlayerAction(
      roomCode: screenState.roomCode,
      action: action,
    );
  }

  Future<OnlinePlayerAction> queueTraitGuess({
    required RemoteMatchScreenState screenState,
    required String traitId,
  }) {
    final action = _actionFactory.buildTraitGuessAction(
      screenState: screenState,
      traitId: traitId,
    );
    return _repository.submitPlayerAction(
      roomCode: screenState.roomCode,
      action: action,
    );
  }
}
