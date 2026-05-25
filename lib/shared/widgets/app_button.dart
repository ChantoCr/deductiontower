import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:flutter/material.dart';

class AppButton extends StatefulWidget {
  const AppButton({
    required this.label,
    this.onPressed,
    this.icon,
    this.isPrimary = true,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isPrimary;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null;
    final glowColor =
        widget.isPrimary ? AppColors.primary : AppColors.secondary;

    final child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, size: 18),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            widget.label,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        ),
      ],
    );

    final button = widget.isPrimary
        ? ElevatedButton(onPressed: widget.onPressed, child: child)
        : OutlinedButton(onPressed: widget.onPressed, child: child);

    return MouseRegion(
      onEnter: isEnabled ? (_) => setState(() => _isHovered = true) : null,
      onExit: isEnabled ? (_) => setState(() => _isHovered = false) : null,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOutCubic,
        scale: isEnabled && _isHovered ? 1.01 : 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: !isEnabled || !_isHovered
                ? const []
                : [
                    BoxShadow(
                      color: glowColor.withValues(
                        alpha: widget.isPrimary ? 0.22 : 0.12,
                      ),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
          ),
          child: button,
        ),
      ),
    );
  }
}
