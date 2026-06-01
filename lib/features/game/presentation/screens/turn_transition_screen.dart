import 'package:anime_deduction_tower/app/router.dart';
import 'package:anime_deduction_tower/core/enums/ai_difficulty.dart';
import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/features/ai_opponent/presentation/providers/ai_opponent_providers.dart';
import 'package:anime_deduction_tower/features/characters/presentation/providers/character_providers.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/game_match.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/category_selection_controller.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/game_setup_controller.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/match_controller.dart';
import 'package:anime_deduction_tower/features/game/presentation/helpers/game_flow_copy_helper.dart';
import 'package:anime_deduction_tower/features/game/presentation/providers/trait_category_providers.dart';
import 'package:anime_deduction_tower/features/game/presentation/widgets/ai_move_summary_card.dart';
import 'package:anime_deduction_tower/shared/animations/pulse_animation.dart';
import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_badge.dart';
import 'package:anime_deduction_tower/shared/widgets/app_button.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:anime_deduction_tower/shared/widgets/app_dialog.dart';
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
    final setupState = ref.watch(gameSetupControllerProvider);
    final isExistingMatch = match != null;
    final isCompletedMatch = match?.status == MatchStatus.completed;
    final isAiTurn = match?.currentPlayer.isAi == true && !isCompletedMatch;

    final title = copy.turnTransitionTitle(match: match);

    final description = copy.turnTransitionDescription(
      match: match,
      aiDifficulty: setupState.aiDifficulty,
    );

    final buttonLabel = copy.turnTransitionButtonLabel(match: match);

    final glowColor = isCompletedMatch
        ? AppColors.success
        : isAiTurn
            ? AppColors.accent
            : isExistingMatch
                ? AppColors.secondary
                : AppColors.primary;

    return AppScaffold(
      title: isAiTurn ? 'AI Turn' : 'Pass the Device',
      bottomBar: AppCard(
        glowColor: glowColor,
        padding: const EdgeInsets.all(16),
        child: AppButton(
          label: buttonLabel,
          icon: isCompletedMatch
              ? Icons.emoji_events_outlined
              : isAiTurn
                  ? Icons.smart_toy_outlined
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
                          : isAiTurn
                              ? Icons.smart_toy_outlined
                              : isExistingMatch
                                  ? Icons.shield_moon_outlined
                                  : Icons.play_circle_outline,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppBadge(
                            label: copy.turnTransitionBadgeLabel(match: match),
                            accent: glowColor,
                            backgroundColor: glowColor.withValues(alpha: 0.14),
                            textStyle: AppTextStyles.label.copyWith(
                              color: glowColor,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
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
                    AppBadge(
                      icon: Icons.visibility_off_outlined,
                      label: 'Private information stays hidden',
                      accent: AppColors.secondary,
                      backgroundColor: AppColors.surface.withValues(alpha: 0.8),
                      borderColor: AppColors.primary.withValues(alpha: 0.16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    AppBadge(
                      icon: isAiTurn
                          ? Icons.memory_outlined
                          : Icons.phone_android_outlined,
                      label: isAiTurn
                          ? '${setupState.aiDifficulty.label} AI reasoning'
                          : 'Pass-the-device safe flow',
                      accent: isAiTurn ? AppColors.accent : AppColors.secondary,
                      backgroundColor: AppColors.surface.withValues(alpha: 0.8),
                      borderColor: AppColors.primary.withValues(alpha: 0.16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    if (isExistingMatch && !isCompletedMatch)
                      AppBadge(
                        icon: isAiTurn
                            ? Icons.smart_toy_outlined
                            : Icons.person_outline,
                        label: isAiTurn
                            ? '${match.currentPlayer.name} acts automatically'
                            : 'Next: ${match.currentPlayer.name}',
                        accent:
                            isAiTurn ? AppColors.accent : AppColors.secondary,
                        backgroundColor:
                            AppColors.surface.withValues(alpha: 0.8),
                        borderColor: AppColors.primary.withValues(alpha: 0.16),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    if (isCompletedMatch)
                      AppBadge(
                        icon: Icons.history_toggle_off_outlined,
                        label: 'Final replay ready',
                        accent: AppColors.secondary,
                        backgroundColor:
                            AppColors.surface.withValues(alpha: 0.8),
                        borderColor: AppColors.primary.withValues(alpha: 0.16),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
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
                Text(
                  isAiTurn ? 'AI turn briefing' : 'Secrecy checklist',
                  style: AppTextStyles.title,
                ),
                const SizedBox(height: AppSpacing.md),
                if (isAiTurn) ...[
                  _ChecklistItem(
                    title: 'No handoff is required for this step',
                    subtitle:
                        '${setupState.playerTwoName} is playing on ${setupState.aiDifficulty.label} difficulty and only performs public actions, so you can stay on the same device screen while its move resolves.',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const _ChecklistItem(
                    title: 'The live match returns after the AI move',
                    subtitle:
                        'Once the automated turn is processed, the app returns to the human player flow or opens the result screen if the match ends.',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const _ChecklistItem(
                    title: 'Public history still stays visible',
                    subtitle:
                        'AI guesses are written into the same shared timeline and follow the same no-lives match rules.',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _AiDifficultyProfileCard(
                    difficulty: setupState.aiDifficulty,
                  ),
                ] else ...[
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
                ],
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

      if (match.currentPlayer.isAi) {
        final categories =
            (await ref.read(validatedTraitCatalogProvider.future))
                .validCategories;
        final characters = await ref.read(charactersProvider.future);
        final setupState = ref.read(gameSetupControllerProvider);
        final result = ref.read(matchControllerProvider.notifier).runAiTurn(
              categories: categories,
              characters: characters,
              difficulty: setupState.aiDifficulty,
            );
        final updatedMatch = ref.read(matchControllerProvider);
        final latestAiTurn = updatedMatch?.turns.isNotEmpty == true
            ? updatedMatch!.turns.last
            : null;

        if (!context.mounted) {
          return;
        }

        await AppDialog.showCustom(
          context,
          title: '${match.currentPlayer.name} Move Resolved',
          accentColor: AppColors.accent,
          icon: result.isCorrect
              ? Icons.auto_awesome_outlined
              : Icons.smart_toy_outlined,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                result.message,
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(height: 1.45),
              ),
              if (latestAiTurn != null) ...[
                const SizedBox(height: AppSpacing.md),
                AiMoveSummaryCard(
                  aiName: match.currentPlayer.name,
                  difficulty: setupState.aiDifficulty,
                  turn: latestAiTurn,
                  categories: categories,
                  characters: characters,
                  title: 'AI public move summary',
                  description:
                      'This public read is now stored in the shared timeline and stays visible when you return to the live board.',
                ),
              ],
            ],
          ),
          actions: [
            SizedBox(
              width: 180,
              child: AppButton(
                label: 'Continue',
                icon: Icons.arrow_forward_rounded,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        );

        if (!context.mounted || updatedMatch == null) {
          return;
        }

        if (updatedMatch.status == MatchStatus.completed) {
          context.go(AppRoutes.result);
          return;
        }

        context.go(AppRoutes.match);
        return;
      }

      context.go(AppRoutes.match);
      return;
    }

    final selectionState = ref.read(categorySelectionControllerProvider);
    final setupState = ref.read(gameSetupControllerProvider);

    if (!selectionState.isComplete || selectionState.playerOneTraitId == null) {
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

    final playerTwoTraitId = selectionState.playerTwoTraitId ??
        ref.read(aiOpponentServiceProvider).chooseSecretTraitId(
              categories: catalog.validCategories,
              excludedTraitId: selectionState.playerOneTraitId,
            );

    ref.read(matchControllerProvider.notifier).initializeMatch(
          playerOneName: setupState.playerOneName,
          playerTwoName: setupState.playerTwoName,
          hintsPerPlayer: setupState.hints,
          playerOneTraitId: selectionState.playerOneTraitId!,
          playerTwoTraitId: playerTwoTraitId,
          categories: catalog.validCategories,
          characters: characters,
          playerTwoIsAi: setupState.isPlayerVsAi,
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

class _AiDifficultyProfileCard extends StatelessWidget {
  const _AiDifficultyProfileCard({required this.difficulty});

  final AiDifficulty difficulty;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppBadge(
                icon: Icons.smart_toy_outlined,
                label: '${difficulty.label.toUpperCase()} PROFILE',
                accent: AppColors.accent,
                backgroundColor: AppColors.background.withValues(alpha: 0.24),
                textStyle: AppTextStyles.label.copyWith(
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            difficulty.shortDescription,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ],
      ),
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
              AppBadge(
                icon: Icons.person_outline,
                label: 'Next: ${match.currentPlayer.name}',
                accent: AppColors.secondary,
                backgroundColor: AppColors.background.withValues(alpha: 0.24),
              ),
              AppBadge(
                icon: Icons.timeline_outlined,
                label: 'Turns: ${match.turns.length}',
                accent: AppColors.secondary,
                backgroundColor: AppColors.background.withValues(alpha: 0.24),
              ),
              AppBadge(
                icon: Icons.style_outlined,
                label: 'Pool: ${match.characterPoolIds.length}',
                accent: AppColors.secondary,
                backgroundColor: AppColors.background.withValues(alpha: 0.24),
              ),
              AppBadge(
                icon: Icons.lightbulb_outline,
                label: 'Hints: ${match.currentPlayer.hintsRemaining}',
                accent: AppColors.secondary,
                backgroundColor: AppColors.background.withValues(alpha: 0.24),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
