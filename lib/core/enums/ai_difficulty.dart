enum AiDifficulty {
  easy,
  standard,
  hard,
}

extension AiDifficultyLabelX on AiDifficulty {
  String get label {
    switch (this) {
      case AiDifficulty.easy:
        return 'Easy';
      case AiDifficulty.standard:
        return 'Standard';
      case AiDifficulty.hard:
        return 'Hard';
    }
  }

  String get shortDescription {
    switch (this) {
      case AiDifficulty.easy:
        return 'Favors safer, more readable public probes before committing.';
      case AiDifficulty.standard:
        return 'Balanced deduction with moderate final-guess timing.';
      case AiDifficulty.hard:
        return 'Pushes stronger information splits and earlier confident reads.';
    }
  }
}
