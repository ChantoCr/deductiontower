import 'package:anime_deduction_tower/app/router.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_button.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:anime_deduction_tower/shared/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TurnTransitionScreen extends StatelessWidget {
  const TurnTransitionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Pass the Phone',
      child: Center(
        child: AppCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Prepare the Next Player', style: AppTextStyles.title),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Use this protected screen before revealing the next secret trait or starting the match.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'Start Match',
                icon: Icons.play_circle_outline,
                onPressed: () => context.go(AppRoutes.match),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
