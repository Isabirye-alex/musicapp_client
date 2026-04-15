import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:little_music/core/theme/a_color_theme.dart';

class ErrorHelper {
  static void showError(BuildContext context, String message, String title) {
    Flushbar(
      margin: EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(16),
      flushbarPosition: FlushbarPosition.TOP,
      message: message,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      shouldIconPulse: true,
      titleColor: AColorTheme.primaryDark,
      title: title,
      duration: const Duration(seconds: 10),
      backgroundColor: AColorTheme.error,
      icon: const Icon(Icons.error, color: Colors.white),
    ).show(context);
  }
}
