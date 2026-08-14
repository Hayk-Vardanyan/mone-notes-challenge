import 'package:flutter/material.dart';

import '../../themes/theme_tailor/theme_colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: context.primary),
    );
  }
}
