import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_ext.dart';
import '../../domain/entities/monthly_analytics.dart';

class MonthlySummaryCard extends StatelessWidget {
  const MonthlySummaryCard({required this.analytics, super.key});
  final MonthlyAnalytics analytics;

  @override
  Widget build(BuildContext context) {
    final isPositive = analytics.comparisonPercentage >= 0;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: context.appColors.textPrimary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Summary',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                context,
                'Total Cost',
                '₹${analytics.totalCost.toStringAsFixed(2)}',
                Icons.attach_money,
                context.appColors.success,
              ),
              _buildStatItem(
                context,
                'Energy',
                '${analytics.totalEnergy.toStringAsFixed(1)} kWh',
                Icons.bolt,
                context.appColors.warning,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                context,
                'Efficiency',
                '${analytics.avgEfficiency.toStringAsFixed(1)} km/kWh',
                Icons.speed,
                context.appColors.info,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isPositive
                      ? context.appColors.danger.withOpacity(0.1)
                      : context.appColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 12.sp,
                      color: isPositive
                          ? context.appColors.danger
                          : context.appColors.success,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${analytics.comparisonPercentage.abs().toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: isPositive
                            ? context.appColors.danger
                            : context.appColors.success,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
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

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16.sp, color: color),
            SizedBox(width: 4.w),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(
                    color: context.appColors.textTertiary,
                  ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
