import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../data/models/note.dart';
import '../../domain/repositories/notes_repository.dart';

part 'notes_store.g.dart';

enum NoteFilter { all, favorites, recent }

typedef _RemovedNote = ({Note note, int index});

@singleton
class NotesStore = _NotesStore with _$NotesStore;

abstract class _NotesStore with Store {
  _NotesStore(this._repository) {
    unawaited(_init());
  }

  final NotesRepository _repository;

  @observable
  ObservableList<Note> notes = ObservableList<Note>();

  @observable
  bool isLoading = true;

  @observable
  NoteFilter activeFilter = NoteFilter.all;

  @observable
  String searchQuery = '';

  Future<void> _init() async {
    final loaded = await _repository.loadNotes();
    _setNotes(loaded);
    _stopLoading();
  }

  @action
  void _setNotes(List<Note> value) {
    notes = ObservableList.of(value);
  }

  @action
  void _stopLoading() {
    isLoading = false;
  }

  @computed
  List<Note> get _sortedNotes =>
      notes.toList()..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

  @computed
  List<Note> get visibleNotes {
    switch (activeFilter) {
      case NoteFilter.all:
        return _sortedNotes;
      case NoteFilter.favorites:
        return _sortedNotes.where((n) => n.isFavorite).toList();
      case NoteFilter.recent:
        final cutoff = DateTime.now().subtract(const Duration(days: 7));
        return _sortedNotes.where((n) => n.updatedAt.isAfter(cutoff)).toList();
    }
  }

  @computed
  List<Note> get searchResults {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return const [];
    }
    return _sortedNotes
        .where(
          (n) =>
              n.title.toLowerCase().contains(query) ||
              n.body.toLowerCase().contains(query),
        )
        .toList();
  }

  Note? byId(String id) {
    for (final note in notes) {
      if (note.id == id) {
        return note;
      }
    }
    return null;
  }

  @action
  void setFilter(NoteFilter filter) {
    activeFilter = filter;
  }

  @action
  void setSearchQuery(String query) {
    searchQuery = query;
  }

  Future<Note> createNote({required String title, required String body}) async {
    final now = DateTime.now();
    final note = Note(
      id: '${now.microsecondsSinceEpoch}',
      title: title,
      body: body,
      isFavorite: false,
      createdAt: now,
      updatedAt: now,
    );
    _addNote(note);
    await _persist();
    return note;
  }

  @action
  void _addNote(Note note) {
    notes.add(note);
  }

  Future<void> updateNote(
    String id, {
    required String title,
    required String body,
  }) async {
    _replaceNote(
      id,
      (note) => note.copyWith(title: title, body: body, updatedAt: DateTime.now()),
    );
    await _persist();
  }

  Future<void> toggleFavorite(String id) async {
    _replaceNote(
      id,
      (note) => note.copyWith(isFavorite: !note.isFavorite, updatedAt: DateTime.now()),
    );
    await _persist();
  }

  @action
  void _replaceNote(String id, Note Function(Note) update) {
    final index = notes.indexWhere((n) => n.id == id);
    if (index == -1) {
      return;
    }
    notes[index] = update(notes[index]);
  }

  /// Returns the removed note and its former index so callers can offer undo.
  Future<_RemovedNote?> deleteNote(String id) async {
    final index = notes.indexWhere((n) => n.id == id);
    if (index == -1) {
      return null;
    }
    final removed = notes[index];
    _removeAt(index);
    await _persist();
    return (note: removed, index: index);
  }

  @action
  void _removeAt(int index) {
    notes.removeAt(index);
  }

  Future<void> restoreNote(Note note, int index) async {
    _insertAt(note, index);
    await _persist();
  }

  @action
  void _insertAt(Note note, int index) {
    notes.insert(index.clamp(0, notes.length), note);
  }

  Future<void> _persist() => _repository.saveNotes(notes);
}
