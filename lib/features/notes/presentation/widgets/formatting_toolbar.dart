import 'package:flutter/material.dart';

import '../notes_theme.dart';

/// The formatting bar drawn in frame "09 — New Note Editor". Notes in this
/// app are plain text with no rich-text model, so per the brief this bar is
/// decorative only — the icons render but do nothing.
class FormattingToolbar extends StatelessWidget {
  const FormattingToolbar({super.key});

  static const _icons = [
    Icons.format_bold,
    Icons.format_italic,
    Icons.format_underlined,
    Icons.format_strikethrough,
    Icons.link,
    Icons.title,
    Icons.code,
    Icons.format_list_numbered,
    Icons.format_list_bulleted,
    Icons.format_quote,
    Icons.functions,
    Icons.check_box_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _icons.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return Icon(_icons[index], size: 22, color: NotesColors.textMuted);
        },
      ),
    );
  }
}
