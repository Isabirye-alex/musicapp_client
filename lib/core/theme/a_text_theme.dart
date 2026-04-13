import 'package:flutter/material.dart';
import 'package:little_music/core/theme/a_color_theme.dart';

class ATextTheme {
  ATextTheme._();
  static TextTheme lightTextTheme = TextTheme(
    bodyLarge: TextStyle().copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AColorTheme.textPrimary,
    ),
    bodyMedium: TextStyle().copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AColorTheme.textPrimary,
    ),
    bodySmall: TextStyle().copyWith(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AColorTheme.textPrimary,
    ),

    headlineLarge: TextStyle().copyWith(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AColorTheme.textPrimary,
    ),
    headlineMedium: TextStyle().copyWith(
      fontSize: 24,
      color: AColorTheme.textPrimary,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle().copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AColorTheme.textPrimary,
    ),

    labelLarge: TextStyle().copyWith(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: AColorTheme.textPrimary,
    ),
    labelMedium: TextStyle().copyWith(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: AColorTheme.textPrimary,
    ),
    labelSmall: TextStyle().copyWith(
      fontSize: 12,
      color: AColorTheme.textPrimary,
      fontWeight: FontWeight.normal,
    ),

    titleLarge: TextStyle().copyWith(
      fontSize: 16,
      color: AColorTheme.textPrimary,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: TextStyle().copyWith(
      fontSize: 16,
      color: AColorTheme.textPrimary,
      fontWeight: FontWeight.w400,
    ),
    titleSmall: TextStyle().copyWith(
      fontSize: 12,
      color: AColorTheme.textPrimary,
      fontWeight: FontWeight.w300,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    bodyLarge: TextStyle().copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AColorTheme.darkTextPrimary,
    ),
    bodyMedium: TextStyle().copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AColorTheme.darkTextPrimary,
    ),
    bodySmall: TextStyle().copyWith(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AColorTheme.darkTextPrimary,
    ),

    headlineLarge: TextStyle().copyWith(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AColorTheme.darkTextPrimary,
    ),
    headlineMedium: TextStyle().copyWith(
      fontSize: 24,
      color: AColorTheme.darkTextPrimary,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle().copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AColorTheme.darkTextPrimary,
    ),

    labelLarge: TextStyle().copyWith(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: AColorTheme.darkTextPrimary,
    ),
    labelMedium: TextStyle().copyWith(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: AColorTheme.darkTextPrimary,
    ),
    labelSmall: TextStyle().copyWith(
      fontSize: 12,
      color: AColorTheme.darkTextPrimary,
      fontWeight: FontWeight.normal,
    ),

    titleLarge: TextStyle().copyWith(
      fontSize: 16,
      color: AColorTheme.darkTextPrimary,
      fontWeight: FontWeight.normal,
    ),
    titleMedium: TextStyle().copyWith(
      fontSize: 16,
      color: AColorTheme.darkTextPrimary,
      fontWeight: FontWeight.normal,
    ),
    titleSmall: TextStyle().copyWith(
      fontSize: 12,
      color: AColorTheme.darkTextPrimary,
      fontWeight: FontWeight.normal,
    ),
  );
}
