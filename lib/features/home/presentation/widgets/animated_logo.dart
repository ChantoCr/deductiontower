import 'package:anime_deduction_tower/shared/animations/pulse_animation.dart';
import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:flutter/material.dart';

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return PulseAnimation(
      child: Container(
        width: 108,
        height: 108,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.32),
              blurRadius: 28,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.auto_awesome, size: 48, color: AppColors.text),
      ),
    );
  }
}
