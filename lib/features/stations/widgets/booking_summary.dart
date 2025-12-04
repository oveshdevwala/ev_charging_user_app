/// File: lib/features/stations/widgets/booking_summary.dart
/// Purpose: Booking summary widget
/// Belongs To: stations feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';

/// Booking summary card showing cost estimation.
class BookingSummary extends StatelessWidget {
  const BookingSummary({
    super.key,
    required this.chargerName,
    required this.duration,
    required this.pricePerKwh,
  });

  final String chargerName;
  final int duration;
  final double pricePerKwh;

  @override
  Widget build(BuildContext context) {
    final estimatedEnergy = (duration / 60) * 50;
    final cost = (duration / 60) * pricePerKwh * 50;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariantLight,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          _buildRow('Charger', chargerName),
          _buildRow('Duration', '$duration min'),
          _buildRow('Estimated Energy', '${estimatedEnergy.toStringAsFixed(0)} kWh'),
          Divider(height: 24.h),
          _buildRow(
            'Estimated Cost',
            '\$${cost.toStringAsFixed(2)}',
            valueStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {TextStyle? valueStyle}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondaryLight)),
          Text(value, style: valueStyle ?? TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

