import 'package:anime_deduction_tower/features/characters/presentation/providers/character_providers.dart';
import 'package:anime_deduction_tower/features/game/presentation/providers/trait_category_providers.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/config/online_backend_target.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/datasources/firebase_online_room_datasource.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/datasources/firebase_online_room_preview_datasource.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/datasources/mock_online_room_datasource.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/datasources/online_room_datasource.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/datasources/supabase_online_room_preview_datasource.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/repositories/online_room_repository_impl.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/online_room_session.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/entities/remote_match_bootstrap_result.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/repositories/online_room_repository.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/services/remote_match_bootstrap_service.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/services/remote_match_preview_seed_service.dart';
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
      return FirebaseOnlineRoomDataSource();
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

  if (session.phase != OnlineRoomPhase.readyToSync || !session.isEveryoneReady) {
    return null;
  }

  final validation = await ref.watch(validatedTraitCatalogProvider.future);
  if (validation.validCategories.isEmpty) {
    throw StateError('No valid trait categories are available for preview.');
  }

  final characters = await ref.watch(charactersProvider.future);
  final playerSeeds = ref.watch(remoteMatchPreviewSeedServiceProvider).buildSeeds(
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
