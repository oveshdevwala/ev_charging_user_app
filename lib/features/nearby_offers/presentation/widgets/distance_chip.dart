/// File: lib/features/nearby_offers/presentation/widgets/distance_chip.dart
/// Purpose: Reusable chip to display distance
/// Belongs To: nearby_offers feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/distance_formatter.dart';

class DistanceChip extends StatelessWidget {
  const DistanceChip({
    required this.distanceKm,
    super.key,
    this.color,
    this.textColor,
  });

  final double? distanceKm;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    if (distanceKm == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on_outlined,
            size: 14.sp,
            color: textColor ?? Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: 4.w),
          Text(
            DistanceFormatter.formatDistance(distanceKm!),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color:
                  textColor ?? Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
