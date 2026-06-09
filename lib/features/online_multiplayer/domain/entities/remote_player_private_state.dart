class RemotePlayerPrivateState {
  const RemotePlayerPrivateState({
    required this.participantId,
    required this.userId,
    required this.secretTraitId,
    required this.secretTraitLocked,
    required this.hasViewedSecret,
    required this.hintsUsed,
    required this.selectedAt,
    required this.updatedAt,
    this.lastPrivateHintText,
  });

  final String participantId;
  final String userId;
  final String secretTraitId;
  final bool secretTraitLocked;
  final bool hasViewedSecret;
  final int hintsUsed;
  final String? lastPrivateHintText;
  final DateTime selectedAt;
  final DateTime updatedAt;

  bool get hasSecretAssigned => secretTraitId.isNotEmpty;

  bool get hasPrivateHint =>
      lastPrivateHintText != null && lastPrivateHintText!.trim().isNotEmpty;
}
