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
    this.isReady = false,
  });

  final String id;
  final String displayName;
  final OnlineRoomParticipantRole role;
  final OnlineRoomParticipantConnectionState connectionState;
  final bool isLocalPlayer;
  final bool isReady;

  OnlineRoomParticipant copyWith({
    String? id,
    String? displayName,
    OnlineRoomParticipantRole? role,
    OnlineRoomParticipantConnectionState? connectionState,
    bool? isLocalPlayer,
    bool? isReady,
  }) {
    return OnlineRoomParticipant(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      connectionState: connectionState ?? this.connectionState,
      isLocalPlayer: isLocalPlayer ?? this.isLocalPlayer,
      isReady: isReady ?? this.isReady,
    );
  }
}
