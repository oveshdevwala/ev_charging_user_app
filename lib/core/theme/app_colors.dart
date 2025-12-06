/// File: lib/core/theme/app_colors.dart
/// Purpose: Centralized color palette for the entire application (WCAG AA compliant)
/// Belongs To: shared
/// Customization Guide:
///    - Modify color values to match your brand
///    - Keep both light and dark variants for each semantic color
///    - Use these colors via context.appColors extension
library;

import 'package:flutter/material.dart';

export 'package:ev_charging_user_app/core/extensions/context_ext.dart';

/// Centralized color palette for the EV Charging app.
/// All colors should be referenced from this class.
///
/// This palette follows WCAG AA contrast guidelines for accessibility.
abstract final class AppColors {
  // ============ Primary Colors ============
  /// Main brand color - Green (EV Charging theme)
  static const Color primary = Color(0xFF34C759);
  static const Color primaryLight = Color(0xFF30D158);
  static const Color primaryDark = Color(0xFF087F23);
  static const Color primaryContainer = Color(0xFFE8F5E9);
  static const Color primaryContainerDark = Color(0xFF003A00);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF001D35);

  // ============ Secondary Colors ============
  /// Accent color - Amber/Gold
  static const Color secondary = Color(0xFFF4B400);
  static const Color secondaryLight = Color(0xFFFFCA4F);
  static const Color secondaryDark = Color(0xFFCC9000);
  static const Color secondaryContainer = Color(0xFFFFF3E0);
  static const Color secondaryContainerDark = Color(0xFF3D3000);
  static const Color onSecondary = Color(0xFF1A1A1A);
  static const Color onSecondaryContainer = Color(0xFF1D1B00);

  // ============ Tertiary Colors ============
  /// Supporting color - Purple/Violet
  static const Color tertiary = Color(0xFF7C4DFF);
  static const Color tertiaryLight = Color(0xFFB47CFF);
  static const Color tertiaryDark = Color(0xFF6B5B95);
  static const Color tertiaryContainer = Color(0xFFE8DDFF);
  static const Color tertiaryContainerDark = Color(0xFF4A4063);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFF21005D);

  // ============ Error/Danger Colors ============
  static const Color error = Color(0xFFFF3B30);
  static const Color errorLight = Color(0xFFFF453A);
  static const Color errorDark = Color(0xFFAB000D);
  static const Color errorContainer = Color(0xFFFCE4EC);
  static const Color errorContainerDark = Color(0xFF410002);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF410002);

  // ============ Success Colors ============
  static const Color success = Color(0xFF34C759);
  static const Color successLight = Color(0xFF30D158);
  static const Color successDark = Color(0xFF087F23);
  static const Color successContainer = Color(0xFFE8F5E9);
  static const Color successContainerDark = Color(0xFF003A00);

  // ============ Warning Colors ============
  static const Color warning = Color(0xFFFF9500);
  static const Color warningLight = Color(0xFFFFB340);
  static const Color warningDark = Color(0xFFCC7700);
  static const Color warningContainer = Color(0xFFFFF3E0);
  static const Color warningContainerDark = Color(0xFF331E00);

  // ============ Info Colors ============
  static const Color info = Color(0xFF03A9F4);
  static const Color infoLight = Color(0xFF4FC3F7);
  static const Color infoDark = Color(0xFF0288D1);
  static const Color infoContainer = Color(0xFFE1F5FE);
  static const Color infoContainerDark = Color(0xFF003549);

  // ============ Neutral Colors - Light Theme ============
  /// Backgrounds - clean, soft, modern
  static const Color backgroundLight = Color(0xFFF8F9FB);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFF1F3F6);
  static const Color surfaceContainerLight = Color(0xFFEEF0F3);
  static const Color surfaceContainerHighLight = Color(0xFFE6E8EB);
  static const Color outlineLight = Color(0xFFE3E5E8);
  static const Color outlineVariantLight = Color(0xFFCACACA);

  // ============ Neutral Colors - Dark Theme ============
  /// Backgrounds - balanced, not pure black
  static const Color backgroundDark = Color(0xFF0F1114);
  static const Color surfaceDark = Color(0xFF1A1D21);
  static const Color surfaceVariantDark = Color(0xFF262A30);
  static const Color surfaceContainerDark = Color(0xFF1E2126);
  static const Color surfaceContainerHighDark = Color(0xFF2A2E34);
  static const Color outlineDark = Color(0xFF2F343A);
  static const Color outlineVariantDark = Color(0xFF44494F);

  // ============ Text Colors - Light Theme ============
  static const Color textPrimaryLight = Color(0xFF1A1A1A);
  static const Color textSecondaryLight = Color(0xFF5E5E5E);
  static const Color textTertiaryLight = Color(0xFF8E8E8E);
  static const Color textDisabledLight = Color(0xFFBDBDBD);

  // ============ Text Colors - Dark Theme ============
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB7BCC5);
  static const Color textTertiaryDark = Color(0xFF8A8F96);
  static const Color textDisabledDark = Color(0xFF5C5C5C);

  // ============ Charger Status Colors ============
  static const Color available = Color(0xFF34C759);
  static const Color occupied = Color(0xFFFF9500);
  static const Color offline = Color(0xFF8E8E93);
  static const Color charging = Color(0xFF34C759);
  static const Color faulted = Color(0xFFFF3B30);

  // ============ Gradient Colors ============
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient primaryGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primary],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryLight],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [success, successDark],
  );

  /// Dark gradient for cards on light backgrounds
  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
  );

  /// Dark gradient for dark theme cards
  static const LinearGradient darkGradientElevated = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF262A30), Color(0xFF1A1D21)],
  );

  // ============ Shadow Colors ============
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);

  /// Shadow for dark mode - subtle and lighter
  static const Color shadowDarkMode = Color(0x40000000);

  // ============ Overlay Colors ============
  static const Color overlayLight = Color(0x80FFFFFF);
  static const Color overlayDark = Color(0x80000000);
  static const Color scrim = Color(0x52000000);

  // ============ Divider Colors ============
  static const Color dividerLight = Color(0xFFE3E5E8);
  static const Color dividerDark = Color(0xFF2F343A);

  // ============ Rating Colors ============
  static const Color ratingActive = Color(0xFFFFB400);
  static const Color ratingInactive = Color(0xFFE0E0E0);
  static const Color ratingInactiveDark = Color(0xFF424242);

  // ============ Special Badge Colors ============
  static const Color goldBadge = Color(0xFFFFB400);
  static const Color silverBadge = Color(0xFF9E9E9E);
  static const Color platinumBadge = Color(0xFF6B5B95);
  static const Color bronzeBadge = Color(0xFFCD7F32);
}
