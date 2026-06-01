import 'package:anime_deduction_tower/core/enums/ai_difficulty.dart';
import 'package:anime_deduction_tower/features/game/presentation/models/match_result_comparison.dart';
import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_badge.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:flutter/material.dart';

class AiPerformanceSummaryCard extends StatelessWidget {
  const AiPerformanceSummaryCard({
    required this.aiName,
    required this.difficulty,
    required this.aiStats,
    required this.humanStats,
    super.key,
  });

  final String aiName;
  final AiDifficulty difficulty;
  final PlayerResultStats aiStats;
  final PlayerResultStats humanStats;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      glowColor: AppColors.accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AI Performance Snapshot',
                      style: AppTextStyles.title,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Review how $aiName performed against the human side across probe accuracy, final-read pressure, and support-action usage.',
                      style: AppTextStyles.subtitle.copyWith(height: 1.45),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppBadge(
                icon: Icons.psychology_alt_outlined,
                label: difficulty.label,
                accent: AppColors.accent,
                backgroundColor: AppColors.accent.withValues(alpha: 0.14),
                textStyle: AppTextStyles.body.copyWith(
                  color: AppColors.text,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  label: 'AI probe accuracy',
                  value: _formatPercent(aiStats.characterGuessAccuracy),
                  helper:
                      '${aiStats.correctCharacterGuesses}/${aiStats.characterGuesses} character reads connected',
                  accent: AppColors.accent,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _MetricTile(
                  label: 'Human probe accuracy',
                  value: _formatPercent(humanStats.characterGuessAccuracy),
                  helper:
                      '${humanStats.correctCharacterGuesses}/${humanStats.characterGuesses} character reads connected',
                  accent: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  label: 'AI overall accuracy',
                  value: _formatPercent(aiStats.overallAccuracy),
                  helper:
                      '${aiStats.correctGuesses}/${aiStats.resolvedGuesses} resolved guesses landed',
                  accent: AppColors.accent,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _MetricTile(
                  label: 'Final tag pressure',
                  value:
                      aiStats.usedFinalTagRead ? 'Committed' : 'No final read',
                  helper:
                      '${aiStats.traitGuesses} final tag guess${aiStats.traitGuesses == 1 ? '' : 'es'} • ${aiStats.hintsUsed} hints used',
                  accent: aiStats.usedFinalTagRead
                      ? AppColors.success
                      : AppColors.muted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatPercent(double? value) {
    if (value == null) {
      return 'N/A';
    }

    return '${(value * 100).round()}%';
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.helper,
    required this.accent,
  });

  final String label;
  final String value;
  final String helper;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.label.copyWith(color: accent),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.title.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 4),
          Text(
            helper,
            style: AppTextStyles.subtitle.copyWith(height: 1.4),
          ),
        ],
      ),
    );
  }
}
