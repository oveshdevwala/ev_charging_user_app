/// File: lib/admin/features/dashboard/widgets/dashboard_revenue_chart.dart
/// Purpose: Dashboard revenue chart widget
/// Belongs To: admin/features/dashboard/widgets
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/core.dart';

/// Dashboard revenue chart.
class DashboardRevenueChart extends StatelessWidget {
  const DashboardRevenueChart({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return AdminCardWithHeader(
      title: 'Revenue Overview',
      subtitle: 'Last 7 days',
      actions: [
        TextButton(
          onPressed: () {},
          child: Text('View Report', style: TextStyle(fontSize: 12.sp)),
        ),
      ],
      child: SizedBox(
        height: 220.h,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 1000,
              getDrawingHorizontalLine: (value) => FlLine(
                color: colors.divider,
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) => Text(
                    '\$${(value / 1000).toStringAsFixed(0)}k',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: colors.textTertiary,
                    ),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                    return Text(
                      days[value.toInt() % 7],
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: colors.textTertiary,
                      ),
                    );
                  },
                ),
              ),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 4200),
                  FlSpot(1, 3800),
                  FlSpot(2, 5100),
                  FlSpot(3, 4600),
                  FlSpot(4, 5800),
                  FlSpot(5, 6200),
                  FlSpot(6, 5680),
                ],
                isCurved: true,
                color: colors.primary,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: colors.primary.withValues(alpha: 0.1),
                ),
              ),
            ],
            minX: 0,
            maxX: 6,
            minY: 0,
            maxY: 8000,
          ),
        ),
      ),
    );
  }
}

