import 'package:anime_deduction_tower/features/online_multiplayer/data/config/online_backend_target.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/datasources/firebase_online_room_preview_datasource.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/datasources/mock_online_room_datasource.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/datasources/online_room_datasource.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/datasources/supabase_online_room_preview_datasource.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/repositories/online_room_repository_impl.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/repositories/online_room_repository.dart';
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
    case OnlineBackendTarget.supabasePreview:
      return SupabaseOnlineRoomPreviewDataSource();
  }
});

final onlineRoomRepositoryProvider = Provider<OnlineRoomRepository>(
  (ref) => OnlineRoomRepositoryImpl(
    dataSource: ref.watch(onlineRoomDataSourceProvider),
  ),
);

final onlineLobbyControllerProvider =
    StateNotifierProvider<OnlineLobbyController, OnlineLobbyState>(
  (ref) => OnlineLobbyController(
    repository: ref.watch(onlineRoomRepositoryProvider),
  ),
);
