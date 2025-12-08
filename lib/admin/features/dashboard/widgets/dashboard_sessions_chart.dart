/// File: lib/admin/features/dashboard/widgets/dashboard_sessions_chart.dart
/// Purpose: Dashboard sessions chart widget
/// Belongs To: admin/features/dashboard/widgets
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/core.dart';

/// Dashboard sessions chart.
class DashboardSessionsChart extends StatelessWidget {
  const DashboardSessionsChart({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return AdminCardWithHeader(
      title: 'Sessions by Station',
      subtitle: 'Today\'s distribution',
      child: SizedBox(
        height: 200.h,
        child: Row(
          children: [
            // Pie chart
            Expanded(
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40.r,
                  sections: [
                    PieChartSectionData(
                      value: 35,
                      color: colors.primary,
                      title: '35%',
                      titleStyle: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.onPrimary,
                      ),
                      radius: 50.r,
                    ),
                    PieChartSectionData(
                      value: 25,
                      color: colors.info,
                      title: '25%',
                      titleStyle: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      radius: 50.r,
                    ),
                    PieChartSectionData(
                      value: 20,
                      color: colors.warning,
                      title: '20%',
                      titleStyle: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      radius: 50.r,
                    ),
                    PieChartSectionData(
                      value: 15,
                      color: colors.tertiary,
                      title: '15%',
                      titleStyle: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      radius: 50.r,
                    ),
                    PieChartSectionData(
                      value: 5,
                      color: colors.textTertiary,
                      title: '5%',
                      titleStyle: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      radius: 50.r,
                    ),
                  ],
                ),
              ),
            ),
            // Legend
            SizedBox(width: 16.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LegendItem(color: colors.primary, label: 'Downtown Hub', value: '120'),
                SizedBox(height: 8.h),
                _LegendItem(color: colors.info, label: 'Westside Mall', value: '85'),
                SizedBox(height: 8.h),
                _LegendItem(color: colors.warning, label: 'Airport', value: '68'),
                SizedBox(height: 8.h),
                _LegendItem(color: colors.tertiary, label: 'Tech Campus', value: '51'),
                SizedBox(height: 8.h),
                _LegendItem(color: colors.textTertiary, label: 'Beach Blvd', value: '18'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10.r,
          height: 10.r,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 8.w),
        SizedBox(
          width: 100.w,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: colors.textSecondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
      ],
    );
  }
}

