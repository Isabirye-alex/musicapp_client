import 'package:flutter/material.dart';
import 'package:little_music/core/theme/a_color_theme.dart';

class ANavigationBarTheme {
  ANavigationBarTheme._();

  static const NavigationBarThemeData lightTheme = NavigationBarThemeData(
    elevation: 70,
    backgroundColor: AColorTheme.background,
    surfaceTintColor: AColorTheme.background
  );

  static const NavigationBarThemeData darkTheme = NavigationBarThemeData(
    backgroundColor: AColorTheme.darkBackground,
    surfaceTintColor: AColorTheme.darkBackground,
    elevation: 70,
  );
}
