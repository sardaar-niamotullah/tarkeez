import 'package:tarkeez/core/shared_files/cubits/theme_cubit.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // ── Brand colors ──────────────────────────────────────
  static const Color green = Color(0xFF008642);
  static const Color greenBright = Color(0xFF00AC04);
  static const Color purple = Colors.deepPurple;
  static const Color purpleBright = Colors.deepPurpleAccent;
  static const Color pink = Colors.pink;
  static const Color pinkBright = Colors.pinkAccent;
  static const Color blue = Colors.blue;
  static const Color blueBright = Colors.lightBlueAccent;
  static const Color teal = Colors.teal;
  static const Color tealBright = Colors.tealAccent;
  static const Color red = Colors.red;
  static const Color redBright = Colors.redAccent;

  static const Color secondary = Color(0xFFC5952A);
  static const Color secondaryBright = Color(0xFFE8BC59);
  static const Color secondaryDark = Color(0xFFC58A00);

  // ── Neutrals ──────────────────────────────────────────
  static const Color greyBg = Color(0xFFF5F5F5);
  static const Color white = Color(0xFFFFFFFF);
  static const Color blackBg = Color(0xFF141414);
  static const Color black = Color(0xFF181818);
  static const Color blacko = Color(0xFF0A0A0A);
  static const Color grey = Color(0xFF8D8D8D);
  static const Color greyBright = Color(0xFFC8C8C8);
  static const Color greyDark = Color(0xFF6E6E6E);
  static const Color success = Colors.green;
  static const Color limeGreen = Color(0xFF27D366);
  static const Color error = Color(0xFFB42323);
  static const Color errorBright = Color(0xFFDC4646);
  static const Color warning = Colors.amber;
  static const Color dividerColor = Color(0x809E9E9E);
  static const Color fireTone = Color(0xFFFF6B35);
  static const Color trophyGold = Color(0xFFFFC107);
  static const Color lightningGold = Color(0xFFFFB800);
  static const Color chainTone = Color(0xFF607D8B);
  static const Color sandAmber = Color(0xFFD4A24C);
  static const Color crimsonTab = Color(0xFFD9483C);

  // ── Color pair resolver ───────────────────────────────
  static (Color primary, Color primaryContainer) resolvePrimaryColors(
    AppThemeColor themeColor,
  ) {
    return switch (themeColor) {
      AppThemeColor.green => (green, greenBright),
      AppThemeColor.purple => (purple, purpleBright),
      AppThemeColor.pink => (pink, pinkBright),
      AppThemeColor.blue => (blue, blueBright),
      AppThemeColor.teal => (teal, tealBright),
    };
  }

  // ── Light Theme ───────────────────────────────────────
  static ThemeData lightTheme(AppThemeColor themeColor) {
    final (primary, primaryContainer) = resolvePrimaryColors(themeColor);
    return ThemeData(
      useMaterial3: true,
      brightness: .light,
      scaffoldBackgroundColor: primary,
      colorScheme: ColorScheme.light(
        primary: primary,
        primaryContainer: primaryContainer,
        onPrimary: white,
        secondary: secondary,
        onSecondary: white,
        secondaryContainer: secondaryBright,
        secondaryFixed: secondaryDark,
        tertiary: white,
        onTertiary: black,
        surface: greyBg,
        inverseSurface: blackBg,
        onSurface: white,
        shadow: black,
        error: errorBright,
      ),
    );
  }

  // ── Dark Theme ────────────────────────────────────────
  static ThemeData darkTheme(AppThemeColor themeColor) {
    final (primary, primaryContainer) = resolvePrimaryColors(themeColor);
    return ThemeData(
      useMaterial3: true,
      brightness: .dark,
      scaffoldBackgroundColor: primary,
      colorScheme: ColorScheme.dark(
        primary: primary,
        primaryContainer: primaryContainer,
        onPrimary: black,
        secondary: secondary,
        onSecondary: black,
        secondaryContainer: secondaryBright,
        secondaryFixed: secondaryDark,
        tertiary: black,
        onTertiary: white,
        surface: blackBg,
        inverseSurface: greyBg,
        onSurface: black,
        shadow: white,
        error: errorBright,
      ),
    );
  }
}
