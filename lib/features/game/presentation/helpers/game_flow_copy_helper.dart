import 'package:anime_deduction_tower/core/enums/ai_difficulty.dart';
import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/game_match.dart';

class GameFlowCopyHelper {
  const GameFlowCopyHelper();

  String setupHeroDescription() {
    return 'This setup supports one-device multiplayer and a mock player-vs-AI ladder. Names, hints, and secret-tag preparation stay clear before the live deduction phase begins.';
  }

  String setupPlayersSectionDescription({required bool isPlayerVsAi}) {
    if (isPlayerVsAi) {
      return 'Set your player name and the AI display name clearly. The roster stays readable in turn summaries, AI briefings, and the public result timeline.';
    }

    return 'Give each side a clear name. The fields are separated for better readability during quick setup and pass-the-device play.';
  }

  String playerNameHelper(int playerNumber) {
    if (playerNumber == 1) {
      return 'Appears in turn flow, match status, and the result timeline.';
    }

    return 'Names are trimmed automatically and never saved as blank.';
  }

  String aiDifficultyDescription(AiDifficulty difficulty) {
    switch (difficulty) {
      case AiDifficulty.easy:
        return 'Prefers safer public checks, leans more on obvious characters, and waits longer before a final tag call.';
      case AiDifficulty.standard:
        return 'Balances readable public probes with timely final tag guesses once the evidence tightens.';
      case AiDifficulty.hard:
        return 'Pushes stronger information splits, wastes fewer turns on weak probes, and commits earlier when the board stops teaching it anything new.';
    }
  }

  String aiDifficultyProbeFocus(AiDifficulty difficulty) {
    switch (difficulty) {
      case AiDifficulty.easy:
        return 'Favors clearer, easier-to-read public probes before narrowing hard.';
      case AiDifficulty.standard:
        return 'Mixes readable public checks with stronger split value when the pool tightens.';
      case AiDifficulty.hard:
        return 'Prioritizes high-value split probes and avoids wasting turns on flat reads.';
    }
  }

  String aiDifficultyCommitmentStyle(AiDifficulty difficulty) {
    switch (difficulty) {
      case AiDifficulty.easy:
        return 'Usually waits longer before locking a final hidden-tag guess.';
      case AiDifficulty.standard:
        return 'Commits once the live evidence is stable enough to justify a clean read.';
      case AiDifficulty.hard:
        return 'Commits early when the next public probe is unlikely to teach anything new.';
    }
  }

  String aiDifficultyTempoStyle(AiDifficulty difficulty) {
    switch (difficulty) {
      case AiDifficulty.easy:
        return 'Creates a slower, more forgiving deduction pace for the human player.';
      case AiDifficulty.standard:
        return 'Keeps a balanced duel tempo without changing the official match rules.';
      case AiDifficulty.hard:
        return 'Applies more pressure through sharper public timing and cleaner probe selection.';
    }
  }

  String aiOpponentSetupDescription({
    required String aiName,
    required AiDifficulty difficulty,
  }) {
    return '$aiName will receive an auto-assigned hidden tag, take public-only turns, and follow a ${difficulty.label.toLowerCase()} behavior profile without changing any official match rules.';
  }

  String aiOpponentLiveDescription({
    required String aiName,
    required AiDifficulty difficulty,
  }) {
    return '$aiName is currently running on ${difficulty.label.toLowerCase()} difficulty. Its hidden tag stays private, but every public automated guess and reasoning summary remains visible in the shared duel flow.';
  }

  String aiOpponentResultDescription({
    required String aiName,
    required AiDifficulty difficulty,
    required bool aiWon,
  }) {
    final outcome = aiWon ? 'won the duel' : 'did not close the duel first';
    return '$aiName $outcome on ${difficulty.label.toLowerCase()} difficulty. Use the analytics below to review probe quality, commitment timing, and final-read efficiency.';
  }

  String hintBudgetDescription(int hints) {
    return 'Each player starts with $hints private hint${hints == 1 ? '' : 's'}. Hints reveal direction, not the exact answer.';
  }

  String matchPreviewPrivacyNote({
    required bool isPlayerVsAi,
    required AiDifficulty aiDifficulty,
  }) {
    if (isPlayerVsAi) {
      return 'Your hidden tag stays private after this screen, while ${aiDifficulty.label} AI turns remain public and are resolved through the same match engine as any human action.';
    }

    return 'Secret tags stay protected after this screen. The device is passed between players before private information is revealed again.';
  }

  String turnTransitionTitle({required GameMatch? match}) {
    final isExistingMatch = match != null;
    final isCompletedMatch = match?.status == MatchStatus.completed;
    final isAiTurn = match?.currentPlayer.isAi == true && !isCompletedMatch;

    if (isCompletedMatch) {
      return 'Match Complete';
    }

    if (isAiTurn) {
      return 'Tower AI Turn';
    }

    if (isExistingMatch) {
      return 'Protected Handoff';
    }

    return 'Prepare the First Player';
  }

  String turnTransitionDescription({
    required GameMatch? match,
    AiDifficulty? aiDifficulty,
  }) {
    final isExistingMatch = match != null;
    final isCompletedMatch = match?.status == MatchStatus.completed;
    final isAiTurn = match?.currentPlayer.isAi == true && !isCompletedMatch;

    if (isCompletedMatch) {
      return 'The match is over. Open the result screen to review the winner, end reason, and full deduction trail.';
    }

    if (isAiTurn) {
      final difficultyLabel = aiDifficulty?.label;
      final difficultyNote =
          difficultyLabel == null ? '' : ' at $difficultyLabel difficulty';
      return '${match!.currentPlayer.name} is ready to take a public turn$difficultyNote. No device handoff is needed while the AI chooses its next move.';
    }

    if (isExistingMatch) {
      return 'Hand the device to ${match.currentPlayer.name}. Only the active player should reveal the next private gameplay screen.';
    }

    return 'Use this protection screen before revealing the first hidden tag and starting the live match.';
  }

  String turnTransitionButtonLabel({required GameMatch? match}) {
    final isExistingMatch = match != null;
    final isCompletedMatch = match?.status == MatchStatus.completed;
    final isAiTurn = match?.currentPlayer.isAi == true && !isCompletedMatch;

    if (isCompletedMatch) {
      return 'View Result';
    }

    if (isAiTurn) {
      return 'Run AI Turn';
    }

    if (isExistingMatch) {
      return 'Reveal Protected Turn';
    }

    return 'Start Match';
  }

  String turnTransitionBadgeLabel({required GameMatch? match}) {
    final isExistingMatch = match != null;
    final isCompletedMatch = match?.status == MatchStatus.completed;
    final isAiTurn = match?.currentPlayer.isAi == true && !isCompletedMatch;

    if (isCompletedMatch) {
      return 'RESULT READY';
    }

    if (isAiTurn) {
      return 'AI OPPONENT';
    }

    if (isExistingMatch) {
      return 'PROTECTED HANDOFF';
    }

    return 'MATCH PREP';
  }

  String turnPanelDescription({
    required bool isPlayerVsAi,
    required String currentPlayerName,
    String? aiName,
    AiDifficulty? aiDifficulty,
  }) {
    if (isPlayerVsAi) {
      final difficultyLabel = aiDifficulty?.label;
      final difficultyText =
          difficultyLabel == null ? 'the AI' : '$difficultyLabel AI';
      return '$currentPlayerName is facing ${aiName ?? 'the AI'} in a public deduction duel. $difficultyText still follows the same no-lives rules: correct secret-tag guess or surrender ends the match.';
    }

    return 'The shared pool is public, but hidden-tag information stays private. The match ends when a player correctly guesses the opponent tag or surrenders.';
  }

  String turnPanelStatusLabel({
    required int hints,
    required bool isPlayerVsAi,
    AiDifficulty? aiDifficulty,
  }) {
    if (isPlayerVsAi && aiDifficulty != null) {
      return '${aiDifficulty.label.toUpperCase()} AI • $hints hints';
    }

    return hints > 0 ? '$hints hints ready' : 'No hints left';
  }

  String towerDescription({
    required bool isPlayerVsAi,
    String? aiName,
  }) {
    if (isPlayerVsAi) {
      return 'The shared pool is the public battlefield for you and ${aiName ?? 'the AI'}. Use it to test patterns before the automated opponent gets its next public read.';
    }

    return 'The shared pool is the public battlefield for both players. Use it to test patterns before committing to a final tag guess.';
  }

  String towerStatusLabel({required bool isPlayerVsAi}) {
    return isPlayerVsAi ? 'PUBLIC BOARD • AI MATCH' : 'PUBLIC BOARD';
  }

  String hintPanelDescription({
    required bool hasHints,
    required bool isPlayerVsAi,
    String? aiName,
  }) {
    if (hasHints) {
      if (isPlayerVsAi) {
        return 'Request a private hint about ${aiName ?? 'the AI'}\'s hidden tag. It consumes one hint, then the automated opponent takes the next public turn.';
      }

      return 'Request a private hint about the opponent\'s secret tag. It consumes one hint, then the device passes to the next player.';
    }

    if (isPlayerVsAi) {
      return 'No hints remain for this player. Use public character reads and final tag timing to out-deduce ${aiName ?? 'the AI'}.';
    }

    return 'No hints remain for this player. Use character and tag guesses to continue deducing the answer.';
  }

  String actionConsoleDescription({
    required bool hasSelection,
    required bool isPlayerVsAi,
    String? aiName,
  }) {
    if (hasSelection) {
      return isPlayerVsAi
          ? 'Your selected guess is staged below. Submit it, then ${aiName ?? 'the AI'} will resolve the next public turn automatically.'
          : 'Your selected guess is staged below and ready for submission.';
    }

    return isPlayerVsAi
        ? 'Pick from the pool or type an exact character name, then submit. After your public action, ${aiName ?? 'the AI'} resolves its next turn without another handoff screen.'
        : 'Pick from the pool or type an exact character name, then submit without scrolling away from the action area.';
  }

  String resultBannerSummary({
    required bool isPlayerVsAi,
    String? aiName,
    AiDifficulty? aiDifficulty,
  }) {
    if (!isPlayerVsAi) {
      return 'Review the revealed tags, remaining hint economy, and the full public event timeline before starting the next round.';
    }

    final difficultyLabel = aiDifficulty?.label;
    final difficultyText =
        difficultyLabel == null ? 'the AI' : '$difficultyLabel AI';
    return 'Review how ${aiName ?? 'the AI'} handled public probes, hint tempo, and final tag timing. Compare the full replay before launching the next $difficultyText match.';
  }

  String resultComparisonDescription({
    required bool isPlayerVsAi,
    String? aiName,
    AiDifficulty? aiDifficulty,
  }) {
    if (!isPlayerVsAi) {
      return 'Compare match efficiency, guess accuracy, and support-action usage to see how the final deduction swung.';
    }

    final difficultyLabel = aiDifficulty?.label;
    final difficultyText =
        difficultyLabel == null ? 'the AI' : '$difficultyLabel AI';
    return 'Compare your efficiency against ${aiName ?? 'the AI'} to see whether $difficultyText won through better public probes, sharper timing, or cleaner final reads.';
  }
}
