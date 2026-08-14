import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../extensions/context_extension.dart';
import '../../../themes/theme_tailor/theme_colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    this.isLoading = false,
    this.enabled = true,
    this.onPressed,
    this.buttonStyle,
    this.icon,
  });

  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final bool enabled;
  final ButtonStyle? buttonStyle;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: enabled ? onPressed : null,
              style: buttonStyle,
              child: isLoading
                  ? SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(
                        color: context.onPrimary,
                        strokeWidth: 3,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          text,
                          style: context.theme.titleMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: context.onPrimary,
                          ),
                        ),
                        if (icon != null) ...[const Gap(12), icon!],
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
