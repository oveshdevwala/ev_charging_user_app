/// File: lib/features/home/widgets/sections/section_activity_enhanced.dart
/// Purpose: Enhanced activity summary section with mini chart
/// Belongs To: home feature
/// Customization Guide:
///    - First section after search bar
///    - Tappable to view full activity details
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../models/charging_session_model.dart';
import '../../../../models/user_activity_model.dart';

/// Enhanced activity section for home screen.
class SectionActivityEnhanced extends StatelessWidget {
  const SectionActivityEnhanced({
    required this.summary,
    required this.weeklyData,
    required this.onViewDetailsTap,
    super.key,
  });

  /// User activity summary.
  final UserActivitySummary summary;

  /// Weekly data for mini chart.
  final List<DailyChargingSummary> weeklyData;

  /// Callback when tapped.
  final VoidCallback onViewDetailsTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: GestureDetector(
        onTap: onViewDetailsTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0F0F23), Color(0xFF1A1A3E)],
            ),
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F0F23).withValues(alpha: 0.2),
                blurRadius: 6.r,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.r),
            child: Stack(
              children: [
                // Background pattern
                Positioned(
                  right: -30.w,
                  top: -30.h,
                  child: Container(
                    width: 150.r,
                    height: 150.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.15),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: -20.w,
                  bottom: -40.h,
                  child: Container(
                    width: 100.r,
                    height: 100.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.secondary.withValues(alpha: 0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: EdgeInsets.all(20.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Text(
                            'Your Activity',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          _buildStreakBadge(),
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Icon(
                              Iconsax.arrow_right_3,
                              size: 16.r,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      // Stats row
                      Row(
                        children: [
                          Expanded(
                            child: _buildStat(
                              icon: Iconsax.flash_1,
                              value: summary.energyUsedKwh.toStringAsFixed(1),
                              unit: 'kWh',
                              label: 'Today',
                              color: AppColors.primary,
                            ),
                          ),
                          _buildDivider(),
                          Expanded(
                            child: _buildStat(
                              icon: Iconsax.wallet_2,
                              value:
                                  '\$${summary.moneySpent.toStringAsFixed(0)}',
                              unit: '',
                              label: 'Spent',
                              color: AppColors.secondary,
                            ),
                          ),
                          _buildDivider(),
                          Expanded(
                            child: _buildStat(
                              icon: Iconsax.tree,
                              value: summary.co2SavedKg.toStringAsFixed(0),
                              unit: 'kg',
                              label: 'CO₂ saved',
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      // // Mini chart
                      // _buildMiniChart(),
                      // SizedBox(height: 12.h),

                      // // Bottom row
                      Row(
                        children: [
                          Icon(
                            Iconsax.chart_21,
                            size: 14.r,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Last 7 days',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Level ${summary.level}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryLight,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          SizedBox(
                            width: 60.w,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4.r),
                              child: LinearProgressIndicator(
                                value: summary.levelProgress,
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.2,
                                ),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryLight,
                                ),
                                minHeight: 4.h,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStreakBadge() {
    if (summary.streaks <= 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B35), Color(0xFFFF9500)],
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🔥', style: TextStyle(fontSize: 12.sp)),
          SizedBox(width: 4.w),
          Text(
            '${summary.streaks}',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat({
    required IconData icon,
    required String value,
    required String unit,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, size: 20.r, color: color),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            if (unit.isNotEmpty) ...[
              SizedBox(width: 2.w),
              Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: Text(
                  unit,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 60.h,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0),
            Colors.white.withValues(alpha: 0.15),
            Colors.white.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }

  // Widget _buildMiniChart() {
  //   if (weeklyData.isEmpty) {
  //     return SizedBox(height: 50.h);
  //   }

  //   final maxEnergy = weeklyData
  //       .map((d) => d.energyKwh)
  //       .reduce((a, b) => a > b ? a : b);
  //   final maxY = maxEnergy > 0 ? maxEnergy * 1.2 : 50.0;

  //   return SizedBox(
  //     height: 50.h,
  //     child: BarChart(
  //       BarChartData(
  //         alignment: BarChartAlignment.spaceAround,
  //         maxY: maxY,
  //         minY: 0,
  //         barTouchData: const BarTouchData(enabled: false),
  //         titlesData: const FlTitlesData(show: false),
  //         borderData: FlBorderData(show: false),
  //         gridData: const FlGridData(show: false),
  //         barGroups: weeklyData.asMap().entries.map((entry) {
  //           final index = entry.key;
  //           final day = entry.value;
  //           final isToday = index == weeklyData.length - 1;

  //           return BarChartGroupData(
  //             x: index,
  //             barRods: [
  //               BarChartRodData(
  //                 toY: day.energyKwh > 0 ? day.energyKwh : 2,
  //                 color: isToday
  //                     ? AppColors.primaryLight
  //                     : AppColors.primary.withValues(alpha: 0.4),
  //                 width: 20.w,
  //                 borderRadius: BorderRadius.vertical(
  //                   top: Radius.circular(4.r),
  //                 ),
  //               ),
  //             ],
  //           );
  //         }).toList(),
  //       ),
  //       duration: Duration.zero,
  //     ),
  //   );
  // }
}
