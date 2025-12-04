/// File: lib/widgets/station_card.dart
/// Purpose: Reusable station card widget for displaying charging stations
/// Belongs To: shared
/// Customization Guide:
///    - Customize via parameters (compact, showDistance, etc.)
///    - Used in station lists and nearby stations

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax/iconsax.dart';

import '../core/theme/app_colors.dart';
import '../models/station_model.dart';

/// Station card widget for displaying charging station info.
class StationCard extends StatelessWidget {
  const StationCard({
    super.key,
    required this.station,
    required this.onTap,
    this.onFavoriteTap,
    this.compact = false,
    this.showDistance = true,
    this.showRating = true,
    this.showAvailability = true,
  });
  
  final StationModel station;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteTap;
  final bool compact;
  final bool showDistance;
  final bool showRating;
  final bool showAvailability;
  
  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompactCard(context);
    }
    return _buildFullCard(context);
  }
  
  Widget _buildFullCard(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.outlineLight, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                  child: CachedNetworkImage(
                    imageUrl: station.imageUrl ?? '',
                    height: 140.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.outlineLight,
                      child: Center(
                        child: Icon(
                          Iconsax.image,
                          size: 32.r,
                          color: AppColors.textTertiaryLight,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.outlineLight,
                      child: Center(
                        child: Icon(
                          Iconsax.image,
                          size: 32.r,
                          color: AppColors.textTertiaryLight,
                        ),
                      ),
                    ),
                  ),
                ),
                // Favorite button
                if (onFavoriteTap != null)
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: GestureDetector(
                      onTap: onFavoriteTap,
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowLight,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          station.isFavorite ? Iconsax.heart5 : Iconsax.heart,
                          size: 20.r,
                          color: station.isFavorite ? AppColors.error : AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                  ),
                // Distance badge
                if (showDistance && station.distance != null)
                  Positioned(
                    bottom: 8.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Iconsax.location,
                            size: 12.r,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${station.distance!.toStringAsFixed(1)} km',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            // Content
            Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Iconsax.location,
                        size: 14.r,
                        color: AppColors.textSecondaryLight,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          station.address,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondaryLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      // Rating
                      if (showRating) ...[
                        Icon(
                          Iconsax.star1,
                          size: 14.r,
                          color: AppColors.ratingActive,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          station.rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimaryLight,
                          ),
                        ),
                        Text(
                          ' (${station.reviewCount})',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                        SizedBox(width: 12.w),
                      ],
                      // Availability
                      if (showAvailability) ...[
                        Container(
                          width: 8.r,
                          height: 8.r,
                          decoration: BoxDecoration(
                            color: station.hasAvailableChargers 
                                ? AppColors.available 
                                : AppColors.occupied,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${station.availableChargers}/${station.totalChargers}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: station.hasAvailableChargers 
                                ? AppColors.available 
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                      const Spacer(),
                      // Price
                      Text(
                        '\$${station.pricePerKwh.toStringAsFixed(2)}/kWh',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCompactCard(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.outlineLight, width: 1),
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CachedNetworkImage(
                imageUrl: station.imageUrl ?? '',
                width: 72.w,
                height: 72.h,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.outlineLight,
                  child: Icon(
                    Iconsax.image,
                    size: 24.r,
                    color: AppColors.textTertiaryLight,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.outlineLight,
                  child: Icon(
                    Iconsax.image,
                    size: 24.r,
                    color: AppColors.textTertiaryLight,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    station.address,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondaryLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      if (showRating) ...[
                        Icon(
                          Iconsax.star1,
                          size: 12.r,
                          color: AppColors.ratingActive,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          station.rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8.w),
                      ],
                      if (showDistance && station.distance != null) ...[
                        Icon(
                          Iconsax.location,
                          size: 12.r,
                          color: AppColors.textSecondaryLight,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '${station.distance!.toStringAsFixed(1)} km',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Favorite and Price
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (onFavoriteTap != null)
                  GestureDetector(
                    onTap: onFavoriteTap,
                    child: Icon(
                      station.isFavorite ? Iconsax.heart5 : Iconsax.heart,
                      size: 20.r,
                      color: station.isFavorite ? AppColors.error : AppColors.textSecondaryLight,
                    ),
                  ),
                if (onFavoriteTap != null) SizedBox(height: 8.h),
                Text(
                  '\$${station.pricePerKwh.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  '/kWh',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

