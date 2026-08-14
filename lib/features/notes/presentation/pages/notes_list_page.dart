import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../core/navigation/app_navigator.dart';
import '../../../../injectable.dart';
import '../notes_theme.dart';
import '../stores/notes_store.dart';
import '../widgets/add_note_fab.dart';
import '../widgets/filter_chip_bar.dart';
import '../widgets/notes_icon_button.dart';
import '../widgets/notes_illustration_state.dart';
import '../widgets/responsive_page_body.dart';
import '../widgets/swipeable_note_card.dart';

class NotesListPage extends StatelessWidget {
  const NotesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = getIt<NotesStore>();
    final navigator = getIt<AppNavigator>();

    return Scaffold(
      backgroundColor: NotesColors.background,
      floatingActionButton: AddNoteFab(
        onPressed: () => navigator.push(NoteEditorRoute()),
      ),
      body: SafeArea(
        child: ResponsivePageBody(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Observer(
              builder: (context) {
                if (store.isLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 120),
                      child: CircularProgressIndicator(color: NotesColors.accent),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    _Header(navigator: navigator, context: context),
                    if (store.notes.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      FilterChipBar(
                        selected: store.activeFilter,
                        onSelect: store.setFilter,
                      ),
                    ],
                    const SizedBox(height: 16),
                    Expanded(
                      child: store.notes.isEmpty
                          ? const NotesIllustrationState(
                              assetPath: 'assets/images/empty_notes.png',
                              message: 'Create your first note !',
                            )
                          : store.visibleNotes.isEmpty
                              ? Center(
                                  child: Text(
                                    _emptyFilterMessage(store.activeFilter),
                                    style: NotesTextStyles.emptyState,
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : ListView.separated(
                                  padding: const EdgeInsets.only(bottom: 96),
                                  itemCount: store.visibleNotes.length,
                                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                                  itemBuilder: (context, index) {
                                    final note = store.visibleNotes[index];
                                    return SwipeableNoteCard(
                                      key: ValueKey(note.id),
                                      note: note,
                                      onTap: () => navigator.push(
                                        NoteReadingRoute(noteId: note.id),
                                      ),
                                      onToggleFavorite: () => store.toggleFavorite(note.id),
                                      onDelete: () => _deleteWithUndo(context, store, note.id),
                                    );
                                  },
                                ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String _emptyFilterMessage(NoteFilter filter) {
    switch (filter) {
      case NoteFilter.all:
        return 'No notes yet';
      case NoteFilter.favorites:
        return 'No favorite notes yet';
      case NoteFilter.recent:
        return 'Nothing edited in the last 7 days';
    }
  }

  Future<void> _deleteWithUndo(
    BuildContext context,
    NotesStore store,
    String noteId,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final removed = await store.deleteNote(noteId);
    if (removed == null || !context.mounted) {
      return;
    }
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Note deleted'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () => store.restoreNote(removed.note, removed.index),
          ),
        ),
      );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.navigator, required this.context});

  final AppNavigator navigator;
  final BuildContext context;

  @override
  Widget build(BuildContext _) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Notes',
            style: NotesTextStyles.pageTitle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        NotesIconButton(
          icon: Icons.search,
          semanticLabel: 'Search notes',
          onTap: () => navigator.push(const SearchRoute()),
        ),
        const SizedBox(width: 12),
        NotesIconButton(
          icon: Icons.info_outline,
          semanticLabel: 'About',
          onTap: () => _showInfoDialog(context),
        ),
      ],
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NotesColors.background,
        title: const Text('Notes', style: TextStyle(color: NotesColors.textPrimary)),
        content: const Text(
          'A small local notes app. Notes are stored on this device only.',
          style: TextStyle(color: NotesColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
