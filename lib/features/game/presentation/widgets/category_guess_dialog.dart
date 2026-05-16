import 'package:flutter/material.dart';

class CategoryGuessDialog extends StatelessWidget {
  const CategoryGuessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Guess the Trait'),
      content: const Text(
        'This placeholder dialog will become the final category guess flow in the local multiplayer MVP.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
