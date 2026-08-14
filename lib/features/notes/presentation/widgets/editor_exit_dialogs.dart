import 'package:flutter/material.dart';

import '../notes_theme.dart';

enum SaveChangesChoice { save, discard, cancel }

/// "12 — Save Dialog": shown when leaving the editor with unsaved changes.
Future<SaveChangesChoice> showSaveChangesDialog(BuildContext context) async {
  final choice = await showDialog<SaveChangesChoice>(
    context: context,
    builder: (context) => _EditorDialog(
      message: 'Save changes ?',
      leftLabel: 'Discard',
      leftColor: NotesColors.danger,
      leftValue: SaveChangesChoice.discard,
      rightLabel: 'Save',
      rightColor: NotesColors.success,
      rightValue: SaveChangesChoice.save,
    ),
  );
  return choice ?? SaveChangesChoice.cancel;
}

/// "13 — Discard Dialog": a second confirmation before changes are actually
/// thrown away, reached from the Save dialog's "Discard" button.
Future<bool> showDiscardConfirmationDialog(BuildContext context) async {
  final choice = await showDialog<SaveChangesChoice>(
    context: context,
    builder: (context) => _EditorDialog(
      message: 'Are you sure you want discard your changes ?',
      leftLabel: 'Discard',
      leftColor: NotesColors.danger,
      leftValue: SaveChangesChoice.discard,
      rightLabel: 'Keep',
      rightColor: NotesColors.success,
      rightValue: SaveChangesChoice.cancel,
    ),
  );
  return choice == SaveChangesChoice.discard;
}

class _EditorDialog extends StatelessWidget {
  const _EditorDialog({
    required this.message,
    required this.leftLabel,
    required this.leftColor,
    required this.leftValue,
    required this.rightLabel,
    required this.rightColor,
    required this.rightValue,
  });

  final String message;
  final String leftLabel;
  final Color leftColor;
  final SaveChangesChoice leftValue;
  final String rightLabel;
  final Color rightColor;
  final SaveChangesChoice rightValue;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: NotesColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 330),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_outline, color: NotesColors.textMuted, size: 32),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: NotesTextStyles.dialogTitle,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _DialogButton(
                      label: leftLabel,
                      color: leftColor,
                      onTap: () => Navigator.of(context).pop(leftValue),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _DialogButton(
                      label: rightLabel,
                      color: rightColor,
                      onTap: () => Navigator.of(context).pop(rightValue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({required this.label, required this.color, required this.onTap});

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: NotesTextStyles.dialogButton,
          ),
        ),
      ),
    );
  }
}
