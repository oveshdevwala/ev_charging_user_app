/// File: lib/features/activity/widgets/energy_chart.dart
/// Purpose: Energy usage bar chart widget
/// Belongs To: activity feature
/// Customization Guide:
///    - Customize colors and styling via params
///    - Uses fl_chart for rendering
library;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/charging_session_model.dart';

/// Energy usage bar chart.
class EnergyChart extends StatelessWidget {
  const EnergyChart({
    required this.data,
    super.key,
    this.height,
    this.barColor,
    this.showLabels = true,
    this.animate = true,
  });

  /// Daily charging data.
  final List<DailyChargingSummary> data;

  /// Chart height.
  final double? height;

  /// Bar color.
  final Color? barColor;

  /// Whether to show axis labels.
  final bool showLabels;

  /// Whether to animate.
  final bool animate;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return SizedBox(
        height: height ?? 200.h,
        child: Center(
          child: Text(
            'No data available',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ),
      );
    }

    final maxEnergy = data
        .map((d) => d.energyKwh)
        .reduce((a, b) => a > b ? a : b);
    final maxY = ((maxEnergy / 20).ceil() * 20).toDouble();

    return SizedBox(
      height: height ?? 200.h,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY > 0 ? maxY : 100,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) =>
                  AppColors.textPrimaryLight.withValues(alpha: 0.9),
              tooltipPadding: EdgeInsets.all(8.r),
              tooltipMargin: 8.h,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final day = data[groupIndex];
                return BarTooltipItem(
                  '${day.energyKwh.toStringAsFixed(1)} kWh\n${day.sessions} sessions',
                  TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: showLabels,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= data.length) {
                    return const SizedBox();
                  }
                  final day = data[value.toInt()];
                  return Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      day.dayAbbrev,
                      style: TextStyle(
                        color: AppColors.textSecondaryLight,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
                reservedSize: 30.h,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: maxY / 4,
                getTitlesWidget: (value, meta) {
                  if (value == 0) {
                    return const SizedBox();
                  }
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: Text(
                      '${value.toInt()}',
                      style: TextStyle(
                        color: AppColors.textTertiaryLight,
                        fontSize: 10.sp,
                      ),
                    ),
                  );
                },
                reservedSize: 35.w,
              ),
            ),
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: maxY / 4,
            getDrawingHorizontalLine: (value) {
              return const FlLine(
                color: AppColors.outlineLight,
                strokeWidth: 1,
                dashArray: [5, 5],
              );
            },
          ),
          barGroups: data.asMap().entries.map((entry) {
            final index = entry.key;
            final day = entry.value;
            final isToday = index == data.length - 1;

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: day.energyKwh,
                  color: isToday
                      ? (barColor ?? AppColors.primary)
                      : (barColor ?? AppColors.primary).withValues(alpha: 0.5),
                  width: data.length > 14 ? 8.w : 24.w,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(4.r),
                  ),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxY,
                    color: AppColors.surfaceVariantLight,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
        duration: animate ? const Duration(milliseconds: 500) : Duration.zero,
      ),
    );
  }
}

/// Spending trend line chart.
class SpendingChart extends StatelessWidget {
  const SpendingChart({
    required this.data,
    super.key,
    this.height,
    this.lineColor,
    this.showLabels = true,
  });

  /// Daily charging data.
  final List<DailyChargingSummary> data;

  /// Chart height.
  final double? height;

  /// Line color.
  final Color? lineColor;

  /// Whether to show axis labels.
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return SizedBox(
        height: height ?? 180.h,
        child: Center(
          child: Text(
            'No data available',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ),
      );
    }

    final maxCost = data.map((d) => d.cost).reduce((a, b) => a > b ? a : b);
    final maxY = ((maxCost / 10).ceil() * 10).toDouble();
    final color = lineColor ?? AppColors.secondary;

    return SizedBox(
      height: height ?? 180.h,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) =>
                  AppColors.textPrimaryLight.withValues(alpha: 0.9),
              tooltipPadding: EdgeInsets.all(8.r),
              getTooltipItems: (spots) {
                return spots.map((spot) {
                  final day = data[spot.x.toInt()];
                  return LineTooltipItem(
                    '\$${day.cost.toStringAsFixed(2)}',
                    TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }).toList();
              },
            ),
          ),
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: maxY / 4,
            getDrawingHorizontalLine: (value) {
              return const FlLine(
                color: AppColors.outlineLight,
                strokeWidth: 1,
                dashArray: [5, 5],
              );
            },
          ),
          titlesData: FlTitlesData(
            show: showLabels,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: (data.length / 6).ceil().toDouble(),
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= data.length) {
                    return const SizedBox();
                  }
                  final day = data[value.toInt()];
                  return Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      day.shortDate,
                      style: TextStyle(
                        color: AppColors.textSecondaryLight,
                        fontSize: 10.sp,
                      ),
                    ),
                  );
                },
                reservedSize: 28.h,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: maxY / 4,
                getTitlesWidget: (value, meta) {
                  if (value == 0) {
                    return const SizedBox();
                  }
                  return Text(
                    '\$${value.toInt()}',
                    style: TextStyle(
                      color: AppColors.textTertiaryLight,
                      fontSize: 10.sp,
                    ),
                  );
                },
                reservedSize: 40.w,
              ),
            ),
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (data.length - 1).toDouble(),
          minY: 0,
          maxY: maxY > 0 ? maxY : 50,
          lineBarsData: [
            LineChartBarData(
              spots: data.asMap().entries.map((entry) {
                return FlSpot(entry.key.toDouble(), entry.value.cost);
              }).toList(),
              isCurved: true,
              curveSmoothness: 0.3,
              color: color,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: index == data.length - 1 ? 5 : 3,
                    color: color,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    color.withValues(alpha: 0.3),
                    color.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 500),
      ),
    );
  }
}
