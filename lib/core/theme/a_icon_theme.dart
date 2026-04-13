import 'package:flutter/material.dart';
import 'package:little_music/core/theme/a_color_theme.dart';

class AIconTheme {
  AIconTheme._();

  static const IconThemeData lightTheme = IconThemeData(
    color: AColorTheme.darkBackground,
  );

  static const IconThemeData darkTheme = IconThemeData(
    color: AColorTheme.background,
  );
}
