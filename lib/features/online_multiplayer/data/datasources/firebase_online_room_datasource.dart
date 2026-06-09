import 'dart:async';
import 'dart:math';

import 'package:anime_deduction_tower/app/firebase_app_initializer.dart';
import 'package:anime_deduction_tower/core/utils/id_generator.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/datasources/online_room_datasource.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_participant.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseOnlineRoomDataSource implements OnlineRoomDataSource {
  FirebaseOnlineRoomDataSource({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    Random? random,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _random = random ?? Random();

  static const roomCodeLength = 6;
  static const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final Random _random;

  CollectionReference<Map<String, dynamic>> get _roomsCollection =>
      _firestore.collection('online_rooms');

  @override
  String normalizeRoomCode(String value) {
    final uppercase = value.toUpperCase();
    final sanitized = uppercase.replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (sanitized.length <= roomCodeLength) {
      return sanitized;
    }

    return sanitized.substring(0, roomCodeLength);
  }

  @override
  OnlineRoomSession createRoom({required String hostPlayerName}) {
    throw UnsupportedError(
      'Use createRoomRealtime() when the Firebase backend target is enabled.',
    );
  }

  @override
  Future<OnlineRoomSession> createRoomRealtime({
    required String hostPlayerName,
  }) async {
    await FirebaseAppInitializer.ensureInitializedForOnlineBackend();
    final user = await _ensureSignedIn();
    final roomCode = await _generateUniqueRoomCode();
    final roomRef = _roomsCollection.doc(roomCode);
    final participantId = IdGenerator.next('online_host');
    final now = FieldValue.serverTimestamp();

    await roomRef.set({
      'roomCode': roomCode,
      'phase': 'waitingForOpponent',
      'createdAt': now,
      'updatedAt': now,
      'hostParticipantId': participantId,
      'guestParticipantId': null,
    });

    await roomRef.collection('participants').doc(participantId).set({
      'participantId': participantId,
      'userId': user.uid,
      'displayName': hostPlayerName.trim(),
      'role': 'host',
      'isReady': false,
      'connectionState': 'connected',
      'joinedAt': now,
      'lastSeenAt': now,
    });

    return _fetchSession(roomCode);
  }

  @override
  OnlineRoomSession joinRoomPreview({
    required String roomCode,
    required String guestPlayerName,
  }) {
    throw UnsupportedError(
      'Use joinRoomRealtime() when the Firebase backend target is enabled.',
    );
  }

  @override
  Future<OnlineRoomSession> joinRoomRealtime({
    required String roomCode,
    required String guestPlayerName,
  }) async {
    await FirebaseAppInitializer.ensureInitializedForOnlineBackend();
    final user = await _ensureSignedIn();
    final normalizedRoomCode = normalizeRoomCode(roomCode);
    final roomRef = _roomsCollection.doc(normalizedRoomCode);
    final roomSnapshot = await roomRef.get();

    if (!roomSnapshot.exists) {
      throw StateError('Room $normalizedRoomCode was not found.');
    }

    final participantsSnapshot = await roomRef.collection('participants').get();
    final participantDocs = participantsSnapshot.docs;
    final existingLocalDoc = participantDocs.where(
      (doc) => (doc.data()['userId'] as String?) == user.uid,
    );
    if (existingLocalDoc.isNotEmpty) {
      return _fetchSession(normalizedRoomCode);
    }

    final hasGuest = participantDocs.any(
      (doc) => (doc.data()['role'] as String?) == 'guest',
    );
    if (hasGuest) {
      throw StateError('Room $normalizedRoomCode already has a guest player.');
    }

    final participantId = IdGenerator.next('online_guest');
    final now = FieldValue.serverTimestamp();
    await roomRef.collection('participants').doc(participantId).set({
      'participantId': participantId,
      'userId': user.uid,
      'displayName': guestPlayerName.trim(),
      'role': 'guest',
      'isReady': false,
      'connectionState': 'connected',
      'joinedAt': now,
      'lastSeenAt': now,
    });

    await roomRef.update({
      'guestParticipantId': participantId,
      'phase': 'waitingForReady',
      'updatedAt': now,
    });

    return _fetchSession(normalizedRoomCode);
  }

  @override
  OnlineRoomSession setLocalParticipantReady({
    required OnlineRoomSession session,
    required bool isReady,
  }) {
    throw UnsupportedError(
      'Use setLocalParticipantReadyRealtime() when the Firebase backend target is enabled.',
    );
  }

  @override
  Future<OnlineRoomSession> setLocalParticipantReadyRealtime({
    required OnlineRoomSession session,
    required bool isReady,
  }) async {
    await FirebaseAppInitializer.ensureInitializedForOnlineBackend();
    final roomRef = _roomsCollection.doc(session.roomCode);
    final now = FieldValue.serverTimestamp();

    await roomRef
        .collection('participants')
        .doc(session.localParticipantId)
        .update({
      'isReady': isReady,
      'lastSeenAt': now,
    });

    final participantsSnapshot = await roomRef.collection('participants').get();
    final allReady = participantsSnapshot.docs.isNotEmpty &&
        participantsSnapshot.docs.every(
          (doc) => (doc.data()['isReady'] as bool?) ?? false,
        );
    final hasGuest = participantsSnapshot.docs.any(
      (doc) => (doc.data()['role'] as String?) == 'guest',
    );

    await roomRef.update({
      'phase': allReady
          ? 'readyToSync'
          : hasGuest
              ? 'waitingForReady'
              : 'waitingForOpponent',
      'updatedAt': now,
    });

    return _fetchSession(session.roomCode);
  }

  @override
  OnlineRoomSession simulateRemoteGuestJoin({
    required OnlineRoomSession session,
    String guestPlayerName = 'Remote Guest',
  }) {
    throw UnsupportedError(
      'Mock remote guest simulation is not available in the Firebase backend datasource.',
    );
  }

  @override
  OnlineRoomSession setRemoteParticipantReady({
    required OnlineRoomSession session,
    required String participantId,
    required bool isReady,
  }) {
    throw UnsupportedError(
      'Mock remote ready simulation is not available in the Firebase backend datasource.',
    );
  }

  @override
  Stream<OnlineRoomSession> watchRoom(String roomCode) {
    final normalizedRoomCode = normalizeRoomCode(roomCode);
    final roomRef = _roomsCollection.doc(normalizedRoomCode);

    return Stream.multi((controller) async {
      await FirebaseAppInitializer.ensureInitializedForOnlineBackend();
      await _ensureSignedIn();

      Map<String, dynamic>? roomData;
      List<QueryDocumentSnapshot<Map<String, dynamic>>> participantDocs = const [];

      void emitIfReady() {
        if (roomData == null || participantDocs.isEmpty) {
          return;
        }

        try {
          controller.add(
            _mapSession(
              roomCode: normalizedRoomCode,
              roomData: roomData!,
              participantDocs: participantDocs,
            ),
          );
        } catch (error, stackTrace) {
          controller.addError(error, stackTrace);
        }
      }

      final roomSub = roomRef.snapshots().listen(
        (snapshot) {
          if (!snapshot.exists) {
            controller.addError(
              StateError('Room $normalizedRoomCode is no longer available.'),
            );
            return;
          }

          roomData = snapshot.data();
          emitIfReady();
        },
        onError: controller.addError,
      );

      final participantSub = roomRef.collection('participants').snapshots().listen(
        (snapshot) {
          participantDocs = snapshot.docs;
          emitIfReady();
        },
        onError: controller.addError,
      );

      controller.onCancel = () async {
        await roomSub.cancel();
        await participantSub.cancel();
      };
    });
  }

  Future<User> _ensureSignedIn() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      return currentUser;
    }

    final credential = await _auth.signInAnonymously();
    final user = credential.user;
    if (user == null) {
      throw StateError('Anonymous Firebase sign-in failed.');
    }

    return user;
  }

  Future<OnlineRoomSession> _fetchSession(String roomCode) async {
    final roomRef = _roomsCollection.doc(roomCode);
    final roomSnapshot = await roomRef.get();
    if (!roomSnapshot.exists) {
      throw StateError('Room $roomCode was not found.');
    }

    final participantsSnapshot = await roomRef.collection('participants').get();
    return _mapSession(
      roomCode: roomCode,
      roomData: roomSnapshot.data() ?? const {},
      participantDocs: participantsSnapshot.docs,
    );
  }

  OnlineRoomSession _mapSession({
    required String roomCode,
    required Map<String, dynamic> roomData,
    required List<QueryDocumentSnapshot<Map<String, dynamic>>> participantDocs,
  }) {
    final currentUserId = _auth.currentUser?.uid;
    final participants = participantDocs.map((doc) {
      final data = doc.data();
      final userId = data['userId'] as String?;
      return OnlineRoomParticipant(
        id: data['participantId'] as String? ?? doc.id,
        displayName: data['displayName'] as String? ?? 'Unknown Player',
        role: _parseRole(data['role'] as String?),
        connectionState: _parseConnectionState(
          data['connectionState'] as String?,
        ),
        isLocalPlayer: currentUserId != null && userId == currentUserId,
        isReady: data['isReady'] as bool? ?? false,
      );
    }).toList();

    final localParticipant = participants.where((participant) => participant.isLocalPlayer);
    if (localParticipant.isEmpty) {
      throw StateError(
        'The signed-in Firebase user is not part of room $roomCode.',
      );
    }

    final createdAtTimestamp = roomData['createdAt'];
    return OnlineRoomSession(
      roomCode: roomCode,
      localParticipantId: localParticipant.first.id,
      participants: participants,
      phase: _parsePhase(roomData['phase'] as String?),
      createdAt: createdAtTimestamp is Timestamp
          ? createdAtTimestamp.toDate()
          : DateTime.now(),
    );
  }

  OnlineRoomParticipantRole _parseRole(String? value) {
    switch (value) {
      case 'guest':
        return OnlineRoomParticipantRole.guest;
      case 'host':
      case null:
        return OnlineRoomParticipantRole.host;
      default:
        return OnlineRoomParticipantRole.host;
    }
  }

  OnlineRoomParticipantConnectionState _parseConnectionState(String? value) {
    switch (value) {
      case 'waitingRemote':
        return OnlineRoomParticipantConnectionState.waitingRemote;
      case 'connected':
      case null:
        return OnlineRoomParticipantConnectionState.connected;
      case 'localPreview':
        return OnlineRoomParticipantConnectionState.localPreview;
      default:
        return OnlineRoomParticipantConnectionState.connected;
    }
  }

  OnlineRoomPhase _parsePhase(String? value) {
    switch (value) {
      case 'waitingForReady':
        return OnlineRoomPhase.waitingForReady;
      case 'readyToSync':
        return OnlineRoomPhase.readyToSync;
      case 'waitingForOpponent':
      case null:
        return OnlineRoomPhase.waitingForOpponent;
      default:
        return OnlineRoomPhase.waitingForOpponent;
    }
  }

  Future<String> _generateUniqueRoomCode() async {
    for (var attempt = 0; attempt < 10; attempt++) {
      final roomCode = _generateRoomCode();
      final snapshot = await _roomsCollection.doc(roomCode).get();
      if (!snapshot.exists) {
        return roomCode;
      }
    }

    throw StateError('Could not generate a unique Firebase room code.');
  }

  String _generateRoomCode() {
    final buffer = StringBuffer();
    for (var index = 0; index < roomCodeLength; index++) {
      final charIndex = _random.nextInt(alphabet.length);
      buffer.write(alphabet[charIndex]);
    }

    return buffer.toString();
  }
}
