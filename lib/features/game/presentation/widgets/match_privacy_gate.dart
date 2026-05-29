import 'package:anime_deduction_tower/shared/animations/pulse_animation.dart';
import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_button.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:flutter/material.dart';

class MatchPrivacyGate extends StatelessWidget {
  const MatchPrivacyGate({
    required this.currentPlayerName,
    required this.onReveal,
    super.key,
  });

  final String currentPlayerName;
  final VoidCallback onReveal;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppCard(
        glowColor: AppColors.secondary,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PulseAnimation(
              child: Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.visibility_off_outlined,
                  color: AppColors.secondary,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Private Turn Protection',
              style: AppTextStyles.title,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Only $currentPlayerName should be looking at the screen right now.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Nothing private is shown until the active player explicitly reveals their turn.',
              style: AppTextStyles.subtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.82),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.14),
                ),
              ),
              child: const Text(
                'Protected reveal is intentionally separated from the live match tools.',
                textAlign: TextAlign.center,
                style: AppTextStyles.subtitle,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: 'Reveal $currentPlayerName\'s Turn',
              icon: Icons.visibility_outlined,
              onPressed: onReveal,
            ),
          ],
        ),
      ),
    );
  }
}
