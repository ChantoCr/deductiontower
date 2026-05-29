import 'package:anime_deduction_tower/core/enums/player_control_type.dart';
import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';
import 'package:anime_deduction_tower/features/ai_opponent/domain/services/ai_opponent_service.dart';
import 'package:anime_deduction_tower/features/ai_opponent/presentation/providers/ai_opponent_providers.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/game_match.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/guess_result.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/player.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/game/domain/services/game_engine.dart';
import 'package:anime_deduction_tower/features/game/domain/services/hint_engine.dart';
import 'package:anime_deduction_tower/features/game/domain/services/trait_filter_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final gameEngineProvider = Provider<GameEngine>((ref) => const GameEngine());
final hintEngineProvider = Provider<HintEngine>((ref) => const HintEngine());
final traitFilterEngineProvider = Provider<TraitFilterEngine>(
  (ref) => const TraitFilterEngine(),
);

class MatchController extends StateNotifier<GameMatch?> {
  MatchController({
    required GameEngine gameEngine,
    required HintEngine hintEngine,
    required TraitFilterEngine traitFilterEngine,
    required AiOpponentService aiOpponentService,
  })  : _gameEngine = gameEngine,
        _hintEngine = hintEngine,
        _traitFilterEngine = traitFilterEngine,
        _aiOpponentService = aiOpponentService,
        super(null);

  final GameEngine _gameEngine;
  final HintEngine _hintEngine;
  final TraitFilterEngine _traitFilterEngine;
  final AiOpponentService _aiOpponentService;

  void setMatch(GameMatch match) => state = match;

  void initializeMatch({
    required String playerOneName,
    required String playerTwoName,
    required int hintsPerPlayer,
    required String playerOneTraitId,
    required String playerTwoTraitId,
    required List<TraitCategory> categories,
    required List<Character> characters,
    bool playerTwoIsAi = false,
  }) {
    final playerOneTrait = _findTraitById(categories, playerOneTraitId);
    final playerTwoTrait = _findTraitById(categories, playerTwoTraitId);

    final playerOneValidCharacters = _traitFilterEngine.filterCharactersByTrait(
      characters,
      playerOneTrait,
    );
    final playerTwoValidCharacters = _traitFilterEngine.filterCharactersByTrait(
      characters,
      playerTwoTrait,
    );

    final characterPoolIds = <String>{
      ...playerOneValidCharacters.map((character) => character.id),
      ...playerTwoValidCharacters.map((character) => character.id),
    }.toList();

    state = _gameEngine.createMatch(
      playerOne: Player(
        id: 'player_one',
        name: playerOneName,
        secretTraitId: playerOneTrait.id,
        validCharacterIds:
            playerOneValidCharacters.map((character) => character.id).toList(),
        hintsRemaining: hintsPerPlayer,
      ),
      playerTwo: Player(
        id: 'player_two',
        name: playerTwoName,
        secretTraitId: playerTwoTrait.id,
        validCharacterIds:
            playerTwoValidCharacters.map((character) => character.id).toList(),
        hintsRemaining: hintsPerPlayer,
        controlType:
            playerTwoIsAi ? PlayerControlType.ai : PlayerControlType.human,
      ),
      characterPoolIds: characterPoolIds,
    );
  }

  GuessResult submitCharacterGuess({
    required String characterId,
    required List<Character> characters,
    required List<TraitCategory> categories,
  }) {
    final match = _requireMatch();
    final guessedCharacter = _findCharacterInPool(
      match: match,
      characters: characters,
      characterId: characterId,
    );
    final opponentSecretTrait = _findOpponentSecretTrait(match, categories);

    final updatedMatch = _gameEngine.resolveCharacterGuess(
      match: match,
      guessedCharacter: guessedCharacter,
      opponentSecretTrait: opponentSecretTrait,
    );

    state = updatedMatch;

    final wasCorrect = updatedMatch.turns.last.wasCorrect;

    return GuessResult(
      isCorrect: wasCorrect,
      message: wasCorrect
          ? '${guessedCharacter.name} matches the opponent\'s hidden tag.'
          : '${guessedCharacter.name} does not match the opponent\'s hidden tag.',
      guessedValue: guessedCharacter.name,
      actionType: updatedMatch.turns.last.actionType,
    );
  }

  GuessResult submitTraitGuess({
    required String guessedTraitId,
    required List<TraitCategory> categories,
  }) {
    final match = _requireMatch();
    final opponentSecretTrait = _findOpponentSecretTrait(match, categories);
    final guessedTrait = _findTraitById(categories, guessedTraitId);

    final updatedMatch = _gameEngine.resolveTraitGuess(
      match: match,
      guessedTraitId: guessedTraitId,
      opponentSecretTrait: opponentSecretTrait,
    );

    state = updatedMatch;

    final wasCorrect = updatedMatch.turns.last.wasCorrect;

    return GuessResult(
      isCorrect: wasCorrect,
      message: wasCorrect
          ? '${guessedTrait.label} is correct. The match is over.'
          : '${guessedTrait.label} is not the opponent\'s hidden tag.',
      guessedValue: guessedTrait.label,
      actionType: updatedMatch.turns.last.actionType,
    );
  }

  String requestHint({
    required List<TraitCategory> categories,
  }) {
    final match = _requireMatch();
    final opponentSecretTrait = _findOpponentSecretTrait(match, categories);
    final hintMessage = _hintEngine.generateHint(opponentSecretTrait);

    state = _gameEngine.resolveHintRequest(
      match: match,
      hintMessage: hintMessage,
    );

    return hintMessage;
  }

  void surrenderCurrentPlayer() {
    final match = _requireMatch();

    state = _gameEngine.surrenderMatch(
      match: match,
      surrenderingPlayerId: match.currentPlayerId,
    );
  }

  GuessResult runAiTurn({
    required List<TraitCategory> categories,
    required List<Character> characters,
  }) {
    final match = _requireMatch();
    if (!match.currentPlayer.isAi) {
      throw StateError('The current player is not AI-controlled.');
    }

    final decision = _aiOpponentService.chooseTurn(
      match: match,
      categories: categories,
      characters: characters,
    );

    switch (decision.actionType) {
      case TurnActionType.guessCharacter:
        final guessedCharacter = _findCharacterInPool(
          match: match,
          characters: characters,
          characterId: decision.value,
        );
        final opponentSecretTrait = _findOpponentSecretTrait(match, categories);
        final updatedMatch = _gameEngine.resolveCharacterGuess(
          match: match,
          guessedCharacter: guessedCharacter,
          opponentSecretTrait: opponentSecretTrait,
        );

        state = updatedMatch;
        final wasCorrect = updatedMatch.turns.last.wasCorrect;
        return GuessResult(
          isCorrect: wasCorrect,
          message: wasCorrect
              ? '${match.currentPlayer.name} guessed ${guessedCharacter.name}, and it matches your hidden tag.'
              : '${match.currentPlayer.name} guessed ${guessedCharacter.name}, but it does not match your hidden tag.',
          guessedValue: guessedCharacter.name,
          actionType: updatedMatch.turns.last.actionType,
        );
      case TurnActionType.guessTrait:
        final guessedTrait = _findTraitById(categories, decision.value);
        final opponentSecretTrait = _findOpponentSecretTrait(match, categories);
        final updatedMatch = _gameEngine.resolveTraitGuess(
          match: match,
          guessedTraitId: guessedTrait.id,
          opponentSecretTrait: opponentSecretTrait,
        );

        state = updatedMatch;
        final wasCorrect = updatedMatch.turns.last.wasCorrect;
        return GuessResult(
          isCorrect: wasCorrect,
          message: wasCorrect
              ? '${match.currentPlayer.name} guessed your hidden tag: ${guessedTrait.label}. The match is over.'
              : '${match.currentPlayer.name} guessed ${guessedTrait.label}, but your hidden tag remains safe.',
          guessedValue: guessedTrait.label,
          actionType: updatedMatch.turns.last.actionType,
        );
      case TurnActionType.requestHint:
      case TurnActionType.surrender:
      case TurnActionType.pass:
        throw StateError(
          'Mock AI decisions currently support only character or trait guesses.',
        );
    }
  }

  void clear() => state = null;

  TraitCategory _findOpponentSecretTrait(
    GameMatch match,
    List<TraitCategory> categories,
  ) {
    final secretTraitId = match.waitingPlayer.secretTraitId;
    if (secretTraitId == null) {
      throw StateError('Waiting player does not have a secret trait.');
    }

    return _findTraitById(categories, secretTraitId);
  }

  TraitCategory _findTraitById(List<TraitCategory> categories, String traitId) {
    return categories.firstWhere(
      (category) => category.id == traitId,
      orElse: () => throw StateError('Trait with id $traitId was not found.'),
    );
  }

  Character _findCharacterInPool({
    required GameMatch match,
    required List<Character> characters,
    required String characterId,
  }) {
    if (!match.characterPoolIds.contains(characterId)) {
      throw StateError(
        'Character $characterId is not part of the current pool.',
      );
    }

    return characters.firstWhere(
      (character) => character.id == characterId,
      orElse: () =>
          throw StateError('Character with id $characterId was not found.'),
    );
  }

  GameMatch _requireMatch() {
    final match = state;
    if (match == null) {
      throw StateError('No active match is available.');
    }

    return match;
  }
}

final matchControllerProvider =
    StateNotifierProvider<MatchController, GameMatch?>(
  (ref) => MatchController(
    gameEngine: ref.watch(gameEngineProvider),
    hintEngine: ref.watch(hintEngineProvider),
    traitFilterEngine: ref.watch(traitFilterEngineProvider),
    aiOpponentService: ref.watch(aiOpponentServiceProvider),
  ),
);
