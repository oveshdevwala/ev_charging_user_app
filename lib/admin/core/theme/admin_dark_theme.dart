/// File: lib/admin/core/theme/admin_dark_theme.dart
/// Purpose: Dark theme configuration for admin panel
/// Belongs To: admin/core/theme
/// Customization Guide:
///    - Modify colorScheme for Material 3 components
///    - Adjust component themes as needed
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'admin_colors.dart';
import 'admin_theme_extensions.dart';

/// Dark theme for the Admin Panel.
ThemeData adminDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AdminColors.primaryLight,
      primaryContainer: AdminColors.primaryContainerDark,
      onPrimary: AdminColors.onPrimary,
      onPrimaryContainer: AdminColors.onPrimaryContainer,
      secondary: AdminColors.secondaryLight,
      secondaryContainer: AdminColors.secondaryContainerDark,
      onSecondary: AdminColors.onSecondary,
      onSecondaryContainer: AdminColors.onSecondaryContainer,
      tertiary: AdminColors.tertiaryLight,
      tertiaryContainer: AdminColors.tertiaryContainerDark,
      onTertiary: AdminColors.onTertiary,
      onTertiaryContainer: AdminColors.onTertiaryContainer,
      error: AdminColors.errorLight,
      errorContainer: AdminColors.errorContainerDark,
      onError: AdminColors.onError,
      onErrorContainer: AdminColors.onErrorContainer,
      surface: AdminColors.surfaceDark,
      onSurface: AdminColors.textPrimaryDark,
      surfaceContainerHighest: AdminColors.surfaceContainerHighDark,
      outline: AdminColors.outlineDark,
      outlineVariant: AdminColors.outlineVariantDark,
    ),
    scaffoldBackgroundColor: AdminColors.backgroundDark,
    extensions: const [AdminAppColors.dark],

    // AppBar Theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: AdminColors.surfaceDark,
      foregroundColor: AdminColors.textPrimaryDark,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: AdminColors.textPrimaryDark,
      ),
      iconTheme: const IconThemeData(
        color: AdminColors.textPrimaryDark,
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      elevation: 0,
      color: AdminColors.surfaceDark,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: const BorderSide(color: AdminColors.outlineDark),
      ),
      margin: EdgeInsets.zero,
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AdminColors.primaryLight,
        foregroundColor: AdminColors.onPrimary,
        disabledBackgroundColor: AdminColors.outlineDark,
        disabledForegroundColor: AdminColors.textDisabledDark,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        minimumSize: Size(0, 44.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        textStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AdminColors.primaryLight,
        disabledForegroundColor: AdminColors.textDisabledDark,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        minimumSize: Size(0, 44.h),
        side: const BorderSide(color: AdminColors.primaryLight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        textStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AdminColors.primaryLight,
        disabledForegroundColor: AdminColors.textDisabledDark,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        textStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AdminColors.surfaceVariantDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: AdminColors.outlineDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: AdminColors.outlineDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: AdminColors.primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: AdminColors.errorLight),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: AdminColors.errorLight, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      hintStyle: TextStyle(
        fontSize: 14.sp,
        color: AdminColors.textTertiaryDark,
      ),
      labelStyle: TextStyle(
        fontSize: 14.sp,
        color: AdminColors.textSecondaryDark,
      ),
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: AdminColors.surfaceVariantDark,
      selectedColor: AdminColors.primaryContainerDark,
      disabledColor: AdminColors.outlineDark,
      labelStyle: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: AdminColors.textPrimaryDark,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
    ),

    // Data Table Theme
    dataTableTheme: DataTableThemeData(
      headingRowColor: WidgetStateProperty.all(AdminColors.tableHeaderDark),
      dataRowColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return AdminColors.tableRowHoverDark;
        }
        return AdminColors.surfaceDark;
      }),
      headingTextStyle: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: AdminColors.textSecondaryDark,
      ),
      dataTextStyle: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        color: AdminColors.textPrimaryDark,
      ),
      dividerThickness: 1,
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      elevation: 8,
      backgroundColor: AdminColors.surfaceDark,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      titleTextStyle: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: AdminColors.textPrimaryDark,
      ),
      contentTextStyle: TextStyle(
        fontSize: 14.sp,
        color: AdminColors.textSecondaryDark,
      ),
    ),

    // Drawer Theme
    drawerTheme: const DrawerThemeData(
      elevation: 0,
      backgroundColor: AdminColors.sidebarDark,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(),
    ),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: AdminColors.dividerDark,
      thickness: 1,
      space: 1,
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: AdminColors.textSecondaryDark,
      size: 24,
    ),

    // List Tile Theme
    listTileTheme: ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      selectedTileColor: AdminColors.sidebarActiveDark,
      selectedColor: AdminColors.primaryLight,
      iconColor: AdminColors.textSecondaryDark,
      textColor: AdminColors.textPrimaryDark,
      titleTextStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
      subtitleTextStyle: TextStyle(
        fontSize: 12.sp,
        color: AdminColors.textSecondaryDark,
      ),
    ),

    // Navigation Rail Theme
    navigationRailTheme: NavigationRailThemeData(
      elevation: 0,
      backgroundColor: AdminColors.sidebarDark,
      selectedIconTheme: const IconThemeData(color: AdminColors.primaryLight),
      unselectedIconTheme: const IconThemeData(color: AdminColors.textSecondaryDark),
      selectedLabelTextStyle: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: AdminColors.primaryLight,
      ),
      unselectedLabelTextStyle: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: AdminColors.textSecondaryDark,
      ),
    ),

    // Popup Menu Theme
    popupMenuTheme: PopupMenuThemeData(
      elevation: 4,
      color: AdminColors.surfaceDark,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      textStyle: TextStyle(
        fontSize: 14.sp,
        color: AdminColors.textPrimaryDark,
      ),
    ),

    // Snackbar Theme
    snackBarTheme: SnackBarThemeData(
      elevation: 4,
      backgroundColor: AdminColors.surfaceVariantDark,
      contentTextStyle: TextStyle(
        fontSize: 14.sp,
        color: AdminColors.textPrimaryDark,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      behavior: SnackBarBehavior.floating,
    ),

    // Tab Bar Theme
    tabBarTheme: TabBarThemeData(
      indicatorColor: AdminColors.primaryLight,
      labelColor: AdminColors.primaryLight,
      unselectedLabelColor: AdminColors.textSecondaryDark,
      labelStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
    ),

    // Tooltip Theme
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: AdminColors.surfaceVariantDark,
        borderRadius: BorderRadius.circular(4.r),
      ),
      textStyle: TextStyle(
        fontSize: 12.sp,
        color: AdminColors.textPrimaryDark,
      ),
    ),

    // Progress Indicator Theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AdminColors.primaryLight,
      circularTrackColor: AdminColors.outlineDark,
      linearTrackColor: AdminColors.outlineDark,
    ),

    // Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AdminColors.primaryLight;
        }
        return AdminColors.surfaceDark;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AdminColors.primaryContainerDark;
        }
        return AdminColors.outlineDark;
      }),
    ),

    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AdminColors.primaryLight;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(AdminColors.onPrimary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.r),
      ),
      side: const BorderSide(color: AdminColors.outlineDark, width: 2),
    ),

    // Radio Theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AdminColors.primaryLight;
        }
        return AdminColors.outlineDark;
      }),
    ),
  );
}

