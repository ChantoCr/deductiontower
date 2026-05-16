class Player {
  const Player({
    required this.id,
    required this.name,
    required this.validCharacterIds,
    required this.lives,
    required this.hintsRemaining,
    this.secretTraitId,
  });

  final String id;
  final String name;
  final String? secretTraitId;
  final List<String> validCharacterIds;
  final int lives;
  final int hintsRemaining;

  Player copyWith({
    String? secretTraitId,
    List<String>? validCharacterIds,
    int? lives,
    int? hintsRemaining,
  }) {
    return Player(
      id: id,
      name: name,
      secretTraitId: secretTraitId ?? this.secretTraitId,
      validCharacterIds: validCharacterIds ?? this.validCharacterIds,
      lives: lives ?? this.lives,
      hintsRemaining: hintsRemaining ?? this.hintsRemaining,
    );
  }
}
