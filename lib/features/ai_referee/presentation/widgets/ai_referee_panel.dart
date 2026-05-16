import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:flutter/material.dart';

class AiRefereePanel extends StatelessWidget {
  const AiRefereePanel({super.key, this.message = 'AI referee support will be added in a future phase.'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('AI Referee', style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.sm),
          Text(message),
        ],
      ),
    );
  }
}
