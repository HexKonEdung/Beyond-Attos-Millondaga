import 'package:flutter/material.dart';

/// Palette from Project Plan Section 3.1 (monochrome terminal style).
class AppColors {
  AppColors._();

  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF0D0D0D);
  static const Color text = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFF999999);
  static const Color border = Color(0xFF333333);
  static const Color disabled = Color(0xFF555555);
}

class AppTheme {
  AppTheme._();

  /// Falls back to the device monospace font. Bundle JetBrains Mono later
  /// by adding it to pubspec.yaml under `flutter: fonts:`.
  static const String fontFamily = 'monospace';

  static ThemeData dark() {
    final base = ThemeData(useMaterial3: true, brightness: Brightness.dark);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.text,
        onPrimary: AppColors.background,
        surface: AppColors.surface,
        onSurface: AppColors.text,
        outline: AppColors.border,
      ),
      textTheme: base.textTheme.apply(
        fontFamily: fontFamily,
        bodyColor: AppColors.text,
        displayColor: AppColors.text,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.text,
        elevation: 0,
      ),
      dividerColor: AppColors.border,
    );
  }
}
