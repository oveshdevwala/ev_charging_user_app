import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extensions/context_ext.dart';
import '../../domain/entities/monthly_analytics.dart';

class CostTrendChart extends StatelessWidget {
  const CostTrendChart({required this.trendData, super.key});
  final List<DailyBreakdown> trendData;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (trendData.isEmpty) {
      return Center(
        child: Text(
          'No trips this month',
          style: TextStyle(color: colors.textSecondary),
        ),
      );
    }

    return Container(
      height: 200.h,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cost Trend',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: colors.outline,
                      strokeWidth: 1,
                      dashArray: const [5, 5],
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '\$${value.toInt()}',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: colors.textTertiary,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < trendData.length) {
                          if (index % 5 == 0) {
                            // Show every 5th day
                            return Text(
                              '${trendData[index].date.day}',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: colors.textSecondary,
                              ),
                            );
                          }
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: trendData
                        .asMap()
                        .entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value.cost))
                        .toList(),
                    isCurved: true,
                    color: colors.primary,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: colors.primary.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
