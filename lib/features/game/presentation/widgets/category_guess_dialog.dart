import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class CategoryGuessDialog extends StatefulWidget {
  const CategoryGuessDialog({
    required this.categories,
    required this.onTraitSelected,
    super.key,
  });

  final List<TraitCategory> categories;
  final ValueChanged<TraitCategory> onTraitSelected;

  @override
  State<CategoryGuessDialog> createState() => _CategoryGuessDialogState();
}

class _CategoryGuessDialogState extends State<CategoryGuessDialog> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredCategories = widget.categories.where((category) {
      final query = _searchQuery.trim().toLowerCase();
      if (query.isEmpty) {
        return true;
      }

      return category.label.toLowerCase().contains(query) ||
          category.hintType.toLowerCase().contains(query);
    }).toList()
      ..sort((a, b) => a.label.compareTo(b.label));

    return AlertDialog(
      title: const Text('Guess the Secret Tag'),
      content: SizedBox(
        width: double.maxFinite,
        height: 420,
        child: Column(
          children: [
            TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: const InputDecoration(
                labelText: 'Search tags',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${filteredCategories.length} tags available',
                style: AppTextStyles.subtitle,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: filteredCategories.isEmpty
                  ? const Center(
                      child: Text('No tags match the current search.'),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: filteredCategories.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final category = filteredCategories[index];

                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(category.label),
                          subtitle: Text(
                            '${category.hintType} • ${category.difficulty.name}',
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: AppColors.muted.withValues(alpha: 0.9),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            widget.onTraitSelected(category);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
