import 'package:anime_deduction_tower/app/router.dart';
import 'package:anime_deduction_tower/features/home/presentation/widgets/animated_logo.dart';
import 'package:anime_deduction_tower/features/home/presentation/widgets/main_menu_button.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:anime_deduction_tower/shared/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Home',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: AnimatedLogo()),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Anime Deduction Tower',
              style: AppTextStyles.title,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'A strategy deduction game built with Flutter + Flame.',
              style: AppTextStyles.subtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MainMenuButton(
                    label: 'Play Local',
                    subtitle: 'Foundation path for the MVP.',
                    icon: Icons.groups_rounded,
                    onPressed: () => context.go(AppRoutes.setup),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const MainMenuButton(
                    label: 'Play vs AI',
                    subtitle: 'Coming soon in the AI-ready phase.',
                    icon: Icons.smart_toy_outlined,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const MainMenuButton(
                    label: 'Online Match',
                    subtitle: 'Planned after local multiplayer is stable.',
                    icon: Icons.wifi_tethering_rounded,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  MainMenuButton(
                    label: 'Characters',
                    subtitle: 'Browse placeholder character data.',
                    icon: Icons.style_outlined,
                    onPressed: () => context.go(AppRoutes.characters),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  MainMenuButton(
                    label: 'Profile',
                    subtitle: 'Future player stats and achievements.',
                    icon: Icons.person_outline,
                    onPressed: () => context.go(AppRoutes.profile),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  MainMenuButton(
                    label: 'Settings',
                    subtitle: 'Theme and gameplay preferences.',
                    icon: Icons.settings_outlined,
                    onPressed: () => context.go(AppRoutes.settings),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
