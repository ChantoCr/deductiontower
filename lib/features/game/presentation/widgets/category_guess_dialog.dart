import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:anime_deduction_tower/shared/styles/app_colors.dart';
import 'package:anime_deduction_tower/shared/styles/app_spacing.dart';
import 'package:anime_deduction_tower/shared/styles/app_text_styles.dart';
import 'package:anime_deduction_tower/shared/widgets/app_button.dart';
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
  late final TextEditingController _searchController;
  String _searchQuery = '';
  String? _selectedCategoryId;
  String? _hoveredCategoryId;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

    TraitCategory? selectedCategory;
    final selectedCategoryId = _selectedCategoryId;
    if (selectedCategoryId != null) {
      for (final category in widget.categories) {
        if (category.id == selectedCategoryId) {
          selectedCategory = category;
          break;
        }
      }
    }

    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Guess the Secret Tag'),
          const SizedBox(height: 6),
          Text(
            'Search, stage, and confirm a final tag guess without exposing extra hidden information.',
            style: AppTextStyles.subtitle.copyWith(fontSize: 14),
          ),
        ],
      ),
      content: SizedBox(
        width: 560,
        height: 520,
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                labelText: 'Search tags',
                hintText: 'Search by label or hint type',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.trim().isEmpty
                    ? null
                    : IconButton(
                        onPressed: _clearSearch,
                        icon: const Icon(Icons.close),
                      ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Text(
                  '${filteredCategories.length} tags available',
                  style: AppTextStyles.subtitle,
                ),
                const Spacer(),
                if (selectedCategory != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      selectedCategory.hintType,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  axisAlignment: -1,
                  child: child,
                ),
              ),
              child: selectedCategory == null
                  ? Container(
                      key: const ValueKey('no-selection'),
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.12),
                        ),
                      ),
                      child: const Text(
                        'No final tag guess is staged yet. Tap a tag below to preview it before confirming.',
                        style: AppTextStyles.subtitle,
                      ),
                    )
                  : Container(
                      key: ValueKey(selectedCategory.id),
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: AppColors.secondary.withValues(alpha: 0.22),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.psychology_alt_outlined,
                            color: AppColors.secondary,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Staged final tag guess',
                                  style: AppTextStyles.body.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  selectedCategory.label,
                                  style: AppTextStyles.subtitle.copyWith(
                                    color: AppColors.text,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: filteredCategories.isEmpty
                  ? const Center(
                      child: Text('No tags match the current search.'),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: filteredCategories.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final category = filteredCategories[index];
                        final isSelected = category.id == _selectedCategoryId;
                        final isHovered = category.id == _hoveredCategoryId;

                        return MouseRegion(
                          onEnter: (_) =>
                              setState(() => _hoveredCategoryId = category.id),
                          onExit: (_) {
                            if (_hoveredCategoryId == category.id) {
                              setState(() => _hoveredCategoryId = null);
                            }
                          },
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: () => setState(
                                () => _selectedCategoryId = category.id,
                              ),
                              child: AnimatedScale(
                                duration: const Duration(milliseconds: 160),
                                curve: Curves.easeOutCubic,
                                scale: isHovered ? 1.01 : 1,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  curve: Curves.easeOutCubic,
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary
                                            .withValues(alpha: 0.16)
                                        : isHovered
                                            ? AppColors.primary
                                                .withValues(alpha: 0.08)
                                            : AppColors.surface
                                                .withValues(alpha: 0.72),
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.secondary
                                              .withValues(alpha: 0.45)
                                          : isHovered
                                              ? AppColors.secondary
                                                  .withValues(alpha: 0.24)
                                              : AppColors.primary
                                                  .withValues(alpha: 0.12),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 42,
                                        height: 42,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.secondary
                                                  .withValues(alpha: 0.18)
                                              : AppColors.primary
                                                  .withValues(alpha: 0.12),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '${index + 1}',
                                          style: AppTextStyles.body.copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.md),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              category.label,
                                              style:
                                                  AppTextStyles.body.copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${category.hintType} • ${category.difficulty.name}',
                                              style: AppTextStyles.subtitle,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: AppSpacing.sm),
                                      AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 160),
                                        child: isSelected
                                            ? const Icon(
                                                Icons.check_circle,
                                                key: ValueKey('selected-icon'),
                                                color: AppColors.secondary,
                                              )
                                            : Icon(
                                                isHovered
                                                    ? Icons.touch_app_rounded
                                                    : Icons
                                                        .arrow_forward_ios_rounded,
                                                key: ValueKey(
                                                  'hover-${category.id}-$isHovered',
                                                ),
                                                size: 18,
                                                color: isHovered
                                                    ? AppColors.secondary
                                                    : AppColors.muted,
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
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
        SizedBox(
          width: 220,
          child: AppButton(
            label: selectedCategory == null
                ? 'Select a Tag First'
                : 'Confirm Tag Guess',
            icon: Icons.check_circle_outline,
            onPressed: selectedCategory == null
                ? null
                : () {
                    Navigator.of(context).pop();
                    widget.onTraitSelected(selectedCategory!);
                  },
          ),
        ),
      ],
    );
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _searchQuery = '');
  }
}
