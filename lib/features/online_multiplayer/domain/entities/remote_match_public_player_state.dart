class RemoteMatchPublicPlayerState {
  const RemoteMatchPublicPlayerState({
    required this.participantId,
    required this.displayName,
    required this.hintsRemaining,
    required this.characterGuessCount,
    required this.traitGuessCount,
  });

  final String participantId;
  final String displayName;
  final int hintsRemaining;
  final int characterGuessCount;
  final int traitGuessCount;

  int get totalGuessCount => characterGuessCount + traitGuessCount;

  RemoteMatchPublicPlayerState copyWith({
    int? hintsRemaining,
    int? characterGuessCount,
    int? traitGuessCount,
  }) {
    return RemoteMatchPublicPlayerState(
      participantId: participantId,
      displayName: displayName,
      hintsRemaining: hintsRemaining ?? this.hintsRemaining,
      characterGuessCount: characterGuessCount ?? this.characterGuessCount,
      traitGuessCount: traitGuessCount ?? this.traitGuessCount,
    );
  }
}
