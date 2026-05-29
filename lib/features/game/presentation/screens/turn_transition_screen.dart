import 'package:anime_deduction_tower/app/router.dart';
import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/features/characters/presentation/providers/character_providers.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/game_match.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/category_selection_controller.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/game_setup_controller.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/match_controller.dart';
import 'package:anime_deduction_tower/features/game/presentation/helpers/game_flow_copy_helper.dart';
import 'package:anime_deduction_tower/features/game/presentation/providers/trait_category_providers.dart';
import 'package:anime_deduction_tower/shared/animations/pulse_animation.dart';
import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_button.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:anime_deduction_tower/shared/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TurnTransitionScreen extends ConsumerWidget {
  const TurnTransitionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const copy = GameFlowCopyHelper();
    final match = ref.watch(matchControllerProvider);
    final isExistingMatch = match != null;
    final isCompletedMatch = match?.status == MatchStatus.completed;

    final title = copy.turnTransitionTitle(
      isExistingMatch: isExistingMatch,
      isCompletedMatch: isCompletedMatch,
    );

    final description = copy.turnTransitionDescription(match: match);

    final buttonLabel = copy.turnTransitionButtonLabel(
      isExistingMatch: isExistingMatch,
      isCompletedMatch: isCompletedMatch,
    );

    final glowColor = isCompletedMatch
        ? AppColors.success
        : isExistingMatch
            ? AppColors.secondary
            : AppColors.primary;

    return AppScaffold(
      title: 'Pass the Device',
      bottomBar: AppCard(
        glowColor: glowColor,
        padding: const EdgeInsets.all(16),
        child: AppButton(
          label: buttonLabel,
          icon: isCompletedMatch
              ? Icons.emoji_events_outlined
              : isExistingMatch
                  ? Icons.visibility_outlined
                  : Icons.play_circle_outline,
          onPressed: () => _handleContinue(context, ref, match: match),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final useWideLayout = constraints.maxWidth >= 900;
          final leadCard = AppCard(
            glowColor: glowColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TransitionOrb(
                      color: glowColor,
                      icon: isCompletedMatch
                          ? Icons.emoji_events_outlined
                          : isExistingMatch
                              ? Icons.shield_moon_outlined
                              : Icons.play_circle_outline,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: glowColor.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              copy.turnTransitionBadgeLabel(
                                isExistingMatch: isExistingMatch,
                                isCompletedMatch: isCompletedMatch,
                              ),
                              style: AppTextStyles.label.copyWith(
                                color: glowColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            child: Column(
                              key: ValueKey(title),
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style:
                                      AppTextStyles.hero.copyWith(fontSize: 30),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  description,
                                  style: AppTextStyles.subtitle
                                      .copyWith(height: 1.5),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _HandoffStepRail(
                  isExistingMatch: isExistingMatch,
                  isCompletedMatch: isCompletedMatch,
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _SecurityPill(
                      icon: Icons.visibility_off_outlined,
                      label: 'Private information stays hidden',
                    ),
                    _SecurityPill(
                      icon: Icons.phone_android_outlined,
                      label: 'Pass-the-device safe flow',
                    ),
                    if (isExistingMatch && !isCompletedMatch)
                      _SecurityPill(
                        icon: Icons.person_outline,
                        label: 'Next: ${match.currentPlayer.name}',
                      ),
                    if (isCompletedMatch)
                      const _SecurityPill(
                        icon: Icons.history_toggle_off_outlined,
                        label: 'Final replay ready',
                      ),
                  ],
                ),
              ],
            ),
          );

          final infoCard = AppCard(
            glowColor: AppColors.secondary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Secrecy checklist', style: AppTextStyles.title),
                const SizedBox(height: AppSpacing.md),
                const _ChecklistItem(
                  title: 'Only the active player should look now',
                  subtitle:
                      'Keep the previous player from seeing the next private turn state.',
                ),
                const SizedBox(height: AppSpacing.md),
                const _ChecklistItem(
                  title: 'Reveal only when ready',
                  subtitle:
                      'The next screen contains private information again once the protected reveal is used.',
                ),
                const SizedBox(height: AppSpacing.md),
                const _ChecklistItem(
                  title: 'Use the result replay after the match ends',
                  subtitle:
                      'Winner celebration, timeline filters, and the full public deduction story are kept on the result screen.',
                ),
                if (isExistingMatch && !isCompletedMatch) ...[
                  const SizedBox(height: AppSpacing.md),
                  _MatchSnapshotCard(match: match),
                ],
              ],
            ),
          );

          if (useWideLayout) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 11, child: leadCard),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(flex: 9, child: infoCard),
                    ],
                  ),
                  const SizedBox(height: 140),
                ],
              ),
            );
          }

          return ListView(
            children: [
              leadCard,
              const SizedBox(height: AppSpacing.md),
              infoCard,
              const SizedBox(height: 140),
            ],
          );
        },
      ),
    );
  }

  Future<void> _handleContinue(
    BuildContext context,
    WidgetRef ref, {
    required GameMatch? match,
  }) async {
    if (match != null) {
      if (match.status == MatchStatus.completed) {
        context.go(AppRoutes.result);
        return;
      }

      context.go(AppRoutes.match);
      return;
    }

    final selectionState = ref.read(categorySelectionControllerProvider);
    final setupState = ref.read(gameSetupControllerProvider);

    if (!selectionState.isComplete ||
        selectionState.playerOneTraitId == null ||
        selectionState.playerTwoTraitId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Complete secret tag selection before starting the match.'),
        ),
      );
      return;
    }

    final catalog = await ref.read(validatedTraitCatalogProvider.future);
    final characters = await ref.read(charactersProvider.future);

    ref.read(matchControllerProvider.notifier).initializeMatch(
          playerOneName: setupState.playerOneName,
          playerTwoName: setupState.playerTwoName,
          hintsPerPlayer: setupState.hints,
          playerOneTraitId: selectionState.playerOneTraitId!,
          playerTwoTraitId: selectionState.playerTwoTraitId!,
          categories: catalog.validCategories,
          characters: characters,
        );

    if (!context.mounted) {
      return;
    }

    context.go(AppRoutes.match);
  }
}

class _TransitionOrb extends StatelessWidget {
  const _TransitionOrb({required this.color, required this.icon});

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return PulseAnimation(
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.14),
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.22)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.14),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 34),
      ),
    );
  }
}

class _HandoffStepRail extends StatelessWidget {
  const _HandoffStepRail({
    required this.isExistingMatch,
    required this.isCompletedMatch,
  });

  final bool isExistingMatch;
  final bool isCompletedMatch;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _HandoffStepNode(
            title: 'Prepare',
            subtitle: isExistingMatch ? 'Done' : 'Active now',
            isActive: !isExistingMatch,
            isDone: isExistingMatch,
          ),
        ),
        Container(
          width: 28,
          height: 2,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          color: isExistingMatch
              ? AppColors.secondary.withValues(alpha: 0.45)
              : AppColors.primary.withValues(alpha: 0.18),
        ),
        Expanded(
          child: _HandoffStepNode(
            title: 'Reveal',
            subtitle: isCompletedMatch
                ? 'Done'
                : isExistingMatch
                    ? 'Active now'
                    : 'Next',
            isActive: isExistingMatch && !isCompletedMatch,
            isDone: isCompletedMatch,
          ),
        ),
        Container(
          width: 28,
          height: 2,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          color: isCompletedMatch
              ? AppColors.success.withValues(alpha: 0.45)
              : AppColors.primary.withValues(alpha: 0.18),
        ),
        Expanded(
          child: _HandoffStepNode(
            title: 'Review',
            subtitle: isCompletedMatch ? 'Ready' : 'Result later',
            isActive: isCompletedMatch,
            isDone: false,
          ),
        ),
      ],
    );
  }
}

class _HandoffStepNode extends StatelessWidget {
  const _HandoffStepNode({
    required this.title,
    required this.subtitle,
    required this.isActive,
    required this.isDone,
  });

  final String title;
  final String subtitle;
  final bool isActive;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    final color = isDone
        ? AppColors.success
        : isActive
            ? AppColors.secondary
            : AppColors.muted;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isActive ? 0.12 : 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDone
                  ? Icons.check_rounded
                  : isActive
                      ? Icons.play_arrow_rounded
                      : Icons.more_horiz_rounded,
              size: 16,
              color: color,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: AppTextStyles.subtitle.copyWith(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _SecurityPill extends StatelessWidget {
  const _SecurityPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.secondary),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Icon(Icons.check, size: 14, color: AppColors.success),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.subtitle.copyWith(height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MatchSnapshotCard extends StatelessWidget {
  const _MatchSnapshotCard({required this.match});

  final GameMatch match;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current match snapshot',
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _SnapshotChip(
                icon: Icons.person_outline,
                label: 'Next: ${match.currentPlayer.name}',
              ),
              _SnapshotChip(
                icon: Icons.timeline_outlined,
                label: 'Turns: ${match.turns.length}',
              ),
              _SnapshotChip(
                icon: Icons.style_outlined,
                label: 'Pool: ${match.characterPoolIds.length}',
              ),
              _SnapshotChip(
                icon: Icons.lightbulb_outline,
                label: 'Hints: ${match.currentPlayer.hintsRemaining}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SnapshotChip extends StatelessWidget {
  const _SnapshotChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.24),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.secondary),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
