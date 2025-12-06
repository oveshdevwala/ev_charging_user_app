/// File: lib/features/home/widgets/components/station_card_horizontal.dart
/// Purpose: Horizontal station card for nearby stations slider
/// Belongs To: home feature
/// Customization Guide:
///    - Used in horizontal scrolling list
///    - Shows key info: name, distance, price, availability
library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/extensions/context_ext.dart';
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
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 280.w,
        margin: EdgeInsets.only(right: 16.w),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: colors.outline),
          boxShadow: [
            BoxShadow(
              color: colors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
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
                  child: _buildStationImage(
                    context,
                    station.imageUrl,
                    height: 120.h,
                    width: double.infinity,
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
                        decoration: BoxDecoration(
                          color: colors.surface,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: colors.shadow, blurRadius: 6),
                          ],
                        ),
                        child: Icon(
                          station.isFavorite ? Iconsax.heart5 : Iconsax.heart,
                          size: 18.r,
                          color: station.isFavorite
                              ? colors.danger
                              : colors.textSecondary,
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
                        color: colors.scrim,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Iconsax.location,
                            size: 12.r,
                            color: colors.textPrimary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${station.distance!.toStringAsFixed(1)} km',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
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
                          ? colors.success
                          : colors.warning,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      '${station.availableChargers}/${station.totalChargers} open',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
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
                      color: colors.textPrimary,
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
                        color: colors.textSecondary,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          station.address,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: colors.textSecondary,
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
                        color: colors.warning,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        station.rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '(${station.reviewCount})',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: colors.textTertiary,
                        ),
                      ),
                      const Spacer(),
                      // Power
                      if (station.chargers.isNotEmpty) ...[
                        Icon(
                          Iconsax.flash_1,
                          size: 12.r,
                          color: colors.primary,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          '${station.chargers.map((c) => c.power).reduce((a, b) => a > b ? a : b).toInt()} kW',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.textSecondary,
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
                          color: colors.primary,
                        ),
                      ),
                      Text(
                        '/kWh',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: colors.textSecondary,
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

  /// Helper to build station image with proper null/empty URL handling.
  Widget _buildStationImage(
    BuildContext context,
    String? imageUrl, {
    double? width,
    double? height,
  }) {
    final colors = context.appColors;

    // Check if URL is valid (not null, not empty, starts with http)
    final isValidUrl =
        imageUrl != null &&
        imageUrl.isNotEmpty &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));

    if (!isValidUrl) {
      // Return placeholder for invalid URLs
      return Container(
        width: width,
        height: height,
        color: colors.surfaceVariant,
        child: Center(
          child: Icon(
            Iconsax.building_4,
            size: 32.r,
            color: colors.textTertiary,
          ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        color: colors.surfaceVariant,
        child: Center(
          child: SizedBox(
            width: 24.r,
            height: 24.r,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(colors.primary),
            ),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        color: colors.surfaceVariant,
        child: Center(
          child: Icon(Iconsax.image, size: 32.r, color: colors.textTertiary),
        ),
      ),
    );
  }
}
