import 'package:flutter/material.dart';

abstract final class HavenColors {
  static const background = Color(0xFFF7F8F2),
      ink = Color(0xFF213B30),
      green = Color(0xFF254E3D),
      muted = Color(0xFF86927D),
      line = Color(0xFFE6EAE0),
      pale = Color(0xFFEDF1E4),
      lime = Color(0xFFE9EDDD);
}

ThemeData havenTheme() => ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: HavenColors.background,
  colorScheme: ColorScheme.fromSeed(
    seedColor: HavenColors.green,
    surface: HavenColors.background,
  ),
  fontFamily: 'HavenSans',
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: HavenColors.ink),
    bodySmall: TextStyle(color: HavenColors.muted),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: HavenColors.background,
    surfaceTintColor: Colors.transparent,
    centerTitle: false,
  ),
  dividerTheme: const DividerThemeData(color: HavenColors.line, thickness: 1),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: HavenColors.green,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: HavenColors.background,
    showDragHandle: true,
  ),
);
