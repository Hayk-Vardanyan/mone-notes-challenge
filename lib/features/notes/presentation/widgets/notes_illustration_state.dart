import 'package:flutter/material.dart';

import '../notes_theme.dart';

/// Shared illustration + caption layout for the "01 — Home Empty" and
/// "08 — Search No Results" frames.
class NotesIllustrationState extends StatelessWidget {
  const NotesIllustrationState({
    super.key,
    required this.assetPath,
    required this.message,
  });

  final String assetPath;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 350, maxHeight: 320),
              child: Image.asset(assetPath, fit: BoxFit.contain),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              textAlign: TextAlign.center,
              style: NotesTextStyles.emptyState,
            ),
          ],
        ),
      ),
    );
  }
}
