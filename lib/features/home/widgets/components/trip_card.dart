/// File: lib/features/home/widgets/components/trip_card.dart
/// Purpose: Trip route card for saved routes section
/// Belongs To: home feature
/// Customization Guide:
///    - Customize colors and layout via params
///    - Shows origin, destination, distance, stops
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../models/trip_route_model.dart';

/// Trip route card widget.
class TripCard extends StatelessWidget {
  const TripCard({
    required this.route, required this.onTap, super.key,
    this.width,
    this.isCompact = false,
  });

  /// Route data.
  final TripRouteModel route;

  /// Callback when card is tapped.
  final VoidCallback onTap;

  /// Card width.
  final double? width;

  /// Whether to use compact layout.
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 260.w,
        margin: EdgeInsets.only(right: 16.w),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.outlineLight),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Route name and favorite
            Row(
              children: [
                Expanded(
                  child: Text(
                    route.name ?? route.displayName,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (route.isFavorite)
                  Icon(
                    Iconsax.heart5,
                    size: 18.r,
                    color: AppColors.error,
                  ),
              ],
            ),
            SizedBox(height: 14.h),

            // Route visualization
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Route dots and line
                Column(
                  children: [
                    Container(
                      width: 12.r,
                      height: 12.r,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 2.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(1.r),
                      ),
                      child: route.stopsCount > 0
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                route.stopsCount.clamp(1, 3),
                                (index) => Container(
                                  width: 6.r,
                                  height: 6.r,
                                  margin: EdgeInsets.symmetric(vertical: 2.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.surfaceLight,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : null,
                    ),
                    Container(
                      width: 12.r,
                      height: 12.r,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 12.w),

                // Origin and destination
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        route.from,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 22.h),
                      Text(
                        route.to,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),

            // Route stats
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariantLight,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat(
                    icon: Iconsax.routing_2,
                    value: '${route.distance.toStringAsFixed(0)} km',
                  ),
                  Container(
                    width: 1,
                    height: 20.h,
                    color: AppColors.outlineLight,
                  ),
                  _buildStat(
                    icon: Iconsax.flash_1,
                    value: '${route.stopsCount} stops',
                  ),
                  Container(
                    width: 1,
                    height: 20.h,
                    color: AppColors.outlineLight,
                  ),
                  _buildStat(
                    icon: Iconsax.clock,
                    value: route.estimation?.formattedTime ?? '--',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat({required IconData icon, required String value}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14.r,
          color: AppColors.textSecondaryLight,
        ),
        SizedBox(width: 4.w),
        Text(
          value,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }
}

/// Quick trip planner card with CTA.
class TripPlannerCard extends StatelessWidget {
  const TripPlannerCard({
    required this.onPlanTripTap, super.key,
  });

  /// Callback when plan trip is tapped.
  final VoidCallback onPlanTripTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPlanTripTap,
      child: Container(
        width: 160.w,
        margin: EdgeInsets.only(right: 16.w),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2196F3),
              Color(0xFF1976D2),
            ],
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2196F3).withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Iconsax.map,
                size: 24.r,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Plan a Trip',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Find optimal charging stops',
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Text(
                  'Start',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Iconsax.arrow_right_3,
                  size: 14.r,
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

