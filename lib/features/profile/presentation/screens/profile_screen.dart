import 'package:anime_deduction_tower/features/profile/presentation/widgets/player_stats_card.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Profile',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Text('Future Profile System', style: AppTextStyles.title),
          SizedBox(height: AppSpacing.md),
          PlayerStatsCard(),
        ],
      ),
    );
  }
}
