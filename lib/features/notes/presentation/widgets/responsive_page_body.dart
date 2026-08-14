import 'package:flutter/material.dart';

/// Keeps content from stretching edge-to-edge (or floating lost in the
/// middle) on tablet/desktop widths the phone-only Figma frames never show,
/// while staying full-width on real phones.
class ResponsivePageBody extends StatelessWidget {
  const ResponsivePageBody({super.key, required this.child, this.maxWidth = 560});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
