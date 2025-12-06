/// File: lib/features/value_packs/presentation/widgets/price_badge.dart
/// Purpose: Price badge widget for displaying pack prices
/// Belongs To: value_packs feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_ext.dart';
import '../../domain/entities/value_pack.dart';

/// Price badge widget.
class PriceBadge extends StatelessWidget {
  const PriceBadge({
    required this.price,
    required this.currency,
    this.oldPrice,
    this.billingCycle = BillingCycle.oneTime,
    super.key,
  });

  final double price;
  final String currency;
  final double? oldPrice;
  final BillingCycle billingCycle;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currency,
              style: textTheme.bodySmall?.copyWith(
                fontSize: 14.sp,
                color: colors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              price.toStringAsFixed(2),
              style: textTheme.headlineSmall?.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: colors.primary,
              ),
            ),
          ],
        ),
        if (oldPrice != null) ...[
          SizedBox(height: 4.h),
          Row(
            children: [
              Text(
                '$currency${oldPrice!.toStringAsFixed(2)}',
                style: textTheme.bodySmall?.copyWith(
                  fontSize: 12.sp,
                  color: colors.textSecondary,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
        ],
        SizedBox(height: 4.h),
        Text(
          billingCycle == BillingCycle.oneTime
              ? 'One-time payment'
              : billingCycle == BillingCycle.monthly
                  ? 'Per month'
                  : 'Per year',
          style: textTheme.bodySmall?.copyWith(
            fontSize: 12.sp,
            color: colors.textTertiary,
          ),
        ),
      ],
    );
  }
}

