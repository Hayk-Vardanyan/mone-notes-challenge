import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/note.dart';

abstract interface class NotesRepository {
  Future<List<Note>> loadNotes();

  Future<void> saveNotes(List<Note> notes);
}

/// Notes are plain title/body strings with no sync target, so the whole list
/// is persisted as one JSON blob on every mutation instead of per-row storage.
@LazySingleton(as: NotesRepository)
class SharedPreferencesNotesRepository implements NotesRepository {
  static const _notesKey = 'notes_v1';

  @override
  Future<List<Note>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_notesKey);
    if (raw == null || raw.isEmpty) {
      return [];
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => Note.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(notes.map((n) => n.toJson()).toList());
    await prefs.setString(_notesKey, encoded);
  }
}
