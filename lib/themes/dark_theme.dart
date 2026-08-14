import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../gen/colors.gen.dart';
import 'theme_tailor/theme_colors.dart';

final _customThemeDark = CustomTheme(
  primary: AppColors.primary,
  onPrimary: AppColors.onPrimary,
  textMain: AppColors.darkTextMain,
  textSecondary: AppColors.darkTextSecondary,
  textTertiary: AppColors.darkTextTertiary,
  textAccent: AppColors.darkTextAccent,
  backgroundMain: AppColors.darkBackgroundMain,
  surface: AppColors.darkSurface,
  divider: AppColors.darkDivider,
  transparent: AppColors.transparent,
  buttonDisabled: AppColors.darkButtonBackgroundDisabled,
  error: AppColors.error,
  success: AppColors.success,
  gray1: AppColors.gray1,
  gray3: AppColors.gray3,
);

final _base = ThemeData.dark(useMaterial3: false);

final _textTheme = _base.primaryTextTheme.copyWith(
  displayLarge: _base.primaryTextTheme.displayLarge!.copyWith(
    color: _customThemeDark.textMain,
    fontWeight: FontWeight.w800,
    fontSize: 36,
    height: 1.1,
  ),
  displayMedium: _base.primaryTextTheme.displayMedium!.copyWith(
    color: _customThemeDark.textMain,
    fontWeight: FontWeight.w800,
    fontSize: 32,
    height: 1.2,
  ),
  displaySmall: _base.primaryTextTheme.displaySmall!.copyWith(
    color: _customThemeDark.textMain,
    fontWeight: FontWeight.w700,
    fontSize: 24,
    height: 1.3,
  ),
  headlineLarge: _base.primaryTextTheme.headlineLarge!.copyWith(
    color: _customThemeDark.textMain,
    fontWeight: FontWeight.w800,
    fontSize: 20,
    height: 1.2,
  ),
  titleLarge: _base.primaryTextTheme.titleLarge!.copyWith(
    color: _customThemeDark.textMain,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    height: 1.2,
  ),
  titleMedium: _base.primaryTextTheme.titleMedium!.copyWith(
    color: _customThemeDark.textMain,
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 1.2,
  ),
  titleSmall: _base.primaryTextTheme.titleSmall!.copyWith(
    color: _customThemeDark.textMain,
    fontWeight: FontWeight.w700,
    fontSize: 14,
    height: 1.4,
  ),
  bodyLarge: _base.primaryTextTheme.bodyLarge!.copyWith(
    color: _customThemeDark.textMain,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 1.4,
  ),
  bodyMedium: _base.primaryTextTheme.bodyMedium!.copyWith(
    color: _customThemeDark.textMain,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.4,
  ),
  bodySmall: _base.primaryTextTheme.bodySmall!.copyWith(
    color: _customThemeDark.textSecondary,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.4,
  ),
  labelLarge: _base.primaryTextTheme.labelLarge!.copyWith(
    color: _customThemeDark.textMain,
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 1.1,
  ),
  labelMedium: _base.primaryTextTheme.labelMedium!.copyWith(
    color: _customThemeDark.textMain,
    fontWeight: FontWeight.w700,
    fontSize: 14,
    height: 1.1,
  ),
  labelSmall: _base.primaryTextTheme.labelSmall!.copyWith(
    color: _customThemeDark.textMain,
    fontWeight: FontWeight.w700,
    fontSize: 12,
    height: 1.5,
  ),
);

final darkTheme = _base.copyWith(
  brightness: Brightness.dark,
  primaryColor: _customThemeDark.primary,
  scaffoldBackgroundColor: _customThemeDark.backgroundMain,
  extensions: [_customThemeDark],
  appBarTheme: AppBarTheme(
    backgroundColor: _customThemeDark.transparent,
    foregroundColor: _customThemeDark.textMain,
    elevation: 0,
    iconTheme: IconThemeData(color: _customThemeDark.textMain),
    centerTitle: false,
    titleSpacing: 0,
    systemOverlayStyle: SystemUiOverlayStyle.light,
  ),
  dividerTheme: DividerThemeData(
    color: _customThemeDark.divider,
    thickness: 1.5,
    space: 0,
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(color: _customThemeDark.divider),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(color: _customThemeDark.divider),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(color: _customThemeDark.divider),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(color: _customThemeDark.primary),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(color: _customThemeDark.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(color: _customThemeDark.error),
    ),
    labelStyle: _textTheme.bodyLarge!.copyWith(
      color: _customThemeDark.textTertiary,
    ),
    errorStyle: _textTheme.bodyMedium!.copyWith(color: _customThemeDark.error),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: WidgetStateProperty.all(0),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return _customThemeDark.buttonDisabled;
        }
        return _customThemeDark.primary;
      }),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(64)),
      ),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.disabled)
            ? _customThemeDark.gray1
            : _customThemeDark.onPrimary;
      }),
      textStyle: WidgetStateProperty.all(
        const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      elevation: WidgetStateProperty.all(0),
      backgroundColor: WidgetStateProperty.all(_customThemeDark.transparent),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
      overlayColor: WidgetStateProperty.all(_customThemeDark.gray3),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(48)),
      ),
      side: WidgetStateProperty.resolveWith((states) {
        return BorderSide(
          color: states.contains(WidgetState.disabled)
              ? _customThemeDark.divider
              : _customThemeDark.primary,
        );
      }),
      foregroundColor: WidgetStateProperty.all(_customThemeDark.textMain),
      textStyle: WidgetStateProperty.all(_textTheme.labelLarge),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      overlayColor: WidgetStateProperty.all(_customThemeDark.transparent),
      textStyle: WidgetStateProperty.resolveWith((states) {
        return _textTheme.labelSmall?.copyWith(
          fontSize: states.contains(WidgetState.pressed) ? 10 : 12,
        );
      }),
    ),
  ),
  textTheme: _textTheme,
);
