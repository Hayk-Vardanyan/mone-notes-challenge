import 'package:flutter/material.dart';

import '../../../themes/theme_tailor/theme_colors.dart';

class DangerOutlineButton extends StatelessWidget {
  const DangerOutlineButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.radius,
  });

  final bool isLoading;
  final String text;
  final VoidCallback onPressed;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(radius ?? 16),
      onTap: isLoading ? null : onPressed,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: context.backgroundMain,
          borderRadius: BorderRadius.circular(radius ?? 16),
          border: Border.all(color: context.error),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: context.error,
            ),
          ),
        ),
      ),
    );
  }
}
