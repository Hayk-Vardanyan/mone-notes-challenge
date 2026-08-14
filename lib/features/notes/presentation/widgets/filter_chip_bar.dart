import 'package:flutter/material.dart';

import '../notes_theme.dart';
import '../stores/notes_store.dart';

class FilterChipBar extends StatelessWidget {
  const FilterChipBar({super.key, required this.selected, required this.onSelect});

  final NoteFilter selected;
  final ValueChanged<NoteFilter> onSelect;

  static const _labels = {
    NoteFilter.all: 'All',
    NoteFilter.favorites: 'Favorites',
    NoteFilter.recent: 'Recent',
  };

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: NoteFilter.values.map((filter) {
        final isSelected = filter == selected;
        return Material(
          color: isSelected ? NotesColors.favorite : NotesColors.surfaceButton,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => onSelect(filter),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                _labels[filter]!,
                style: NotesTextStyles.chip.copyWith(
                  color: isSelected ? NotesColors.onCard : NotesColors.textMuted,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
