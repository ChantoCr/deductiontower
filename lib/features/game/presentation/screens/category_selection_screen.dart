import 'package:anime_deduction_tower/app/router.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_button.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:anime_deduction_tower/shared/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategorySelectionScreen extends StatelessWidget {
  const CategorySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Secret Trait Selection',
      child: ListView(
        children: [
          const AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Protected Selection Flow', style: AppTextStyles.title),
                SizedBox(height: AppSpacing.sm),
                Text('This screen will later protect secret information during local pass-and-play setup.'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const SecretTraitPreview(label: 'Preview Trait', value: 'Black Hair'),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'Pass to Next Player',
            icon: Icons.swap_horiz,
            onPressed: () => context.go(AppRoutes.turnTransition),
          ),
        ],
      ),
    );
  }
}

class SecretTraitPreview extends StatelessWidget {
  const SecretTraitPreview({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.sm),
          Text(value, style: AppTextStyles.subtitle),
        ],
      ),
    );
  }
}
