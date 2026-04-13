import 'package:flutter/material.dart';
import 'package:little_music/core/theme/a_color_theme.dart';

class AElevatedButton {
  AElevatedButton._();

  static ElevatedButtonThemeData lightTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.all(16),
      elevation: 20,
      foregroundColor: AColorTheme.background,
      backgroundColor: AColorTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12))
    )
  );

    static ElevatedButtonThemeData darkTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.all(16),
      elevation: 20,
      foregroundColor: AColorTheme.background,
      backgroundColor: AColorTheme.gradient1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12))
    ),
  );
}
