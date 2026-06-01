import 'package:anime_deduction_tower/core/enums/ai_difficulty.dart';
import 'package:anime_deduction_tower/features/game/presentation/helpers/game_flow_copy_helper.dart';
import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_badge.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:flutter/material.dart';

class AiOpponentProfileCard extends StatelessWidget {
  const AiOpponentProfileCard({
    required this.aiName,
    required this.difficulty,
    required this.title,
    required this.description,
    this.footer,
    super.key,
  });

  final String aiName;
  final AiDifficulty difficulty;
  final String title;
  final String description;
  final String? footer;

  @override
  Widget build(BuildContext context) {
    const copy = GameFlowCopyHelper();

    return AppCard(
      glowColor: AppColors.accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.smart_toy_outlined,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.title),
                    const SizedBox(height: 2),
                    Text(
                      aiName,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              AppBadge(
                label: '${difficulty.label.toUpperCase()} AI',
                accent: AppColors.accent,
                backgroundColor: AppColors.accent.withValues(alpha: 0.14),
                textStyle: AppTextStyles.label.copyWith(
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            description,
            style: AppTextStyles.subtitle.copyWith(height: 1.45),
          ),
          const SizedBox(height: AppSpacing.md),
          _InsightRow(
            icon: Icons.tune_outlined,
            label: 'Probe focus',
            value: copy.aiDifficultyProbeFocus(difficulty),
          ),
          const SizedBox(height: AppSpacing.sm),
          _InsightRow(
            icon: Icons.bolt_outlined,
            label: 'Commitment style',
            value: copy.aiDifficultyCommitmentStyle(difficulty),
          ),
          const SizedBox(height: AppSpacing.sm),
          _InsightRow(
            icon: Icons.timeline_outlined,
            label: 'Match tempo',
            value: copy.aiDifficultyTempoStyle(difficulty),
          ),
          if (footer != null) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.24),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.14),
                ),
              ),
              child: Text(
                footer!,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: AppColors.accent),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
