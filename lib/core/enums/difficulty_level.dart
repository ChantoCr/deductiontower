enum DifficultyLevel {
  easy,
  medium,
  hard;

  static DifficultyLevel fromValue(String value) {
    return DifficultyLevel.values.firstWhere(
      (level) => level.name == value,
      orElse: () => DifficultyLevel.easy,
    );
  }
}
