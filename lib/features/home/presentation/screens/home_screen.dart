import 'package:anime_deduction_tower/app/router.dart';
import 'package:anime_deduction_tower/core/enums/game_mode.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/category_selection_controller.dart';
import 'package:anime_deduction_tower/features/game/presentation/controllers/game_setup_controller.dart';
import 'package:anime_deduction_tower/features/home/presentation/widgets/animated_logo.dart';
import 'package:anime_deduction_tower/features/home/presentation/widgets/main_menu_button.dart';
import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:anime_deduction_tower/shared/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: AnimatedLogo()),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Anime Deduction Tower',
              style: AppTextStyles.hero,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'A deduction battleground with private traits, shared character pools, and clean turn-based reasoning.',
              style: AppTextStyles.subtitle.copyWith(fontSize: 17),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text('PLAY MODES', style: AppTextStyles.label),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Text(
                    'Choose how you want to play.',
                    style: AppTextStyles.title,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Local multiplayer is ready for gameplay iteration, Play vs AI now has a stronger presentation pass, and online multiplayer has started its room-code foundation preview.',
                    style: AppTextStyles.subtitle.copyWith(height: 1.45),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            MainMenuButton(
              label: 'Single Device Match',
              subtitle:
                  'Professional local setup with protected trait selection and pass-the-device turns.',
              icon: Icons.sports_esports_rounded,
              onPressed: () {
                ref
                    .read(gameSetupControllerProvider.notifier)
                    .updateMatchMode(GameMode.localMultiplayer);
                ref.read(categorySelectionControllerProvider.notifier).reset();
                context.go(AppRoutes.setup);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            MainMenuButton(
              label: 'Play vs AI',
              subtitle:
                  'Start a mock AI match where the opponent receives an auto-assigned hidden tag and takes automated public turns.',
              icon: Icons.smart_toy_outlined,
              onPressed: () {
                ref
                    .read(gameSetupControllerProvider.notifier)
                    .updateMatchMode(GameMode.playerVsAi);
                ref
                    .read(categorySelectionControllerProvider.notifier)
                    .reset(isPlayerVsAi: true);
                context.go(AppRoutes.setup);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            MainMenuButton(
              label: 'Online Match',
              subtitle:
                  'Preview the new room-code lobby foundation before realtime sync and remote match state are connected.',
              icon: Icons.wifi_tethering_rounded,
              onPressed: () => context.go(AppRoutes.onlineMatch),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Explore the build', style: AppTextStyles.title),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Verify the live imported roster, inspect the current catalog, and move around the supporting screens while gameplay iteration continues.',
                    style: AppTextStyles.subtitle.copyWith(height: 1.45),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            MainMenuButton(
              label: 'Character Library',
              subtitle:
                  'Browse the full live catalog with search and imported-character coverage.',
              icon: Icons.style_outlined,
              onPressed: () => context.go(AppRoutes.characters),
            ),
            const SizedBox(height: AppSpacing.md),
            MainMenuButton(
              label: 'Profile',
              subtitle: 'Future player stats, history, and progression.',
              icon: Icons.person_outline,
              onPressed: () => context.go(AppRoutes.profile),
            ),
            const SizedBox(height: AppSpacing.md),
            MainMenuButton(
              label: 'Settings',
              subtitle: 'Theme and future gameplay preferences.',
              icon: Icons.settings_outlined,
              onPressed: () => context.go(AppRoutes.settings),
            ),
          ],
        ),
      ),
    );
  }
}
