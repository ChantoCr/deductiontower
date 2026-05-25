import 'package:anime_deduction_tower/app/router.dart';
import 'package:anime_deduction_tower/core/enums/match_status.dart';
import 'package:anime_deduction_tower/features/characters/presentation/providers/character_providers.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/game_match.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/category_selection_controller.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/game_setup_controller.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/match_controller.dart';
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
    final match = ref.watch(matchControllerProvider);
    final isExistingMatch = match != null;
    final isCompletedMatch = match?.status == MatchStatus.completed;

    final title = isCompletedMatch
        ? 'Match Complete'
        : isExistingMatch
            ? 'Protected Handoff'
            : 'Prepare the First Player';

    final description = isCompletedMatch
        ? 'The match is over. Open the result screen to review the winner, end reason, and full deduction trail.'
        : isExistingMatch
            ? 'Hand the device to ${match.currentPlayer.name}. Only the active player should reveal the next private gameplay screen.'
            : 'Use this protection screen before revealing the first hidden tag and starting the live match.';

    final buttonLabel = isCompletedMatch
        ? 'View Result'
        : isExistingMatch
            ? 'Reveal Protected Turn'
            : 'Start Match';

    return AppScaffold(
      title: 'Pass the Device',
      bottomBar: AppCard(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PulseAnimation(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shield_moon_outlined,
                      color: AppColors.secondary,
                      size: 34,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(title, style: AppTextStyles.hero.copyWith(fontSize: 30)),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  description,
                  style: AppTextStyles.subtitle.copyWith(height: 1.5),
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
                  ],
                ),
              ],
            ),
          );

          final infoCard = AppCard(
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
                if (isExistingMatch && !isCompletedMatch) ...[
                  const SizedBox(height: AppSpacing.md),
                  _ChecklistItem(
                    title: 'Current match snapshot',
                    subtitle:
                        'Turns played: ${match.turns.length} • Shared pool size: ${match.characterPoolIds.length} • Hints: ${match.currentPlayer.hintsRemaining}',
                  ),
                ],
              ],
            ),
          );

          if (useWideLayout) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 11, child: leadCard),
                const SizedBox(width: AppSpacing.md),
                Expanded(flex: 9, child: infoCard),
              ],
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
