import 'package:flutter/material.dart';

import '../notes_theme.dart';

/// The rounded 50x50 icon buttons used across every notes screen header
/// (back, search, info, save, favorite...).
class NotesIconButton extends StatelessWidget {
  const NotesIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.iconColor = NotesColors.textPrimary,
    this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color iconColor;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: NotesColors.surfaceButton,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap,
          child: SizedBox(
            width: 50,
            height: 50,
            child: Icon(icon, color: iconColor, size: 24),
          ),
        ),
      ),
    );
  }
}
