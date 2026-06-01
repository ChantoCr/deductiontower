import 'package:anime_deduction_tower/features/game/presentation/helpers/game_flow_copy_helper.dart';
import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:flutter/material.dart';

class TurnPanel extends StatelessWidget {
  const TurnPanel({
    required this.currentPlayer,
    required this.hints,
    this.description,
    this.statusLabel,
    super.key,
  });

  final String currentPlayer;
  final int hints;
  final String? description;
  final String? statusLabel;

  @override
  Widget build(BuildContext context) {
    const copy = GameFlowCopyHelper();
    final accent = hints > 0 ? AppColors.secondary : AppColors.accent;

    return AppCard(
      glowColor: accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    const SizedBox(height: AppSpacing.sm),
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
                        statusLabel ??
                            copy.turnPanelStatusLabel(
                              hints: hints,
                              isPlayerVsAi: false,
                            ),
                        style: AppTextStyles.label.copyWith(color: accent),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: accent.withValues(alpha: 0.18)),
                ),
                child: Column(
                  children: [
                    Icon(
                      hints > 0
                          ? Icons.lightbulb_outline
                          : Icons.hourglass_bottom_rounded,
                      color: accent,
                      size: 18,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$hints',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            description ??
                copy.turnPanelDescription(
                  isPlayerVsAi: false,
                  currentPlayerName: currentPlayer,
                ),
            style: AppTextStyles.subtitle.copyWith(height: 1.45),
          ),
        ],
      ),
    );
  }
}
