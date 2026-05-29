import 'package:anime_deduction_tower/app/router.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/characters/presentation/providers/character_providers.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/match_controller.dart';
import 'package:anime_deduction_tower/features/game/presentation/helpers/match_lookup_helper.dart';
import 'package:anime_deduction_tower/features/game/presentation/helpers/match_presentation_mapper.dart';
import 'package:anime_deduction_tower/features/game/presentation/models/match_result_comparison.dart';
import 'package:anime_deduction_tower/features/game/presentation/providers/trait_category_providers.dart';
import 'package:anime_deduction_tower/features/game/presentation/widgets/guess_history.dart';
import 'package:anime_deduction_tower/features/game/presentation/widgets/result_celebration_banner.dart';
import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_button.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:anime_deduction_tower/shared/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const lookup = MatchLookupHelper();
    const mapper = MatchPresentationMapper();
    final match = ref.watch(matchControllerProvider);
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
    final timelineEntries = mapper.buildTimelineEntries(
      match: match,
      categories: categories,
      characters: characters,
    );
    final comparison = mapper.buildResultComparison(match: match);

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
            summary:
                'Review the revealed tags, remaining hint economy, and the full public event timeline before starting the next round.',
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
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _ResultStatCard(
                      label: 'Pool Size',
                      value: '${match.characterPoolIds.length}',
                      icon: Icons.style_outlined,
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
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _ResultStatCard(
                      label: '${match.playerTwo.name} Hints Left',
                      value: '${match.playerTwo.hintsRemaining}',
                      icon: Icons.looks_two_rounded,
                    ),
                  ),
                ],
              ),
            ],
          );

          final comparisonCard = _ResultComparisonCard(comparison: comparison);

          final revealedTagsCard = AppCard(
            glowColor: AppColors.secondary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Revealed Secret Tags', style: AppTextStyles.title),
                const SizedBox(height: AppSpacing.md),
                _ResultRevealRow(
                  playerName: match.playerOne.name,
                  traitLabel: playerOneTrait ?? 'Unknown',
                ),
                const SizedBox(height: AppSpacing.md),
                _ResultRevealRow(
                  playerName: match.playerTwo.name,
                  traitLabel: playerTwoTrait ?? 'Unknown',
                ),
              ],
            ),
          );

          final timelineCard = GuessHistory(
            title: 'Final Timeline',
            description:
                'Filter the full public match story by guess type, outcome, or support actions, then expand the timeline when you want the complete deduction replay.',
            entries: timelineEntries,
            collapsedCount: 6,
            emptyStateMessage: 'No final timeline events were recorded.',
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
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.secondary),
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
  const _ResultComparisonCard({required this.comparison});

  final MatchResultComparison comparison;

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
            'Compare match efficiency, guess accuracy, and support-action usage to see how the final deduction swung.',
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

class _ResultRevealRow extends StatelessWidget {
  const _ResultRevealRow({
    required this.playerName,
    required this.traitLabel,
  });

  final String playerName;
  final String traitLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              playerName,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Flexible(
            child: Text(
              traitLabel,
              textAlign: TextAlign.right,
              style: AppTextStyles.subtitle.copyWith(
                color: AppColors.text,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
