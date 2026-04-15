import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:little_music/core/theme/a_color_theme.dart';

class SuccessHelper {
  static void showSuccess(BuildContext context, String message, String title) {
    Flushbar(
      title: title,
      margin: EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(16),
      flushbarPosition: FlushbarPosition.TOP,
      message: message,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      shouldIconPulse: true,
      duration: const Duration(seconds: 3),
      backgroundColor: AColorTheme.success,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    ).show(context);
  }
}
