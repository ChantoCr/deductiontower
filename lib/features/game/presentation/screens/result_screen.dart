import 'package:anime_deduction_tower/app/router.dart';
import 'package:anime_deduction_tower/core/enums/match_end_reason.dart';
import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/characters/presentation/providers/character_providers.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/turn.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/match_controller.dart';
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

    final winnerName = match.winnerId == match.playerOne.id
        ? match.playerOne.name
        : match.winnerId == match.playerTwo.id
            ? match.playerTwo.name
            : 'No winner';
    final playerOneTrait =
        _findTraitLabel(categories, match.playerOne.secretTraitId);
    final playerTwoTrait =
        _findTraitLabel(categories, match.playerTwo.secretTraitId);
    final timelineEntries = _buildTimelineEntries(
      turns: match.turns,
      categories: categories,
      characters: characters,
      playerOneName: match.playerOne.name,
      playerTwoName: match.playerTwo.name,
      playerOneId: match.playerOne.id,
    );

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
            reasonLabel: _endReasonLabel(match.endReason),
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
                      label: '${match.playerOne.name} Hints',
                      value: '${match.playerOne.hintsRemaining}',
                      icon: Icons.looks_one_rounded,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _ResultStatCard(
                      label: '${match.playerTwo.name} Hints',
                      value: '${match.playerTwo.hintsRemaining}',
                      icon: Icons.looks_two_rounded,
                    ),
                  ),
                ],
              ),
            ],
          );

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

  List<GuessHistoryEntry> _buildTimelineEntries({
    required List<Turn> turns,
    required List<TraitCategory> categories,
    required List<Character> characters,
    required String playerOneName,
    required String playerTwoName,
    required String playerOneId,
  }) {
    return turns.reversed.map((turn) {
      final playerName =
          turn.playerId == playerOneId ? playerOneName : playerTwoName;

      switch (turn.actionType) {
        case TurnActionType.guessCharacter:
          final characterName = _findCharacterName(characters, turn.value);
          return GuessHistoryEntry(
            title: '$playerName guessed $characterName',
            subtitle: turn.wasCorrect
                ? 'The character matched the hidden tag.'
                : 'The character did not match the hidden tag.',
            icon: turn.wasCorrect
                ? Icons.check_circle_outline
                : Icons.cancel_outlined,
            color: turn.wasCorrect ? AppColors.success : AppColors.error,
            actionType: turn.actionType,
            playerName: playerName,
            wasCorrect: turn.wasCorrect,
          );
        case TurnActionType.guessTrait:
          final traitLabel =
              _findTraitLabel(categories, turn.value) ?? turn.value;
          return GuessHistoryEntry(
            title: '$playerName guessed tag $traitLabel',
            subtitle: turn.wasCorrect
                ? 'The final tag guess was correct.'
                : 'The final tag guess was incorrect.',
            icon: turn.wasCorrect
                ? Icons.emoji_events_outlined
                : Icons.psychology_alt_outlined,
            color: turn.wasCorrect ? AppColors.success : AppColors.error,
            actionType: turn.actionType,
            playerName: playerName,
            wasCorrect: turn.wasCorrect,
          );
        case TurnActionType.requestHint:
          return GuessHistoryEntry(
            title: '$playerName requested a private hint',
            subtitle: 'A hidden clue was consumed to continue the deduction.',
            icon: Icons.lightbulb_outline,
            color: AppColors.secondary,
            actionType: turn.actionType,
            playerName: playerName,
          );
        case TurnActionType.surrender:
          return GuessHistoryEntry(
            title: '$playerName surrendered',
            subtitle: 'The opponent won immediately by surrender.',
            icon: Icons.flag_outlined,
            color: AppColors.accent,
            actionType: turn.actionType,
            playerName: playerName,
          );
        case TurnActionType.pass:
          return GuessHistoryEntry(
            title: '$playerName passed the turn',
            subtitle: 'Control moved to the next player.',
            icon: Icons.swap_horiz_rounded,
            color: AppColors.muted,
            actionType: turn.actionType,
            playerName: playerName,
          );
      }
    }).toList();
  }

  String _findCharacterName(List<Character> characters, String characterId) {
    for (final character in characters) {
      if (character.id == characterId) {
        return character.name;
      }
    }

    return characterId;
  }

  String? _findTraitLabel(List<TraitCategory> categories, String? traitId) {
    if (traitId == null) {
      return null;
    }

    for (final category in categories) {
      if (category.id == traitId) {
        return category.label;
      }
    }

    return null;
  }

  String _endReasonLabel(MatchEndReason? endReason) {
    switch (endReason) {
      case MatchEndReason.correctTraitGuess:
        return 'Victory by correct secret tag guess';
      case MatchEndReason.surrender:
        return 'Victory by surrender';
      case null:
        return 'Match ended';
    }
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
