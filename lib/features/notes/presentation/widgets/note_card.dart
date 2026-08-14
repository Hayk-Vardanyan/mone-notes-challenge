import 'package:flutter/material.dart';

import '../../data/models/note.dart';
import '../notes_theme.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    this.onTap,
    this.showFavoriteBadge = false,
  });

  final Note note;
  final VoidCallback? onTap;

  /// Filter/search views draw a star badge on favorited notes; the plain
  /// list only reveals favorite state through the swipe action.
  final bool showFavoriteBadge;

  @override
  Widget build(BuildContext context) {
    final title = note.title.trim().isEmpty ? note.body : note.title;

    return Material(
      color: NotesColors.cardColorFor(note.id),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title.isEmpty ? 'Untitled note' : title,
                  style: NotesTextStyles.noteCard,
                ),
              ),
              if (showFavoriteBadge && note.isFavorite) ...[
                const SizedBox(width: 12),
                const Icon(
                  Icons.star,
                  color: NotesColors.onCard,
                  size: 20,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
