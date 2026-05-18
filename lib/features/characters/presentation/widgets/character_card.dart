import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:flutter/material.dart';

class CharacterCard extends StatelessWidget {
  const CharacterCard({required this.character, super.key});

  final Character character;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(character.name, style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.xs),
          Text(character.series, style: AppTextStyles.subtitle),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: character.tags
                .map(
                  (tag) => Chip(
                    label: Text(tag),
                    backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                    side: BorderSide.none,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
