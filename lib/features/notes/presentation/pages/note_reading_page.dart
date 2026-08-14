import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../core/navigation/app_navigator.dart';
import '../../../../injectable.dart';
import '../notes_theme.dart';
import '../stores/notes_store.dart';
import '../widgets/notes_icon_button.dart';
import '../widgets/responsive_page_body.dart';

@RoutePage()
class NoteReadingPage extends StatelessWidget {
  const NoteReadingPage({super.key, required this.noteId});

  final String noteId;

  @override
  Widget build(BuildContext context) {
    final store = getIt<NotesStore>();
    final navigator = getIt<AppNavigator>();

    return Scaffold(
      backgroundColor: NotesColors.background,
      body: SafeArea(
        child: ResponsivePageBody(
          child: Observer(
            builder: (context) {
              final note = store.byId(noteId);
              if (note == null) {
                // Deleted from elsewhere (e.g. swiped away) while this
                // screen was open underneath a push.
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (navigator.canPop()) {
                    navigator.pop();
                  }
                });
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        NotesIconButton(
                          icon: Icons.chevron_left,
                          semanticLabel: 'Back',
                          onTap: () => navigator.pop(),
                        ),
                        const Spacer(),
                        NotesIconButton(
                          icon: Icons.edit_outlined,
                          semanticLabel: 'Edit',
                          onTap: () => navigator.push(NoteEditorRoute(noteId: note.id)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              note.title.isEmpty ? 'Untitled note' : note.title,
                              style: NotesTextStyles.editorTitle,
                            ),
                            const SizedBox(height: 16),
                            Text(note.body, style: NotesTextStyles.editorBody),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
