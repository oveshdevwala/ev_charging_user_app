/// File: lib/admin/core/theme/admin_theme_extensions.dart
/// Purpose: ThemeExtension for admin panel semantic color tokens
/// Belongs To: admin/core/theme
/// Customization Guide:
///    - Access colors via context.adminColors extension
///    - Both light and dark themes provide these tokens
library;

import 'package:flutter/material.dart';

import 'admin_colors.dart';

/// ThemeExtension providing semantic color tokens for the admin panel.
/// Access via context.adminColors (see admin_context_ext.dart).
@immutable
class AdminAppColors extends ThemeExtension<AdminAppColors> {
  const AdminAppColors({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.outline,
    required this.outlineVariant,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textDisabled,
    required this.primary,
    required this.primaryContainer,
    required this.onPrimary,
    required this.secondary,
    required this.secondaryContainer,
    required this.onSecondary,
    required this.tertiary,
    required this.tertiaryContainer,
    required this.onTertiary,
    required this.error,
    required this.errorContainer,
    required this.onError,
    required this.success,
    required this.successContainer,
    required this.warning,
    required this.warningContainer,
    required this.info,
    required this.infoContainer,
    required this.divider,
    required this.shadow,
    required this.sidebar,
    required this.sidebarActive,
    required this.sidebarHover,
    required this.tableHeader,
    required this.tableRowHover,
    required this.tableBorder,
  });

  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color outline;
  final Color outlineVariant;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textDisabled;
  final Color primary;
  final Color primaryContainer;
  final Color onPrimary;
  final Color secondary;
  final Color secondaryContainer;
  final Color onSecondary;
  final Color tertiary;
  final Color tertiaryContainer;
  final Color onTertiary;
  final Color error;
  final Color errorContainer;
  final Color onError;
  final Color success;
  final Color successContainer;
  final Color warning;
  final Color warningContainer;
  final Color info;
  final Color infoContainer;
  final Color divider;
  final Color shadow;
  final Color sidebar;
  final Color sidebarActive;
  final Color sidebarHover;
  final Color tableHeader;
  final Color tableRowHover;
  final Color tableBorder;

  /// Light theme color scheme
  static const AdminAppColors light = AdminAppColors(
    background: AdminColors.backgroundLight,
    surface: AdminColors.surfaceLight,
    surfaceVariant: AdminColors.surfaceVariantLight,
    surfaceContainer: AdminColors.surfaceContainerLight,
    surfaceContainerHigh: AdminColors.surfaceContainerHighLight,
    outline: AdminColors.outlineLight,
    outlineVariant: AdminColors.outlineVariantLight,
    textPrimary: AdminColors.textPrimaryLight,
    textSecondary: AdminColors.textSecondaryLight,
    textTertiary: AdminColors.textTertiaryLight,
    textDisabled: AdminColors.textDisabledLight,
    primary: AdminColors.primary,
    primaryContainer: AdminColors.primaryContainer,
    onPrimary: AdminColors.onPrimary,
    secondary: AdminColors.secondary,
    secondaryContainer: AdminColors.secondaryContainer,
    onSecondary: AdminColors.onSecondary,
    tertiary: AdminColors.tertiary,
    tertiaryContainer: AdminColors.tertiaryContainer,
    onTertiary: AdminColors.onTertiary,
    error: AdminColors.error,
    errorContainer: AdminColors.errorContainer,
    onError: AdminColors.onError,
    success: AdminColors.success,
    successContainer: AdminColors.successContainer,
    warning: AdminColors.warning,
    warningContainer: AdminColors.warningContainer,
    info: AdminColors.info,
    infoContainer: AdminColors.infoContainer,
    divider: AdminColors.dividerLight,
    shadow: AdminColors.shadowLight,
    sidebar: AdminColors.sidebarLight,
    sidebarActive: AdminColors.sidebarActiveLight,
    sidebarHover: AdminColors.sidebarHoverLight,
    tableHeader: AdminColors.tableHeaderLight,
    tableRowHover: AdminColors.tableRowHoverLight,
    tableBorder: AdminColors.tableBorderLight,
  );

  /// Dark theme color scheme
  static const AdminAppColors dark = AdminAppColors(
    background: AdminColors.backgroundDark,
    surface: AdminColors.surfaceDark,
    surfaceVariant: AdminColors.surfaceVariantDark,
    surfaceContainer: AdminColors.surfaceContainerDark,
    surfaceContainerHigh: AdminColors.surfaceContainerHighDark,
    outline: AdminColors.outlineDark,
    outlineVariant: AdminColors.outlineVariantDark,
    textPrimary: AdminColors.textPrimaryDark,
    textSecondary: AdminColors.textSecondaryDark,
    textTertiary: AdminColors.textTertiaryDark,
    textDisabled: AdminColors.textDisabledDark,
    primary: AdminColors.primaryLight,
    primaryContainer: AdminColors.primaryContainerDark,
    onPrimary: AdminColors.onPrimary,
    secondary: AdminColors.secondaryLight,
    secondaryContainer: AdminColors.secondaryContainerDark,
    onSecondary: AdminColors.onSecondary,
    tertiary: AdminColors.tertiaryLight,
    tertiaryContainer: AdminColors.tertiaryContainerDark,
    onTertiary: AdminColors.onTertiary,
    error: AdminColors.errorLight,
    errorContainer: AdminColors.errorContainerDark,
    onError: AdminColors.onError,
    success: AdminColors.successLight,
    successContainer: AdminColors.successContainerDark,
    warning: AdminColors.warningLight,
    warningContainer: AdminColors.warningContainerDark,
    info: AdminColors.infoLight,
    infoContainer: AdminColors.infoContainerDark,
    divider: AdminColors.dividerDark,
    shadow: AdminColors.shadowDarkMode,
    sidebar: AdminColors.sidebarDark,
    sidebarActive: AdminColors.sidebarActiveDark,
    sidebarHover: AdminColors.sidebarHoverDark,
    tableHeader: AdminColors.tableHeaderDark,
    tableRowHover: AdminColors.tableRowHoverDark,
    tableBorder: AdminColors.tableBorderDark,
  );

  @override
  AdminAppColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? outline,
    Color? outlineVariant,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textDisabled,
    Color? primary,
    Color? primaryContainer,
    Color? onPrimary,
    Color? secondary,
    Color? secondaryContainer,
    Color? onSecondary,
    Color? tertiary,
    Color? tertiaryContainer,
    Color? onTertiary,
    Color? error,
    Color? errorContainer,
    Color? onError,
    Color? success,
    Color? successContainer,
    Color? warning,
    Color? warningContainer,
    Color? info,
    Color? infoContainer,
    Color? divider,
    Color? shadow,
    Color? sidebar,
    Color? sidebarActive,
    Color? sidebarHover,
    Color? tableHeader,
    Color? tableRowHover,
    Color? tableBorder,
  }) {
    return AdminAppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textDisabled: textDisabled ?? this.textDisabled,
      primary: primary ?? this.primary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      secondaryContainer: secondaryContainer ?? this.secondaryContainer,
      onSecondary: onSecondary ?? this.onSecondary,
      tertiary: tertiary ?? this.tertiary,
      tertiaryContainer: tertiaryContainer ?? this.tertiaryContainer,
      onTertiary: onTertiary ?? this.onTertiary,
      error: error ?? this.error,
      errorContainer: errorContainer ?? this.errorContainer,
      onError: onError ?? this.onError,
      success: success ?? this.success,
      successContainer: successContainer ?? this.successContainer,
      warning: warning ?? this.warning,
      warningContainer: warningContainer ?? this.warningContainer,
      info: info ?? this.info,
      infoContainer: infoContainer ?? this.infoContainer,
      divider: divider ?? this.divider,
      shadow: shadow ?? this.shadow,
      sidebar: sidebar ?? this.sidebar,
      sidebarActive: sidebarActive ?? this.sidebarActive,
      sidebarHover: sidebarHover ?? this.sidebarHover,
      tableHeader: tableHeader ?? this.tableHeader,
      tableRowHover: tableRowHover ?? this.tableRowHover,
      tableBorder: tableBorder ?? this.tableBorder,
    );
  }

  @override
  AdminAppColors lerp(ThemeExtension<AdminAppColors>? other, double t) {
    if (other is! AdminAppColors) {
      return this;
    }
    return AdminAppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      surfaceContainer: Color.lerp(surfaceContainer, other.surfaceContainer, t)!,
      surfaceContainerHigh: Color.lerp(surfaceContainerHigh, other.surfaceContainerHigh, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      outlineVariant: Color.lerp(outlineVariant, other.outlineVariant, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryContainer: Color.lerp(primaryContainer, other.primaryContainer, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryContainer: Color.lerp(secondaryContainer, other.secondaryContainer, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      tertiaryContainer: Color.lerp(tertiaryContainer, other.tertiaryContainer, t)!,
      onTertiary: Color.lerp(onTertiary, other.onTertiary, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorContainer: Color.lerp(errorContainer, other.errorContainer, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      success: Color.lerp(success, other.success, t)!,
      successContainer: Color.lerp(successContainer, other.successContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      sidebar: Color.lerp(sidebar, other.sidebar, t)!,
      sidebarActive: Color.lerp(sidebarActive, other.sidebarActive, t)!,
      sidebarHover: Color.lerp(sidebarHover, other.sidebarHover, t)!,
      tableHeader: Color.lerp(tableHeader, other.tableHeader, t)!,
      tableRowHover: Color.lerp(tableRowHover, other.tableRowHover, t)!,
      tableBorder: Color.lerp(tableBorder, other.tableBorder, t)!,
    );
  }
}

