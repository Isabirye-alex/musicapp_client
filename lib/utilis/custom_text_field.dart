// Custom text field widget
// A reusable text form field with customizable icons and behavior
import 'package:flutter/material.dart';

/// A customizable text field widget with prefix/suffix icons and validation
/// Used throughout the app for user input
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    required this.controller,
    this.isObscureText = false,
    this.readOnly = false,
    this.songOnTap,
    this.maxLines = 1,
  });

  /// Placeholder text shown when the field is empty
  final String? hintText;

  /// Icon displayed before the text input
  final IconData? prefixIcon;

  /// Icon displayed after the text input (e.g., for password toggle)
  final IconData? suffixIcon;

  /// Callback when the suffix icon is tapped
  final VoidCallback? onTap;

  /// Callback when the text field is tapped
  final VoidCallback? songOnTap;

  /// Controller for managing the text input
  final TextEditingController? controller;

  /// Whether to obscure the text (for password fields)
  final bool isObscureText;

  /// Whether the field is read-only
  final bool readOnly;

  /// Maximum number of lines for multiline input
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: TextAlign.start,
      maxLines: maxLines,
      onTap: songOnTap,
      readOnly: readOnly,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return '$hintText is missing';
        }
        return null;
      },
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon != null
            ? InkWell(onTap: onTap, child: Icon(suffixIcon))
            : null,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      ),
      obscureText: isObscureText,
      obscuringCharacter: '*',
      autofocus: false,
    );
  }
}
