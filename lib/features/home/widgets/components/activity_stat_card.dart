/// File: lib/features/home/widgets/components/activity_stat_card.dart
/// Purpose: Activity statistic card for dashboard section
/// Belongs To: home feature
/// Customization Guide:
///    - Customize icon, colors, and layout via params
///    - Supports trend indicators
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';

/// Activity stat card for displaying metrics.
class ActivityStatCard extends StatelessWidget {
  const ActivityStatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.unit,
    this.iconColor,
    this.backgroundColor,
    this.trend,
    this.trendPositive = true,
    this.isCompact = false,
  });

  /// Icon to display.
  final IconData icon;

  /// Stat label.
  final String label;

  /// Stat value.
  final String value;

  /// Optional unit suffix.
  final String? unit;

  /// Icon color.
  final Color? iconColor;

  /// Background color.
  final Color? backgroundColor;

  /// Optional trend text (e.g., "+15%").
  final String? trend;

  /// Whether trend is positive.
  final bool trendPositive;

  /// Whether to use compact layout.
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? AppColors.primary;

    return Container(
      padding: EdgeInsets.all(isCompact ? 12.r : 16.r),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.outlineLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: isCompact ? 36.r : 40.r,
                height: isCompact ? 36.r : 40.r,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  icon,
                  size: isCompact ? 18.r : 20.r,
                  color: color,
                ),
              ),
              if (trend != null) ...[
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.w,
                    vertical: 2.h,
                  ),
                  decoration: BoxDecoration(
                    color: (trendPositive ? AppColors.success : AppColors.error)
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    trend!,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color:
                          trendPositive ? AppColors.successDark : AppColors.error,
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: isCompact ? 10.h : 14.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: isCompact ? 18.sp : 22.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              if (unit != null) ...[
                SizedBox(width: 2.w),
                Padding(
                  padding: EdgeInsets.only(bottom: 2.h),
                  child: Text(
                    unit!,
                    style: TextStyle(
                      fontSize: isCompact ? 11.sp : 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: isCompact ? 11.sp : 12.sp,
              color: AppColors.textSecondaryLight,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Streak badge widget for gamification.
class StreakBadge extends StatelessWidget {
  const StreakBadge({
    super.key,
    required this.streaks,
    this.onTap,
  });

  /// Number of consecutive days.
  final int streaks;

  /// Optional tap callback.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (streaks <= 0) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B35), Color(0xFFFF9500)],
          ),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6B35).withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '🔥',
              style: TextStyle(fontSize: 18.sp),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$streaks Day Streak!',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Keep charging daily',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

