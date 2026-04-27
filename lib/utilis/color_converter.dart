// Color conversion utilities
// Provides functions to convert hex color strings to Flutter Color objects
import 'package:flutter/material.dart';

/// Converts a hex color string to a Flutter Color object
/// Supports both 6-character and 8-character hex codes
/// [hexCode] - The hex color string (with or without # prefix)
/// Returns a purple Color as fallback for invalid input
Color hexToColor(String hexCode) {
  // Handle empty or invalid hex
  if (hexCode.isEmpty) return Colors.purple;

  // Remove # if present
  final cleaned = hexCode.replaceAll('#', '').trim();

  // Handle invalid length
  if (cleaned.length != 6 && cleaned.length != 8) return Colors.purple;

  try {
    // Add FF for opacity if 6 chars (fully opaque)
    final hex = cleaned.length == 6 ? 'FF$cleaned' : cleaned;
    return Color(int.parse(hex, radix: 16));
  } catch (e) {
    return Colors.purple; // Fallback on any parse error
  }
}
