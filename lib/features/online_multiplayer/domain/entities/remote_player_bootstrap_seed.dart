class RemotePlayerBootstrapSeed {
  const RemotePlayerBootstrapSeed({
    required this.participantId,
    required this.userId,
    required this.secretTraitId,
    this.hasViewedSecret = true,
  });

  final String participantId;
  final String userId;
  final String secretTraitId;
  final bool hasViewedSecret;

  bool get isComplete =>
      participantId.isNotEmpty &&
      userId.isNotEmpty &&
      secretTraitId.isNotEmpty;
}
