/// File: lib/features/trip_history/presentation/widgets/completed_trip_battery_chart.dart
/// Purpose: Battery SOC vs Distance chart widget for completed trips
/// Belongs To: trip_history feature
/// Customization Guide:
///    - Adjust colors via parameters
///    - Customize chart height and styling
library;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_ext.dart';
import '../../domain/entities/completed_trip.dart';

/// Battery chart widget for completed trips.
class CompletedTripBatteryChart extends StatelessWidget {
  const CompletedTripBatteryChart({
    required this.trip,
    super.key,
    this.height,
    this.reserveSocPercent = 10,
  });

  final CompletedTrip trip;
  final double? height;
  final double reserveSocPercent;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (trip.batteryTimeline.isEmpty) {
      return SizedBox(
        height: height ?? 200.h,
        child: Center(
          child: Text(
            'No battery data available',
            style: TextStyle(
              fontSize: 14.sp,
              color: colors.textSecondary,
            ),
          ),
        ),
      );
    }

    final maxDistance = trip.distanceKm;
    final timeline = trip.batteryTimeline;

    // Create line chart spots
    final spots = timeline
        .map((point) => FlSpot(point.distanceKm, point.socPercent))
        .toList();

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
            horizontalInterval: 20,
            verticalInterval: maxDistance > 0 ? maxDistance / 5 : 100,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: colors.outline.withValues(alpha: 0.3),
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: colors.outline.withValues(alpha: 0.3),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(
              
            ),
            topTitles: const AxisTitles(
              
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: maxDistance > 0 ? maxDistance / 5 : 100,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: colors.textSecondary,
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 20,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}%',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: colors.textSecondary,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: reserveSocPercent,
                color: colors.warning.withValues(alpha: 0.7),
                strokeWidth: 1,
                dashArray: [5, 5],
                label: HorizontalLineLabel(
                  show: true,
                  alignment: Alignment.topRight,
                  labelResolver: (line) => 'Reserve',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: colors.warning,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              color: colors.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                  if (index < timeline.length) {
                    final point = timeline[index];
                    final isCharging = point.isChargingStop;
                    if (isCharging) {
                      return FlDotCirclePainter(
                        radius: 8.r,
                        color: colors.secondary,
                        strokeWidth: 2,
                        strokeColor: colors.surface,
                      );
                    }
                  }
                  return FlDotCirclePainter(
                    radius: 0,
                    color: Colors.transparent,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: colors.primary.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
