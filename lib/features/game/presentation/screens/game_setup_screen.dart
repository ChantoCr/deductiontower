import 'package:anime_deduction_tower/app/router.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/category_selection_controller.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_button.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:anime_deduction_tower/shared/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GameSetupScreen extends ConsumerWidget {
  const GameSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      title: 'Game Setup',
      child: ListView(
        children: [
          const AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Local Multiplayer Setup', style: AppTextStyles.title),
                SizedBox(height: AppSpacing.sm),
                Text('Player names, difficulty, hints, and timer options will be wired here in a future step.'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const TextField(decoration: InputDecoration(labelText: 'Player 1 Name')),
          const SizedBox(height: AppSpacing.md),
          const TextField(decoration: InputDecoration(labelText: 'Player 2 Name')),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'Continue to Secret Selection',
            icon: Icons.arrow_forward,
            onPressed: () {
              ref.read(categorySelectionControllerProvider.notifier).reset();
              context.go(AppRoutes.categorySelection);
            },
          ),
        ],
      ),
    );
  }
}
