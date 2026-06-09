import 'dart:math';

import 'package:anime_deduction_tower/features/online_multiplayer/data/datasources/mock_online_room_datasource.dart';
import 'package:anime_deduction_tower/features/online_multiplayer/data/repositories/online_room_repository_impl.dart';

class MockOnlineRoomRepositoryImpl extends OnlineRoomRepositoryImpl {
  MockOnlineRoomRepositoryImpl({Random? random})
      : super(dataSource: MockOnlineRoomDataSource(random: random));
}
