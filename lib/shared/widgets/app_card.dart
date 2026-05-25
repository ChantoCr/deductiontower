import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:flutter/material.dart';

class AppCard extends StatefulWidget {
  const AppCard({
    required this.child,
    this.padding,
    this.glowColor,
    this.enableHoverEffect = true,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? glowColor;
  final bool enableHoverEffect;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final glowColor = widget.glowColor ?? AppColors.primary;
    final showHoverEffect = widget.enableHoverEffect;

    return MouseRegion(
      onEnter:
          showHoverEffect ? (_) => setState(() => _isHovered = true) : null,
      onExit:
          showHoverEffect ? (_) => setState(() => _isHovered = false) : null,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        scale: showHoverEffect && _isHovered ? 1.008 : 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          width: double.infinity,
          padding: widget.padding ?? const EdgeInsets.all(20),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: glowColor.withValues(
                alpha: showHoverEffect && _isHovered ? 0.26 : 0.16,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: glowColor.withValues(
                  alpha: showHoverEffect && _isHovered ? 0.18 : 0.12,
                ),
                blurRadius: showHoverEffect && _isHovered ? 30 : 24,
                offset: Offset(0, showHoverEffect && _isHovered ? 16 : 12),
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
