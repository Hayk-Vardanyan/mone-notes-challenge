import 'package:flutter/material.dart';

/// Visual tokens lifted from the "Notes App UI" Figma file. The Figma frames
/// use Nunito, which isn't bundled with this project (no font assets were
/// added), so these fall back to the platform default font.
class NotesColors {
  const NotesColors._();

  static const background = Color(0xFF252525);
  static const surfaceButton = Color(0xFF3B3B3B);
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xFFCFCFCF);
  static const textMuted = Color(0xFF9A9A9A);
  static const accent = Color(0xFFB69CFF);
  static const favorite = Color(0xFFFFD700);
  static const danger = Color(0xFFFF3B30);
  static const success = Color(0xFF30BE71);

  /// Pastel card colors, cycled by note id so a note keeps its color as the
  /// list gets sorted, filtered or searched.
  static const cardPalette = [
    Color(0xFFFF9E9E),
    Color(0xFF91F48F),
    Color(0xFFFFF599),
    Color(0xFF9EFFFF),
    Color(0xFFB69CFF),
  ];

  static Color cardColorFor(String noteId) =>
      cardPalette[noteId.hashCode.abs() % cardPalette.length];

  /// Text drawn on top of the pastel cards, always dark regardless of theme.
  static const onCard = Color(0xFF252525);
}

class NotesTextStyles {
  const NotesTextStyles._();

  static const pageTitle = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w600,
    color: NotesColors.textPrimary,
  );

  static const noteCard = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: NotesColors.onCard,
    height: 1.35,
  );

  static const editorTitle = TextStyle(
    fontSize: 35,
    fontWeight: FontWeight.w600,
    color: NotesColors.textPrimary,
  );

  static const editorTitleHint = TextStyle(
    fontSize: 35,
    fontWeight: FontWeight.w400,
    color: NotesColors.textMuted,
  );

  static const editorBody = TextStyle(
    fontSize: 23,
    fontWeight: FontWeight.w400,
    color: NotesColors.textPrimary,
    height: 1.5,
  );

  static const editorBodyHint = TextStyle(
    fontSize: 23,
    fontWeight: FontWeight.w400,
    color: NotesColors.textMuted,
    height: 1.5,
  );

  static const chip = TextStyle(fontSize: 14, fontWeight: FontWeight.w600);

  static const emptyState = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    color: NotesColors.textPrimary,
  );

  static const dialogTitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: NotesColors.textSecondary,
  );

  static const dialogButton = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}
