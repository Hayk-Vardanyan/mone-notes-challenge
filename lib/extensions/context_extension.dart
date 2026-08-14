import 'dart:math' as math;

import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  MediaQueryData get media => MediaQuery.of(this);

  double get height => media.size.height;

  double get bodyHeight => height - 100;

  double get width => media.size.width;

  double get topPadding => media.padding.top;

  double get bottomPadding => media.padding.bottom;

  double get bottomSecurePadding =>
      math.max(media.viewInsets.bottom, math.max(bottomPadding, 16));

  bool get isDarkMode => media.platformBrightness == Brightness.dark;
}

extension ThemeDataHelper on ThemeData {
  TextStyle get displayLarge => textTheme.displayLarge!;

  TextStyle get displayMedium => textTheme.displayMedium!;

  TextStyle get displaySmall => textTheme.displaySmall!;

  TextStyle get headlineLarge => textTheme.headlineLarge!;

  TextStyle get titleLarge => textTheme.titleLarge!;

  TextStyle get titleMedium => textTheme.titleMedium!;

  TextStyle get titleSmall => textTheme.titleSmall!;

  TextStyle get bodyLarge => textTheme.bodyLarge!;

  TextStyle get bodyMedium => textTheme.bodyMedium!;

  TextStyle get bodySmall => textTheme.bodySmall!;

  TextStyle get labelLarge => textTheme.labelLarge!;

  TextStyle get labelMedium => textTheme.labelMedium!;

  TextStyle get labelSmall => textTheme.labelSmall!;

  ButtonStyle get elevatedButtonStyle => elevatedButtonTheme.style!;

  ButtonStyle get textButtonStyle => textButtonTheme.style!;
}

// usage example: context.theme.titleMedium.bold
extension TextStyleHelpers on TextStyle {
  TextStyle get regular =>
      copyWith(fontVariations: const [FontVariation('wght', 400)]);

  TextStyle get medium =>
      copyWith(fontVariations: const [FontVariation('wght', 500)]);

  TextStyle get bold =>
      copyWith(fontVariations: const [FontVariation('wght', 700)]);

  TextStyle get extraBold => copyWith(fontWeight: FontWeight.w800);

  TextStyle get megaBold => copyWith(fontWeight: FontWeight.w900);
}
