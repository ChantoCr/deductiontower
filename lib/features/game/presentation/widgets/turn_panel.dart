import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:flutter/material.dart';

class TurnPanel extends StatelessWidget {
  const TurnPanel({
    required this.currentPlayer,
    required this.hints,
    super.key,
  });

  final String currentPlayer;
  final int hints;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Turn Panel', style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.sm),
          Text('Current player: $currentPlayer'),
          Text('Hints left: $hints'),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            'Match ends when a player surrenders or correctly guesses the opponent\'s secret trait.',
          ),
        ],
      ),
    );
  }
}
