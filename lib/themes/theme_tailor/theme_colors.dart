import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'theme_colors.tailor.dart';

@tailorMixin
class CustomTheme extends ThemeExtension<CustomTheme>
    with _$CustomThemeTailorMixin {
  const CustomTheme({
    required this.primary,
    required this.onPrimary,
    required this.textMain,
    required this.textSecondary,
    required this.textTertiary,
    required this.textAccent,
    required this.backgroundMain,
    required this.surface,
    required this.divider,
    required this.transparent,
    required this.buttonDisabled,
    required this.error,
    required this.success,
    required this.gray1,
    required this.gray3,
  });

  @override
  final Color primary;
  @override
  final Color onPrimary;
  @override
  final Color textMain;
  @override
  final Color textSecondary;
  @override
  final Color textTertiary;
  @override
  final Color textAccent;
  @override
  final Color backgroundMain;
  @override
  final Color surface;
  @override
  final Color divider;
  @override
  final Color transparent;
  @override
  final Color buttonDisabled;
  @override
  final Color error;
  @override
  final Color success;
  @override
  final Color gray1;
  @override
  final Color gray3;
}
