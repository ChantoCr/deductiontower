import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppBadge extends StatelessWidget {
  const AppBadge({
    required this.label,
    this.icon,
    this.accent = AppColors.secondary,
    this.backgroundColor,
    this.borderColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.textStyle,
    this.iconSize = 16,
    this.iconSpacing = 8,
    super.key,
  });

  final String label;
  final IconData? icon;
  final Color accent;
  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;
  final double iconSize;
  final double iconSpacing;

  @override
  Widget build(BuildContext context) {
    final resolvedTextStyle = textStyle ??
        AppTextStyles.body.copyWith(
          color: AppColors.text,
          fontWeight: FontWeight.w600,
        );

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: borderColor == null ? null : Border.all(color: borderColor!),
      ),
      child: icon == null
          ? Text(label, style: resolvedTextStyle)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: iconSize, color: accent),
                SizedBox(width: iconSpacing),
                Flexible(child: Text(label, style: resolvedTextStyle)),
              ],
            ),
    );
  }
}
