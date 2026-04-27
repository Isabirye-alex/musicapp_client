// Navigation bar theme configuration
// Defines styles for Material 3 navigation bar in light and dark themes
import 'package:flutter/material.dart';
import 'package:little_music/core/theme/a_color_theme.dart';

/// Navigation bar theme configuration (Material 3)
class ANavigationBarTheme {
  ANavigationBarTheme._(); // Private constructor to prevent instantiation

  /// Light mode navigation bar theme
  static const NavigationBarThemeData lightTheme = NavigationBarThemeData(
    elevation: 70,
    backgroundColor: AColorTheme.background,
    surfaceTintColor: AColorTheme.background,
  );

  /// Dark mode navigation bar theme
  static const NavigationBarThemeData darkTheme = NavigationBarThemeData(
    backgroundColor: AColorTheme.darkBackground,
    surfaceTintColor: AColorTheme.darkBackground,
    elevation: 70,
  );
}
