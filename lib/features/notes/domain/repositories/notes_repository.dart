import '../../data/models/note.dart';

abstract interface class NotesRepository {
  Future<List<Note>> loadNotes();

  Future<void> saveNotes(List<Note> notes);
}
