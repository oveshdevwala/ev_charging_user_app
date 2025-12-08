/// File: lib/admin/core/theme/admin_text_styles.dart
/// Purpose: Centralized typography system for admin panel using ScreenUtil
/// Belongs To: admin/core/theme
/// Customization Guide:
///    - Adjust sizes and weights as needed
///    - All sizes use ScreenUtil (.sp) for responsiveness
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'admin_colors.dart';

/// Centralized typography system for the Admin Panel.
/// Uses ScreenUtil for responsive text sizing.
abstract final class AdminTextStyles {
  // ============ Display Styles ============
  /// Large display text - for hero sections
  static TextStyle displayLarge({Color? color}) => TextStyle(
    fontSize: 48.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    height: 1.12,
    color: color ?? AdminColors.textPrimaryLight,
  );

  static TextStyle displayMedium({Color? color}) => TextStyle(
    fontSize: 36.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.16,
    color: color ?? AdminColors.textPrimaryLight,
  );

  static TextStyle displaySmall({Color? color}) => TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.22,
    color: color ?? AdminColors.textPrimaryLight,
  );

  // ============ Headline Styles ============
  /// Headlines for sections and cards
  static TextStyle headlineLarge({Color? color}) => TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.25,
    color: color ?? AdminColors.textPrimaryLight,
  );

  static TextStyle headlineMedium({Color? color}) => TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.29,
    color: color ?? AdminColors.textPrimaryLight,
  );

  static TextStyle headlineSmall({Color? color}) => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.33,
    color: color ?? AdminColors.textPrimaryLight,
  );

  // ============ Title Styles ============
  /// Titles for app bars and list items
  static TextStyle titleLarge({Color? color}) => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.27,
    color: color ?? AdminColors.textPrimaryLight,
  );

  static TextStyle titleMedium({Color? color}) => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.5,
    color: color ?? AdminColors.textPrimaryLight,
  );

  static TextStyle titleSmall({Color? color}) => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.43,
    color: color ?? AdminColors.textPrimaryLight,
  );

  // ============ Body Styles ============
  /// Body text for content
  static TextStyle bodyLarge({Color? color}) => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.5,
    color: color ?? AdminColors.textPrimaryLight,
  );

  static TextStyle bodyMedium({Color? color}) => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
    color: color ?? AdminColors.textPrimaryLight,
  );

  static TextStyle bodySmall({Color? color}) => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    color: color ?? AdminColors.textSecondaryLight,
  );

  // ============ Label Styles ============
  /// Labels for buttons, inputs, and captions
  static TextStyle labelLarge({Color? color}) => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.43,
    color: color ?? AdminColors.textPrimaryLight,
  );

  static TextStyle labelMedium({Color? color}) => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.33,
    color: color ?? AdminColors.textPrimaryLight,
  );

  static TextStyle labelSmall({Color? color}) => TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.45,
    color: color ?? AdminColors.textSecondaryLight,
  );

  // ============ Button Styles ============
  static TextStyle buttonLarge({Color? color}) => TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.5,
    color: color ?? AdminColors.onPrimary,
  );

  static TextStyle buttonMedium({Color? color}) => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.43,
    color: color ?? AdminColors.onPrimary,
  );

  static TextStyle buttonSmall({Color? color}) => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.33,
    color: color ?? AdminColors.onPrimary,
  );

  // ============ Table Styles ============
  static TextStyle tableHeader({Color? color}) => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.33,
    color: color ?? AdminColors.textSecondaryLight,
  );

  static TextStyle tableCell({Color? color}) => TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
    color: color ?? AdminColors.textPrimaryLight,
  );

  // ============ Sidebar Styles ============
  static TextStyle sidebarItem({Color? color}) => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
    color: color ?? AdminColors.textPrimaryLight,
  );

  static TextStyle sidebarItemActive({Color? color}) => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.43,
    color: color ?? AdminColors.primary,
  );

  static TextStyle sidebarGroup({Color? color}) => TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 1,
    height: 1.45,
    color: color ?? AdminColors.textTertiaryLight,
  );

  // ============ Metric Styles ============
  static TextStyle metricValue({Color? color}) => TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
    color: color ?? AdminColors.textPrimaryLight,
  );

  static TextStyle metricLabel({Color? color}) => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.33,
    color: color ?? AdminColors.textSecondaryLight,
  );

  static TextStyle metricChange({Color? color}) => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.25,
    height: 1.33,
    color: color ?? AdminColors.success,
  );

  // ============ Badge Styles ============
  static TextStyle badge({Color? color}) => TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.2,
    color: color ?? AdminColors.onPrimary,
  );

  // ============ Caption Styles ============
  static TextStyle caption({Color? color}) => TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.4,
    color: color ?? AdminColors.textTertiaryLight,
  );

  static TextStyle overline({Color? color}) => TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
    height: 1.6,
    color: color ?? AdminColors.textSecondaryLight,
  );

  // ============ Code Style ============
  static TextStyle code({Color? color}) => TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    fontFamily: 'monospace',
    letterSpacing: 0,
    height: 1.5,
    color: color ?? AdminColors.textPrimaryLight,
  );
}

