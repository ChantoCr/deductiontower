import 'package:anime_deduction_tower/app/router.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/characters/presentation/providers/character_providers.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/game_setup_controller.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/match_controller.dart';
import 'package:anime_deduction_tower/features/game/presentation/helpers/game_flow_copy_helper.dart';
import 'package:anime_deduction_tower/features/game/presentation/helpers/match_lookup_helper.dart';
import 'package:anime_deduction_tower/features/game/presentation/helpers/match_presentation_mapper.dart';
import 'package:anime_deduction_tower/features/game/presentation/models/match_result_comparison.dart';
import 'package:anime_deduction_tower/features/game/presentation/providers/trait_category_providers.dart';
import 'package:anime_deduction_tower/features/game/presentation/widgets/ai_move_summary_card.dart';
import 'package:anime_deduction_tower/features/game/presentation/widgets/ai_opponent_profile_card.dart';
import 'package:anime_deduction_tower/features/game/presentation/widgets/ai_performance_summary_card.dart';
import 'package:anime_deduction_tower/features/game/presentation/widgets/guess_history.dart';
import 'package:anime_deduction_tower/features/game/presentation/widgets/result_celebration_banner.dart';
import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_badge.dart';
import 'package:anime_deduction_tower/shared/widgets/app_button.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:anime_deduction_tower/shared/widgets/app_scaffold.dart';
import 'package:anime_deduction_tower/shared/widgets/app_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const copy = GameFlowCopyHelper();
    const lookup = MatchLookupHelper();
    const mapper = MatchPresentationMapper();
    final match = ref.watch(matchControllerProvider);
    final setupState = ref.watch(gameSetupControllerProvider);
    final categories = ref.watch(validatedTraitCatalogProvider).maybeWhen(
          data: (catalog) => catalog.validCategories,
          orElse: () => const <TraitCategory>[],
        );
    final characters = ref.watch(charactersProvider).maybeWhen(
          data: (data) => data,
          orElse: () => const <Character>[],
        );

    if (match == null) {
      return AppScaffold(
        title: 'Result',
        child: Center(
          child: AppCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('No Result Available', style: AppTextStyles.title),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  'Start and complete a match to see the final result screen.',
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: 'Back Home',
                  icon: Icons.home_outlined,
                  onPressed: () => context.go(AppRoutes.home),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final winnerName = lookup.winnerName(match);
    final playerOneTrait = lookup.traitLabelForPlayer(
      categories,
      match.playerOne,
    );
    final playerTwoTrait = lookup.traitLabelForPlayer(
      categories,
      match.playerTwo,
    );
    final isAiMatch = lookup.isAiMatch(match);
    final aiPlayerName = lookup.aiPlayerName(match);
    final timelineEntries = mapper.buildTimelineEntries(
      match: match,
      categories: categories,
      characters: characters,
    );
    final comparison = mapper.buildResultComparison(match: match);
    final latestAiTurn = isAiMatch ? lookup.latestAiTurn(match) : null;
    final aiPlayer = isAiMatch ? lookup.aiPlayer(match) : null;
    final aiStats = aiPlayer == null
        ? null
        : comparison.winner.playerId == aiPlayer.id
            ? comparison.winner
            : comparison.loser;
    final humanStats = aiPlayer == null
        ? null
        : comparison.winner.playerId == aiPlayer.id
            ? comparison.loser
            : comparison.winner;

    return AppScaffold(
      title: 'Match Result',
      bottomBar: LayoutBuilder(
        builder: (context, constraints) {
          final useWideButtons = constraints.maxWidth >= 700;
          return AppCard(
            padding: const EdgeInsets.all(16),
            child: useWideButtons
                ? Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Rematch Setup',
                          icon: Icons.restart_alt,
                          onPressed: () {
                            ref.read(matchControllerProvider.notifier).clear();
                            context.go(AppRoutes.setup);
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: AppButton(
                          label: 'Back Home',
                          icon: Icons.home_outlined,
                          onPressed: () {
                            ref.read(matchControllerProvider.notifier).clear();
                            context.go(AppRoutes.home);
                          },
                          isPrimary: false,
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppButton(
                        label: 'Rematch Setup',
                        icon: Icons.restart_alt,
                        onPressed: () {
                          ref.read(matchControllerProvider.notifier).clear();
                          context.go(AppRoutes.setup);
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppButton(
                        label: 'Back Home',
                        icon: Icons.home_outlined,
                        onPressed: () {
                          ref.read(matchControllerProvider.notifier).clear();
                          context.go(AppRoutes.home);
                        },
                        isPrimary: false,
                      ),
                    ],
                  ),
          );
        },
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final useWideLayout = constraints.maxWidth >= 1000;

          final heroCard = ResultCelebrationBanner(
            winnerName: winnerName,
            reasonLabel: lookup.endReasonLabel(match.endReason),
            summary: copy.resultBannerSummary(
              isPlayerVsAi: isAiMatch,
              aiName: aiPlayerName,
              aiDifficulty: setupState.aiDifficulty,
            ),
          );

          final statsBlock = Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _ResultStatCard(
                      label: 'Turns',
                      value: '${match.turns.length}',
                      icon: Icons.timeline_outlined,
                      accent: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _ResultStatCard(
                      label: 'Pool Size',
                      value: '${match.characterPoolIds.length}',
                      icon: Icons.style_outlined,
                      accent: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _ResultStatCard(
                      label: '${match.playerOne.name} Hints Left',
                      value: '${match.playerOne.hintsRemaining}',
                      icon: Icons.looks_one_rounded,
                      accent: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _ResultStatCard(
                      label: '${match.playerTwo.name} Hints Left',
                      value: '${match.playerTwo.hintsRemaining}',
                      icon: Icons.looks_two_rounded,
                      accent: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ],
          );

          final comparisonCard = _ResultComparisonCard(
            comparison: comparison,
            description: copy.resultComparisonDescription(
              isPlayerVsAi: isAiMatch,
              aiName: aiPlayerName,
              aiDifficulty: setupState.aiDifficulty,
            ),
          );

          final revealedTagsCard = AppSummaryCard(
            title: 'Revealed Secret Tags',
            glowColor: AppColors.secondary,
            rowBackgroundColor: AppColors.primary.withValues(alpha: 0.08),
            items: [
              AppSummaryItem(
                label: match.playerOne.name,
                value: playerOneTrait ?? 'Unknown',
              ),
              AppSummaryItem(
                label: match.playerTwo.name,
                value: playerTwoTrait ?? 'Unknown',
              ),
            ],
            labelStyle:
                AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
            valueStyle: AppTextStyles.subtitle.copyWith(
              color: AppColors.text,
              fontWeight: FontWeight.w700,
            ),
          );

          final timelineCard = GuessHistory(
            title: isAiMatch ? 'Final Human vs AI Timeline' : 'Final Timeline',
            description: isAiMatch
                ? 'Filter the full public duel between you and ${aiPlayerName ?? 'the AI'}, then expand the replay to inspect how each probe and final read shaped the result.'
                : 'Filter the full public match story by guess type, outcome, or support actions, then expand the timeline when you want the complete deduction replay.',
            entries: timelineEntries,
            collapsedCount: 6,
            emptyStateMessage: 'No final timeline events were recorded.',
          );

          final aiSummaryCard = latestAiTurn?.publicNote == null
              ? null
              : AiMoveSummaryCard(
                  aiName: aiPlayerName ?? setupState.playerTwoName,
                  difficulty: setupState.aiDifficulty,
                  turn: latestAiTurn!,
                  categories: categories,
                  characters: characters,
                  title: 'Final AI move summary',
                  description:
                      'Use the closing automated read as a fast replay anchor before diving into the full public timeline.',
                );

          final aiProfileCard = !isAiMatch
              ? null
              : AiOpponentProfileCard(
                  aiName: aiPlayerName ?? setupState.playerTwoName,
                  difficulty: setupState.aiDifficulty,
                  title: 'AI opponent profile',
                  description: copy.aiOpponentResultDescription(
                    aiName: aiPlayerName ?? setupState.playerTwoName,
                    difficulty: setupState.aiDifficulty,
                    aiWon: lookup.winnerPlayer(match).isAi,
                  ),
                  footer:
                      'All AI actions still resolved through the same shared no-lives match engine as human turns.',
                );

          final aiPerformanceCard = aiStats == null || humanStats == null
              ? null
              : AiPerformanceSummaryCard(
                  aiName: aiPlayerName ?? setupState.playerTwoName,
                  difficulty: setupState.aiDifficulty,
                  aiStats: aiStats,
                  humanStats: humanStats,
                );

          if (useWideLayout) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  heroCard,
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 9,
                        child: Column(
                          children: [
                            statsBlock,
                            const SizedBox(height: AppSpacing.md),
                            comparisonCard,
                            if (aiProfileCard != null) ...[
                              const SizedBox(height: AppSpacing.md),
                              aiProfileCard,
                            ],
                            if (aiPerformanceCard != null) ...[
                              const SizedBox(height: AppSpacing.md),
                              aiPerformanceCard,
                            ],
                            if (aiSummaryCard != null) ...[
                              const SizedBox(height: AppSpacing.md),
                              aiSummaryCard,
                            ],
                            const SizedBox(height: AppSpacing.md),
                            revealedTagsCard,
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(flex: 11, child: timelineCard),
                    ],
                  ),
                  const SizedBox(height: 180),
                ],
              ),
            );
          }

          return ListView(
            children: [
              heroCard,
              const SizedBox(height: AppSpacing.md),
              statsBlock,
              const SizedBox(height: AppSpacing.md),
              comparisonCard,
              if (aiProfileCard != null) ...[
                const SizedBox(height: AppSpacing.md),
                aiProfileCard,
              ],
              if (aiPerformanceCard != null) ...[
                const SizedBox(height: AppSpacing.md),
                aiPerformanceCard,
              ],
              if (aiSummaryCard != null) ...[
                const SizedBox(height: AppSpacing.md),
                aiSummaryCard,
              ],
              const SizedBox(height: AppSpacing.md),
              revealedTagsCard,
              const SizedBox(height: AppSpacing.md),
              timelineCard,
              const SizedBox(height: 180),
            ],
          );
        },
      ),
    );
  }
}

class _ResultStatCard extends StatelessWidget {
  const _ResultStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      glowColor: accent,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: accent),
              ),
              const Spacer(),
              AppBadge(
                label: 'MATCH STAT',
                accent: accent,
                backgroundColor: accent.withValues(alpha: 0.12),
                textStyle: AppTextStyles.label.copyWith(color: accent),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(value, style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.xs),
          Text(label, style: AppTextStyles.subtitle),
        ],
      ),
    );
  }
}

class _ResultComparisonCard extends StatelessWidget {
  const _ResultComparisonCard({
    required this.comparison,
    required this.description,
  });

  final MatchResultComparison comparison;
  final String description;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      glowColor: AppColors.success,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Winner vs Loser Breakdown', style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.sm),
          Text(
            description,
            style: AppTextStyles.subtitle.copyWith(height: 1.45),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _PlayerResultPill(
                  label: 'Winner',
                  playerName: comparison.winner.playerName,
                  color: AppColors.success,
                  icon: Icons.emoji_events_outlined,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _PlayerResultPill(
                  label: comparison.loser.surrendered ? 'Surrendered' : 'Loser',
                  playerName: comparison.loser.playerName,
                  color: comparison.loser.surrendered
                      ? AppColors.accent
                      : AppColors.primary,
                  icon: comparison.loser.surrendered
                      ? Icons.flag_outlined
                      : Icons.shield_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _ComparisonMetricRow(
            label: 'Correct guesses',
            winnerValue: comparison.winner.correctGuesses,
            loserValue: comparison.loser.correctGuesses,
            higherIsBetter: true,
          ),
          const SizedBox(height: AppSpacing.sm),
          _ComparisonMetricRow(
            label: 'Incorrect guesses',
            winnerValue: comparison.winner.incorrectGuesses,
            loserValue: comparison.loser.incorrectGuesses,
            higherIsBetter: false,
          ),
          const SizedBox(height: AppSpacing.sm),
          _ComparisonMetricRow(
            label: 'Character guesses',
            winnerValue: comparison.winner.characterGuesses,
            loserValue: comparison.loser.characterGuesses,
          ),
          const SizedBox(height: AppSpacing.sm),
          _ComparisonMetricRow(
            label: 'Tag guesses',
            winnerValue: comparison.winner.traitGuesses,
            loserValue: comparison.loser.traitGuesses,
          ),
          const SizedBox(height: AppSpacing.sm),
          _ComparisonMetricRow(
            label: 'Hints used',
            winnerValue: comparison.winner.hintsUsed,
            loserValue: comparison.loser.hintsUsed,
            higherIsBetter: false,
          ),
          const SizedBox(height: AppSpacing.sm),
          _ComparisonMetricRow(
            label: 'Turns taken',
            winnerValue: comparison.winner.turnsTaken,
            loserValue: comparison.loser.turnsTaken,
          ),
          if (comparison.loser.surrendered) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.18),
                ),
              ),
              child: Text(
                '${comparison.loser.playerName} ended the match by surrender, so the winner closed the round without needing another public guess.',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PlayerResultPill extends StatelessWidget {
  const _PlayerResultPill({
    required this.label,
    required this.playerName,
    required this.color,
    required this.icon,
  });

  final String label;
  final String playerName;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.label.copyWith(color: color)),
                const SizedBox(height: 2),
                Text(
                  playerName,
                  style:
                      AppTextStyles.body.copyWith(fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ComparisonMetricRow extends StatelessWidget {
  const _ComparisonMetricRow({
    required this.label,
    required this.winnerValue,
    required this.loserValue,
    this.higherIsBetter,
  });

  final String label;
  final int winnerValue;
  final int loserValue;
  final bool? higherIsBetter;

  @override
  Widget build(BuildContext context) {
    final winnerColor = _resolveValueColor(
      ownValue: winnerValue,
      otherValue: loserValue,
      ownWinsColor: AppColors.success,
      otherWinsColor: AppColors.accent,
    );
    final loserColor = _resolveValueColor(
      ownValue: loserValue,
      otherValue: winnerValue,
      ownWinsColor: AppColors.accent,
      otherWinsColor: AppColors.success,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: Text(
              '$winnerValue',
              textAlign: TextAlign.left,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w800,
                color: winnerColor,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.subtitle.copyWith(
                color: AppColors.text,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 48,
            child: Text(
              '$loserValue',
              textAlign: TextAlign.right,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w800,
                color: loserColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _resolveValueColor({
    required int ownValue,
    required int otherValue,
    required Color ownWinsColor,
    required Color otherWinsColor,
  }) {
    if (higherIsBetter == null || ownValue == otherValue) {
      return AppColors.text;
    }

    final ownLeads =
        higherIsBetter! ? ownValue > otherValue : ownValue < otherValue;
    return ownLeads ? ownWinsColor : otherWinsColor.withValues(alpha: 0.66);
  }
}
