import 'package:flutter/material.dart';

class AppColors {
  // Main theme colors
  static const primary = Color(0xFF271963); // Dark purple
  static const secondary = Color(0xFFFCC826); // Yellow accent
  static const tertiary = Color(0xFFC5C0D7); // Light purple

  // UI colors
  static const background = Colors.white;
  static const surface = Color(0xFFF5F5F7);
  static const textPrimary = Color(0xFF333333);
  static const textSecondary = Color(0xFF666666);

  // Feedback colors
  static const success = Color(0xFF4CAF50);
  static const error = Color(0xFFE53935);
  static const warning = Color(0xFFFF9800);
  static const info = Color(0xFF2196F3);

  // Card gradients
  static const cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF271963),
      Color(0xFF33237A),
    ],
  );
}
