/// File: lib/features/stations/widgets/station_header_info.dart
/// Purpose: Station header info widget
/// Belongs To: stations feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/station_model.dart';

/// Station header with name, address, rating, and price.
class StationHeaderInfo extends StatelessWidget {
  const StationHeaderInfo({required this.station, super.key, this.onRatingTap});

  final StationModel station;
  final VoidCallback? onRatingTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                station.name,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
            ),
            _buildStatusBadge(context),
          ],
        ),
        SizedBox(height: 8.h),
        _buildAddress(context),
        SizedBox(height: 12.h),
        _buildRatingAndPrice(context),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: station.hasAvailableChargers
            ? colors.successContainer
            : colors.warningContainer,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        station.hasAvailableChargers
            ? AppStrings.available
            : AppStrings.occupied,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: station.hasAvailableChargers ? colors.success : colors.warning,
        ),
      ),
    );
  }

  Widget _buildAddress(BuildContext context) {
    final colors = context.appColors;

    return Row(
      children: [
        Icon(Iconsax.location, size: 16.r, color: colors.textSecondary),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            station.address,
            style: TextStyle(fontSize: 14.sp, color: colors.textSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingAndPrice(BuildContext context) {
    final colors = context.appColors;

    return Row(
      children: [
        GestureDetector(
          onTap: onRatingTap,
          behavior: HitTestBehavior.opaque,
          child: Row(
            children: [
              Icon(Iconsax.star1, size: 18.r, color: colors.warning),
              SizedBox(width: 4.w),
              Text(
                station.rating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              Text(
                ' (${station.reviewCount} ${AppStrings.reviews.toLowerCase()})',
                style: TextStyle(fontSize: 14.sp, color: colors.textSecondary),
              ),
              if (onRatingTap != null) ...[
                SizedBox(width: 4.w),
                Icon(
                  Iconsax.arrow_right_3,
                  size: 14.r,
                  color: colors.textSecondary,
                ),
              ],
            ],
          ),
        ),
        const Spacer(),
        Text(
          '\$${station.pricePerKwh.toStringAsFixed(2)}/kWh',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: colors.primary,
          ),
        ),
      ],
    );
  }
}
