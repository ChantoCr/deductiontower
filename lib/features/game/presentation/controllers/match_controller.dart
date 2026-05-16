import 'package:anime_deduction_tower/features/game/domain/entities/game_match.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MatchController extends StateNotifier<GameMatch?> {
  MatchController() : super(null);

  void setMatch(GameMatch match) => state = match;
  void clear() => state = null;
}

final matchControllerProvider = StateNotifierProvider<MatchController, GameMatch?>(
  (ref) => MatchController(),
);
