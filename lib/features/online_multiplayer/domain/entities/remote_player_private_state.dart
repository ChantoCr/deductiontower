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

  RemotePlayerPrivateState copyWith({
    String? secretTraitId,
    bool? secretTraitLocked,
    bool? hasViewedSecret,
    int? hintsUsed,
    String? lastPrivateHintText,
    DateTime? updatedAt,
    bool clearLastPrivateHintText = false,
  }) {
    return RemotePlayerPrivateState(
      participantId: participantId,
      userId: userId,
      secretTraitId: secretTraitId ?? this.secretTraitId,
      secretTraitLocked: secretTraitLocked ?? this.secretTraitLocked,
      hasViewedSecret: hasViewedSecret ?? this.hasViewedSecret,
      hintsUsed: hintsUsed ?? this.hintsUsed,
      lastPrivateHintText: clearLastPrivateHintText
          ? null
          : lastPrivateHintText ?? this.lastPrivateHintText,
      selectedAt: selectedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
