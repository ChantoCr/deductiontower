import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:flutter/material.dart';

class PlayerStatsCard extends StatelessWidget {
  const PlayerStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Player Stats Placeholder', style: AppTextStyles.title),
          SizedBox(height: AppSpacing.sm),
          Text('Wins, match history, achievements, and progression will be added later.'),
        ],
      ),
    );
  }
}
