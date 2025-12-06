/// File: lib/features/stations/widgets/booking_summary.dart
/// Purpose: Booking summary widget
/// Belongs To: stations feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/context_ext.dart';
import '../../../core/theme/app_colors.dart';

/// Booking summary card showing cost estimation.
class BookingSummary extends StatelessWidget {
  const BookingSummary({
    required this.chargerName,
    required this.duration,
    required this.pricePerKwh,
    super.key,
  });

  final String chargerName;
  final int duration;
  final double pricePerKwh;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final estimatedEnergy = (duration / 60) * 50;
    final cost = (duration / 60) * pricePerKwh * 50;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          _buildRow(context, 'Charger', chargerName),
          _buildRow(context, 'Duration', '$duration min'),
          _buildRow(context, 'Estimated Energy', '${estimatedEnergy.toStringAsFixed(0)} kWh'),
          Divider(height: 24.h, color: colors.outline),
          _buildRow(
            context,
            'Estimated Cost',
            '\$${cost.toStringAsFixed(2)}',
            valueStyle: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: colors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    String label,
    String value, {
    TextStyle? valueStyle,
  }) {
    final colors = context.appColors;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: colors.textSecondary,
            ),
          ),
          Text(
            value,
            style: valueStyle ??
                TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
          ),
        ],
      ),
    );
  }
}
