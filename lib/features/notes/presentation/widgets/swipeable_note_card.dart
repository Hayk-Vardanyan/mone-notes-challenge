import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/models/note.dart';
import '../notes_theme.dart';
import 'note_card.dart';

/// A note card that reveals a favorite action on a right-swipe (leading
/// edge, matching the Figma "Swipe to Favorite" frame) and commits a delete
/// on a left-swipe past [_deleteThreshold] (matching "Swipe to Delete",
/// where the frame shows the row already fully red mid-flight). Only one
/// direction is ever active at a time and a new drag always interrupts
/// whatever snap animation is currently running, so the two gestures never
/// fight each other. `Dismissible` isn't used per the challenge brief.
class SwipeableNoteCard extends StatefulWidget {
  const SwipeableNoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onToggleFavorite,
    required this.onDelete,
  });

  final Note note;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  final VoidCallback onDelete;

  @override
  State<SwipeableNoteCard> createState() => _SwipeableNoteCardState();
}

class _SwipeableNoteCardState extends State<SwipeableNoteCard>
    with SingleTickerProviderStateMixin {
  static const _favoriteRevealWidth = 88.0;
  static const _deleteThreshold = 120.0;
  static const _maxDrag = 260.0;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: -_maxDrag,
      upperBound: _favoriteRevealWidth,
      value: 0,
      duration: const Duration(milliseconds: 200),
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDragStart(DragStartDetails details) {
    _controller.stop();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final next = _controller.value + details.delta.dx;
    _controller.value = next.clamp(_controller.lowerBound, _controller.upperBound);
  }

  Future<void> _onDragEnd(DragEndDetails details) async {
    final value = _controller.value;
    if (value <= -_deleteThreshold) {
      await _animateTo(_controller.lowerBound);
      widget.onDelete();
      return;
    }
    await _animateTo(value > _favoriteRevealWidth / 2 ? _favoriteRevealWidth : 0);
  }

  Future<void> _animateTo(double target) {
    return _controller.animateTo(target, curve: Curves.easeOut);
  }

  void _closeIfOpen() {
    if (_controller.value != 0) {
      unawaited(_animateTo(0));
    } else {
      widget.onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dx = _controller.value;
    final favoriteProgress = (dx / _favoriteRevealWidth).clamp(0.0, 1.0);
    final deleteProgress = (-dx / _deleteThreshold).clamp(0.0, 1.0);

    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Row(
                children: [
                  SizedBox(
                    width: _favoriteRevealWidth,
                    child: ColoredBox(
                      color: NotesColors.favorite,
                      child: Center(
                        child: Opacity(
                          opacity: favoriteProgress,
                          child: IconButton(
                            icon: Icon(
                              widget.note.isFavorite ? Icons.star : Icons.star_border,
                              color: NotesColors.onCard,
                            ),
                            onPressed: () {
                              widget.onToggleFavorite();
                              unawaited(_animateTo(0));
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ColoredBox(
                      color: NotesColors.danger,
                      child: Center(
                        child: Opacity(
                          opacity: deleteProgress,
                          child: const Icon(Icons.delete_outline, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(dx, 0),
            child: NoteCard(note: widget.note, onTap: _closeIfOpen),
          ),
        ],
      ),
    );
  }
}
