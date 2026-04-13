import 'package:flutter/material.dart';
import 'package:little_music/core/theme/a_color_theme.dart';

class ABottomNavBar {
  ABottomNavBar._();

  static const BottomNavigationBarThemeData lightTheme =
      BottomNavigationBarThemeData(
        backgroundColor: AColorTheme.background,
        elevation: 30,

      );

  static const BottomNavigationBarThemeData darkTheme =
      BottomNavigationBarThemeData(
        backgroundColor: AColorTheme.darkBackground,
        elevation: 30,
      );
}
