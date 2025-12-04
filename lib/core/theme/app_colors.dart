/// File: lib/core/theme/app_colors.dart
/// Purpose: Centralized color palette for the entire application
/// Belongs To: shared
/// Customization Guide:
///    - Modify color values to match your brand
///    - Keep both light and dark variants for each semantic color
///    - Use these colors via context.colors extension
library;

import 'package:flutter/material.dart';

/// Centralized color palette for the EV Charging app.
/// All colors should be referenced from this class.
abstract final class AppColors {
  // ============ Primary Colors ============
  /// Main brand color - Electric Green
  static const Color primary = Color(0xFF00C853);
  static const Color primaryLight = Color(0xFF5EFC82);
  static const Color primaryDark = Color(0xFF009624);
  static const Color primaryContainer = Color(0xFFB9F6CA);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF002106);

  // ============ Secondary Colors ============
  /// Accent color - Electric Blue
  static const Color secondary = Color(0xFF2196F3);
  static const Color secondaryLight = Color(0xFF6EC6FF);
  static const Color secondaryDark = Color(0xFF0069C0);
  static const Color secondaryContainer = Color(0xFFBBDEFB);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF001D35);

  // ============ Tertiary Colors ============
  /// Supporting color - Purple/Violet
  static const Color tertiary = Color(0xFF7C4DFF);
  static const Color tertiaryLight = Color(0xFFB47CFF);
  static const Color tertiaryDark = Color(0xFF3F1DCB);
  static const Color tertiaryContainer = Color(0xFFE8DDFF);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFF21005D);

  // ============ Error Colors ============
  static const Color error = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFFF6F60);
  static const Color errorDark = Color(0xFFAB000D);
  static const Color errorContainer = Color(0xFFFCE4EC);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF410002);

  // ============ Success Colors ============
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF80E27E);
  static const Color successDark = Color(0xFF087F23);
  static const Color successContainer = Color(0xFFE8F5E9);

  // ============ Warning Colors ============
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningDark = Color(0xFFF57C00);
  static const Color warningContainer = Color(0xFFFFF3E0);

  // ============ Info Colors ============
  static const Color info = Color(0xFF03A9F4);
  static const Color infoLight = Color(0xFF4FC3F7);
  static const Color infoDark = Color(0xFF0288D1);
  static const Color infoContainer = Color(0xFFE1F5FE);

  // ============ Neutral Colors - Light Theme ============
  static const Color backgroundLight = Color(0xFFF8FAF9);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFF1F5F3);
  static const Color outlineLight = Color(0xFFE0E0E0);
  static const Color outlineVariantLight = Color(0xFFBDBDBD);

  // ============ Neutral Colors - Dark Theme ============
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color surfaceVariantDark = Color(0xFF2C2C2C);
  static const Color outlineDark = Color(0xFF424242);
  static const Color outlineVariantDark = Color(0xFF616161);

  // ============ Text Colors - Light Theme ============
  static const Color textPrimaryLight = Color(0xFF1A1A1A);
  static const Color textSecondaryLight = Color(0xFF666666);
  static const Color textTertiaryLight = Color(0xFF999999);
  static const Color textDisabledLight = Color(0xFFBDBDBD);

  // ============ Text Colors - Dark Theme ============
  static const Color textPrimaryDark = Color(0xFFF5F5F5);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color textTertiaryDark = Color(0xFF757575);
  static const Color textDisabledDark = Color(0xFF5C5C5C);

  // ============ Charger Status Colors ============
  static const Color available = Color(0xFF4CAF50);
  static const Color occupied = Color(0xFFFF9800);
  static const Color offline = Color(0xFF9E9E9E);
  static const Color charging = Color(0xFF2196F3);
  static const Color faulted = Color(0xFFE53935);

  // ============ Gradient Colors ============
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryLight],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
  );

  // ============ Shadow Colors ============
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);

  // ============ Overlay Colors ============
  static const Color overlayLight = Color(0x80FFFFFF);
  static const Color overlayDark = Color(0x80000000);

  // ============ Divider Colors ============
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF424242);

  // ============ Rating Colors ============
  static const Color ratingActive = Color(0xFFFFB400);
  static const Color ratingInactive = Color(0xFFE0E0E0);
}
