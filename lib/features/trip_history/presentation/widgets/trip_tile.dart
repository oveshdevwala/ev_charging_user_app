/// File: lib/features/trip_history/presentation/widgets/trip_tile.dart
/// Purpose: Reusable trip tile widget for displaying completed trips in list
/// Belongs To: trip_history feature
/// Customization Guide:
///    - Adjust padding and spacing via parameters
///    - Customize icon and colors via theme
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/extensions/context_ext.dart';
import '../../domain/entities/completed_trip.dart';

/// Trip tile widget for displaying completed trips in list.
class TripTile extends StatelessWidget {
  const TripTile({
    required this.trip,
    required this.onTap,
    this.onFavoriteTap,
    super.key,
  });

  final CompletedTrip trip;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: colors.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            // Leading icon
            Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Iconsax.routing_2,
                size: 24.r,
                color: colors.primary,
              ),
            ),
            SizedBox(width: 12.w),
            // Trip info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Text(
                        trip.formattedDistance,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: colors.textSecondary,
                        ),
                      ),
                      Text(
                        ' • ',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: colors.textSecondary,
                        ),
                      ),
                      Text(
                        trip.formattedTotalTime,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: colors.textSecondary,
                        ),
                      ),
                      Text(
                        ' • ',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: colors.textSecondary,
                        ),
                      ),
                      Text(
                        '${trip.stopCount} stops',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Favorite and chevron
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onFavoriteTap != null)
                  GestureDetector(
                    onTap: () {
                      if (onFavoriteTap != null) {
                        onFavoriteTap!();
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.r),
                      child: Icon(
                        trip.isFavorite ? Iconsax.heart5 : Iconsax.heart,
                        size: 22.r,
                        color: trip.isFavorite
                            ? Colors.red
                            : colors.textSecondary,
                      ),
                    ),
                  ),
                Icon(
                  Iconsax.arrow_right_3,
                  size: 20.r,
                  color: colors.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
