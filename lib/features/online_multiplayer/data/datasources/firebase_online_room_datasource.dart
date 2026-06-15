import 'dart:async';
import 'dart:math';

import 'package:anime_deduction_tower/app/firebase_app_initializer.dart';
import 'package:anime_deduction_tower/core/utils/id_generator.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/datasources/online_room_datasource.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/models/online_player_action_model.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/models/remote_match_bootstrap_payload_model.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/models/remote_match_public_state_model.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/models/remote_player_private_state_model.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/services/remote_match_firestore_bundle_builder.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_player_action.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_participant.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_session.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_handoff_snapshot.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/services/remote_match_bootstrap_service.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/services/remote_match_preview_seed_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseOnlineRoomDataSource implements OnlineRoomDataSource {
  FirebaseOnlineRoomDataSource({
    required Future<List<TraitCategory>> Function() loadValidCategories,
    required Future<List<Character>> Function() loadCharacters,
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    Random? random,
    RemoteMatchBootstrapService? bootstrapService,
    RemoteMatchPreviewSeedService? previewSeedService,
    RemoteMatchFirestoreBundleBuilder? firestoreBundleBuilder,
    int hintsPerPlayer = 2,
  })  : _loadValidCategories = loadValidCategories,
        _loadCharacters = loadCharacters,
        _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _random = random ?? Random(),
        _bootstrapService = bootstrapService ?? const RemoteMatchBootstrapService(),
        _previewSeedService = previewSeedService ?? const RemoteMatchPreviewSeedService(),
        _firestoreBundleBuilder = firestoreBundleBuilder ??
            const RemoteMatchFirestoreBundleBuilder(),
        _hintsPerPlayer = hintsPerPlayer;

  static const roomCodeLength = 6;
  static const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  static const _currentDocumentId = 'current';

  final Future<List<TraitCategory>> Function() _loadValidCategories;
  final Future<List<Character>> Function() _loadCharacters;
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final Random _random;
  final RemoteMatchBootstrapService _bootstrapService;
  final RemoteMatchPreviewSeedService _previewSeedService;
  final RemoteMatchFirestoreBundleBuilder _firestoreBundleBuilder;
  final int _hintsPerPlayer;

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

    final updatedSession = await _fetchSession(session.roomCode);
    if (updatedSession.phase == OnlineRoomPhase.readyToSync &&
        updatedSession.isEveryoneReady) {
      await _persistBootstrapDocumentsIfNeeded(updatedSession);
    }

    return updatedSession;
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

  @override
  Stream<RemoteMatchHandoffSnapshot?> watchMatchHandoff({
    required String roomCode,
    required String participantId,
  }) {
    final normalizedRoomCode = normalizeRoomCode(roomCode);
    final roomRef = _roomsCollection.doc(normalizedRoomCode);

    return Stream.multi((controller) async {
      await FirebaseAppInitializer.ensureInitializedForOnlineBackend();
      await _ensureSignedIn();

      Map<String, dynamic>? bootstrapData;
      Map<String, dynamic>? publicStateData;
      Map<String, dynamic>? privateStateData;
      var hasBootstrapSnapshot = false;
      var hasPublicStateSnapshot = false;
      var hasPrivateStateSnapshot = false;

      void emitIfReady() {
        if (!hasBootstrapSnapshot ||
            !hasPublicStateSnapshot ||
            !hasPrivateStateSnapshot) {
          return;
        }

        if (bootstrapData == null &&
            publicStateData == null &&
            privateStateData == null) {
          controller.add(null);
          return;
        }

        try {
          controller.add(
            RemoteMatchHandoffSnapshot(
              roomCode: normalizedRoomCode,
              localParticipantId: participantId,
              bootstrapPayload: bootstrapData == null
                  ? null
                  : RemoteMatchBootstrapPayloadModel.fromJson(
                      bootstrapData!,
                    ).toEntity(),
              publicState: publicStateData == null
                  ? null
                  : RemoteMatchPublicStateModel.fromJson(
                      publicStateData!,
                    ).toEntity(),
              privateState: privateStateData == null
                  ? null
                  : RemotePlayerPrivateStateModel.fromJson(
                      privateStateData!,
                    ).toEntity(),
            ),
          );
        } catch (error, stackTrace) {
          controller.addError(error, stackTrace);
        }
      }

      final bootstrapSub = roomRef
          .collection('match_bootstrap')
          .doc(_currentDocumentId)
          .snapshots()
          .listen(
        (snapshot) {
          hasBootstrapSnapshot = true;
          bootstrapData = snapshot.data();
          emitIfReady();
        },
        onError: controller.addError,
      );

      final publicStateSub = roomRef
          .collection('match_public')
          .doc(_currentDocumentId)
          .snapshots()
          .listen(
        (snapshot) {
          hasPublicStateSnapshot = true;
          publicStateData = snapshot.data();
          emitIfReady();
        },
        onError: controller.addError,
      );

      final privateStateSub = roomRef
          .collection('private_player_state')
          .doc(participantId)
          .snapshots()
          .listen(
        (snapshot) {
          hasPrivateStateSnapshot = true;
          privateStateData = snapshot.data();
          emitIfReady();
        },
        onError: controller.addError,
      );

      controller.onCancel = () async {
        await bootstrapSub.cancel();
        await publicStateSub.cancel();
        await privateStateSub.cancel();
      };
    });
  }

  @override
  Future<OnlinePlayerAction> submitPlayerAction({
    required String roomCode,
    required OnlinePlayerAction action,
  }) async {
    await FirebaseAppInitializer.ensureInitializedForOnlineBackend();
    final user = await _ensureSignedIn();
    final normalizedRoomCode = normalizeRoomCode(roomCode);
    final roomRef = _roomsCollection.doc(normalizedRoomCode);

    if (action.submittedByUserId != user.uid) {
      throw StateError('Queued action user id does not match the signed-in Firebase user.');
    }

    final publicMatchDoc =
        await roomRef.collection('match_public').doc(_currentDocumentId).get();
    if (!publicMatchDoc.exists) {
      throw StateError(
        'Remote match bootstrap is not ready yet for room $normalizedRoomCode.',
      );
    }

    final model = OnlinePlayerActionModel.fromEntity(action);
    await roomRef.collection('player_actions').doc(action.actionId).set(model.toJson());
    return action;
  }

  @override
  Stream<List<OnlinePlayerAction>> watchPlayerActions(String roomCode) {
    final normalizedRoomCode = normalizeRoomCode(roomCode);
    final roomRef = _roomsCollection.doc(normalizedRoomCode);

    return Stream.multi((controller) async {
      await FirebaseAppInitializer.ensureInitializedForOnlineBackend();
      await _ensureSignedIn();

      final actionSub = roomRef.collection('player_actions').snapshots().listen(
        (snapshot) {
          try {
            final actions = snapshot.docs
                .map((doc) => OnlinePlayerActionModel.fromJson(doc.data()).toEntity())
                .toList()
              ..sort((left, right) => right.createdAt.compareTo(left.createdAt));
            controller.add(actions);
          } catch (error, stackTrace) {
            controller.addError(error, stackTrace);
          }
        },
        onError: controller.addError,
      );

      controller.onCancel = () async {
        await actionSub.cancel();
      };
    });
  }

  Future<void> _persistBootstrapDocumentsIfNeeded(
    OnlineRoomSession session,
  ) async {
    final roomRef = _roomsCollection.doc(session.roomCode);
    final publicMatchDoc =
        await roomRef.collection('match_public').doc(_currentDocumentId).get();
    if (publicMatchDoc.exists) {
      return;
    }

    final categories = await _loadValidCategories();
    if (categories.isEmpty) {
      throw StateError(
        'No valid trait categories are available for Firebase bootstrap.',
      );
    }

    final characters = await _loadCharacters();
    final participantUserIds = await _loadParticipantUserIds(roomRef);
    final bootstrapCreatedAt = session.createdAt.toUtc();
    final bootstrapSeeds = _previewSeedService.buildSeeds(
      room: session,
      validCategories: categories,
      participantUserIds: participantUserIds,
    );
    final bootstrapResult = _bootstrapService.build(
      room: session,
      hintsPerPlayer: _hintsPerPlayer,
      playerSeeds: bootstrapSeeds,
      categories: categories,
      characters: characters,
      matchId: _matchIdForRoom(session.roomCode),
      createdAt: bootstrapCreatedAt,
    );
    final bundle = _firestoreBundleBuilder.build(bootstrapResult);

    final batch = _firestore.batch();
    batch.set(
      roomRef.collection('match_bootstrap').doc(_currentDocumentId),
      bundle.bootstrapDocument,
    );
    batch.set(
      roomRef.collection('match_public').doc(_currentDocumentId),
      bundle.publicMatchDocument,
    );
    for (final entry in bundle.privatePlayerDocuments.entries) {
      batch.set(
        roomRef.collection('private_player_state').doc(entry.key),
        entry.value,
      );
    }
    batch.set(
      roomRef,
      {
        ...bundle.roomDocumentPatch,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    await batch.commit();
  }

  Future<Map<String, String>> _loadParticipantUserIds(
    DocumentReference<Map<String, dynamic>> roomRef,
  ) async {
    final participantsSnapshot = await roomRef.collection('participants').get();
    final participantUserIds = <String, String>{};

    for (final participantDoc in participantsSnapshot.docs) {
      final data = participantDoc.data();
      final participantId = data['participantId'] as String? ?? participantDoc.id;
      final userId = (data['userId'] as String?)?.trim();
      if (userId != null && userId.isNotEmpty) {
        participantUserIds[participantId] = userId;
      }
    }

    return participantUserIds;
  }

  String _matchIdForRoom(String roomCode) {
    return 'match_$roomCode';
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
