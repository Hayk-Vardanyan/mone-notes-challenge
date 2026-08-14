import 'package:flutter/material.dart';

import '../../themes/theme_tailor/theme_colors.dart';

class ModalTopLine extends StatelessWidget {
  const ModalTopLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: context.divider,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
