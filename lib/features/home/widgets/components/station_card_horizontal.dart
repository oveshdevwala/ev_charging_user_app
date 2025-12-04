/// File: lib/features/home/widgets/components/station_card_horizontal.dart
/// Purpose: Horizontal station card for nearby stations slider
/// Belongs To: home feature
/// Customization Guide:
///    - Used in horizontal scrolling list
///    - Shows key info: name, distance, price, availability
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../models/station_model.dart';

/// Horizontal station card for carousel display.
class StationCardHorizontal extends StatelessWidget {
  const StationCardHorizontal({
    required this.station,
    required this.onTap,
    super.key,
    this.onFavoriteTap,
    this.width,
  });

  /// Station data.
  final StationModel station;

  /// Callback when card is tapped.
  final VoidCallback onTap;

  /// Callback when favorite button is tapped.
  final VoidCallback? onFavoriteTap;

  /// Card width.
  final double? width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 280.w,
        margin: EdgeInsets.only(right: 16.w),
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
          children: [
            // Image with overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.r),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: station.imageUrl ?? '',
                    height: 120.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 120.h,
                      color: AppColors.surfaceVariantLight,
                      child: Center(
                        child: Icon(
                          Iconsax.image,
                          size: 32.r,
                          color: AppColors.textTertiaryLight,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 120.h,
                      color: AppColors.surfaceVariantLight,
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
                    top: 10.h,
                    right: 10.w,
                    child: GestureDetector(
                      onTap: onFavoriteTap,
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowMedium,
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Icon(
                          station.isFavorite ? Iconsax.heart5 : Iconsax.heart,
                          size: 18.r,
                          color: station.isFavorite
                              ? AppColors.error
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                  ),

                // Distance badge
                if (station.distance != null)
                  Positioned(
                    bottom: 10.h,
                    left: 10.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
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
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Availability badge
                Positioned(
                  bottom: 10.h,
                  right: 10.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: station.hasAvailableChargers
                          ? AppColors.available
                          : AppColors.occupied,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      '${station.availableChargers}/${station.totalChargers} open',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(14.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station.name,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(
                        Iconsax.location,
                        size: 12.r,
                        color: AppColors.textSecondaryLight,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          station.address,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textSecondaryLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      // Rating
                      Icon(
                        Iconsax.star1,
                        size: 14.r,
                        color: AppColors.ratingActive,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        station.rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryLight,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '(${station.reviewCount})',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textTertiaryLight,
                        ),
                      ),
                      const Spacer(),
                      // Power
                      if (station.chargers.isNotEmpty) ...[
                        Icon(
                          Iconsax.flash_1,
                          size: 12.r,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          '${station.chargers.map((c) => c.power).reduce((a, b) => a > b ? a : b).toInt()} kW',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                        SizedBox(width: 10.w),
                      ],
                      // Price
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
          ],
        ),
      ),
    );
  }
}
