import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        ),
      ],
    );

    if (isPrimary) {
      return ElevatedButton(onPressed: onPressed, child: child);
    }

    return OutlinedButton(onPressed: onPressed, child: child);
  }
}
