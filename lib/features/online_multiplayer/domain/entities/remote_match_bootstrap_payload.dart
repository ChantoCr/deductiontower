class RemoteMatchBootstrapPayload {
  const RemoteMatchBootstrapPayload({
    required this.roomCode,
    required this.matchId,
    required this.hostParticipantId,
    required this.guestParticipantId,
    required this.startingParticipantId,
    required this.hostPlayerName,
    required this.guestPlayerName,
    required this.hintsPerPlayer,
    required this.hostSecretTraitId,
    required this.guestSecretTraitId,
    required this.sharedCharacterPoolIds,
    required this.createdAt,
  });

  final String roomCode;
  final String matchId;
  final String hostParticipantId;
  final String guestParticipantId;
  final String startingParticipantId;
  final String hostPlayerName;
  final String guestPlayerName;
  final int hintsPerPlayer;
  final String hostSecretTraitId;
  final String guestSecretTraitId;
  final List<String> sharedCharacterPoolIds;
  final DateTime createdAt;

  List<String> get participantIds => [hostParticipantId, guestParticipantId];

  bool get hasRequiredParticipants =>
      hostParticipantId.isNotEmpty && guestParticipantId.isNotEmpty;

  bool get hasSecretsAssigned =>
      hostSecretTraitId.isNotEmpty && guestSecretTraitId.isNotEmpty;

  bool get hasPlayableCharacterPool => sharedCharacterPoolIds.isNotEmpty;

  bool get canStartMatch =>
      hasRequiredParticipants &&
      hasSecretsAssigned &&
      hasPlayableCharacterPool &&
      hintsPerPlayer >= 0 &&
      participantIds.contains(startingParticipantId);
}
