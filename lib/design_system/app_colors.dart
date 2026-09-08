import 'package:flutter/material.dart';

abstract final class AppColors {
  // Primary — medical green
  static const Color primary = Color(0xFF1B5E20);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFA5D6A7);
  static const Color onPrimaryContainer = Color(0xFF002204);

  // Secondary — teal accent
  static const Color secondary = Color(0xFF00695C);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFF80CBC4);
  static const Color onSecondaryContainer = Color(0xFF002020);

  // Tertiary — warm amber for highlights
  static const Color tertiary = Color(0xFFF57F17);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFFFECB3);
  static const Color onTertiaryContainer = Color(0xFF3E2700);

  // Surface & background
  static const Color surface = Color(0xFFF8FAF5);
  static const Color onSurface = Color(0xFF1A1C19);
  static const Color surfaceVariant = Color(0xFFE0E4DA);
  static const Color onSurfaceVariant = Color(0xFF444940);

  // Error
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF410002);

  // Outline
  static const Color outline = Color(0xFF74796E);
  static const Color outlineVariant = Color(0xFFC4C8BC);
}
