import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.backgroundColor, this.size});

  final Color? backgroundColor;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: context.router.maybePop,
      child: Container(
        width: size ?? 24,
        height: size ?? 24,
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        decoration: backgroundColor == null
            ? null
            : BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
        child: const Icon(Icons.arrow_back_ios_new, size: 16),
      ),
    );
  }
}
