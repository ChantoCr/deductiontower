import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/game_match.dart';

class GameFlowCopyHelper {
  const GameFlowCopyHelper();

  String setupHeroDescription() {
    return 'This setup is designed for one-device multiplayer. Names, hints, and protected secret-tag selection stay clear before the live deduction phase begins.';
  }

  String setupPlayersSectionDescription() {
    return 'Give each side a clear name. The fields are separated for better readability during quick setup and pass-the-device play.';
  }

  String playerNameHelper(int playerNumber) {
    if (playerNumber == 1) {
      return 'Appears in turn flow, match status, and the result timeline.';
    }

    return 'Names are trimmed automatically and never saved as blank.';
  }

  String hintBudgetDescription(int hints) {
    return 'Each player starts with $hints private hint${hints == 1 ? '' : 's'}. Hints reveal direction, not the exact answer.';
  }

  String matchPreviewPrivacyNote() {
    return 'Secret tags stay protected after this screen. The device is passed between players before private information is revealed again.';
  }

  String turnTransitionTitle({
    required bool isExistingMatch,
    required bool isCompletedMatch,
  }) {
    if (isCompletedMatch) {
      return 'Match Complete';
    }

    if (isExistingMatch) {
      return 'Protected Handoff';
    }

    return 'Prepare the First Player';
  }

  String turnTransitionDescription({required GameMatch? match}) {
    final isExistingMatch = match != null;
    final isCompletedMatch = match?.status == MatchStatus.completed;

    if (isCompletedMatch) {
      return 'The match is over. Open the result screen to review the winner, end reason, and full deduction trail.';
    }

    if (isExistingMatch) {
      return 'Hand the device to ${match.currentPlayer.name}. Only the active player should reveal the next private gameplay screen.';
    }

    return 'Use this protection screen before revealing the first hidden tag and starting the live match.';
  }

  String turnTransitionButtonLabel({
    required bool isExistingMatch,
    required bool isCompletedMatch,
  }) {
    if (isCompletedMatch) {
      return 'View Result';
    }

    if (isExistingMatch) {
      return 'Reveal Protected Turn';
    }

    return 'Start Match';
  }

  String turnTransitionBadgeLabel({
    required bool isExistingMatch,
    required bool isCompletedMatch,
  }) {
    if (isCompletedMatch) {
      return 'RESULT READY';
    }

    if (isExistingMatch) {
      return 'PROTECTED HANDOFF';
    }

    return 'MATCH PREP';
  }

  String turnPanelDescription() {
    return 'The shared pool is public, but hidden-tag information stays private. The match ends when a player correctly guesses the opponent tag or surrenders.';
  }

  String turnPanelStatusLabel(int hints) {
    return hints > 0 ? '$hints hints ready' : 'No hints left';
  }

  String towerDescription() {
    return 'The shared pool is the public battlefield for both players. Use it to test patterns before committing to a final tag guess.';
  }

  String towerStatusLabel() {
    return 'PUBLIC BOARD';
  }
}
