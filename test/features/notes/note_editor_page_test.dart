// Regression test for a back-button hang: NoteEditorPage's PopScope has
// canPop permanently false, so any "leave this page" call must use a
// forced Navigator.pop() rather than AppNavigator's maybePop-based one -
// otherwise the pop keeps re-triggering PopScope's own callback forever.
// pumpAndSettle's timeout is what would catch a regression here.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes_app/features/notes/data/models/note.dart';
import 'package:notes_app/features/notes/data/repositories/notes_repository.dart';
import 'package:notes_app/features/notes/presentation/pages/note_editor_page.dart';
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

Future<void> _pumpEditorBehindAButton(WidgetTester tester) async {
  await getIt.reset();
  getIt.registerSingleton<NotesRepository>(_FakeNotesRepository([]));
  getIt.registerSingleton<NotesStore>(NotesStore(getIt<NotesRepository>()));

  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const NoteEditorPage(),
                ),
              ),
              child: const Text('open editor'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();

  await tester.tap(find.text('open editor'));
  await tester.pumpAndSettle();
  expect(find.byType(NoteEditorPage), findsOneWidget);
}

void main() {
  tearDown(getIt.reset);

  testWidgets('tapping back with no changes pops the editor without hanging', (
    tester,
  ) async {
    await _pumpEditorBehindAButton(tester);

    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.byType(NoteEditorPage), findsNothing);
    expect(find.text('open editor'), findsOneWidget);
  });

  testWidgets(
    'saving a new note pops the editor without hanging',
    (tester) async {
      await _pumpEditorBehindAButton(tester);

      await tester.enterText(find.widgetWithText(TextField, 'Title'), 'Hi');
      await tester.tap(find.byIcon(Icons.save_outlined));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byType(NoteEditorPage), findsNothing);
      expect(find.text('open editor'), findsOneWidget);
    },
  );
}
