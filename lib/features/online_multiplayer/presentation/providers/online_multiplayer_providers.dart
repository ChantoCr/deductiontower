import 'package:anime_deduction_tower/features/characters/presentation/providers/character_providers.dart';
import 'package:anime_deduction_tower/features/game/presentation/providers/trait_category_providers.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/config/online_backend_target.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/datasources/firebase_online_room_datasource.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/datasources/firebase_online_room_preview_datasource.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/datasources/mock_online_room_datasource.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/datasources/online_room_datasource.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/datasources/supabase_online_room_preview_datasource.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/repositories/online_room_repository_impl.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/services/remote_match_firestore_bundle_builder.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_action_resolution_authority.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_player_action.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_session.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_bootstrap_result.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_handoff_snapshot.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_public_event.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_screen_state.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/repositories/online_room_repository.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/services/online_action_resolution_policy.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/services/remote_match_action_factory.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/services/remote_match_action_resolver.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/services/remote_match_bootstrap_service.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/services/remote_match_preview_seed_service.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/services/remote_match_screen_state_loader.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/presentation/controllers/online_action_queue_controller.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/presentation/controllers/online_action_resolution_controller.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/presentation/controllers/online_lobby_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final onlineBackendTargetProvider = Provider<OnlineBackendTarget>(
  (ref) => OnlineBackendTarget.mockPreview,
);

final onlineRoomDataSourceProvider = Provider<OnlineRoomDataSource>((ref) {
  switch (ref.watch(onlineBackendTargetProvider)) {
    case OnlineBackendTarget.mockPreview:
      return MockOnlineRoomDataSource();
    case OnlineBackendTarget.firebasePreview:
      return FirebaseOnlineRoomPreviewDataSource();
    case OnlineBackendTarget.firebaseBackend:
      final bootstrapService = ref.watch(remoteMatchBootstrapServiceProvider);
      final previewSeedService = ref.watch(
        remoteMatchPreviewSeedServiceProvider,
      );
      final hintsPerPlayer = ref.watch(onlinePreviewHintsPerPlayerProvider);
      final enableBackendAuthorityResolution = ref.watch(
        onlineUseBackendResolutionAuthorityProvider,
      );
      return FirebaseOnlineRoomDataSource(
        loadValidCategories: () async {
          final validation =
              await ref.read(validatedTraitCatalogProvider.future);
          return validation.validCategories;
        },
        loadCharacters: () => ref.read(charactersProvider.future),
        bootstrapService: bootstrapService,
        previewSeedService: previewSeedService,
        firestoreBundleBuilder: const RemoteMatchFirestoreBundleBuilder(),
        enableBackendAuthorityResolution: enableBackendAuthorityResolution,
        hintsPerPlayer: hintsPerPlayer,
      );
    case OnlineBackendTarget.supabasePreview:
      return SupabaseOnlineRoomPreviewDataSource();
  }
});

final onlineRoomRepositoryProvider = Provider<OnlineRoomRepository>(
  (ref) => OnlineRoomRepositoryImpl(
    dataSource: ref.watch(onlineRoomDataSourceProvider),
  ),
);

final remoteMatchBootstrapServiceProvider =
    Provider<RemoteMatchBootstrapService>(
  (ref) => const RemoteMatchBootstrapService(),
);

final remoteMatchPreviewSeedServiceProvider =
    Provider<RemoteMatchPreviewSeedService>(
  (ref) => const RemoteMatchPreviewSeedService(),
);

final onlinePreviewHintsPerPlayerProvider = Provider<int>((ref) => 2);

final remoteMatchScreenStateLoaderProvider =
    Provider<RemoteMatchScreenStateLoader>(
  (ref) => const RemoteMatchScreenStateLoader(),
);

final remoteMatchActionFactoryProvider = Provider<RemoteMatchActionFactory>(
  (ref) => const RemoteMatchActionFactory(),
);

final remoteMatchActionResolverProvider = Provider<RemoteMatchActionResolver>(
  (ref) => const RemoteMatchActionResolver(),
);

final onlineUseBackendResolutionAuthorityProvider = Provider<bool>(
  (ref) => false,
);

final onlineActionResolutionAuthorityProvider =
    Provider<OnlineActionResolutionAuthority>((ref) {
  final backendTarget = ref.watch(onlineBackendTargetProvider);
  final useBackendAuthority = ref.watch(
    onlineUseBackendResolutionAuthorityProvider,
  );

  if (useBackendAuthority &&
      backendTarget == OnlineBackendTarget.firebaseBackend) {
    return OnlineActionResolutionAuthority.backendService;
  }

  return OnlineActionResolutionAuthority.hostClient;
});

final onlineActionResolutionPolicyProvider =
    Provider<OnlineActionResolutionPolicy>(
  (ref) => const OnlineActionResolutionPolicy(),
);

final onlineCanResolveQueuedActionsProvider = Provider<bool>((ref) {
  final session = ref.watch(
    onlineLobbyControllerProvider.select((state) => state.activeSession),
  );
  return ref
      .watch(onlineActionResolutionPolicyProvider)
      .canLocalClientResolveQueuedActions(
        authority: ref.watch(onlineActionResolutionAuthorityProvider),
        session: session,
      );
});

final onlineActionQueueControllerProvider =
    Provider<OnlineActionQueueController>(
  (ref) => OnlineActionQueueController(
    repository: ref.watch(onlineRoomRepositoryProvider),
    actionFactory: ref.watch(remoteMatchActionFactoryProvider),
  ),
);

final onlineActionResolutionControllerProvider =
    Provider<OnlineActionResolutionController>(
  (ref) => OnlineActionResolutionController(
    repository: ref.watch(onlineRoomRepositoryProvider),
    actionResolver: ref.watch(remoteMatchActionResolverProvider),
    resolutionPolicy: ref.watch(onlineActionResolutionPolicyProvider),
    resolutionAuthority: ref.watch(onlineActionResolutionAuthorityProvider),
    loadValidCategories: () async {
      final validation = await ref.read(validatedTraitCatalogProvider.future);
      return validation.validCategories;
    },
    loadCharacters: () => ref.read(charactersProvider.future),
  ),
);

final onlineLobbyControllerProvider =
    StateNotifierProvider<OnlineLobbyController, OnlineLobbyState>(
  (ref) => OnlineLobbyController(
    repository: ref.watch(onlineRoomRepositoryProvider),
  ),
);

final remoteMatchBootstrapPreviewProvider =
    FutureProvider<RemoteMatchBootstrapResult?>((ref) async {
  final session = ref.watch(
    onlineLobbyControllerProvider.select((state) => state.activeSession),
  );
  if (session == null || !session.hasGuest) {
    return null;
  }

  if (session.phase != OnlineRoomPhase.readyToSync ||
      !session.isEveryoneReady) {
    return null;
  }

  final validation = await ref.watch(validatedTraitCatalogProvider.future);
  if (validation.validCategories.isEmpty) {
    throw StateError('No valid trait categories are available for preview.');
  }

  final characters = await ref.watch(charactersProvider.future);
  final playerSeeds =
      ref.watch(remoteMatchPreviewSeedServiceProvider).buildSeeds(
            room: session,
            validCategories: validation.validCategories,
          );

  return ref.watch(remoteMatchBootstrapServiceProvider).build(
        room: session,
        hintsPerPlayer: ref.watch(onlinePreviewHintsPerPlayerProvider),
        playerSeeds: playerSeeds,
        categories: validation.validCategories,
        characters: characters,
      );
});

final remoteMatchHandoffProvider =
    StreamProvider<RemoteMatchHandoffSnapshot?>((ref) {
  final backendTarget = ref.watch(onlineBackendTargetProvider);
  final session = ref.watch(
    onlineLobbyControllerProvider.select((state) => state.activeSession),
  );

  if (backendTarget != OnlineBackendTarget.firebaseBackend || session == null) {
    return Stream.value(null);
  }

  return ref.watch(onlineRoomRepositoryProvider).watchMatchHandoff(
        roomCode: session.roomCode,
        participantId: session.localParticipantId,
      );
});

final remoteMatchScreenStateProvider =
    StreamProvider<RemoteMatchScreenState?>((ref) {
  final backendTarget = ref.watch(onlineBackendTargetProvider);
  final session = ref.watch(
    onlineLobbyControllerProvider.select((state) => state.activeSession),
  );

  if (backendTarget != OnlineBackendTarget.firebaseBackend || session == null) {
    return Stream.value(null);
  }

  final loader = ref.watch(remoteMatchScreenStateLoaderProvider);

  return ref
      .watch(onlineRoomRepositoryProvider)
      .watchMatchHandoff(
        roomCode: session.roomCode,
        participantId: session.localParticipantId,
      )
      .asyncMap((handoff) async {
    if (handoff == null || !handoff.isComplete) {
      return null;
    }

    final validation = await ref.read(validatedTraitCatalogProvider.future);
    final categories = validation.validCategories;
    final characters = await ref.read(charactersProvider.future);

    return loader.load(
      handoff: handoff,
      categories: categories,
      characters: characters,
    );
  });
});

final onlinePlayerActionsProvider =
    StreamProvider<List<OnlinePlayerAction>>((ref) {
  final backendTarget = ref.watch(onlineBackendTargetProvider);
  final session = ref.watch(
    onlineLobbyControllerProvider.select((state) => state.activeSession),
  );

  if (backendTarget != OnlineBackendTarget.firebaseBackend || session == null) {
    return Stream.value(const <OnlinePlayerAction>[]);
  }

  return ref.watch(onlineRoomRepositoryProvider).watchPlayerActions(
        session.roomCode,
      );
});

final onlinePublicEventsProvider =
    StreamProvider<List<RemoteMatchPublicEvent>>((ref) {
  final backendTarget = ref.watch(onlineBackendTargetProvider);
  final session = ref.watch(
    onlineLobbyControllerProvider.select((state) => state.activeSession),
  );

  if (backendTarget != OnlineBackendTarget.firebaseBackend || session == null) {
    return Stream.value(const <RemoteMatchPublicEvent>[]);
  }

  return ref.watch(onlineRoomRepositoryProvider).watchPublicEvents(
        session.roomCode,
      );
});
