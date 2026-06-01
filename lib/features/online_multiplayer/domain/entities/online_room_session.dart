enum OnlineRoomPhase {
  waitingForOpponent,
  readyToSync,
}

class OnlineRoomSession {
  const OnlineRoomSession({
    required this.roomCode,
    required this.hostPlayerName,
    required this.isHost,
    required this.phase,
    required this.createdAt,
    this.guestPlayerName,
  });

  final String roomCode;
  final String hostPlayerName;
  final String? guestPlayerName;
  final bool isHost;
  final OnlineRoomPhase phase;
  final DateTime createdAt;

  bool get hasGuest => guestPlayerName != null && guestPlayerName!.isNotEmpty;

  OnlineRoomSession copyWith({
    String? roomCode,
    String? hostPlayerName,
    String? guestPlayerName,
    bool? isHost,
    OnlineRoomPhase? phase,
    DateTime? createdAt,
  }) {
    return OnlineRoomSession(
      roomCode: roomCode ?? this.roomCode,
      hostPlayerName: hostPlayerName ?? this.hostPlayerName,
      guestPlayerName: guestPlayerName ?? this.guestPlayerName,
      isHost: isHost ?? this.isHost,
      phase: phase ?? this.phase,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
