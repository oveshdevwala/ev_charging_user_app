/// File: lib/core/theme/app_text_styles.dart
/// Purpose: Centralized typography system using ScreenUtil
/// Belongs To: shared
/// Customization Guide:
///    - Adjust sizes and weights as needed
///    - All sizes use ScreenUtil (.sp) for responsiveness
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

/// Centralized typography system for the EV Charging app.
/// Uses ScreenUtil for responsive text sizing.
abstract final class AppTextStyles {
  // ============ Display Styles ============
  /// Large display text - for hero sections
  static TextStyle displayLarge({Color? color}) => TextStyle(
    fontSize: 57.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    height: 1.12,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle displayMedium({Color? color}) => TextStyle(
    fontSize: 45.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.16,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle displaySmall({Color? color}) => TextStyle(
    fontSize: 36.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.22,
    color: color ?? AppColors.textPrimaryLight,
  );

  // ============ Headline Styles ============
  /// Headlines for sections and cards
  static TextStyle headlineLarge({Color? color}) => TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.25,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle headlineMedium({Color? color}) => TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.29,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle headlineSmall({Color? color}) => TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.33,
    color: color ?? AppColors.textPrimaryLight,
  );

  // ============ Title Styles ============
  /// Titles for app bars and list items
  static TextStyle titleLarge({Color? color}) => TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.27,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle titleMedium({Color? color}) => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.5,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle titleSmall({Color? color}) => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.43,
    color: color ?? AppColors.textPrimaryLight,
  );

  // ============ Body Styles ============
  /// Body text for content
  static TextStyle bodyLarge({Color? color}) => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.5,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle bodyMedium({Color? color}) => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle bodySmall({Color? color}) => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    color: color ?? AppColors.textSecondaryLight,
  );

  // ============ Label Styles ============
  /// Labels for buttons and captions
  static TextStyle labelLarge({Color? color}) => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.43,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle labelMedium({Color? color}) => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.33,
    color: color ?? AppColors.textPrimaryLight,
  );

  static TextStyle labelSmall({Color? color}) => TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.45,
    color: color ?? AppColors.textSecondaryLight,
  );

  // ============ Button Styles ============
  static TextStyle buttonLarge({Color? color}) => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    height: 1.5,
    color: color ?? AppColors.onPrimary,
  );

  static TextStyle buttonMedium({Color? color}) => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    height: 1.43,
    color: color ?? AppColors.onPrimary,
  );

  static TextStyle buttonSmall({Color? color}) => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    height: 1.33,
    color: color ?? AppColors.onPrimary,
  );

  // ============ Special Styles ============
  static TextStyle price({Color? color}) => TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 1.2,
    color: color ?? AppColors.primary,
  );

  static TextStyle caption({Color? color}) => TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.4,
    color: color ?? AppColors.textTertiaryLight,
  );

  static TextStyle overline({Color? color}) => TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
    height: 1.6,
    color: color ?? AppColors.textSecondaryLight,
  );
}
