import 'package:anime_deduction_tower/features/flame_board/components/energy_background_component.dart';
import 'package:anime_deduction_tower/features/flame_board/components/particle_burst_component.dart';
import 'package:anime_deduction_tower/features/flame_board/components/tower_component.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class DeductionTowerGame extends FlameGame {
  DeductionTowerGame({
    this.celebrationMode = false,
    this.showTower = true,
  });

  final bool celebrationMode;
  final bool showTower;

  @override
  Color backgroundColor() => const Color(0xFF090A14);

  @override
  Future<void> onLoad() async {
    final components = <Component>[
      EnergyBackgroundComponent(celebrationMode: celebrationMode),
    ];

    if (showTower) {
      components.add(TowerComponent());
    }

    if (celebrationMode) {
      components.add(ParticleBurstComponent());
    }

    await addAll(components);
  }
}
