import 'package:flutter/material.dart';

class AppTheme {
  static const double _borderRadius = 16.0;
  static const double _cardRadius = 20.0;

  static ThemeData lightTheme(Color colorSeed) {
    final cs = ColorScheme.fromSeed(seedColor: colorSeed, brightness: Brightness.light);
    return _build(cs);
  }

  static ThemeData darkTheme(Color colorSeed) {
    final cs = ColorScheme.fromSeed(seedColor: colorSeed, brightness: Brightness.dark);
    return _build(cs);
  }

  static ThemeData _build(ColorScheme cs) => ThemeData(
    useMaterial3: true,
    colorScheme: cs,
    fontFamily: 'Inter',
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: cs.surface,
      foregroundColor: cs.onSurface,
      titleTextStyle: TextStyle(
        fontFamily: 'Inter', fontSize: 22,
        fontWeight: FontWeight.w700, color: cs.onSurface,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_cardRadius)),
      color: cs.surfaceContainerHighest.withOpacity(0.5),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_borderRadius)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_borderRadius)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cs.surfaceContainerHighest.withOpacity(0.4),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
        borderSide: BorderSide(color: cs.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    bottomSheetTheme: const BottomSheetThemeData(showDragHandle: true),
  );
}

class AppColorThemes {
  static const Map<String, Color> themes = {
    'Blue Pulse': Color(0xFF2563EB),
    'Violet Dream': Color(0xFF7C3AED),
    'Emerald Clean': Color(0xFF059669),
    'Rose Bloom': Color(0xFFE11D48),
    'Amber Glow': Color(0xFFD97706),
    'Cyan Fresh': Color(0xFF0891B2),
    'Indigo Night': Color(0xFF4338CA),
    'Teal Breeze': Color(0xFF0D9488),
  };
  static const String defaultTheme = 'Blue Pulse';
  static Color get defaultColor => themes[defaultTheme]!;
}