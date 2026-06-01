import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';

class AppDialog {
  const AppDialog._();

  static Future<void> showInfo(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => _AnimatedDialogShell(
        title: title,
        accentColor: AppColors.secondary,
        icon: Icons.info_outline,
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(height: 1.45),
        ),
        actions: [
          SizedBox(
            width: 180,
            child: AppButton(
              label: 'Continue',
              icon: Icons.arrow_forward_rounded,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> showFeedback(
    BuildContext context, {
    required String title,
    required String message,
    required bool isSuccess,
  }) {
    final accentColor = isSuccess ? AppColors.success : AppColors.error;
    final icon = isSuccess ? Icons.check_circle_outline : Icons.cancel_outlined;

    return showDialog<void>(
      context: context,
      builder: (context) => _AnimatedDialogShell(
        title: title,
        accentColor: accentColor,
        icon: icon,
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(height: 1.45),
        ),
        actions: [
          SizedBox(
            width: 180,
            child: AppButton(
              label: 'Continue',
              icon: Icons.arrow_forward_rounded,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> showCustom(
    BuildContext context, {
    required String title,
    required Widget content,
    required List<Widget> actions,
    Color accentColor = AppColors.secondary,
    IconData icon = Icons.info_outline,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => _AnimatedDialogShell(
        title: title,
        accentColor: accentColor,
        icon: icon,
        content: content,
        actions: actions,
      ),
    );
  }

  static Future<bool> showConfirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDanger = false,
  }) async {
    final accentColor = isDanger ? AppColors.error : AppColors.secondary;
    final icon = isDanger ? Icons.warning_amber_rounded : Icons.help_outline;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => _AnimatedDialogShell(
        title: title,
        accentColor: accentColor,
        icon: icon,
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(height: 1.45),
        ),
        actions: [
          Expanded(
            child: AppButton(
              label: cancelLabel,
              icon: Icons.close_rounded,
              isPrimary: false,
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: AppButton(
              label: confirmLabel,
              icon: isDanger ? Icons.flag_outlined : Icons.check_rounded,
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}

class _AnimatedDialogShell extends StatelessWidget {
  const _AnimatedDialogShell({
    required this.title,
    required this.accentColor,
    required this.icon,
    required this.content,
    required this.actions,
  });

  final String title;
  final Color accentColor;
  final IconData icon;
  final Widget content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      title: Row(
        children: [
          Expanded(child: Text(title)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.7, end: 1),
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutBack,
            builder: (context, value, child) => Transform.scale(
              scale: value,
              child: Opacity(opacity: value.clamp(0, 1), child: child),
            ),
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accentColor, size: 40),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          content,
        ],
      ),
      actions: [
        Row(
          children: actions,
        ),
      ],
    );
  }
}
