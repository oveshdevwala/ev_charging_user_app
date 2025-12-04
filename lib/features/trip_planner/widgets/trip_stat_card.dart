/// File: lib/features/trip_planner/widgets/trip_stat_card.dart
/// Purpose: Trip statistics card widget
/// Belongs To: trip_planner feature
/// Customization Guide:
///    - Customize via parameters (icon, colors, etc.)
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';

/// Trip stat card widget for displaying single statistics.
class TripStatCard extends StatelessWidget {
  const TripStatCard({
    required this.icon, required this.label, required this.value, super.key,
    this.subtitle,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? subtitle;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIconColor = iconColor ?? AppColors.primary;
    final effectiveBgColor =
        backgroundColor ?? effectiveIconColor.withValues(alpha: 0.1);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.outlineLight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: effectiveBgColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                size: 20.r,
                color: effectiveIconColor,
              ),
            ),
            SizedBox(height: 12.h),
            // Label
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondaryLight,
              ),
            ),
            SizedBox(height: 4.h),
            // Value
            Text(
              value,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimaryLight,
              ),
            ),
            if (subtitle != null) ...[
              SizedBox(height: 2.h),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textTertiaryLight,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Horizontal trip stat row for compact display.
class TripStatRow extends StatelessWidget {
  const TripStatRow({
    required this.stats, super.key,
  });

  final List<TripStatData> stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: stats.asMap().entries.map((entry) {
        final index = entry.key;
        final stat = entry.value;
        final isLast = index == stats.length - 1;

        return Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              border: !isLast
                  ? const Border(
                      right: BorderSide(
                        color: AppColors.outlineLight,
                      ),
                    )
                  : null,
            ),
            child: Column(
              children: [
                Icon(
                  stat.icon,
                  size: 20.r,
                  color: stat.color ?? AppColors.primary,
                ),
                SizedBox(height: 6.h),
                Text(
                  stat.value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  stat.label,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Trip stat data for TripStatRow.
class TripStatData {
  const TripStatData({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? color;
}

/// Summary stats card with multiple stats in a row.
class TripSummaryStatsCard extends StatelessWidget {
  const TripSummaryStatsCard({
    required this.stats, super.key,
    this.backgroundColor,
  });

  final List<TripStatData> stats;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.outlineLight,
        ),
      ),
      child: TripStatRow(stats: stats),
    );
  }
}

/// Large featured stat widget.
class FeaturedStatWidget extends StatelessWidget {
  const FeaturedStatWidget({
    required this.icon, required this.label, required this.value, super.key,
    this.unit,
    this.color,
    this.gradient,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? unit;
  final Color? color;
  final LinearGradient? gradient;

  @override
  Widget build(BuildContext context) {
    final effectiveGradient = gradient ??
        LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color ?? AppColors.primary,
            (color ?? AppColors.primary).withValues(alpha: 0.8),
          ],
        );

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: effectiveGradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: (color ?? AppColors.primary).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56.r,
            height: 56.r,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              icon,
              size: 28.r,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    if (unit != null) ...[
                      SizedBox(width: 4.w),
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: Text(
                          unit!,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

