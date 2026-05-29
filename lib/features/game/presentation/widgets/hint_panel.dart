import 'package:anime_deduction_tower/shared/animations/pulse_animation.dart';
import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:flutter/material.dart';

class HintPanel extends StatelessWidget {
  const HintPanel({
    required this.hint,
    this.isActionAvailable = true,
    super.key,
  });

  final String hint;
  final bool isActionAvailable;

  @override
  Widget build(BuildContext context) {
    final accent = isActionAvailable ? AppColors.accent : AppColors.muted;

    return AppCard(
      glowColor: accent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PulseAnimation(
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                isActionAvailable
                    ? Icons.tips_and_updates_outlined
                    : Icons.hourglass_bottom_rounded,
                color: accent,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text('Hint Strategy', style: AppTextStyles.title),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        isActionAvailable ? 'READY' : 'EMPTY',
                        style: AppTextStyles.label.copyWith(color: accent),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  hint,
                  style: AppTextStyles.subtitle.copyWith(height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
