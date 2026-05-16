import 'package:anime_deduction_tower/app/router.dart';
import 'package:anime_deduction_tower/features/game/presentation/widgets/category_guess_dialog.dart';
import 'package:anime_deduction_tower/features/game/presentation/widgets/guess_history.dart';
import 'package:anime_deduction_tower/features/game/presentation/widgets/hint_panel.dart';
import 'package:anime_deduction_tower/features/game/presentation/widgets/secret_trait_card.dart';
import 'package:anime_deduction_tower/features/game/presentation/widgets/tower_view.dart';
import 'package:anime_deduction_tower/features/game/presentation/widgets/turn_panel.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/widgets/app_button.dart';
import 'package:anime_deduction_tower/shared/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Match',
      child: ListView(
        children: [
          const TurnPanel(currentPlayer: 'Player 1', lives: 3, hints: 2),
          const SizedBox(height: AppSpacing.md),
          const TowerView(label: 'Opponent Mystery Tower'),
          const SizedBox(height: AppSpacing.md),
          const SecretTraitCard(title: 'Your Secret Trait', value: 'Hidden during real gameplay'),
          const SizedBox(height: AppSpacing.md),
          const HintPanel(hint: 'The trait is related to appearance.'),
          const SizedBox(height: AppSpacing.md),
          const GuessHistory(
            items: ['Player 1 guessed Shadow Ninja', 'Player 2 asked for a hint'],
          ),
          const SizedBox(height: AppSpacing.lg),
          const TextField(decoration: InputDecoration(labelText: 'Guess a character')),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: 'Guess Secret Trait',
            icon: Icons.psychology_alt_outlined,
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => const CategoryGuessDialog(),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: 'Finish Placeholder Match',
            icon: Icons.flag_outlined,
            onPressed: () => context.go(AppRoutes.result),
          ),
        ],
      ),
    );
  }
}
