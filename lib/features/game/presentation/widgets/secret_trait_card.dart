import 'package:anime_deduction_tower/shared/animations/pulse_animation.dart';
import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:flutter/material.dart';

class SecretTraitCard extends StatelessWidget {
  const SecretTraitCard({
    required this.title,
    required this.value,
    required this.isRevealed,
    required this.onToggleVisibility,
    super.key,
  });

  final String title;
  final String value;
  final bool isRevealed;
  final VoidCallback onToggleVisibility;

  @override
  Widget build(BuildContext context) {
    final accent = isRevealed ? AppColors.secondary : AppColors.primary;

    return AppCard(
      glowColor: accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.title),
                    const SizedBox(height: AppSpacing.xs),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        isRevealed
                            ? 'PRIVATE REMINDER OPEN'
                            : 'PRIVATE REMINDER HIDDEN',
                        style: AppTextStyles.label.copyWith(color: accent),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconButton(
                  tooltip:
                      isRevealed ? 'Hide tag reminder' : 'Show tag reminder',
                  onPressed: onToggleVisibility,
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: Icon(
                      isRevealed
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      key: ValueKey(isRevealed),
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: isRevealed ? 0.1 : 0.06),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: accent.withValues(alpha: 0.18)),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, animation) {
                final slideAnimation = Tween<Offset>(
                  begin: const Offset(0, 0.08),
                  end: Offset.zero,
                ).animate(animation);

                return FadeTransition(
                  opacity: animation,
                  child:
                      SlideTransition(position: slideAnimation, child: child),
                );
              },
              child: isRevealed
                  ? _RevealedTraitContent(
                      key: const ValueKey('revealed'),
                      value: value,
                    )
                  : const _HiddenTraitContent(key: ValueKey('hidden')),
            ),
          ),
        ],
      ),
    );
  }
}

class _RevealedTraitContent extends StatelessWidget {
  const _RevealedTraitContent({required this.value, super.key});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.verified_outlined,
                color: AppColors.secondary,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'Your hidden tag is visible only on this reminder card.',
                style: AppTextStyles.subtitle.copyWith(
                  color: AppColors.text,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          value,
          style: AppTextStyles.title.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _HiddenTraitContent extends StatelessWidget {
  const _HiddenTraitContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            PulseAnimation(
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.visibility_off_outlined,
                  color: AppColors.secondary,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'Hidden for privacy. Reveal it only if you need a quick reminder.',
                style: AppTextStyles.subtitle.copyWith(
                  color: AppColors.text,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          width: 180,
          height: 12,
          decoration: BoxDecoration(
            color: AppColors.muted.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: 120,
          height: 12,
          decoration: BoxDecoration(
            color: AppColors.muted.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ],
    );
  }
}
