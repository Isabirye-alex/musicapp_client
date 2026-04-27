// Drawer theme configuration
// Defines drawer styles for light and dark themes
import 'package:flutter/material.dart';
import 'package:little_music/core/theme/a_color_theme.dart';

/// Drawer theme configuration
class ADrawerTheme {
  ADrawerTheme._(); // Private constructor to prevent instantiation

  /// Light mode drawer theme
  static const DrawerThemeData lightTheme = DrawerThemeData(
    backgroundColor: AColorTheme.background,
    elevation: 70,
    surfaceTintColor: AColorTheme.darkBackground,
  );

  /// Dark mode drawer theme
  static const DrawerThemeData darkTheme = DrawerThemeData(
    backgroundColor: AColorTheme.darkBackground,
    elevation: 70,
    surfaceTintColor: AColorTheme.darkCard,
  );
}
