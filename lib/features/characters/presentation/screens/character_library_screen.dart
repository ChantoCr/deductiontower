import 'package:anime_deduction_tower/core/enums/difficulty_level.dart';
import 'package:anime_deduction_tower/features/characters/domain/entities/character.dart';
import 'package:anime_deduction_tower/features/characters/presentation/widgets/character_card.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

class CharacterLibraryScreen extends StatelessWidget {
  const CharacterLibraryScreen({super.key});

  static const _previewCharacters = [
    Character(
      id: 'shadow_ninja',
      name: 'Shadow Ninja',
      series: 'Original',
      tags: ['black_hair', 'uses_sword', 'has_tragic_past'],
      difficulty: DifficultyLevel.medium,
      popularity: 8,
    ),
    Character(
      id: 'solar_fighter',
      name: 'Solar Fighter',
      series: 'Original',
      tags: ['protagonist', 'has_transformation'],
      difficulty: DifficultyLevel.easy,
      popularity: 9,
    ),
    Character(
      id: 'void_beast',
      name: 'Void Beast',
      series: 'Original',
      tags: ['villain', 'non_human', 'has_transformation'],
      difficulty: DifficultyLevel.medium,
      popularity: 7,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Character Library',
      child: ListView(
        children: [
          const Text('Sample Character Data', style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'This placeholder screen previews the original, anime-inspired dataset used for the foundation phase.',
            style: AppTextStyles.body,
          ),
          const SizedBox(height: AppSpacing.lg),
          const CharacterCard(character: _previewCharacters[0]),
          const SizedBox(height: AppSpacing.md),
          const CharacterCard(character: _previewCharacters[1]),
          const SizedBox(height: AppSpacing.md),
          const CharacterCard(character: _previewCharacters[2]),
        ],
      ),
    );
  }
}
