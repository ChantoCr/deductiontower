enum OnlineRoomParticipantRole {
  host,
  guest,
}

enum OnlineRoomParticipantConnectionState {
  localPreview,
  waitingRemote,
  connected,
}

class OnlineRoomParticipant {
  const OnlineRoomParticipant({
    required this.id,
    required this.displayName,
    required this.role,
    required this.connectionState,
    required this.isLocalPlayer,
    this.userId,
    this.isReady = false,
  });

  final String id;
  final String displayName;
  final OnlineRoomParticipantRole role;
  final OnlineRoomParticipantConnectionState connectionState;
  final bool isLocalPlayer;
  final String? userId;
  final bool isReady;

  OnlineRoomParticipant copyWith({
    String? id,
    String? displayName,
    OnlineRoomParticipantRole? role,
    OnlineRoomParticipantConnectionState? connectionState,
    bool? isLocalPlayer,
    String? userId,
    bool? isReady,
  }) {
    return OnlineRoomParticipant(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      connectionState: connectionState ?? this.connectionState,
      isLocalPlayer: isLocalPlayer ?? this.isLocalPlayer,
      userId: userId ?? this.userId,
      isReady: isReady ?? this.isReady,
    );
  }
}
