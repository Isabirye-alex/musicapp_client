import 'package:flutter/material.dart';

Color hexToColor(String hexCode) {
  // ✅ handle empty or invalid hex
  if (hexCode.isEmpty) return Colors.purple; // default color

  // remove # if present
  final cleaned = hexCode.replaceAll('#', '').trim();

  // ✅ handle invalid length
  if (cleaned.length != 6 && cleaned.length != 8) return Colors.purple;

  try {
    // add FF for opacity if 6 chars
    final hex = cleaned.length == 6 ? 'FF$cleaned' : cleaned;
    return Color(int.parse(hex, radix: 16));
  } catch (e) {
    return Colors.purple; // ✅ fallback on any parse error
  }
}
