/// File: lib/admin/core/theme/admin_light_theme.dart
/// Purpose: Light theme configuration for admin panel
/// Belongs To: admin/core/theme
/// Customization Guide:
///    - Modify colorScheme for Material 3 components
///    - Adjust component themes as needed
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'admin_colors.dart';
import 'admin_theme_extensions.dart';

/// Light theme for the Admin Panel.
ThemeData adminLightTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AdminColors.primary,
      primaryContainer: AdminColors.primaryContainer,
      onPrimaryContainer: AdminColors.onPrimaryContainer,
      secondary: AdminColors.secondary,
      secondaryContainer: AdminColors.secondaryContainer,
      onSecondary: AdminColors.onSecondary,
      onSecondaryContainer: AdminColors.onSecondaryContainer,
      tertiary: AdminColors.tertiary,
      tertiaryContainer: AdminColors.tertiaryContainer,
      onTertiary: AdminColors.onTertiary,
      onTertiaryContainer: AdminColors.onTertiaryContainer,
      error: AdminColors.error,
      errorContainer: AdminColors.errorContainer,
      onErrorContainer: AdminColors.onErrorContainer,
      onSurface: AdminColors.textPrimaryLight,
      surfaceContainerHighest: AdminColors.surfaceContainerHighLight,
      outline: AdminColors.outlineLight,
      outlineVariant: AdminColors.outlineVariantLight,
    ),
    scaffoldBackgroundColor: AdminColors.backgroundLight,
    extensions: const [AdminAppColors.light],

    // AppBar Theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: AdminColors.surfaceLight,
      foregroundColor: AdminColors.textPrimaryLight,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: AdminColors.textPrimaryLight,
      ),
      iconTheme: const IconThemeData(color: AdminColors.textPrimaryLight),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      elevation: 0,
      color: AdminColors.surfaceLight,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: const BorderSide(color: AdminColors.outlineLight),
      ),
      margin: EdgeInsets.zero,
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AdminColors.primary,
        foregroundColor: AdminColors.onPrimary,
        disabledBackgroundColor: AdminColors.outlineLight,
        disabledForegroundColor: AdminColors.textDisabledLight,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        minimumSize: Size(0, 44.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        textStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AdminColors.primary,
        disabledForegroundColor: AdminColors.textDisabledLight,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        minimumSize: Size(0, 44.h),
        side: const BorderSide(color: AdminColors.primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        textStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AdminColors.primary,
        disabledForegroundColor: AdminColors.textDisabledLight,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        textStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AdminColors.surfaceVariantLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: AdminColors.outlineLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: AdminColors.outlineLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: AdminColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: AdminColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: AdminColors.error, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      hintStyle: TextStyle(
        fontSize: 14.sp,
        color: AdminColors.textTertiaryLight,
      ),
      labelStyle: TextStyle(
        fontSize: 14.sp,
        color: AdminColors.textSecondaryLight,
      ),
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: AdminColors.surfaceVariantLight,
      selectedColor: AdminColors.primaryContainer,
      disabledColor: AdminColors.outlineLight,
      labelStyle: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: AdminColors.textPrimaryLight,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
    ),

    // Data Table Theme
    dataTableTheme: DataTableThemeData(
      headingRowColor: WidgetStateProperty.all(AdminColors.tableHeaderLight),
      dataRowColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return AdminColors.tableRowHoverLight;
        }
        return AdminColors.surfaceLight;
      }),
      headingTextStyle: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: AdminColors.textSecondaryLight,
      ),
      dataTextStyle: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        color: AdminColors.textPrimaryLight,
      ),
      dividerThickness: 1,
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      elevation: 8,
      backgroundColor: AdminColors.surfaceLight,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      titleTextStyle: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: AdminColors.textPrimaryLight,
      ),
      contentTextStyle: TextStyle(
        fontSize: 14.sp,
        color: AdminColors.textSecondaryLight,
      ),
    ),

    // Drawer Theme
    drawerTheme: const DrawerThemeData(
      elevation: 0,
      backgroundColor: AdminColors.sidebarLight,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(),
    ),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: AdminColors.dividerLight,
      thickness: 1,
      space: 1,
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: AdminColors.textSecondaryLight,
      size: 24,
    ),

    // List Tile Theme
    listTileTheme: ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      selectedTileColor: AdminColors.sidebarActiveLight,
      selectedColor: AdminColors.primary,
      iconColor: AdminColors.textSecondaryLight,
      textColor: AdminColors.textPrimaryLight,
      titleTextStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
      subtitleTextStyle: TextStyle(
        fontSize: 12.sp,
        color: AdminColors.textSecondaryLight,
      ),
    ),

    // Navigation Rail Theme
    navigationRailTheme: NavigationRailThemeData(
      elevation: 0,
      backgroundColor: AdminColors.sidebarLight,
      selectedIconTheme: const IconThemeData(color: AdminColors.primary),
      unselectedIconTheme: const IconThemeData(
        color: AdminColors.textSecondaryLight,
      ),
      selectedLabelTextStyle: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: AdminColors.primary,
      ),
      unselectedLabelTextStyle: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: AdminColors.textSecondaryLight,
      ),
    ),

    // Popup Menu Theme
    popupMenuTheme: PopupMenuThemeData(
      elevation: 4,
      color: AdminColors.surfaceLight,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      textStyle: TextStyle(
        fontSize: 14.sp,
        color: AdminColors.textPrimaryLight,
      ),
    ),

    // Snackbar Theme
    snackBarTheme: SnackBarThemeData(
      elevation: 4,
      backgroundColor: AdminColors.surfaceDark,
      contentTextStyle: TextStyle(
        fontSize: 14.sp,
        color: AdminColors.textPrimaryDark,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      behavior: SnackBarBehavior.floating,
    ),

    // Tab Bar Theme
    tabBarTheme: TabBarThemeData(
      indicatorColor: AdminColors.primary,
      labelColor: AdminColors.primary,
      unselectedLabelColor: AdminColors.textSecondaryLight,
      labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
    ),

    // Tooltip Theme
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: AdminColors.surfaceDark,
        borderRadius: BorderRadius.circular(4.r),
      ),
      textStyle: TextStyle(fontSize: 12.sp, color: AdminColors.textPrimaryDark),
    ),

    // Progress Indicator Theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AdminColors.primary,
      circularTrackColor: AdminColors.outlineLight,
      linearTrackColor: AdminColors.outlineLight,
    ),

    // Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AdminColors.primary;
        }
        return AdminColors.surfaceLight;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AdminColors.primaryContainer;
        }
        return AdminColors.outlineLight;
      }),
    ),

    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AdminColors.primary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(AdminColors.onPrimary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
      side: const BorderSide(color: AdminColors.outlineLight, width: 2),
    ),

    // Radio Theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AdminColors.primary;
        }
        return AdminColors.outlineLight;
      }),
    ),
  );
}
