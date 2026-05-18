class Player {
  const Player({
    required this.id,
    required this.name,
    required this.validCharacterIds,
    required this.hintsRemaining,
    this.secretTraitId,
  });

  final String id;
  final String name;
  final String? secretTraitId;
  final List<String> validCharacterIds;
  final int hintsRemaining;

  Player copyWith({
    String? secretTraitId,
    List<String>? validCharacterIds,
    int? hintsRemaining,
  }) {
    return Player(
      id: id,
      name: name,
      secretTraitId: secretTraitId ?? this.secretTraitId,
      validCharacterIds: validCharacterIds ?? this.validCharacterIds,
      hintsRemaining: hintsRemaining ?? this.hintsRemaining,
    );
  }
}
