import 'package:anime_deduction_tower/features/flame_board/components/energy_background_component.dart';
import 'package:anime_deduction_tower/features/flame_board/components/tower_component.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class DeductionTowerGame extends FlameGame {
  @override
  Color backgroundColor() => const Color(0xFF090A14);

  @override
  Future<void> onLoad() async {
    await addAll([
      EnergyBackgroundComponent(),
      TowerComponent(),
    ]);
  }
}
