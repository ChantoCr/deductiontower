import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:flutter/material.dart';

class TurnPanel extends StatelessWidget {
  const TurnPanel({
    required this.currentPlayer,
    required this.hints,
    super.key,
  });

  final String currentPlayer;
  final int hints;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Active turn', style: AppTextStyles.title),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      currentPlayer,
                      style: AppTextStyles.subtitle.copyWith(
                        color: AppColors.text,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      color: AppColors.secondary,
                      size: 18,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$hints',
                      style: AppTextStyles.body
                          .copyWith(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'The shared pool is public, but hidden-tag information stays private. The match ends when a player correctly guesses the opponent tag or surrenders.',
            style: AppTextStyles.subtitle.copyWith(height: 1.45),
          ),
        ],
      ),
    );
  }
}
