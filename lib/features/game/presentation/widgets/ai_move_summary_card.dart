import 'package:anime_deduction_tower/core/enums/ai_difficulty.dart';
import 'package:anime_deduction_tower/core/enums/turn_action_type.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/features/game/domain/entities/turn.dart';
import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_badge.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:flutter/material.dart';

class AiMoveSummaryCard extends StatelessWidget {
  const AiMoveSummaryCard({
    required this.aiName,
    required this.difficulty,
    required this.turn,
    required this.categories,
    required this.characters,
    this.title = 'Latest AI Move Summary',
    this.description,
    this.glowColor = AppColors.accent,
    super.key,
  });

  final String aiName;
  final AiDifficulty difficulty;
  final Turn turn;
  final List<TraitCategory> categories;
  final List<Character> characters;
  final String title;
  final String? description;
  final Color glowColor;

  @override
  Widget build(BuildContext context) {
    final accent = _accentForTurn(turn);
    final resolvedValue = _resolvedValue(turn);
    final moveLabel = _moveLabel(turn.actionType);
    final outcomeLabel = _outcomeLabel(turn);
    final outcomeDescription = _outcomeDescription(turn);
    final summary = turn.publicNote ?? 'No AI reasoning summary was captured.';

    return AppCard(
      glowColor: glowColor,
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
                    Text(title, style: AppTextStyles.title),
                    if (description != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        description!,
                        style: AppTextStyles.subtitle.copyWith(height: 1.45),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppBadge(
                icon: Icons.smart_toy_outlined,
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
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              AppBadge(
                icon: Icons.psychology_alt_outlined,
                label: moveLabel,
                accent: AppColors.secondary,
                backgroundColor: AppColors.secondary.withValues(alpha: 0.12),
                textStyle: AppTextStyles.body.copyWith(
                  color: AppColors.text,
                  fontWeight: FontWeight.w700,
                ),
              ),
              AppBadge(
                icon: turn.wasCorrect
                    ? Icons.check_circle_outline
                    : Icons.radio_button_unchecked_outlined,
                label: outcomeLabel,
                accent: accent,
                backgroundColor: accent.withValues(alpha: 0.12),
                textStyle: AppTextStyles.body.copyWith(
                  color: AppColors.text,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: accent.withValues(alpha: 0.18)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$aiName revealed $resolvedValue',
                  style: AppTextStyles.body.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  outcomeDescription,
                  style: AppTextStyles.subtitle.copyWith(height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.26),
              borderRadius: BorderRadius.circular(18),
              border:
                  Border.all(color: AppColors.primary.withValues(alpha: 0.14)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI reasoning summary',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  summary,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _accentForTurn(Turn turn) {
    switch (turn.actionType) {
      case TurnActionType.guessCharacter:
      case TurnActionType.guessTrait:
        return turn.wasCorrect ? AppColors.success : AppColors.accent;
      case TurnActionType.requestHint:
        return AppColors.secondary;
      case TurnActionType.surrender:
        return AppColors.error;
      case TurnActionType.pass:
        return AppColors.muted;
    }
  }

  String _resolvedValue(Turn turn) {
    switch (turn.actionType) {
      case TurnActionType.guessCharacter:
        return _findCharacterName(turn.value);
      case TurnActionType.guessTrait:
        return _findTraitLabel(turn.value) ?? turn.value;
      case TurnActionType.requestHint:
      case TurnActionType.surrender:
      case TurnActionType.pass:
        return turn.value;
    }
  }

  String _moveLabel(TurnActionType actionType) {
    switch (actionType) {
      case TurnActionType.guessCharacter:
        return 'Public character probe';
      case TurnActionType.guessTrait:
        return 'Final tag read';
      case TurnActionType.requestHint:
        return 'Hint request';
      case TurnActionType.surrender:
        return 'Surrender';
      case TurnActionType.pass:
        return 'Pass';
    }
  }

  String _outcomeLabel(Turn turn) {
    switch (turn.actionType) {
      case TurnActionType.guessCharacter:
        return turn.wasCorrect ? 'Probe connected' : 'Probe missed';
      case TurnActionType.guessTrait:
        return turn.wasCorrect ? 'Tag confirmed' : 'Tag denied';
      case TurnActionType.requestHint:
        return 'Utility action';
      case TurnActionType.surrender:
        return 'Match ended';
      case TurnActionType.pass:
        return 'Turn passed';
    }
  }

  String _outcomeDescription(Turn turn) {
    switch (turn.actionType) {
      case TurnActionType.guessCharacter:
        return turn.wasCorrect
            ? 'That public character check matched the hidden tag and confirmed live evidence for the AI.'
            : 'That public character check failed to match the hidden tag, trimming the AI\'s live read.';
      case TurnActionType.guessTrait:
        return turn.wasCorrect
            ? 'The AI committed to a final tag guess and ended the match immediately.'
            : 'The AI committed to a final tag guess, but the hidden tag stayed unresolved.';
      case TurnActionType.requestHint:
        return 'The AI spent a support action instead of making a public guess.';
      case TurnActionType.surrender:
        return 'The AI ended the round by surrendering.';
      case TurnActionType.pass:
        return 'The AI passed control without spending a guess.';
    }
  }

  String _findCharacterName(String characterId) {
    for (final character in characters) {
      if (character.id == characterId) {
        return character.name;
      }
    }

    return characterId;
  }

  String? _findTraitLabel(String traitId) {
    for (final category in categories) {
      if (category.id == traitId) {
        return category.label;
      }
    }

    return null;
  }
}
