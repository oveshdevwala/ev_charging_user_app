/// File: lib/admin/core/widgets/admin_button.dart
/// Purpose: Reusable button widgets for admin panel
/// Belongs To: admin/core/widgets
/// Customization Guide:
///    - Use AdminButton for standard buttons
///    - Use AdminIconButton for icon-only buttons
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/admin_context_ext.dart';
import '../theme/admin_colors.dart';

/// Button variants.
enum AdminButtonVariant { filled, outlined, text, tonal }

/// Button sizes.
enum AdminButtonSize { small, medium, large }

/// Admin panel button widget.
class AdminButton extends StatelessWidget {
  const AdminButton({
    required this.label,
    super.key,
    this.onPressed,
    this.variant = AdminButtonVariant.filled,
    this.size = AdminButtonSize.medium,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.isLoading = false,
    this.isFullWidth = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  /// Primary action button.
  factory AdminButton.primary({
    required String label,
    VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    bool isFullWidth = false,
  }) {
    return AdminButton(
      label: label,
      onPressed: onPressed,
      icon: icon,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
    );
  }

  /// Secondary action button.
  factory AdminButton.secondary({
    required String label,
    VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    bool isFullWidth = false,
  }) {
    return AdminButton(
      label: label,
      onPressed: onPressed,
      variant: AdminButtonVariant.outlined,
      icon: icon,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
    );
  }

  /// Danger/destructive button.
  factory AdminButton.danger({
    required String label,
    VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
  }) {
    return AdminButton(
      label: label,
      onPressed: onPressed,
      backgroundColor: AdminColors.error,
      foregroundColor: AdminColors.onError,
      icon: icon,
      isLoading: isLoading,
    );
  }

  final String label;
  final VoidCallback? onPressed;
  final AdminButtonVariant variant;
  final AdminButtonSize size;
  final IconData? icon;
  final IconPosition iconPosition;
  final bool isLoading;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    // Determine sizes
    final double height;
    final double fontSize;
    final EdgeInsets padding;
    final double iconSize;

    switch (size) {
      case AdminButtonSize.small:
        height = 32.h;
        fontSize = 12.sp;
        padding = EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h);
        iconSize = 16.r;
        break;
      case AdminButtonSize.medium:
        height = 40.h;
        fontSize = 14.sp;
        padding = EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h);
        iconSize = 18.r;
        break;
      case AdminButtonSize.large:
        height = 48.h;
        fontSize = 15.sp;
        padding = EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h);
        iconSize = 20.r;
        break;
    }

    // Build content
    final Widget content = isLoading
        ? SizedBox(
            width: iconSize,
            height: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(
                foregroundColor ?? 
                  (variant == AdminButtonVariant.filled 
                    ? colors.onPrimary 
                    : colors.primary),
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

    final effectiveOnPressed = isLoading ? null : onPressed;
    final borderRadius = BorderRadius.circular(8.r);

    Widget button;

    switch (variant) {
      case AdminButtonVariant.filled:
        button = ElevatedButton(
          onPressed: effectiveOnPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? colors.primary,
            foregroundColor: foregroundColor ?? colors.onPrimary,
            disabledBackgroundColor: colors.outline,
            disabledForegroundColor: colors.textDisabled,
            elevation: 0,
            padding: padding,
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
          ),
          child: content,
        );
        break;

      case AdminButtonVariant.outlined:
        button = OutlinedButton(
          onPressed: effectiveOnPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: foregroundColor ?? colors.primary,
            disabledForegroundColor: colors.textDisabled,
            padding: padding,
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
            side: BorderSide(
              color: effectiveOnPressed == null 
                  ? colors.outline 
                  : backgroundColor ?? colors.primary,
            ),
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
          ),
          child: content,
        );
        break;

      case AdminButtonVariant.text:
        button = TextButton(
          onPressed: effectiveOnPressed,
          style: TextButton.styleFrom(
            foregroundColor: foregroundColor ?? colors.primary,
            disabledForegroundColor: colors.textDisabled,
            padding: padding,
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
          ),
          child: content,
        );
        break;

      case AdminButtonVariant.tonal:
        button = FilledButton.tonal(
          onPressed: effectiveOnPressed,
          style: FilledButton.styleFrom(
            backgroundColor: backgroundColor ?? colors.primaryContainer,
            foregroundColor: foregroundColor ?? colors.primary,
            disabledBackgroundColor: colors.outline,
            disabledForegroundColor: colors.textDisabled,
            padding: padding,
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
          ),
          child: content,
        );
        break;
    }

    return button;
  }
}

/// Icon position in button.
enum IconPosition { left, right }

/// Admin icon button.
class AdminIconButton extends StatelessWidget {
  const AdminIconButton({
    required this.icon,
    super.key,
    this.onPressed,
    this.size = 40,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.isLoading = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    Widget button = IconButton(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? SizedBox(
              width: 18.r,
              height: 18.r,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(
                  foregroundColor ?? colors.textSecondary,
                ),
              ),
            )
          : Icon(
              icon,
              size: 20.r,
              color: foregroundColor ?? colors.textSecondary,
            ),
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor ?? colors.surfaceVariant,
        fixedSize: Size(size.r, size.r),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );

    if (tooltip != null) {
      button = Tooltip(
        message: tooltip,
        child: button,
      );
    }

    return button;
  }
}

