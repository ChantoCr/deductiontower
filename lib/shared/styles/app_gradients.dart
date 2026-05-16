import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:flutter/material.dart';

class AppGradients {
  const AppGradients._();

  static const LinearGradient screenBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF101427),
      AppColors.background,
      Color(0xFF07090F),
    ],
  );
}
