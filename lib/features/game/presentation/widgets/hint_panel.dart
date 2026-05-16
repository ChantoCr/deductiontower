import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:flutter/material.dart';

class HintPanel extends StatelessWidget {
  const HintPanel({required this.hint, super.key});

  final String hint;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Hint Panel', style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.sm),
          Text(hint),
        ],
      ),
    );
  }
}
