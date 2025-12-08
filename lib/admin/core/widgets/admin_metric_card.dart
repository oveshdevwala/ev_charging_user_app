/// File: lib/admin/core/widgets/admin_metric_card.dart
/// Purpose: Metric/stat card widget for dashboard
/// Belongs To: admin/core/widgets
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../extensions/admin_context_ext.dart';
import '../theme/admin_colors.dart';

/// Admin metric card widget.
class AdminMetricCard extends StatelessWidget {
  const AdminMetricCard({
    required this.title,
    required this.value,
    super.key,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.iconBackgroundColor,
    this.change,
    this.changeLabel,
    this.isPositiveChange,
    this.onTap,
  });

  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final String? change;
  final String? changeLabel;
  final bool? isPositiveChange;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.outline),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (icon != null)
                  Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: iconBackgroundColor ?? colors.primaryContainer,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      icon,
                      size: 20.r,
                      color: iconColor ?? colors.primary,
                    ),
                  ),
                if (change != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: (isPositiveChange ?? true)
                          ? colors.successContainer
                          : colors.errorContainer,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          (isPositiveChange ?? true)
                              ? Iconsax.arrow_up_3
                              : Iconsax.arrow_down,
                          size: 12.r,
                          color: (isPositiveChange ?? true)
                              ? colors.success
                              : colors.error,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          change!,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: (isPositiveChange ?? true)
                                ? colors.success
                                : colors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16.h),

            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: colors.textSecondary,
              ),
            ),
            SizedBox(height: 4.h),

            // Value
            Text(
              value,
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
                height: 1.2,
              ),
            ),

            // Subtitle/change label
            if (subtitle != null || changeLabel != null) ...[
              SizedBox(height: 8.h),
              Text(
                subtitle ?? changeLabel ?? '',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: colors.textTertiary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Mini metric card for compact displays.
class AdminMiniMetricCard extends StatelessWidget {
  const AdminMiniMetricCard({
    required this.title,
    required this.value,
    super.key,
    this.icon,
    this.iconColor,
  });

  final String title;
  final String value;
  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 18.r,
              color: iconColor ?? colors.primary,
            ),
            SizedBox(width: 10.w),
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

