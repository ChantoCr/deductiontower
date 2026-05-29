import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_card.dart';
import 'package:flutter/material.dart';

class AppSummaryItem {
  const AppSummaryItem({required this.label, required this.value});

  final String label;
  final String value;
}

class AppSummaryCard extends StatelessWidget {
  const AppSummaryCard({
    required this.title,
    required this.items,
    this.description,
    this.footer,
    this.glowColor,
    this.rowBackgroundColor,
    this.rowBorderColor,
    this.rowPadding = const EdgeInsets.all(14),
    this.rowSpacing = AppSpacing.sm,
    this.labelStyle,
    this.valueStyle,
    super.key,
  });

  final String title;
  final List<AppSummaryItem> items;
  final String? description;
  final Widget? footer;
  final Color? glowColor;
  final Color? rowBackgroundColor;
  final Color? rowBorderColor;
  final EdgeInsetsGeometry rowPadding;
  final double rowSpacing;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      glowColor: glowColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.title),
          if (description != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              description!,
              style: AppTextStyles.subtitle.copyWith(height: 1.45),
            ),
          ],
          if (items.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Column(
              children: [
                for (var index = 0; index < items.length; index++) ...[
                  AppSummaryRow(
                    item: items[index],
                    backgroundColor: rowBackgroundColor,
                    borderColor: rowBorderColor,
                    padding: rowPadding,
                    labelStyle: labelStyle,
                    valueStyle: valueStyle,
                  ),
                  if (index < items.length - 1) SizedBox(height: rowSpacing),
                ],
              ],
            ),
          ],
          if (footer != null) ...[
            const SizedBox(height: AppSpacing.md),
            footer!,
          ],
        ],
      ),
    );
  }
}

class AppSummaryRow extends StatelessWidget {
  const AppSummaryRow({
    required this.item,
    this.backgroundColor,
    this.borderColor,
    this.padding = const EdgeInsets.all(14),
    this.labelStyle,
    this.valueStyle,
    super.key,
  });

  final AppSummaryItem item;
  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsetsGeometry padding;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      children: [
        Expanded(
          child: Text(
            item.label,
            style: labelStyle ??
                AppTextStyles.subtitle.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Flexible(
          child: Text(
            item.value,
            textAlign: TextAlign.right,
            style: valueStyle ??
                AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );

    if (backgroundColor == null && borderColor == null) {
      return row;
    }

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: borderColor == null ? null : Border.all(color: borderColor!),
      ),
      child: row,
    );
  }
}
