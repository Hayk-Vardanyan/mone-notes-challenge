import 'package:flutter/material.dart';

import '../notes_theme.dart';

class AddNoteFab extends StatelessWidget {
  const AddNoteFab({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: NotesColors.accent,
      elevation: 4,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, color: NotesColors.onCard, size: 32),
    );
  }
}
