/// File: lib/features/trip_planner/widgets/saved_trip_card.dart
/// Purpose: Saved trip card widget for displaying saved trips
/// Belongs To: trip_planner feature
/// Customization Guide:
///    - Customize via parameters
///    - Add action buttons as needed
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/extensions/context_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../models/models.dart';

/// Saved trip card widget.
class SavedTripCard extends StatelessWidget {
  const SavedTripCard({
    required this.trip,
    required this.onTap,
    super.key,
    this.onFavoriteTap,
    this.onDeleteTap,
    this.compact = false,
  });

  final TripModel trip;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onDeleteTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (compact) {
      return _buildCompactCard(context, theme);
    }
    return _buildFullCard(context, theme);
  }

  Widget _buildFullCard(BuildContext context, ThemeData theme) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: context.appColors.outline),
          boxShadow: [
            BoxShadow(
              color: context.appColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with route
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: context.appColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          trip.displayName,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: context.appColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (onFavoriteTap != null)
                        GestureDetector(
                          onTap: onFavoriteTap,
                          child: Icon(
                            trip.isFavorite ? Iconsax.heart5 : Iconsax.heart,
                            size: 22.r,
                            color: trip.isFavorite
                                ? context.appColors.danger
                                : context.appColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Iconsax.location,
                        size: 14.r,
                        color: context.appColors.primary,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          trip.origin.shortDisplay,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: context.appColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 6.w),
                    child: Icon(
                      Iconsax.arrow_down,
                      size: 12.r,
                      color: context.appColors.textTertiary,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Iconsax.flag,
                        size: 14.r,
                        color: context.appColors.danger,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          trip.destination.shortDisplay,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: context.appColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Stats
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatItem(
                        Iconsax.routing_2,
                        '${trip.estimates?.totalDistanceKm.toStringAsFixed(0) ?? '0'} km',
                        context: context,
                      ),
                      _buildStatItem(
                        Iconsax.clock,
                        trip.estimates?.formattedTotalTime ?? '--',
                        context: context,
                      ),
                      _buildStatItem(
                        Iconsax.flash_1,
                        '${trip.chargingStops.length} stops',
                        context: context,
                      ),
                      _buildStatItem(
                        Iconsax.dollar_circle,
                        '\$${trip.estimates?.estimatedCost.toStringAsFixed(2) ?? '0'}',
                        context: context,
                        valueColor: context.appColors.primary,
                      ),
                    ],
                  ),
                  if (trip.createdAt != null) ...[
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDate(trip.createdAt!),
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: context.appColors.textTertiary,
                          ),
                        ),
                        if (onDeleteTap != null)
                          GestureDetector(
                            onTap: onDeleteTap,
                            child: Row(
                              children: [
                                Icon(
                                  Iconsax.trash,
                                  size: 14.r,
                                  color: context.appColors.danger,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'Delete',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: context.appColors.danger,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactCard(BuildContext context, ThemeData theme) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: context.appColors.outline),
        ),
        child: Row(
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: context.appColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Iconsax.routing_2,
                size: 22.r,
                color: context.appColors.primary,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.displayName,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: context.appColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${trip.estimates?.totalDistanceKm.toStringAsFixed(0) ?? '0'} km • ${trip.estimates?.formattedTotalTime ?? '--'} • ${trip.chargingStops.length} stops',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: context.appColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (onFavoriteTap != null) ...[
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: onFavoriteTap,
                child: Icon(
                  trip.isFavorite ? Iconsax.heart5 : Iconsax.heart,
                  size: 20.r,
                  color: trip.isFavorite
                      ? context.appColors.danger
                      : context.appColors.textSecondary,
                ),
              ),
            ],
            SizedBox(width: 8.w),
            Icon(
              Iconsax.arrow_right_3,
              size: 16.r,
              color: context.appColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String value, {
    required BuildContext context,
    Color? valueColor,
  }) {
    return Column(
      children: [
        Icon(icon, size: 16.r, color: context.appColors.textSecondary),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: valueColor ?? context.appColors.textPrimary,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Today';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}
