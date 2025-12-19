import 'package:flutter/material.dart';

class AppTheme {
  // Palette (taken from provided image) - use these colors only
  static const Color pBrightCyan = Color(0xFF00B4E6); // left-most bright cyan
  // slightly lighter greyish background for better readability in dark mode
  static const Color pBlack = Color(0xFF1E1E24);
  static const Color pDeepBlue = Color(0xFF005A9C);
  static const Color pVeryPale = Color(0xFFEFF6FA);
  static const Color pLightDesat = Color(0xFFBFD6E6);
  static const Color pMediumBlue = Color(0xFF8FB3C6);
  static const Color pCyanAlt = Color(0xFF00AEE0);
  static const Color pTealish = Color(0xFF088DB2);
  static const Color pDarkCyan = Color(0xFF0E79A8);

  // Light theme: primary and accents from palette (bright, airy)
  static ThemeData light() {
    final seed = pBrightCyan;

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light),
    );

    return base.copyWith(
      scaffoldBackgroundColor: pVeryPale,
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: pDeepBlue,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      cardTheme: base.cardTheme.copyWith(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      chipTheme: base.chipTheme.copyWith(
        selectedColor: pMediumBlue,
        backgroundColor: pLightDesat,
        labelStyle: const TextStyle(color: Colors.black87),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: pBrightCyan,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      snackBarTheme: base.snackBarTheme.copyWith(
        backgroundColor: pDeepBlue,
        contentTextStyle: const TextStyle(color: Colors.white),
      ),
    );
  }

  // Dark theme: choose deeper palette colors for contrast
  static ThemeData dark() {
    final seed = pDarkCyan;

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark),
    );

    return base.copyWith(
      scaffoldBackgroundColor: pBlack,
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: pDeepBlue,
        foregroundColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF121212),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      cardTheme: base.cardTheme.copyWith(
        color: const Color(0xFF151515),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      chipTheme: base.chipTheme.copyWith(
        selectedColor: pTealish,
        backgroundColor: const Color(0xFF1E1E1E),
        labelStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: pDeepBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      snackBarTheme: base.snackBarTheme.copyWith(
        backgroundColor: pDarkCyan,
        contentTextStyle: const TextStyle(color: Colors.white),
      ),
    );
  }
}
