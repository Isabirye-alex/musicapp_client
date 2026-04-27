// Elevated button theme configuration
// Defines button styles for light and dark themes
import 'package:flutter/material.dart';
import 'package:little_music/core/theme/a_color_theme.dart';

/// Elevated button theme configuration
class AElevatedButton {
  AElevatedButton._(); // Private constructor to prevent instantiation

  /// Light mode elevated button theme
  static ElevatedButtonThemeData lightTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.all(16),
      elevation: 20,
      foregroundColor: AColorTheme.background,
      backgroundColor: AColorTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(12),
      ),
    ),
  );

  /// Dark mode elevated button theme
  static ElevatedButtonThemeData darkTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.all(16),
      elevation: 20,
      foregroundColor: AColorTheme.background,
      backgroundColor: AColorTheme.gradient1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(12),
      ),
    ),
  );
}
