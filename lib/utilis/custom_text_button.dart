// Custom text button widget
// A reusable elevated button with text content
import 'package:flutter/material.dart';

/// A customizable elevated button widget
/// Used throughout the app for primary actions
class CustomTextButton extends StatelessWidget {
  const CustomTextButton({super.key, required this.text, required this.onTap});

  /// The text to display on the button
  final String text;

  /// Callback when the button is pressed
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(),
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(text, style: TextTheme.of(context).bodyLarge),
      ),
    );
  }
}
