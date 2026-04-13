import 'package:flutter/material.dart';
import 'package:little_music/core/theme/a_app_bar_theme.dart';
import 'package:little_music/core/theme/a_bottom_nav_bar.dart';
import 'package:little_music/core/theme/a_color_theme.dart';
import 'package:little_music/core/theme/a_drawer_theme.dart';
import 'package:little_music/core/theme/a_elevated_button.dart';
import 'package:little_music/core/theme/a_text_theme.dart';
import 'package:little_music/core/theme/input_decoration.dart';
import 'package:little_music/core/theme/navigation_bar_theme.dart';

class AAppTheme {
  AAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Poppins',
    primaryColor: AColorTheme.primary,
    scaffoldBackgroundColor: AColorTheme.background,
    textTheme: ATextTheme.lightTextTheme,
    navigationBarTheme: ANavigationBarTheme.lightTheme,
    appBarTheme: AAppBarTheme.lightTheme,
    drawerTheme: ADrawerTheme.lightTheme,
    bottomNavigationBarTheme: ABottomNavBar.lightTheme,
    inputDecorationTheme: LInputDecoration.lightTheme,
    elevatedButtonTheme: AElevatedButton.lightTheme,
    bottomSheetTheme: BottomSheetThemeData()
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Poppins',
    primaryColor: AColorTheme.primary,
    scaffoldBackgroundColor: AColorTheme.darkBackground,
    textTheme: ATextTheme.darkTextTheme,
    appBarTheme: AAppBarTheme.darkTheme,
    drawerTheme: ADrawerTheme.darkTheme,
    navigationBarTheme: ANavigationBarTheme.darkTheme,
    inputDecorationTheme: LInputDecoration.darkTheme,
    elevatedButtonTheme: AElevatedButton.darkTheme,
    bottomNavigationBarTheme: ABottomNavBar.darkTheme
  );
}
