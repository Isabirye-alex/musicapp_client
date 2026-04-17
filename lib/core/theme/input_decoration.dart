import 'package:flutter/material.dart';
import 'package:little_music/core/theme/a_color_theme.dart';

class LInputDecoration {
  LInputDecoration._();

  static InputDecorationTheme lightTheme = InputDecorationTheme(
    contentPadding: EdgeInsets.all(12),

    focusColor: AColorTheme.secondary,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2),
      borderRadius: BorderRadius.circular(16),
    ),
  );

  static InputDecorationTheme darkTheme = InputDecorationTheme(

    contentPadding: EdgeInsets.all(12),
    focusColor: AColorTheme.secondary,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide( width: 2),
      borderRadius: BorderRadius.circular(16),
    ),
  );
}
