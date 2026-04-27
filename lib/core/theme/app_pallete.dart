// Application color palette
// Defines the color constants used throughout the app
import 'package:flutter/material.dart';

/// Static color constants for the application
/// Used for theming and UI elements
class Pallete {
  Pallete._(); // Private constructor to prevent instantiation

  // Card and UI colors
  static const cardColor = Color.fromRGBO(30, 30, 30, 1);
  static const greenColor = Colors.green;
  static const subtitleText = Color(0xffa7a7a7);
  static const inactiveBottomBarItemColor = Color(0xffababab);

  // Background and gradient colors
  static const Color backgroundColor = Color.fromRGBO(18, 18, 18, 1);
  static const Color gradient1 = Color.fromRGBO(187, 63, 221, 1);
  static const Color gradient2 = Color.fromRGBO(251, 109, 169, 1);
  static const Color gradient3 = Color.fromRGBO(255, 159, 124, 1);

  // Basic colors
  static const Color borderColor = Color.fromRGBO(52, 51, 67, 1);
  static const Color whiteColor = Colors.white;
  static const Color greyColor = Colors.grey;
  static const Color errorColor = Colors.redAccent;
  static const Color transparentColor = Colors.transparent;

  // Player specific colors
  static const Color inactiveSeekColor = Colors.white38;
}
