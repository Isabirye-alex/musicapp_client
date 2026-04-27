// Icon theme configuration
// Defines icon colors for light and dark themes
import 'package:flutter/material.dart';
import 'package:little_music/core/theme/a_color_theme.dart';

/// Icon theme configuration for the application
class AIconTheme {
  AIconTheme._(); // Private constructor to prevent instantiation

  /// Light mode icon theme
  static const IconThemeData lightTheme = IconThemeData(
    color: AColorTheme.darkBackground,
  );

  /// Dark mode icon theme
  static const IconThemeData darkTheme = IconThemeData(
    color: AColorTheme.background,
  );
}
