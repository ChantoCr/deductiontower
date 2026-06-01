import 'dart:math';

import 'package:anime_deduction_tower/core/enums/ai_difficulty.dart';
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
    required AiDifficulty difficulty,
  }) {
    if (!match.currentPlayer.isAi) {
      throw StateError('AI turn requested for a human-controlled player.');
    }

    final profile = _profileFor(difficulty);
    final categoriesById = {
      for (final category in categories) category.id: category,
    };
    final charactersById = {
      for (final character in characters) character.id: character,
    };
    final traitGuessesTried = match.turns
        .where(
          (turn) =>
              turn.playerId == match.currentPlayerId &&
              turn.actionType == TurnActionType.guessTrait,
        )
        .map((turn) => turn.value)
        .toSet();
    final candidateTraits = _resolveCandidateTraits(
      match: match,
      categories: categories,
      charactersById: charactersById,
      ruledOutTraitIds: traitGuessesTried,
    );
    final availableTraitCandidates = candidateTraits
        .where((category) => !traitGuessesTried.contains(category.id))
        .toList();
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
    final bestProbe = _pickBestCharacterProbe(
      remainingPool: remainingPool,
      candidateTraits: candidateTraits,
      profile: profile,
    );

    if (_shouldGuessTrait(
      availableTraitCount: availableTraitCandidates.length,
      aiCharacterGuessCount: guessedCharacterIds.length,
      bestProbe: bestProbe,
      profile: profile,
      hasRemainingPool: remainingPool.isNotEmpty,
    )) {
      final pickedTrait = _pickFallbackTrait(
        availableTraitCandidates,
        categoriesById,
        traitGuessesTried,
      );
      final traitSummary = _buildTraitGuessSummary(
        difficulty: difficulty,
        candidateCount: availableTraitCandidates.isEmpty
            ? candidateTraits.length
            : availableTraitCandidates.length,
        bestProbe: bestProbe,
      );

      return AiTurnDecision(
        actionType: TurnActionType.guessTrait,
        value: pickedTrait.id,
        summary: traitSummary,
      );
    }

    if (bestProbe != null) {
      return AiTurnDecision(
        actionType: TurnActionType.guessCharacter,
        value: bestProbe.character.id,
        summary: _buildCharacterGuessSummary(
          difficulty: difficulty,
          probe: bestProbe,
          candidateCount: candidateTraits.length,
        ),
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
      summary: _buildTraitGuessSummary(
        difficulty: difficulty,
        candidateCount: availableTraitCandidates.isEmpty
            ? candidateTraits.length
            : availableTraitCandidates.length,
        bestProbe: bestProbe,
      ),
    );
  }

  List<TraitCategory> _resolveCandidateTraits({
    required GameMatch match,
    required List<TraitCategory> categories,
    required Map<String, Character> charactersById,
    required Set<String> ruledOutTraitIds,
  }) {
    var candidates = categories
        .where((category) => !ruledOutTraitIds.contains(category.id))
        .toList();

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
        final fallback = categories
            .where((category) => !ruledOutTraitIds.contains(category.id))
            .toList();
        return fallback.isEmpty ? categories : fallback;
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

  _AiProfile _profileFor(AiDifficulty difficulty) {
    switch (difficulty) {
      case AiDifficulty.easy:
        return const _AiProfile(
          popularityWeight: 0.34,
          minCharacterGuessesBeforeSmartGuess: 4,
          maxCandidateCountForSmartGuess: 2,
          maxProbeInfoScoreForSmartGuess: 0.02,
          minCharacterGuessesBeforeStalledGuess: 4,
          maxCandidateCountForStalledGuess: 2,
          maxProbeInfoScoreForStalledGuess: 0.0,
        );
      case AiDifficulty.standard:
        return const _AiProfile(
          popularityWeight: 0.18,
          minCharacterGuessesBeforeSmartGuess: 3,
          maxCandidateCountForSmartGuess: 2,
          maxProbeInfoScoreForSmartGuess: 0.18,
          minCharacterGuessesBeforeStalledGuess: 2,
          maxCandidateCountForStalledGuess: 3,
          maxProbeInfoScoreForStalledGuess: 0.04,
        );
      case AiDifficulty.hard:
        return const _AiProfile(
          popularityWeight: 0.08,
          minCharacterGuessesBeforeSmartGuess: 2,
          maxCandidateCountForSmartGuess: 3,
          maxProbeInfoScoreForSmartGuess: 0.28,
          minCharacterGuessesBeforeStalledGuess: 1,
          maxCandidateCountForStalledGuess: 4,
          maxProbeInfoScoreForStalledGuess: 0.08,
        );
    }
  }

  bool _shouldGuessTrait({
    required int availableTraitCount,
    required int aiCharacterGuessCount,
    required _CharacterProbeScore? bestProbe,
    required _AiProfile profile,
    required bool hasRemainingPool,
  }) {
    if (availableTraitCount <= 1) {
      return true;
    }

    if (!hasRemainingPool || bestProbe == null) {
      return true;
    }

    if (availableTraitCount <= profile.maxCandidateCountForSmartGuess &&
        aiCharacterGuessCount >= profile.minCharacterGuessesBeforeSmartGuess &&
        bestProbe.infoScore <= profile.maxProbeInfoScoreForSmartGuess) {
      return true;
    }

    if (availableTraitCount <= profile.maxCandidateCountForStalledGuess &&
        aiCharacterGuessCount >=
            profile.minCharacterGuessesBeforeStalledGuess &&
        bestProbe.infoScore <= profile.maxProbeInfoScoreForStalledGuess) {
      return true;
    }

    return false;
  }

  _CharacterProbeScore? _pickBestCharacterProbe({
    required List<Character> remainingPool,
    required List<TraitCategory> candidateTraits,
    required _AiProfile profile,
  }) {
    if (remainingPool.isEmpty || candidateTraits.isEmpty) {
      return null;
    }

    final candidateCount = candidateTraits.length;
    _CharacterProbeScore? bestProbe;

    for (final character in remainingPool) {
      final matchingTraitCount = candidateTraits
          .where((category) => character.tags.contains(category.tagId))
          .length;
      final nonMatchingTraitCount = candidateCount - matchingTraitCount;
      final infoScore = _calculateInfoScore(
        candidateCount: candidateCount,
        matchingTraitCount: matchingTraitCount,
        nonMatchingTraitCount: nonMatchingTraitCount,
      );
      final popularityScore =
          (character.popularity / 10).clamp(0, 1).toDouble();
      final finalScore = (infoScore * (1 - profile.popularityWeight)) +
          (popularityScore * profile.popularityWeight);
      final probe = _CharacterProbeScore(
        character: character,
        matchingTraitCount: matchingTraitCount,
        nonMatchingTraitCount: nonMatchingTraitCount,
        infoScore: infoScore,
        popularityScore: popularityScore,
        finalScore: finalScore,
      );

      if (bestProbe == null || probe.isBetterThan(bestProbe)) {
        bestProbe = probe;
      }
    }

    return bestProbe;
  }

  double _calculateInfoScore({
    required int candidateCount,
    required int matchingTraitCount,
    required int nonMatchingTraitCount,
  }) {
    if (candidateCount <= 1 ||
        matchingTraitCount == 0 ||
        nonMatchingTraitCount == 0) {
      return 0;
    }

    final total = candidateCount.toDouble();
    final yesRatio = matchingTraitCount / total;
    final noRatio = nonMatchingTraitCount / total;
    final entropyScore = _binaryEntropy(yesRatio, noRatio);
    final expectedRemaining = ((matchingTraitCount * matchingTraitCount) +
            (nonMatchingTraitCount * nonMatchingTraitCount)) /
        total;
    final eliminationScore = 1 - (expectedRemaining / total);

    return (entropyScore * 0.55) + (eliminationScore * 0.45);
  }

  double _binaryEntropy(double yesRatio, double noRatio) {
    return -((yesRatio * _log2(yesRatio)) + (noRatio * _log2(noRatio)));
  }

  double _log2(double value) => log(value) / ln2;

  String _buildCharacterGuessSummary({
    required AiDifficulty difficulty,
    required _CharacterProbeScore probe,
    required int candidateCount,
  }) {
    final splitLabel = probe.infoScore >= 0.45
        ? 'a strong public split'
        : probe.infoScore >= 0.2
            ? 'a useful public split'
            : 'a light public check';

    return '${difficulty.label} AI used ${probe.character.name} as $splitLabel against $candidateCount live tag candidate${candidateCount == 1 ? '' : 's'}.';
  }

  String _buildTraitGuessSummary({
    required AiDifficulty difficulty,
    required int candidateCount,
    required _CharacterProbeScore? bestProbe,
  }) {
    if (candidateCount <= 1) {
      return '${difficulty.label} AI narrowed the field to one live tag and committed immediately.';
    }

    if (bestProbe == null || bestProbe.infoScore <= 0.08) {
      return '${difficulty.label} AI judged that the remaining pool offered almost no extra public information, so it committed to a final tag read.';
    }

    return '${difficulty.label} AI committed after shrinking the field to $candidateCount live tag candidates and deciding the next probe was too weak to justify another delay.';
  }
}

class _AiProfile {
  const _AiProfile({
    required this.popularityWeight,
    required this.minCharacterGuessesBeforeSmartGuess,
    required this.maxCandidateCountForSmartGuess,
    required this.maxProbeInfoScoreForSmartGuess,
    required this.minCharacterGuessesBeforeStalledGuess,
    required this.maxCandidateCountForStalledGuess,
    required this.maxProbeInfoScoreForStalledGuess,
  });

  final double popularityWeight;
  final int minCharacterGuessesBeforeSmartGuess;
  final int maxCandidateCountForSmartGuess;
  final double maxProbeInfoScoreForSmartGuess;
  final int minCharacterGuessesBeforeStalledGuess;
  final int maxCandidateCountForStalledGuess;
  final double maxProbeInfoScoreForStalledGuess;
}

class _CharacterProbeScore {
  const _CharacterProbeScore({
    required this.character,
    required this.matchingTraitCount,
    required this.nonMatchingTraitCount,
    required this.infoScore,
    required this.popularityScore,
    required this.finalScore,
  });

  final Character character;
  final int matchingTraitCount;
  final int nonMatchingTraitCount;
  final double infoScore;
  final double popularityScore;
  final double finalScore;

  bool isBetterThan(_CharacterProbeScore other) {
    if (finalScore != other.finalScore) {
      return finalScore > other.finalScore;
    }

    if (infoScore != other.infoScore) {
      return infoScore > other.infoScore;
    }

    if (character.popularity != other.character.popularity) {
      return character.popularity > other.character.popularity;
    }

    return character.name.compareTo(other.character.name) < 0;
  }
}
