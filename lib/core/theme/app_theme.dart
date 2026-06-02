import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const ink = Color(0xFF111111);
  static const inkSoft = Color(0xFF4B4B4B);
  static const paper = Color(0xFFFAF9F3);
  static const paperWarm = Color(0xFFF1EFE5);
  static const mist = Color(0xFFE2E0D8);
  static const sage = Color(0xFF78B877);
  static const amber = Color(0xFFE8C36D);
  static const clay = Color(0xFFC8B6A4);

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: paper,
      colorScheme: const ColorScheme.light(
        primary: ink,
        onPrimary: paper,
        secondary: inkSoft,
        surface: paper,
        onSurface: ink,
      ),
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 42, color: ink),
        headlineMedium: TextStyle(fontSize: 30, color: ink),
        titleLarge: TextStyle(fontSize: 24, color: ink),
        bodyLarge: TextStyle(fontSize: 18, color: ink),
        bodyMedium: TextStyle(fontSize: 15, color: ink),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: ink,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: paper,
        modalBackgroundColor: paper,
      ),
    );
  }
}

TextStyle kaushan({
  double size = 32,
  Color color = AppTheme.ink,
  FontWeight weight = FontWeight.w400,
}) {
  return TextStyle(
    fontFamily: 'KaushanScript',
    fontSize: size,
    fontWeight: weight,
    color: color,
    letterSpacing: 0,
  );
}
