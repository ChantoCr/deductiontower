import 'package:anime_deduction_tower/features/game/domain/entities/trait_category.dart';
import 'package:flutter/material.dart';

class CategoryGuessDialog extends StatelessWidget {
  const CategoryGuessDialog({
    required this.categories,
    required this.onTraitSelected,
    super.key,
  });

  final List<TraitCategory> categories;
  final ValueChanged<TraitCategory> onTraitSelected;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Guess the Trait'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: categories.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final category = categories[index];

            return ListTile(
              title: Text(category.label),
              subtitle: Text('Hint type: ${category.hintType}'),
              onTap: () {
                Navigator.of(context).pop();
                onTraitSelected(category);
              },
            );
          },
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
