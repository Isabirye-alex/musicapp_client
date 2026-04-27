// Bottom navigation bar theme configuration
// Defines styles for bottom navigation bar in light and dark themes
import 'package:flutter/material.dart';
import 'package:little_music/core/theme/a_color_theme.dart';

/// Bottom navigation bar theme configuration
class ABottomNavBar {
  ABottomNavBar._(); // Private constructor to prevent instantiation

  /// Light mode bottom navigation bar theme
  static const BottomNavigationBarThemeData lightTheme =
      BottomNavigationBarThemeData(
        backgroundColor: AColorTheme.background,
        elevation: 30,
      );

  /// Dark mode bottom navigation bar theme
  static const BottomNavigationBarThemeData darkTheme =
      BottomNavigationBarThemeData(
        backgroundColor: AColorTheme.darkBackground,
        elevation: 30,
      );
}
