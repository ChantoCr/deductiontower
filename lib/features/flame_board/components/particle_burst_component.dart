import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

class ParticleBurstComponent extends PositionComponent
    with HasGameReference<FlameGame> {
  ParticleBurstComponent();

  final math.Random _random = math.Random(19);
  final List<_BurstParticle> _particles = [];
  double _spawnTimer = 0;

  @override
  Future<void> onLoad() async {
    size = game.size;
    _spawnBurst();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _spawnTimer += dt;

    for (final particle in _particles) {
      particle.age += dt;
      particle.position += particle.velocity * dt;
    }

    _particles.removeWhere((particle) => particle.age >= particle.maxAge);

    if (_spawnTimer >= 1.2) {
      _spawnTimer = 0;
      _spawnBurst();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    for (final particle in _particles) {
      final progress = particle.age / particle.maxAge;
      final alpha = (1 - progress).clamp(0.0, 1.0) * particle.opacity;
      final paint = Paint()..color = particle.color.withValues(alpha: alpha);
      canvas.drawCircle(
        Offset(particle.position.x, particle.position.y),
        particle.radius * (1 - (progress * 0.2)),
        paint,
      );
    }
  }

  void _spawnBurst() {
    if (size.x <= 0 || size.y <= 0) {
      return;
    }

    final origin = Vector2(
      size.x * (0.2 + (_random.nextDouble() * 0.6)),
      size.y * (0.18 + (_random.nextDouble() * 0.22)),
    );

    for (var i = 0; i < 14; i++) {
      final angle = (_random.nextDouble() * math.pi) - (math.pi / 2);
      final speed = 20 + (_random.nextDouble() * 34);
      _particles.add(
        _BurstParticle(
          position: origin.clone(),
          velocity: Vector2(math.cos(angle) * speed, math.sin(angle) * speed),
          radius: 2 + (_random.nextDouble() * 3.5),
          color: _random.nextBool()
              ? const Color(0xFF22C55E)
              : const Color(0xFF06B6D4),
          opacity: 0.7,
          age: 0,
          maxAge: 1 + (_random.nextDouble() * 0.9),
        ),
      );
    }
  }
}

class _BurstParticle {
  _BurstParticle({
    required this.position,
    required this.velocity,
    required this.radius,
    required this.color,
    required this.opacity,
    required this.age,
    required this.maxAge,
  });

  Vector2 position;
  final Vector2 velocity;
  final double radius;
  final Color color;
  final double opacity;
  double age;
  final double maxAge;
}
