import 'package:flutter/material.dart';
import 'package:little_music/core/theme/a_color_theme.dart';
import 'package:little_music/core/theme/a_icon_theme.dart';

class AAppBarTheme {
  AAppBarTheme._();

  static AppBarTheme lightTheme = AppBarTheme(
    centerTitle: false,
    backgroundColor: AColorTheme.background,
    foregroundColor: AColorTheme.border,
    elevation: 0,
    toolbarHeight: 80,
    surfaceTintColor: AColorTheme.background,
    shadowColor: AColorTheme.background,
    actionsPadding: EdgeInsets.only(left: 10, right: 10),
    iconTheme: AIconTheme.lightTheme,
  );

  static AppBarTheme darkTheme = AppBarTheme(
    centerTitle: false,
    backgroundColor: AColorTheme.darkBackground,
    foregroundColor: AColorTheme.darkBackground,
    elevation: 0,
    toolbarHeight: 80,
    surfaceTintColor: AColorTheme.darkBackground,
    shadowColor: AColorTheme.darkBackground,
    actionsPadding: EdgeInsets.only(left: 10, right: 10),
    iconTheme: AIconTheme.darkTheme,
    
    
  );
}
