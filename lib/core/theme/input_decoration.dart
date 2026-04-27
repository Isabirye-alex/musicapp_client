// Input decoration theme configuration
// Defines styles for text input fields in light and dark themes
import 'package:flutter/material.dart';
import 'package:little_music/core/theme/a_color_theme.dart';

/// Input decoration theme configuration
class LInputDecoration {
  LInputDecoration._(); // Private constructor to prevent instantiation

  /// Light mode input decoration theme
  static InputDecorationTheme lightTheme = InputDecorationTheme(
    contentPadding: EdgeInsets.all(12),
    focusColor: AColorTheme.secondary,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2),
      borderRadius: BorderRadius.circular(16),
    ),
  );

  /// Dark mode input decoration theme
  static InputDecorationTheme darkTheme = InputDecorationTheme(
    contentPadding: EdgeInsets.all(12),
    focusColor: AColorTheme.secondary,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2),
      borderRadius: BorderRadius.circular(16),
    ),
  );
}
