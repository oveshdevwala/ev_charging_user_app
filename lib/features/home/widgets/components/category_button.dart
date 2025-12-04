/// File: lib/features/home/widgets/components/category_button.dart
/// Purpose: Category quick action button for grid
/// Belongs To: home feature
/// Customization Guide:
///    - Customize icon, colors, and size via params
///    - Uses Iconsax for consistent iconography
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';

/// Category button widget for quick actions grid.
class CategoryButton extends StatelessWidget {
  const CategoryButton({
    required this.icon, required this.label, required this.onTap, super.key,
    this.iconColor,
    this.backgroundColor,
    this.labelStyle,
    this.iconSize,
    this.isCompact = false,
  });

  /// Icon to display.
  final IconData icon;

  /// Label text.
  final String label;

  /// Callback when button is tapped.
  final VoidCallback onTap;

  /// Icon color (defaults to primary).
  final Color? iconColor;

  /// Background color (defaults to primary container).
  final Color? backgroundColor;

  /// Custom label style.
  final TextStyle? labelStyle;

  /// Custom icon size.
  final double? iconSize;

  /// Whether to use compact layout.
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isCompact ? 12.w : 16.w,
          vertical: isCompact ? 12.h : 16.h,
        ),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.surfaceVariantLight,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.outlineLight.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: isCompact ? 44.r : 52.r,
              height: isCompact ? 44.r : 52.r,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primary).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: iconSize ?? (isCompact ? 22.r : 26.r),
                color: iconColor ?? AppColors.primary,
              ),
            ),
            SizedBox(height: isCompact ? 8.h : 12.h),
            Text(
              label,
              style: labelStyle ??
                  TextStyle(
                    fontSize: isCompact ? 11.sp : 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryLight,
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal category button with icon and label in a row.
class CategoryButtonHorizontal extends StatelessWidget {
  const CategoryButtonHorizontal({
    required this.icon, required this.label, required this.onTap, super.key,
    this.iconColor,
    this.backgroundColor,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? backgroundColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.outlineLight),
        ),
        child: Row(
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primary).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                size: 22.r,
                color: iconColor ?? AppColors.primary,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryLight,
                ),
              ),
            ),
            trailing ??
                Icon(
                  Iconsax.arrow_right_3,
                  size: 20.r,
                  color: AppColors.textTertiaryLight,
                ),
          ],
        ),
      ),
    );
  }
}

