import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../gen/colors.gen.dart';
import 'theme_tailor/theme_colors.dart';

final _customThemeLight = CustomTheme(
  primary: AppColors.primary,
  onPrimary: AppColors.onPrimary,
  textMain: AppColors.lightTextMain,
  textSecondary: AppColors.lightTextSecondary,
  textTertiary: AppColors.lightTextTertiary,
  textAccent: AppColors.lightTextAccent,
  backgroundMain: AppColors.lightBackgroundMain,
  surface: AppColors.lightSurface,
  divider: AppColors.lightDivider,
  transparent: AppColors.transparent,
  buttonDisabled: AppColors.lightButtonBackgroundDisabled,
  error: AppColors.error,
  success: AppColors.success,
  gray1: AppColors.gray1,
  gray3: AppColors.gray3,
);

final _base = ThemeData.light(useMaterial3: false);

final _textTheme = _base.primaryTextTheme.copyWith(
  displayLarge: _base.primaryTextTheme.displayLarge!.copyWith(
    color: _customThemeLight.textMain,
    fontWeight: FontWeight.w800,
    fontSize: 36,
    height: 1.1,
  ),
  displayMedium: _base.primaryTextTheme.displayMedium!.copyWith(
    color: _customThemeLight.textMain,
    fontWeight: FontWeight.w800,
    fontSize: 32,
    height: 1.2,
  ),
  displaySmall: _base.primaryTextTheme.displaySmall!.copyWith(
    color: _customThemeLight.textMain,
    fontWeight: FontWeight.w700,
    fontSize: 24,
    height: 1.3,
  ),
  headlineLarge: _base.primaryTextTheme.headlineLarge!.copyWith(
    color: _customThemeLight.textMain,
    fontWeight: FontWeight.w800,
    fontSize: 20,
    height: 1.2,
  ),
  titleLarge: _base.primaryTextTheme.titleLarge!.copyWith(
    color: _customThemeLight.textMain,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    height: 1.2,
  ),
  titleMedium: _base.primaryTextTheme.titleMedium!.copyWith(
    color: _customThemeLight.textMain,
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 1.2,
  ),
  titleSmall: _base.primaryTextTheme.titleSmall!.copyWith(
    color: _customThemeLight.textMain,
    fontWeight: FontWeight.w700,
    fontSize: 14,
    height: 1.4,
  ),
  bodyLarge: _base.primaryTextTheme.bodyLarge!.copyWith(
    color: _customThemeLight.textMain,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 1.4,
  ),
  bodyMedium: _base.primaryTextTheme.bodyMedium!.copyWith(
    color: _customThemeLight.textMain,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.4,
  ),
  bodySmall: _base.primaryTextTheme.bodySmall!.copyWith(
    color: _customThemeLight.textSecondary,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.4,
  ),
  labelLarge: _base.primaryTextTheme.labelLarge!.copyWith(
    color: _customThemeLight.textMain,
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 1.1,
  ),
  labelMedium: _base.primaryTextTheme.labelMedium!.copyWith(
    color: _customThemeLight.textMain,
    fontWeight: FontWeight.w700,
    fontSize: 14,
    height: 1.1,
  ),
  labelSmall: _base.primaryTextTheme.labelSmall!.copyWith(
    color: _customThemeLight.textMain,
    fontWeight: FontWeight.w700,
    fontSize: 12,
    height: 1.5,
  ),
);

final lightTheme = _base.copyWith(
  brightness: Brightness.light,
  primaryColor: _customThemeLight.primary,
  scaffoldBackgroundColor: _customThemeLight.backgroundMain,
  extensions: [_customThemeLight],
  appBarTheme: AppBarTheme(
    backgroundColor: _customThemeLight.transparent,
    foregroundColor: _customThemeLight.textMain,
    elevation: 0,
    iconTheme: IconThemeData(color: _customThemeLight.textMain),
    centerTitle: false,
    titleSpacing: 0,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  ),
  dividerTheme: DividerThemeData(
    color: _customThemeLight.divider,
    thickness: 1.5,
    space: 0,
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(color: _customThemeLight.divider),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(color: _customThemeLight.divider),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(color: _customThemeLight.divider),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(color: _customThemeLight.primary),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(color: _customThemeLight.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(color: _customThemeLight.error),
    ),
    labelStyle: _textTheme.bodyLarge!.copyWith(
      color: _customThemeLight.textTertiary,
    ),
    errorStyle: _textTheme.bodyMedium!.copyWith(
      color: _customThemeLight.error,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: WidgetStateProperty.all(0),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return _customThemeLight.buttonDisabled;
        }
        return _customThemeLight.primary;
      }),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(64)),
      ),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.disabled)
            ? _customThemeLight.gray1
            : _customThemeLight.onPrimary;
      }),
      textStyle: WidgetStateProperty.all(
        const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      elevation: WidgetStateProperty.all(0),
      backgroundColor: WidgetStateProperty.all(_customThemeLight.transparent),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
      overlayColor: WidgetStateProperty.all(_customThemeLight.gray3),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(48)),
      ),
      side: WidgetStateProperty.resolveWith((states) {
        return BorderSide(
          color: states.contains(WidgetState.disabled)
              ? _customThemeLight.divider
              : _customThemeLight.primary,
        );
      }),
      foregroundColor: WidgetStateProperty.all(_customThemeLight.textMain),
      textStyle: WidgetStateProperty.all(_textTheme.labelLarge),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      overlayColor: WidgetStateProperty.all(_customThemeLight.transparent),
      textStyle: WidgetStateProperty.resolveWith((states) {
        return _textTheme.labelSmall?.copyWith(
          fontSize: states.contains(WidgetState.pressed) ? 10 : 12,
        );
      }),
    ),
  ),
  textTheme: _textTheme,
);
