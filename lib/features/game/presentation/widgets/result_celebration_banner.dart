import 'dart:math' as math;

import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:flutter/material.dart';

class ResultCelebrationBanner extends StatefulWidget {
  const ResultCelebrationBanner({
    required this.winnerName,
    required this.reasonLabel,
    required this.summary,
    super.key,
  });

  final String winnerName;
  final String reasonLabel;
  final String summary;

  @override
  State<ResultCelebrationBanner> createState() =>
      _ResultCelebrationBannerState();
}

class _ResultCelebrationBannerState extends State<ResultCelebrationBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final angle = _controller.value * math.pi * 2;
        final trophyLift = math.sin(angle) * 6;
        final trophyScale = 1 + ((math.sin(angle) + 1) * 0.03);
        final pulseOpacity = 0.12 + ((math.sin(angle) + 1) * 0.06);

        return AppCard(
          padding: EdgeInsets.zero,
          glowColor: AppColors.success,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final useWideLayout = constraints.maxWidth >= 760;

                return Stack(
                  children: [
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.success.withValues(alpha: 0.2),
                              AppColors.primary.withValues(alpha: 0.28),
                              AppColors.secondary.withValues(alpha: 0.18),
                              AppColors.surface,
                            ],
                          ),
                        ),
                      ),
                    ),
                    ..._celebrationSparkles(
                      constraints: constraints,
                      angle: angle,
                    ),
                    Container(
                      constraints: const BoxConstraints(minHeight: 240),
                      padding: const EdgeInsets.all(20),
                      child: useWideLayout
                          ? Row(
                              children: [
                                _TrophyOrb(
                                  lift: trophyLift,
                                  scale: trophyScale,
                                  pulseOpacity: pulseOpacity,
                                ),
                                const SizedBox(width: AppSpacing.lg),
                                Expanded(
                                  child: _CelebrationCopy(
                                    winnerName: widget.winnerName,
                                    reasonLabel: widget.reasonLabel,
                                    summary: widget.summary,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: _TrophyOrb(
                                    lift: trophyLift,
                                    scale: trophyScale,
                                    pulseOpacity: pulseOpacity,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.lg),
                                _CelebrationCopy(
                                  winnerName: widget.winnerName,
                                  reasonLabel: widget.reasonLabel,
                                  summary: widget.summary,
                                ),
                              ],
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  List<Widget> _celebrationSparkles({
    required BoxConstraints constraints,
    required double angle,
  }) {
    const seeds = [
      _SparkleSeed(leftFactor: 0.08, topFactor: 0.12, phase: 0.0, size: 18),
      _SparkleSeed(leftFactor: 0.22, topFactor: 0.72, phase: 0.9, size: 16),
      _SparkleSeed(leftFactor: 0.48, topFactor: 0.16, phase: 1.4, size: 22),
      _SparkleSeed(leftFactor: 0.68, topFactor: 0.74, phase: 2.1, size: 18),
      _SparkleSeed(leftFactor: 0.88, topFactor: 0.22, phase: 2.8, size: 16),
    ];

    return seeds.map((seed) {
      final shimmer = (math.sin(angle + seed.phase) + 1) / 2;
      return Positioned(
        left: constraints.maxWidth * seed.leftFactor,
        top: (constraints.maxHeight * seed.topFactor) +
            (math.sin(angle + seed.phase) * 10),
        child: Opacity(
          opacity: 0.2 + (shimmer * 0.45),
          child: Transform.scale(
            scale: 0.9 + (shimmer * 0.35),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: shimmer > 0.5 ? AppColors.secondary : AppColors.success,
              size: seed.size,
            ),
          ),
        ),
      );
    }).toList();
  }
}

class _CelebrationCopy extends StatelessWidget {
  const _CelebrationCopy({
    required this.winnerName,
    required this.reasonLabel,
    required this.summary,
  });

  final String winnerName;
  final String reasonLabel;
  final String summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: AppColors.success.withValues(alpha: 0.18),
            ),
          ),
          child: const Text('MATCH COMPLETE', style: AppTextStyles.label),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Winner: $winnerName',
          style: AppTextStyles.hero.copyWith(fontSize: 30),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          reasonLabel,
          style: AppTextStyles.subtitle.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          summary,
          style: AppTextStyles.subtitle.copyWith(height: 1.45),
        ),
      ],
    );
  }
}

class _TrophyOrb extends StatelessWidget {
  const _TrophyOrb({
    required this.lift,
    required this.scale,
    required this.pulseOpacity,
  });

  final double lift;
  final double scale;
  final double pulseOpacity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 128,
      height: 128,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.success.withValues(alpha: pulseOpacity),
              ),
            ),
          ),
          Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.secondary.withValues(alpha: pulseOpacity),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(0, lift),
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.success.withValues(alpha: 0.92),
                      AppColors.secondary.withValues(alpha: 0.82),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withValues(alpha: 0.28),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  size: 42,
                  color: AppColors.background,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SparkleSeed {
  const _SparkleSeed({
    required this.leftFactor,
    required this.topFactor,
    required this.phase,
    required this.size,
  });

  final double leftFactor;
  final double topFactor;
  final double phase;
  final double size;
}
