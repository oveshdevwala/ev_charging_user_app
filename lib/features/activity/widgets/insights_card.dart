/// File: lib/features/activity/widgets/insights_card.dart
/// Purpose: Insights and statistics cards for activity dashboard
/// Belongs To: activity feature
/// Customization Guide:
///    - Customize card appearance and metrics via params
///    - Add new insight types as needed
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/theme/app_colors.dart';
import '../../../repositories/activity_repository.dart';

/// Large stat card with icon and trend.
class InsightStatCard extends StatelessWidget {
  const InsightStatCard({
    required this.title, required this.value, required this.icon, super.key,
    this.subtitle,
    this.trend,
    this.trendPositive = true,
    this.iconColor,
    this.backgroundColor,
  });

  final String title;
  final String value;
  final IconData icon;
  final String? subtitle;
  final String? trend;
  final bool trendPositive;
  final Color? iconColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? AppColors.primary;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.outlineLight),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, size: 22.r, color: color),
              ),
              if (trend != null) ...[
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: (trendPositive ? AppColors.success : AppColors.error)
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        trendPositive ? Iconsax.arrow_up_3 : Iconsax.arrow_down,
                        size: 12.r,
                        color: trendPositive ? AppColors.success : AppColors.error,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        trend!,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: trendPositive ? AppColors.success : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimaryLight,
              height: 1,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textSecondaryLight,
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
    );
  }
}

/// Horizontal insight card.
class InsightRow extends StatelessWidget {
  const InsightRow({
    required this.label, required this.value, super.key,
    this.icon,
    this.iconColor,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 18.r,
              color: iconColor ?? AppColors.textSecondaryLight,
            ),
            SizedBox(width: 10.w),
          ],
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondaryLight,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

/// Insights summary panel.
class InsightsPanel extends StatelessWidget {
  const InsightsPanel({
    required this.insights, super.key,
  });

  final ActivityInsights insights;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A1A2E),
            Color(0xFF16213E),
          ],
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1A2E).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Iconsax.chart_2,
                  size: 20.r,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Smart Insights',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Insights grid
          Row(
            children: [
              Expanded(
                child: _buildInsightItem(
                  icon: Iconsax.flash_1,
                  label: 'Avg Energy',
                  value: '${insights.averageEnergyPerSession.toStringAsFixed(1)} kWh',
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildInsightItem(
                  icon: Iconsax.wallet_2,
                  label: 'Avg Cost',
                  value: '\$${insights.averageCostPerSession.toStringAsFixed(2)}',
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildInsightItem(
                  icon: Iconsax.clock,
                  label: 'Peak Hour',
                  value: insights.peakHourFormatted,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildInsightItem(
                  icon: Iconsax.chart_21,
                  label: 'Efficiency',
                  value: '${insights.chargingEfficiency.toStringAsFixed(0)}%',
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Savings highlight
          Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              children: [
                Icon(Iconsax.tree, size: 24.r, color: AppColors.successLight),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$${insights.savingsVsGasoline.toStringAsFixed(0)} saved vs gasoline',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${insights.carbonFootprintReduction.toStringAsFixed(0)} kg CO₂ reduced',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18.r, color: Colors.white.withValues(alpha: 0.7)),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

/// Environmental impact card.
class EnvironmentalImpactCard extends StatelessWidget {
  const EnvironmentalImpactCard({
    required this.co2SavedKg, required this.treesEquivalent, super.key,
  });

  final double co2SavedKg;
  final double treesEquivalent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.success,
            AppColors.successDark,
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Iconsax.tree, size: 28.r, color: Colors.white),
              SizedBox(width: 12.w),
              Text(
                'Environmental Impact',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      co2SavedKg.toStringAsFixed(0),
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'kg CO₂ saved',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 50.h,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          treesEquivalent.toStringAsFixed(0),
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.h),
                          child: Text(
                            ' 🌳',
                            style: TextStyle(fontSize: 20.sp),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'trees equivalent',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

