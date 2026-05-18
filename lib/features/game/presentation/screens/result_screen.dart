import 'package:anime_deduction_tower/app/router.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_button.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:anime_deduction_tower/shared/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Result',
      child: ListView(
        children: [
          const AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Winner: Player 1', style: AppTextStyles.title),
                SizedBox(height: AppSpacing.sm),
                Text('Win Reason: Correct secret trait guess'),
                Text('Secret Trait: Black Hair'),
                Text('Turns: 8'),
                Text('Character Pool Size: 12'),
                Text('Hints used: 1'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'Rematch Setup',
            icon: Icons.restart_alt,
            onPressed: () => context.go(AppRoutes.setup),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: 'Back Home',
            icon: Icons.home_outlined,
            onPressed: () => context.go(AppRoutes.home),
            isPrimary: false,
          ),
        ],
      ),
    );
  }
}
