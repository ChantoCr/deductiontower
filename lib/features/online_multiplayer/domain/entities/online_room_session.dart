import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_participant.dart';

enum OnlineRoomPhase {
  waitingForOpponent,
  waitingForReady,
  readyToSync,
}

class OnlineRoomSession {
  const OnlineRoomSession({
    required this.roomCode,
    required this.localParticipantId,
    required this.participants,
    required this.phase,
    required this.createdAt,
  });

  final String roomCode;
  final String localParticipantId;
  final List<OnlineRoomParticipant> participants;
  final OnlineRoomPhase phase;
  final DateTime createdAt;

  OnlineRoomParticipant get localParticipant => participants.firstWhere(
        (participant) => participant.id == localParticipantId,
      );

  OnlineRoomParticipant? get hostParticipant {
    for (final participant in participants) {
      if (participant.role == OnlineRoomParticipantRole.host) {
        return participant;
      }
    }

    return null;
  }

  OnlineRoomParticipant? get guestParticipant {
    for (final participant in participants) {
      if (participant.role == OnlineRoomParticipantRole.guest) {
        return participant;
      }
    }

    return null;
  }

  bool get isHost => localParticipant.role == OnlineRoomParticipantRole.host;

  List<OnlineRoomParticipant> get remoteParticipants => participants
      .where((participant) => !participant.isLocalPlayer)
      .toList(growable: false);

  OnlineRoomParticipant? get primaryRemoteParticipant {
    if (remoteParticipants.isEmpty) {
      return null;
    }

    return remoteParticipants.first;
  }

  bool get hasGuest => guestParticipant != null;

  int get participantCount => participants.length;

  String get hostPlayerName => hostParticipant?.displayName ?? 'Unknown Host';

  String? get guestPlayerName => guestParticipant?.displayName;

  bool get isEveryoneReady =>
      participants.isNotEmpty &&
      participants.every((participant) => participant.isReady);

  OnlineRoomSession copyWith({
    String? roomCode,
    String? localParticipantId,
    List<OnlineRoomParticipant>? participants,
    OnlineRoomPhase? phase,
    DateTime? createdAt,
  }) {
    return OnlineRoomSession(
      roomCode: roomCode ?? this.roomCode,
      localParticipantId: localParticipantId ?? this.localParticipantId,
      participants: participants ?? this.participants,
      phase: phase ?? this.phase,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
