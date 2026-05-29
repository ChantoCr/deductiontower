import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

class EnergyBackgroundComponent extends PositionComponent
    with HasGameReference<FlameGame> {
  EnergyBackgroundComponent({this.celebrationMode = false});

  final bool celebrationMode;
  final math.Random _random = math.Random(7);
  final List<_EnergyOrb> _orbs = [];

  @override
  Future<void> onLoad() async {
    size = game.size;
    _seedOrbs();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
    if (_orbs.isEmpty) {
      _seedOrbs();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    for (final orb in _orbs) {
      orb.position += orb.velocity * dt;

      if (orb.position.x < -orb.radius) {
        orb.position = Vector2(size.x + orb.radius, orb.position.y);
      } else if (orb.position.x > size.x + orb.radius) {
        orb.position = Vector2(-orb.radius, orb.position.y);
      }

      if (orb.position.y < -orb.radius) {
        orb.position = Vector2(orb.position.x, size.y + orb.radius);
      } else if (orb.position.y > size.y + orb.radius) {
        orb.position = Vector2(orb.position.x, -orb.radius);
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final backgroundPaint = Paint()
      ..shader = Gradient.linear(
        Offset.zero,
        Offset(size.x, size.y),
        const [
          Color(0x2206B6D4),
          Color(0x118B5CF6),
          Color(0x22090A14),
        ],
      );

    canvas.drawRect(Offset.zero & Size(size.x, size.y), backgroundPaint);

    for (final orb in _orbs) {
      final paint = Paint()..color = orb.color.withValues(alpha: orb.opacity);
      canvas.drawCircle(
        Offset(orb.position.x, orb.position.y),
        orb.radius,
        paint,
      );
    }
  }

  void _seedOrbs() {
    if (size.x <= 0 || size.y <= 0) {
      return;
    }

    _orbs
      ..clear()
      ..addAll(
        List.generate(
          celebrationMode ? 18 : 10,
          (_) => _EnergyOrb(
            position: Vector2(
              _random.nextDouble() * size.x,
              _random.nextDouble() * size.y,
            ),
            velocity: Vector2(
              (_random.nextDouble() - 0.5) * (celebrationMode ? 26 : 14),
              (_random.nextDouble() - 0.5) * (celebrationMode ? 18 : 10),
            ),
            radius: celebrationMode
                ? 8 + (_random.nextDouble() * 18)
                : 10 + (_random.nextDouble() * 22),
            color: _random.nextBool()
                ? const Color(0xFF06B6D4)
                : const Color(0xFF8B5CF6),
            opacity: celebrationMode
                ? 0.08 + (_random.nextDouble() * 0.12)
                : 0.04 + (_random.nextDouble() * 0.08),
          ),
        ),
      );
  }
}

class _EnergyOrb {
  _EnergyOrb({
    required this.position,
    required this.velocity,
    required this.radius,
    required this.color,
    required this.opacity,
  });

  Vector2 position;
  final Vector2 velocity;
  final double radius;
  final Color color;
  final double opacity;
}
