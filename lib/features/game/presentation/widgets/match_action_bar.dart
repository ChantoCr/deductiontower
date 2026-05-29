import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_button.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:flutter/material.dart';

class MatchActionBar extends StatelessWidget {
  const MatchActionBar({
    required this.guessController,
    required this.onGuessChanged,
    required this.onSubmitCharacterGuess,
    required this.onRequestHint,
    required this.onGuessTag,
    required this.onSurrender,
    required this.onClearSelection,
    required this.canRequestHint,
    required this.canGuessTag,
    this.selectedCharacterName,
    super.key,
  });

  final TextEditingController guessController;
  final VoidCallback onGuessChanged;
  final VoidCallback onSubmitCharacterGuess;
  final VoidCallback onRequestHint;
  final VoidCallback onGuessTag;
  final VoidCallback onSurrender;
  final VoidCallback onClearSelection;
  final bool canRequestHint;
  final bool canGuessTag;
  final String? selectedCharacterName;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useWideLayout = constraints.maxWidth >= 900;
        final utilityButtons = useWideLayout
            ? Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Request Hint',
                      icon: Icons.lightbulb_outline,
                      isPrimary: false,
                      onPressed: canRequestHint ? onRequestHint : null,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppButton(
                      label: 'Guess Tag',
                      icon: Icons.psychology_alt_outlined,
                      isPrimary: false,
                      onPressed: canGuessTag ? onGuessTag : null,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppButton(
                      label: 'Surrender Match',
                      icon: Icons.flag_outlined,
                      isPrimary: false,
                      onPressed: onSurrender,
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Request Hint',
                          icon: Icons.lightbulb_outline,
                          isPrimary: false,
                          onPressed: canRequestHint ? onRequestHint : null,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: AppButton(
                          label: 'Guess Tag',
                          icon: Icons.psychology_alt_outlined,
                          isPrimary: false,
                          onPressed: canGuessTag ? onGuessTag : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppButton(
                    label: 'Surrender Match',
                    icon: Icons.flag_outlined,
                    isPrimary: false,
                    onPressed: onSurrender,
                  ),
                ],
              );

        return AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text('Action Console', style: AppTextStyles.title),
                  ),
                  if (selectedCharacterName != null)
                    TextButton.icon(
                      onPressed: onClearSelection,
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text('Clear'),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                selectedCharacterName == null
                    ? 'Pick from the pool or type an exact character name, then submit without scrolling away from the action area.'
                    : 'Your selected guess is staged below and ready for submission.',
                style: AppTextStyles.subtitle,
              ),
              if (selectedCharacterName != null) ...[
                const SizedBox(height: AppSpacing.md),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.22),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          selectedCharacterName!,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: guessController,
                decoration: const InputDecoration(
                  labelText: 'Character guess',
                  helperText:
                      'Pool tap autofills this field. Exact name matching still works.',
                  prefixIcon: Icon(Icons.person_search_outlined),
                ),
                onChanged: (_) => onGuessChanged(),
              ),
              const SizedBox(height: AppSpacing.md),
              if (useWideLayout)
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: AppButton(
                        label: 'Submit Character Guess',
                        icon: Icons.check_circle_outline,
                        onPressed: onSubmitCharacterGuess,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(flex: 5, child: utilityButtons),
                  ],
                )
              else ...[
                AppButton(
                  label: 'Submit Character Guess',
                  icon: Icons.check_circle_outline,
                  onPressed: onSubmitCharacterGuess,
                ),
                const SizedBox(height: AppSpacing.sm),
                utilityButtons,
              ],
            ],
          ),
        );
      },
    );
  }
}
