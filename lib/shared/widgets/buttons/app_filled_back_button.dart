import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../themes/theme_tailor/theme_colors.dart';
import 'app_back_button.dart';

class AppFilledBackButton extends StatelessWidget {
  const AppFilledBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: context.router.maybePop,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 42,
        width: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: context.surface,
          shape: BoxShape.circle,
        ),
        child: const AppBackButton(size: 16),
      ),
    );
  }
}
