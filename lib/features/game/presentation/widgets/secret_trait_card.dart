import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:flutter/material.dart';

class SecretTraitCard extends StatelessWidget {
  const SecretTraitCard({
    required this.title,
    required this.value,
    required this.isRevealed,
    required this.onToggleVisibility,
    super.key,
  });

  final String title;
  final String value;
  final bool isRevealed;
  final VoidCallback onToggleVisibility;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: AppTextStyles.title)),
              IconButton(
                tooltip: isRevealed ? 'Hide tag reminder' : 'Show tag reminder',
                onPressed: onToggleVisibility,
                icon: Icon(
                  isRevealed
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: isRevealed
                ? Text(
                    value,
                    key: const ValueKey('revealed-trait'),
                    style: AppTextStyles.subtitle.copyWith(
                      color: AppColors.text,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : Column(
                    key: const ValueKey('hidden-trait'),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 180,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.muted.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      const Text(
                        'Hidden for privacy. Tap the eye icon only if you need a quick reminder of your secret tag.',
                        style: AppTextStyles.subtitle,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
