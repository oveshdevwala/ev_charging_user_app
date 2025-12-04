/// File: lib/widgets/common_button.dart
/// Purpose: Reusable button widget with multiple variants
/// Belongs To: shared
/// Customization Guide:
///    - Use ButtonVariant enum for different styles
///    - Customize via parameters (size, color, icon, etc.)
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_colors.dart';

/// Button variants for different use cases.
enum ButtonVariant {
  filled,
  outlined,
  text,
  tonal,
}

/// Button sizes.
enum ButtonSize {
  small,
  medium,
  large,
}

/// Reusable button widget with multiple variants.
class CommonButton extends StatelessWidget {
  const CommonButton({
    required this.label, required this.onPressed, super.key,
    this.variant = ButtonVariant.filled,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.isFullWidth = true,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderRadius,
    this.elevation,
    this.padding,
  });
  
  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final bool isDisabled;
  final bool isFullWidth;
  final IconData? icon;
  final IconPosition iconPosition;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final double? elevation;
  final EdgeInsets? padding;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Determine sizes based on button size
    final double height;
    final double fontSize;
    final EdgeInsets buttonPadding;
    final double iconSize;
    
    switch (size) {
      case ButtonSize.small:
        height = 36.h;
        fontSize = 12.sp;
        buttonPadding = EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h);
        iconSize = 16.r;
        break;
      case ButtonSize.medium:
        height = 48.h;
        fontSize = 14.sp;
        buttonPadding = EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h);
        iconSize = 20.r;
        break;
      case ButtonSize.large:
        height = 56.h;
        fontSize = 16.sp;
        buttonPadding = EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h);
        iconSize = 24.r;
        break;
    }
    
    // Build button content
    final Widget content = isLoading
        ? SizedBox(
            width: iconSize,
            height: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(
                variant == ButtonVariant.filled
                    ? foregroundColor ?? AppColors.onPrimary
                    : foregroundColor ?? theme.colorScheme.primary,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null && iconPosition == IconPosition.left) ...[
                Icon(icon, size: iconSize),
                SizedBox(width: 8.w),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (icon != null && iconPosition == IconPosition.right) ...[
                SizedBox(width: 8.w),
                Icon(icon, size: iconSize),
              ],
            ],
          );
    
    // Build button based on variant
    final effectiveDisabled = isDisabled || isLoading;
    final effectiveOnPressed = effectiveDisabled ? null : onPressed;
    final effectiveBorderRadius = BorderRadius.circular(borderRadius ?? 12.r);
    final effectivePadding = padding ?? buttonPadding;
    
    Widget button;
    
    switch (variant) {
      case ButtonVariant.filled:
        button = ElevatedButton(
          onPressed: effectiveOnPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? theme.colorScheme.primary,
            foregroundColor: foregroundColor ?? AppColors.onPrimary,
            disabledBackgroundColor: AppColors.outlineLight,
            disabledForegroundColor: AppColors.textDisabledLight,
            elevation: elevation ?? 0,
            padding: effectivePadding,
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
            shape: RoundedRectangleBorder(borderRadius: effectiveBorderRadius),
          ),
          child: content,
        );
        break;
        
      case ButtonVariant.outlined:
        button = OutlinedButton(
          onPressed: effectiveOnPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: foregroundColor ?? theme.colorScheme.primary,
            disabledForegroundColor: AppColors.textDisabledLight,
            padding: effectivePadding,
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
            side: BorderSide(
              color: effectiveDisabled
                  ? AppColors.outlineLight
                  : borderColor ?? theme.colorScheme.primary,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(borderRadius: effectiveBorderRadius),
          ),
          child: content,
        );
        break;
        
      case ButtonVariant.text:
        button = TextButton(
          onPressed: effectiveOnPressed,
          style: TextButton.styleFrom(
            foregroundColor: foregroundColor ?? theme.colorScheme.primary,
            disabledForegroundColor: AppColors.textDisabledLight,
            padding: effectivePadding,
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
            shape: RoundedRectangleBorder(borderRadius: effectiveBorderRadius),
          ),
          child: content,
        );
        break;
        
      case ButtonVariant.tonal:
        button = FilledButton.tonal(
          onPressed: effectiveOnPressed,
          style: FilledButton.styleFrom(
            backgroundColor: backgroundColor ?? theme.colorScheme.primaryContainer,
            foregroundColor: foregroundColor ?? theme.colorScheme.onPrimaryContainer,
            disabledBackgroundColor: AppColors.outlineLight,
            disabledForegroundColor: AppColors.textDisabledLight,
            elevation: elevation ?? 0,
            padding: effectivePadding,
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
            shape: RoundedRectangleBorder(borderRadius: effectiveBorderRadius),
          ),
          child: content,
        );
        break;
    }
    
    return button;
  }
}

/// Icon position in button.
enum IconPosition {
  left,
  right,
}

/// Social login button.
class SocialButton extends StatelessWidget {
  const SocialButton({
    required this.label, required this.onPressed, required this.icon, super.key,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
  });
  
  final String label;
  final VoidCallback? onPressed;
  final Widget icon;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor ?? AppColors.textPrimaryLight,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        minimumSize: Size(double.infinity, 52.h),
        side: const BorderSide(color: AppColors.outlineLight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: isLoading
          ? SizedBox(
              width: 20.r,
              height: 20.r,
              child: const CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 24.r, height: 24.r, child: icon),
                SizedBox(width: 12.w),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );
  }
}

