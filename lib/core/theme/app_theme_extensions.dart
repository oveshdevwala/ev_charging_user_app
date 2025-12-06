/// File: lib/core/theme/app_theme_extensions.dart
/// Purpose: ThemeExtension for custom AppColors that adapts to light/dark mode
/// Belongs To: shared
/// Customization Guide:
///    - Add new color properties here
///    - Update copyWith and lerp methods when adding properties
///    - Use via context.appColors extension
library;

import 'package:flutter/material.dart';

/// Custom theme extension for app-specific colors.
/// This extension provides semantic color tokens that automatically
/// adapt to light and dark themes.
///
/// Usage:
/// ```dart
/// Container(
///   color: context.appColors.background,
///   child: Text(
///     'Hello',
///     style: TextStyle(color: context.appColors.textPrimary),
///   ),
/// )
/// ```
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textDisabled,
    required this.primary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.secondaryContainer,
    required this.tertiary,
    required this.tertiaryContainer,
    required this.success,
    required this.successContainer,
    required this.danger,
    required this.dangerContainer,
    required this.warning,
    required this.warningContainer,
    required this.info,
    required this.infoContainer,
    required this.outline,
    required this.outlineVariant,
    required this.divider,
    required this.shadow,
    required this.scrim,
  });
  // ============ Background & Surface Colors ============

  /// Background color for the entire app (scaffold background).
  final Color background;

  /// Surface color for cards, sheets, dialogs.
  final Color surface;

  /// Surface variant color (elevated surfaces, input fields).
  final Color surfaceVariant;

  /// Surface container for subtle elevation.
  final Color surfaceContainer;

  /// Higher contrast surface container.
  final Color surfaceContainerHigh;

  // ============ Text Colors ============

  /// Primary text color (headings, important text).
  final Color textPrimary;

  /// Secondary text color (body text, descriptions).
  final Color textSecondary;

  /// Tertiary text color (hints, placeholders).
  final Color textTertiary;

  /// Disabled text color.
  final Color textDisabled;

  // ============ Brand Colors ============

  /// Primary brand color (main actions, buttons).
  final Color primary;

  /// Primary container color (backgrounds for primary elements).
  final Color primaryContainer;

  /// Color for content on primary container.
  final Color onPrimaryContainer;

  /// Secondary brand color (accent actions).
  final Color secondary;

  /// Secondary container color.
  final Color secondaryContainer;

  /// Tertiary brand color (supporting color).
  final Color tertiary;

  /// Tertiary container color.
  final Color tertiaryContainer;

  // ============ Functional/Status Colors ============

  /// Success state color (success messages, confirmations).
  final Color success;

  /// Success container color.
  final Color successContainer;

  /// Error/danger state color (errors, warnings).
  final Color danger;

  /// Danger container color.
  final Color dangerContainer;

  /// Warning state color (warnings, cautions).
  final Color warning;

  /// Warning container color.
  final Color warningContainer;

  /// Info state color (informational messages).
  final Color info;

  /// Info container color.
  final Color infoContainer;

  // ============ Outline & Divider Colors ============

  /// Outline color for borders.
  final Color outline;

  /// Outline variant color (subtle borders).
  final Color outlineVariant;

  /// Divider color.
  final Color divider;

  // ============ Shadow Color ============

  /// Shadow color for elevations.
  final Color shadow;

  /// Scrim color for modals/overlays.
  final Color scrim;

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textDisabled,
    Color? primary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? secondary,
    Color? secondaryContainer,
    Color? tertiary,
    Color? tertiaryContainer,
    Color? success,
    Color? successContainer,
    Color? danger,
    Color? dangerContainer,
    Color? warning,
    Color? warningContainer,
    Color? info,
    Color? infoContainer,
    Color? outline,
    Color? outlineVariant,
    Color? divider,
    Color? shadow,
    Color? scrim,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textDisabled: textDisabled ?? this.textDisabled,
      primary: primary ?? this.primary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      secondary: secondary ?? this.secondary,
      secondaryContainer: secondaryContainer ?? this.secondaryContainer,
      tertiary: tertiary ?? this.tertiary,
      tertiaryContainer: tertiaryContainer ?? this.tertiaryContainer,
      success: success ?? this.success,
      successContainer: successContainer ?? this.successContainer,
      danger: danger ?? this.danger,
      dangerContainer: dangerContainer ?? this.dangerContainer,
      warning: warning ?? this.warning,
      warningContainer: warningContainer ?? this.warningContainer,
      info: info ?? this.info,
      infoContainer: infoContainer ?? this.infoContainer,
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
      divider: divider ?? this.divider,
      shadow: shadow ?? this.shadow,
      scrim: scrim ?? this.scrim,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }

    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      surfaceContainer: Color.lerp(
        surfaceContainer,
        other.surfaceContainer,
        t,
      )!,
      surfaceContainerHigh: Color.lerp(
        surfaceContainerHigh,
        other.surfaceContainerHigh,
        t,
      )!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryContainer: Color.lerp(
        primaryContainer,
        other.primaryContainer,
        t,
      )!,
      onPrimaryContainer: Color.lerp(
        onPrimaryContainer,
        other.onPrimaryContainer,
        t,
      )!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryContainer: Color.lerp(
        secondaryContainer,
        other.secondaryContainer,
        t,
      )!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      tertiaryContainer: Color.lerp(
        tertiaryContainer,
        other.tertiaryContainer,
        t,
      )!,
      success: Color.lerp(success, other.success, t)!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerContainer: Color.lerp(dangerContainer, other.dangerContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      info: Color.lerp(info, other.info, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      outlineVariant: Color.lerp(outlineVariant, other.outlineVariant, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
    );
  }
}
