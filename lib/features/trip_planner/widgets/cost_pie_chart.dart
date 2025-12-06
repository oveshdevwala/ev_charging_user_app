/// File: lib/features/trip_planner/widgets/cost_pie_chart.dart
/// Purpose: Cost breakdown pie chart widget using fl_chart
/// Belongs To: trip_planner feature
/// Customization Guide:
///    - Customize colors via CostBreakdownItem
///    - Adjust pie chart appearance
// ignore_for_file: parameter_assignments

library;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/context_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../models/models.dart';

/// Cost breakdown pie chart widget.
class CostPieChart extends StatefulWidget {
  const CostPieChart({
    required this.costBreakdown,
    required this.totalCost,
    super.key,
    this.size,
    this.centerText,
    this.showLegend = true,
    this.animate = true,
  });

  /// Cost breakdown items.
  final List<CostBreakdownItem> costBreakdown;

  /// Total cost for center display.
  final double totalCost;

  /// Chart size.
  final double? size;

  /// Text to show in center (defaults to total cost).
  final String? centerText;

  /// Whether to show legend.
  final bool showLegend;

  /// Whether to animate.
  final bool animate;

  @override
  State<CostPieChart> createState() => _CostPieChartState();
}

class _CostPieChartState extends State<CostPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (widget.costBreakdown.isEmpty) {
      return SizedBox(
        height: widget.size ?? 200.h,
        child: Center(
          child: Text(
            'No cost data',
            style: TextStyle(
              fontSize: 14.sp,
              color: colors.textSecondary,
            ),
          ),
        ),
      );
    }

    final chartSize = widget.size ?? 180.r;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: chartSize,
          height: chartSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (event, response) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            response == null ||
                            response.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex =
                            response.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  sectionsSpace: 2,
                  centerSpaceRadius: chartSize * 0.35,
                  sections: _buildSections(context),
                ),
                duration: widget.animate
                    ? const Duration(milliseconds: 500)
                    : Duration.zero,
              ),
              // Center text
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: colors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    widget.centerText ??
                        '\$${widget.totalCost.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (widget.showLegend) ...[SizedBox(height: 16.h), _buildLegend(context)],
      ],
    );
  }

  List<PieChartSectionData> _buildSections(BuildContext context) {
    final colors = context.appColors;

    return List.generate(widget.costBreakdown.length, (index) {
      final item = widget.costBreakdown[index];
      final isTouched = index == touchedIndex;
      final percentage = widget.totalCost > 0
          ? (item.amount / widget.totalCost) * 100
          : 0.0;

      return PieChartSectionData(
        color: _parseColor(item.colorHex),
        value: item.amount,
        title: isTouched ? '${percentage.toStringAsFixed(1)}%' : '',
        radius: isTouched ? 40.r : 35.r,
        titleStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: colors.surface,
        ),
        titlePositionPercentageOffset: 0.6,
      );
    });
  }

  Widget _buildLegend(BuildContext context) {
    final colors = context.appColors;

    return Wrap(
      spacing: 16.w,
      runSpacing: 8.h,
      alignment: WrapAlignment.center,
      children: widget.costBreakdown.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.r,
              height: 12.r,
              decoration: BoxDecoration(
                color: _parseColor(item.colorHex),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              '${item.label} (\$${item.amount.toStringAsFixed(2)})',
              style: TextStyle(
                fontSize: 12.sp,
                color: colors.textSecondary,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Color _parseColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}

/// Simple horizontal cost bar breakdown.
class CostBarBreakdown extends StatelessWidget {
  const CostBarBreakdown({
    required this.costBreakdown,
    required this.totalCost,
    super.key,
    this.height,
    this.borderRadius,
  });

  final List<CostBreakdownItem> costBreakdown;
  final double totalCost;
  final double? height;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (costBreakdown.isEmpty || totalCost <= 0) {
      return const SizedBox.shrink();
    }

    final barHeight = height ?? 12.h;
    final radius = borderRadius ?? 6.r;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bar
        ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Row(
            children: costBreakdown.map((item) {
              final widthFraction = item.amount / totalCost;
              return Expanded(
                flex: (widthFraction * 100).round().clamp(1, 100),
                child: Container(
                  height: barHeight,
                  color: _parseColor(item.colorHex),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 12.h),
        // Legend
        Wrap(
          spacing: 16.w,
          runSpacing: 8.h,
          children: costBreakdown.map((item) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8.r,
                  height: 8.r,
                  decoration: BoxDecoration(
                    color: _parseColor(item.colorHex),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: colors.textSecondary,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  '\$${item.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _parseColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}
