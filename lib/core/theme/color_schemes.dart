/// File: lib/core/theme/color_schemes.dart
/// Purpose: Light and dark color scheme definitions using AppColors extension
/// Belongs To: shared
/// Customization Guide:
///    - Modify color values here to change the app's appearance
///    - Ensure light and dark schemes have proper contrast (WCAG AA)
///    - All colors should be accessible
library;

import 'app_colors.dart' as static_colors;
import 'app_theme_extensions.dart';

/// Light theme color scheme.
/// All colors are optimized for light backgrounds with proper contrast.
/// Follows WCAG AA contrast guidelines.
const AppColors lightColorScheme = AppColors(
  // Backgrounds
  background: static_colors.AppColors.backgroundLight,
  surface: static_colors.AppColors.surfaceLight,
  surfaceVariant: static_colors.AppColors.surfaceVariantLight,
  surfaceContainer: static_colors.AppColors.surfaceContainerLight,
  surfaceContainerHigh: static_colors.AppColors.surfaceContainerHighLight,

  // Text
  textPrimary: static_colors.AppColors.textPrimaryLight,
  textSecondary: static_colors.AppColors.textSecondaryLight,
  textTertiary: static_colors.AppColors.textTertiaryLight,
  textDisabled: static_colors.AppColors.textDisabledLight,

  // Brand colors
  primary: static_colors.AppColors.primary,
  primaryContainer: static_colors.AppColors.primaryContainer,
  onPrimaryContainer: static_colors.AppColors.onPrimaryContainer,
  secondary: static_colors.AppColors.secondary,
  secondaryContainer: static_colors.AppColors.secondaryContainer,
  tertiary: static_colors.AppColors.tertiary,
  tertiaryContainer: static_colors.AppColors.tertiaryContainer,

  // Functional colors
  success: static_colors.AppColors.success,
  successContainer: static_colors.AppColors.successContainer,
  danger: static_colors.AppColors.error,
  dangerContainer: static_colors.AppColors.errorContainer,
  warning: static_colors.AppColors.warning,
  warningContainer: static_colors.AppColors.warningContainer,
  info: static_colors.AppColors.info,
  infoContainer: static_colors.AppColors.infoContainer,

  // Outlines and dividers
  outline: static_colors.AppColors.outlineLight,
  outlineVariant: static_colors.AppColors.outlineVariantLight,
  divider: static_colors.AppColors.dividerLight,

  // Shadow and scrim
  shadow: static_colors.AppColors.shadowLight,
  scrim: static_colors.AppColors.scrim,
);

/// Dark theme color scheme.
/// All colors are optimized for dark backgrounds with proper contrast.
/// Uses balanced dark tones (not pure black) for comfortable viewing.
/// Follows WCAG AA contrast guidelines.
const AppColors darkColorScheme = AppColors(
  // Backgrounds - balanced, not pure black
  background: static_colors.AppColors.backgroundDark,
  surface: static_colors.AppColors.surfaceDark,
  surfaceVariant: static_colors.AppColors.surfaceVariantDark,
  surfaceContainer: static_colors.AppColors.surfaceContainerDark,
  surfaceContainerHigh: static_colors.AppColors.surfaceContainerHighDark,

  // Text - high contrast for readability
  textPrimary: static_colors.AppColors.textPrimaryDark,
  textSecondary: static_colors.AppColors.textSecondaryDark,
  textTertiary: static_colors.AppColors.textTertiaryDark,
  textDisabled: static_colors.AppColors.textDisabledDark,

  // Brand colors (lighter variants for dark mode visibility)
  primary: static_colors.AppColors.primaryLight,
  primaryContainer: static_colors.AppColors.primaryContainerDark,
  onPrimaryContainer: static_colors.AppColors.primaryContainer,
  secondary: static_colors.AppColors.secondaryLight,
  secondaryContainer: static_colors.AppColors.secondaryContainerDark,
  tertiary: static_colors.AppColors.tertiaryLight,
  tertiaryContainer: static_colors.AppColors.tertiaryContainerDark,

  // Functional colors (lighter variants for dark mode visibility)
  success: static_colors.AppColors.successLight,
  successContainer: static_colors.AppColors.successContainerDark,
  danger: static_colors.AppColors.errorLight,
  dangerContainer: static_colors.AppColors.errorContainerDark,
  warning: static_colors.AppColors.warningLight,
  warningContainer: static_colors.AppColors.warningContainerDark,
  info: static_colors.AppColors.infoLight,
  infoContainer: static_colors.AppColors.infoContainerDark,

  // Outlines and dividers
  outline: static_colors.AppColors.outlineDark,
  outlineVariant: static_colors.AppColors.outlineVariantDark,
  divider: static_colors.AppColors.dividerDark,

  // Shadow and scrim
  shadow: static_colors.AppColors.shadowDarkMode,
  scrim: static_colors.AppColors.scrim,
);
