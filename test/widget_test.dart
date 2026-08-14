// Renders the notes list across a range of widths, text scales and content
// states, per the challenge brief's guidance that this is the most valuable
// test to write. Uses a fake in-memory repository instead of
// SharedPreferences so results are deterministic.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes_app/core/navigation/app_navigator.dart';
import 'package:notes_app/features/notes/data/models/note.dart';
import 'package:notes_app/features/notes/domain/repositories/notes_repository.dart';
import 'package:notes_app/features/notes/presentation/pages/notes_list_page.dart';
import 'package:notes_app/features/notes/presentation/stores/notes_store.dart';
import 'package:notes_app/injectable.dart';

class _FakeNotesRepository implements NotesRepository {
  _FakeNotesRepository(this._notes);

  List<Note> _notes;

  @override
  Future<List<Note>> loadNotes() async => _notes;

  @override
  Future<void> saveNotes(List<Note> notes) async {
    _notes = notes;
  }
}

Note _note(String id, String title, {bool favorite = false, String body = ''}) {
  final timestamp = DateTime(2026);
  return Note(
    id: id,
    title: title,
    body: body,
    isFavorite: favorite,
    createdAt: timestamp,
    updatedAt: timestamp,
  );
}

final _longTitleNote = _note(
  '3',
  'A considerably longer note title that should wrap across multiple '
      'lines without truncating or overflowing the card, even on the '
      'narrowest supported width',
);

Future<void> _pumpNotesList(
  WidgetTester tester, {
  required List<Note> notes,
  required Size size,
  required double textScale,
}) async {
  await getIt.reset();
  getIt.registerSingleton<NotesRepository>(_FakeNotesRepository(notes));
  getIt.registerSingleton<NotesStore>(NotesStore(getIt<NotesRepository>()));
  getIt.registerSingleton<AppNavigator>(AppNavigator());

  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(size: size, textScaler: TextScaler.linear(textScale)),
      child: const MaterialApp(home: NotesListPage()),
    ),
  );
  await tester.pump();
}

void main() {
  tearDown(getIt.reset);

  const widths = [320.0, 414.0, 800.0, 1200.0];
  const textScales = [1.0, 1.3, 2.0];

  for (final width in widths) {
    for (final scale in textScales) {
      testWidgets('empty state renders at width=$width, textScale=$scale', (tester) async {
        await _pumpNotesList(tester, notes: [], size: Size(width, 900), textScale: scale);

        expect(find.text('Notes'), findsOneWidget);
        expect(find.text('Create your first note !'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('populated list renders at width=$width, textScale=$scale', (tester) async {
        await _pumpNotesList(
          tester,
          notes: [
            _note(
              '1',
              'Book Review : The Design of Everyday Things by Don Norman',
              favorite: true,
            ),
            _note('2', 'Short'),
            _longTitleNote,
          ],
          size: Size(width, 900),
          textScale: scale,
        );

        expect(find.text('Notes'), findsOneWidget);
        expect(find.byIcon(Icons.add), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('favorites filter shows only favorited notes', (tester) async {
    await _pumpNotesList(
      tester,
      notes: [
        _note('1', 'Favorite note', favorite: true),
        _note('2', 'Plain note'),
      ],
      size: const Size(414, 900),
      textScale: 1,
    );

    expect(find.text('Favorite note'), findsOneWidget);
    expect(find.text('Plain note'), findsOneWidget);

    await tester.tap(find.text('Favorites'));
    await tester.pump();

    expect(find.text('Favorite note'), findsOneWidget);
    expect(find.text('Plain note'), findsNothing);
  });
}
