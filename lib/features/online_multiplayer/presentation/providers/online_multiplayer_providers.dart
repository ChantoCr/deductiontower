import 'package:anime_deduction_tower/features/online_multiplayer/data/repositories/mock_online_room_repository_impl.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/domain/repositories/online_room_repository.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/presentation/controllers/online_lobby_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final onlineRoomRepositoryProvider = Provider<OnlineRoomRepository>(
  (ref) => MockOnlineRoomRepositoryImpl(),
);

final onlineLobbyControllerProvider =
    StateNotifierProvider<OnlineLobbyController, OnlineLobbyState>(
  (ref) => OnlineLobbyController(
    repository: ref.watch(onlineRoomRepositoryProvider),
  ),
);
