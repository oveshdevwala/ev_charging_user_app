/// File: lib/features/trip_planner/widgets/battery_graph.dart
/// Purpose: Battery SOC vs Distance graph widget using fl_chart
/// Belongs To: trip_planner feature
/// Customization Guide:
///    - Adjust colors via parameters
///    - Customize tooltip appearance
library;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../models/models.dart';

/// Battery SOC vs Distance graph widget.
class BatteryGraph extends StatelessWidget {
  const BatteryGraph({
    required this.dataPoints,
    super.key,
    this.reserveSocPercent = 10,
    this.height,
    this.lineColor,
    this.reserveLineColor,
    this.chargingColor,
    this.showGrid = true,
    this.showTooltip = true,
    this.animate = true,
  });

  /// Data points for the graph.
  final List<BatteryDataPoint> dataPoints;

  /// Reserve SOC percentage to show as warning line.
  final double reserveSocPercent;

  /// Graph height.
  final double? height;

  /// Line color for battery curve.
  final Color? lineColor;

  /// Reserve line color.
  final Color? reserveLineColor;

  /// Color for charging jumps.
  final Color? chargingColor;

  /// Whether to show grid lines.
  final bool showGrid;

  /// Whether to show tooltip on touch.
  final bool showTooltip;

  /// Whether to animate the graph.
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (dataPoints.isEmpty) {
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

    final maxDistance = dataPoints
        .map((d) => d.distanceKm)
        .reduce((a, b) => a > b ? a : b);

    final effectiveLineColor = lineColor ?? AppColors.primary;
    final effectiveReserveColor = reserveLineColor ?? AppColors.warning;
    final effectiveChargingColor = chargingColor ?? AppColors.secondary;

    // Create line chart spots
    final spots = <FlSpot>[];
    for (final point in dataPoints) {
      spots.add(FlSpot(point.distanceKm, point.socPercent));
    }

    return Container(
      height: height ?? 200.h,
      padding: EdgeInsets.only(right: 16.w, top: 16.h),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: maxDistance,
          minY: 0,
          maxY: 100,
          gridData: FlGridData(
            show: showGrid,
            horizontalInterval: 20,
            verticalInterval: maxDistance / 5,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: (isDark ? AppColors.outlineDark : AppColors.outlineLight)
                    .withValues(alpha: 0.5),
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: (isDark ? AppColors.outlineDark : AppColors.outlineLight)
                    .withValues(alpha: 0.5),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              axisNameWidget: Text(
                'SOC %',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35.w,
                interval: 20,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}%',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.textSecondaryLight,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              axisNameWidget: Text(
                'Distance (km)',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 25.h,
                interval: maxDistance / 5,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.textSecondaryLight,
                    ),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              left: BorderSide(
                color: isDark ? AppColors.outlineDark : AppColors.outlineLight,
              ),
              bottom: BorderSide(
                color: isDark ? AppColors.outlineDark : AppColors.outlineLight,
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            enabled: showTooltip,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) =>
                  isDark ? AppColors.surfaceDark : Colors.white,
              tooltipPadding: EdgeInsets.all(8.r),
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final point = _findDataPoint(spot.x);
                  return LineTooltipItem(
                    '${spot.y.toStringAsFixed(1)}%\n${spot.x.toStringAsFixed(0)} km',
                    TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: point?.isChargingStop ?? false
                          ? effectiveChargingColor
                          : effectiveLineColor,
                    ),
                    children: point?.label != null
                        ? [
                            TextSpan(
                              text: '\n${point!.label}',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.normal,
                                color: AppColors.textSecondaryLight,
                              ),
                            ),
                          ]
                        : null,
                  );
                }).toList();
              },
            ),
          ),
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              // Reserve SOC warning line
              HorizontalLine(
                y: reserveSocPercent,
                color: effectiveReserveColor.withValues(alpha: 0.7),
                dashArray: [5, 5],
                label: HorizontalLineLabel(
                  show: true,
                  alignment: Alignment.topRight,
                  labelResolver: (line) => 'Reserve',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: effectiveReserveColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              color: effectiveLineColor,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                  final point = dataPoints.length > index
                      ? dataPoints[index]
                      : null;
                  final isCharging = point?.isChargingStop ?? false;

                  return FlDotCirclePainter(
                    radius: isCharging ? 6.r : 3.r,
                    color: isCharging
                        ? effectiveChargingColor
                        : effectiveLineColor,
                    strokeWidth: isCharging ? 2 : 0,
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
                    effectiveLineColor.withValues(alpha: 0.3),
                    effectiveLineColor.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ],
        ),
        duration: animate ? const Duration(milliseconds: 500) : Duration.zero,
      ),
    );
  }

  BatteryDataPoint? _findDataPoint(double distance) {
    for (final point in dataPoints) {
      if ((point.distanceKm - distance).abs() < 1) {
        return point;
      }
    }
    return null;
  }
}

/// Compact battery progress indicator.
class BatteryProgressIndicator extends StatelessWidget {
  const BatteryProgressIndicator({
    required this.socPercent,
    super.key,
    this.width,
    this.height,
    this.showLabel = true,
    this.reserveSocPercent = 10,
  });

  final double socPercent;
  final double? width;
  final double? height;
  final bool showLabel;
  final double reserveSocPercent;

  @override
  Widget build(BuildContext context) {
    final isLow = socPercent <= reserveSocPercent;
    final color = isLow
        ? AppColors.error
        : socPercent <= 30
        ? AppColors.warning
        : AppColors.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: width ?? 60.w,
          height: height ?? 24.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(color: AppColors.outlineLight, width: 2),
          ),
          child: Stack(
            children: [
              // Battery level fill
              FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (socPercent / 100).clamp(0, 1),
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              // Reserve line
              Positioned(
                left: (reserveSocPercent / 100) * (width ?? 60.w) - 3.w,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 2,
                  color: AppColors.warning.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
        if (showLabel) ...[
          SizedBox(height: 4.h),
          Text(
            '${socPercent.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ],
    );
  }
}
