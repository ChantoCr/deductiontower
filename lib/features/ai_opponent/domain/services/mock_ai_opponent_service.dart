import 'dart:math';

import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';
import 'package:anime_deduction_tower/features/ai_opponent/domain/entities/ai_turn_decision.dart';
import 'package:anime_deduction_tower/features/ai_opponent/domain/services/ai_opponent_service.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/game_match.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';

class MockAiOpponentService implements AiOpponentService {
  MockAiOpponentService({Random? random}) : _random = random ?? Random();

  final Random _random;

  @override
  String chooseSecretTraitId({
    required List<TraitCategory> categories,
    String? excludedTraitId,
  }) {
    if (categories.isEmpty) {
      throw StateError('At least one trait category is required for AI setup.');
    }

    final selectableCategories =
        categories.where((category) => category.id != excludedTraitId).toList();
    final pool =
        selectableCategories.isEmpty ? categories : selectableCategories;

    return pool[_random.nextInt(pool.length)].id;
  }

  @override
  AiTurnDecision chooseTurn({
    required GameMatch match,
    required List<TraitCategory> categories,
    required List<Character> characters,
  }) {
    if (!match.currentPlayer.isAi) {
      throw StateError('AI turn requested for a human-controlled player.');
    }

    final categoriesById = {
      for (final category in categories) category.id: category,
    };
    final charactersById = {
      for (final character in characters) character.id: character,
    };
    final candidateTraits = _resolveCandidateTraits(
      match: match,
      categories: categories,
      charactersById: charactersById,
    );
    final traitGuessesTried = match.turns
        .where(
          (turn) =>
              turn.playerId == match.currentPlayerId &&
              turn.actionType == TurnActionType.guessTrait,
        )
        .map((turn) => turn.value)
        .toSet();
    final availableTraitCandidates = candidateTraits
        .where((category) => !traitGuessesTried.contains(category.id))
        .toList();

    if (availableTraitCandidates.length == 1) {
      return AiTurnDecision(
        actionType: TurnActionType.guessTrait,
        value: availableTraitCandidates.first.id,
      );
    }

    final guessedCharacterIds = match.turns
        .where(
          (turn) =>
              turn.playerId == match.currentPlayerId &&
              turn.actionType == TurnActionType.guessCharacter,
        )
        .map((turn) => turn.value)
        .toSet();
    final remainingPool = match.characterPoolIds
        .where((characterId) => !guessedCharacterIds.contains(characterId))
        .map((characterId) => charactersById[characterId])
        .whereType<Character>()
        .toList();

    if (remainingPool.isEmpty) {
      final fallbackCategory = _pickFallbackTrait(
        availableTraitCandidates,
        categoriesById,
        traitGuessesTried,
      );

      return AiTurnDecision(
        actionType: TurnActionType.guessTrait,
        value: fallbackCategory.id,
      );
    }

    final aiCharacterGuessCount = guessedCharacterIds.length;
    if (availableTraitCandidates.length <= 2 && aiCharacterGuessCount >= 2) {
      final pickedTrait = _pickTraitGuess(availableTraitCandidates);
      return AiTurnDecision(
        actionType: TurnActionType.guessTrait,
        value: pickedTrait.id,
      );
    }

    final bestCharacter = _pickBestCharacter(
      remainingPool: remainingPool,
      candidateTraits: candidateTraits,
    );

    if (bestCharacter != null) {
      return AiTurnDecision(
        actionType: TurnActionType.guessCharacter,
        value: bestCharacter.id,
      );
    }

    final fallbackCategory = _pickFallbackTrait(
      availableTraitCandidates,
      categoriesById,
      traitGuessesTried,
    );

    return AiTurnDecision(
      actionType: TurnActionType.guessTrait,
      value: fallbackCategory.id,
    );
  }

  List<TraitCategory> _resolveCandidateTraits({
    required GameMatch match,
    required List<TraitCategory> categories,
    required Map<String, Character> charactersById,
  }) {
    var candidates = List<TraitCategory>.from(categories);

    final aiCharacterTurns = match.turns.where(
      (turn) =>
          turn.playerId == match.currentPlayerId &&
          turn.actionType == TurnActionType.guessCharacter,
    );

    for (final turn in aiCharacterTurns) {
      final guessedCharacter = charactersById[turn.value];
      if (guessedCharacter == null) {
        continue;
      }

      candidates = candidates.where((category) {
        final matchesCategory = guessedCharacter.tags.contains(category.tagId);
        return turn.wasCorrect ? matchesCategory : !matchesCategory;
      }).toList();

      if (candidates.isEmpty) {
        return categories;
      }
    }

    return candidates;
  }

  TraitCategory _pickFallbackTrait(
    List<TraitCategory> availableTraitCandidates,
    Map<String, TraitCategory> categoriesById,
    Set<String> traitGuessesTried,
  ) {
    if (availableTraitCandidates.isNotEmpty) {
      return _pickTraitGuess(availableTraitCandidates);
    }

    final remainingCategories = categoriesById.values
        .where((category) => !traitGuessesTried.contains(category.id))
        .toList();

    if (remainingCategories.isNotEmpty) {
      return _pickTraitGuess(remainingCategories);
    }

    return categoriesById.values.first;
  }

  TraitCategory _pickTraitGuess(List<TraitCategory> categories) {
    final sorted = [...categories]..sort((a, b) => a.label.compareTo(b.label));
    return sorted.first;
  }

  Character? _pickBestCharacter({
    required List<Character> remainingPool,
    required List<TraitCategory> candidateTraits,
  }) {
    if (remainingPool.isEmpty) {
      return null;
    }

    final candidateCount = candidateTraits.length;
    Character? bestCharacter;
    var bestScore = -1;
    var bestPopularity = -1;

    for (final character in remainingPool) {
      final matchingTraitCount = candidateTraits
          .where((category) => character.tags.contains(category.tagId))
          .length;
      final splitScore =
          min(matchingTraitCount, candidateCount - matchingTraitCount);

      if (splitScore > bestScore ||
          (splitScore == bestScore && character.popularity > bestPopularity)) {
        bestCharacter = character;
        bestScore = splitScore;
        bestPopularity = character.popularity;
      }
    }

    return bestCharacter;
  }
}
