// Error notification helper
// Provides a method to display error messages using Flushbar
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:little_music/core/theme/a_color_theme.dart';

/// Helper class for showing error notifications
/// Displays a top-positioned flushbar with an error icon
class ErrorHelper {
  /// Shows an error notification with the given message and title
  /// [context] - The BuildContext for showing the flushbar
  /// [message] - The error message to display
  /// [title] - The title of the notification
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
