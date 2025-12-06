/// File: lib/features/value_packs/presentation/widgets/value_pack_slider_entry.dart
/// Purpose: Compact slider entry widget for value packs
/// Belongs To: value_packs feature
/// Customization Guide:
///    - Used in horizontal sliders/carousels
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/extensions/context_ext.dart';
import '../../domain/entities/value_pack.dart';
import 'price_badge.dart';

/// Compact slider entry widget for value packs.
class ValuePackSliderEntry extends StatelessWidget {
  const ValuePackSliderEntry({
    required this.pack,
    required this.onTap,
    super.key,
  });

  /// Value pack data.
  final ValuePack pack;

  /// Callback when tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.text;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200.w,
        margin: EdgeInsets.only(right: 12.w),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: colors.primaryContainer.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: colors.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Iconsax.flash,
                size: 20.r,
                color: colors.primary,
              ),
            ),
            SizedBox(height: 12.h),
            // Title
            Text(
              pack.title,
              style: textTheme.titleSmall?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            // Price
            PriceBadge(
              price: pack.price,
              currency: pack.priceCurrency,
              oldPrice: pack.oldPrice,
              billingCycle: pack.billingCycle,
            ),
          ],
        ),
      ),
    );
  }
}

