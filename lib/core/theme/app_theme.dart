import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.ink,
    required this.inkSoft,
    required this.paper,
    required this.paperWarm,
    required this.mist,
    required this.sage,
    required this.amber,
    required this.clay,
  });

  final Color ink;
  final Color inkSoft;
  final Color paper;
  final Color paperWarm;
  final Color mist;
  final Color sage;
  final Color amber;
  final Color clay;

  @override
  AppColors copyWith({
    Color? ink,
    Color? inkSoft,
    Color? paper,
    Color? paperWarm,
    Color? mist,
    Color? sage,
    Color? amber,
    Color? clay,
  }) {
    return AppColors(
      ink: ink ?? this.ink,
      inkSoft: inkSoft ?? this.inkSoft,
      paper: paper ?? this.paper,
      paperWarm: paperWarm ?? this.paperWarm,
      mist: mist ?? this.mist,
      sage: sage ?? this.sage,
      amber: amber ?? this.amber,
      clay: clay ?? this.clay,
    );
  }

  @override
  AppColors lerp(covariant ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      ink: Color.lerp(ink, other.ink, t) ?? ink,
      inkSoft: Color.lerp(inkSoft, other.inkSoft, t) ?? inkSoft,
      paper: Color.lerp(paper, other.paper, t) ?? paper,
      paperWarm: Color.lerp(paperWarm, other.paperWarm, t) ?? paperWarm,
      mist: Color.lerp(mist, other.mist, t) ?? mist,
      sage: Color.lerp(sage, other.sage, t) ?? sage,
      amber: Color.lerp(amber, other.amber, t) ?? amber,
      clay: Color.lerp(clay, other.clay, t) ?? clay,
    );
  }
}

abstract final class AppTheme {
  static const ink = Color(0xFF111111);
  static const inkSoft = Color(0xFF4B4B4B);
  static const paper = Color(0xFFFAF9F3);
  static const paperWarm = Color(0xFFF1EFE5);
  static const mist = Color(0xFFE2E0D8);
  static const sage = Color(0xFF78B877);
  static const amber = Color(0xFFE8C36D);
  static const clay = Color(0xFFC8B6A4);

  static const lightColors = AppColors(
    ink: ink,
    inkSoft: inkSoft,
    paper: paper,
    paperWarm: paperWarm,
    mist: mist,
    sage: sage,
    amber: amber,
    clay: clay,
  );

  static AppColors of(BuildContext context) {
    return Theme.of(context).extension<AppColors>() ?? lightColors;
  }

  static ThemeData light() {
    const colors = lightColors;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: colors.paper,
      colorScheme: ColorScheme.light(
        primary: colors.ink,
        onPrimary: colors.paper,
        secondary: colors.inkSoft,
        surface: colors.paper,
        onSurface: colors.ink,
      ),
      extensions: const [colors],
      fontFamily: 'Roboto',
      textTheme: TextTheme(
        headlineLarge: TextStyle(fontSize: 42, color: colors.ink),
        headlineMedium: TextStyle(fontSize: 30, color: colors.ink),
        titleLarge: TextStyle(fontSize: 24, color: colors.ink),
        bodyLarge: TextStyle(fontSize: 18, color: colors.ink),
        bodyMedium: TextStyle(fontSize: 15, color: colors.ink),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: colors.ink,
      ),
      cardColor: colors.paperWarm,
      dividerColor: colors.ink.withValues(alpha: 0.14),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.paperWarm,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.ink.withValues(alpha: 0.12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.ink.withValues(alpha: 0.12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.ink.withValues(alpha: 0.35)),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.paper,
        modalBackgroundColor: colors.paper,
      ),
    );
  }
}

TextStyle kaushan({
  double size = 32,
  Color? color,
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
