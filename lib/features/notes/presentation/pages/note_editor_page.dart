import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/features/notes/presentation/widgets/formatting_toolbar.dart';

import '../../../../injectable.dart';
import '../../data/models/note.dart';
import '../notes_theme.dart';
import '../stores/notes_store.dart';
import '../widgets/editor_exit_dialogs.dart';
import '../widgets/notes_icon_button.dart';
import '../widgets/responsive_page_body.dart';

@RoutePage()
class NoteEditorPage extends StatefulWidget {
  const NoteEditorPage({super.key, this.noteId});

  final String? noteId;

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  late final NotesStore _store;
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  Note? _original;
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _store = getIt<NotesStore>();
    _original = widget.noteId == null ? null : _store.byId(widget.noteId!);
    _titleController = TextEditingController(text: _original?.title ?? '');
    _bodyController = TextEditingController(text: _original?.body ?? '');
    _isFavorite = _original?.isFavorite ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  bool get _hasChanges {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();
    if (_original == null) {
      return title.isNotEmpty || body.isNotEmpty;
    }
    return title != _original!.title.trim() ||
        body != _original!.body.trim() ||
        _isFavorite != _original!.isFavorite;
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();
    if (title.isEmpty && body.isEmpty) {
      return;
    }
    if (_original == null) {
      final created = await _store.createNote(title: title, body: body);
      if (_isFavorite) {
        await _store.toggleFavorite(created.id);
      }
      _original = _store.byId(created.id);
    } else {
      await _store.updateNote(_original!.id, title: title, body: body);
      if (_isFavorite != _original!.isFavorite) {
        await _store.toggleFavorite(_original!.id);
      }
      _original = _store.byId(_original!.id);
    }
  }

  Future<bool> _handleBackRequest() async {
    if (!_hasChanges) {
      return true;
    }
    if (!mounted) {
      return false;
    }
    final choice = await showSaveChangesDialog(context);
    switch (choice) {
      case SaveChangesChoice.save:
        await _save();
        return true;
      case SaveChangesChoice.discard:
        if (!mounted) {
          return true;
        }
        return showDiscardConfirmationDialog(context);
      case SaveChangesChoice.cancel:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        final shouldPop = await _handleBackRequest();
        // A forced pop, unlike AppNavigator.pop()'s maybePop, bypasses
        // PopScope instead of re-triggering this same callback and
        // recursing forever.
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: NotesColors.background,
        body: SafeArea(
          child: ResponsivePageBody(
            child: Padding(
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
                        // Goes through the same PopScope confirmation flow
                        // as the system back gesture instead of duplicating
                        // it here.
                        onTap: () => Navigator.maybePop(context),
                      ),
                      const Spacer(),
                      NotesIconButton(
                        icon: _isFavorite ? Icons.star : Icons.star_border,
                        iconColor: _isFavorite
                            ? NotesColors.favorite
                            : NotesColors.textPrimary,
                        semanticLabel: 'Toggle favorite',
                        onTap: () => setState(() => _isFavorite = !_isFavorite),
                      ),
                      const SizedBox(width: 12),
                      NotesIconButton(
                        icon: Icons.save_outlined,
                        semanticLabel: 'Save',
                        onTap: () async {
                          await _save();
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  TextField(
                    controller: _titleController,
                    style: NotesTextStyles.editorTitle,
                    cursorColor: NotesColors.accent,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Title',
                      hintStyle: NotesTextStyles.editorTitleHint,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      child: TextField(
                        controller: _bodyController,
                        style: NotesTextStyles.editorBody,
                        cursorColor: NotesColors.accent,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Type something...',
                          hintStyle: NotesTextStyles.editorBodyHint,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FormattingToolbar(),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
