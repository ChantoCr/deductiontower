import 'package:anime_deduction_tower/features/flame_board/game/deduction_tower_game.dart';
import 'package:anime_deduction_tower/features/game/presentation/helpers/game_flow_copy_helper.dart';
import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class TowerView extends StatefulWidget {
  const TowerView({
    super.key,
    this.label = 'Character Tower',
    this.description,
    this.statusLabel,
    this.enableFlameBackdrop = true,
  });

  final String label;
  final String? description;
  final String? statusLabel;
  final bool enableFlameBackdrop;

  @override
  State<TowerView> createState() => _TowerViewState();
}

class _TowerViewState extends State<TowerView> {
  late final DeductionTowerGame _towerGame = DeductionTowerGame(
    celebrationMode: false,
    showTower: true,
  );

  @override
  Widget build(BuildContext context) {
    const copy = GameFlowCopyHelper();

    return AppCard(
      glowColor: AppColors.secondary,
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
                    Text(widget.label, style: AppTextStyles.title),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      widget.description ??
                          copy.towerDescription(isPlayerVsAi: false),
                      style: AppTextStyles.subtitle.copyWith(height: 1.45),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  widget.statusLabel ??
                      copy.towerStatusLabel(isPlayerVsAi: false),
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 132,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary.withValues(alpha: 0.1),
                            AppColors.secondary.withValues(alpha: 0.08),
                            AppColors.surface,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (widget.enableFlameBackdrop)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Opacity(
                        opacity: 0.32,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: GameWidget(game: _towerGame),
                        ),
                      ),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    5,
                    (index) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: index == 4 ? 0 : 8),
                        child: AnimatedContainer(
                          duration: Duration(
                            milliseconds: 220 + (index * 20),
                          ),
                          curve: Curves.easeOutCubic,
                          height: 90,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.primary.withValues(alpha: 0.16),
                                AppColors.secondary.withValues(alpha: 0.08),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: AppColors.secondary.withValues(alpha: 0.2),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColors.secondary.withValues(alpha: 0.08),
                                blurRadius: 14,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '#${index + 1}',
                                style: AppTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                index < 2 ? 'Hot lead' : 'Open lane',
                                style: AppTextStyles.subtitle.copyWith(
                                  fontSize: 11,
                                  color: AppColors.text,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
