import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:flutter/material.dart';

class GuessHistory extends StatelessWidget {
  const GuessHistory({required this.items, super.key});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Public Match Timeline', style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Recent shared information stays visible here so both players can track the deduction trail.',
            style: AppTextStyles.subtitle.copyWith(height: 1.45),
          ),
          const SizedBox(height: AppSpacing.md),
          ...items.take(8).map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(top: 6),
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: Text(item, style: AppTextStyles.body)),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
