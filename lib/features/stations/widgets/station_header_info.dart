/// File: lib/features/stations/widgets/station_header_info.dart
/// Purpose: Station header info widget
/// Belongs To: stations feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../models/station_model.dart';

/// Station header with name, address, rating, and price.
class StationHeaderInfo extends StatelessWidget {
  const StationHeaderInfo({super.key, required this.station});

  final StationModel station;

  @override
  Widget build(BuildContext context) {
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
                  color: AppColors.textPrimaryLight,
                ),
              ),
            ),
            _buildStatusBadge(),
          ],
        ),
        SizedBox(height: 8.h),
        _buildAddress(),
        SizedBox(height: 12.h),
        _buildRatingAndPrice(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: station.hasAvailableChargers ? AppColors.successContainer : AppColors.warningContainer,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        station.hasAvailableChargers ? AppStrings.available : AppStrings.occupied,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: station.hasAvailableChargers ? AppColors.success : AppColors.warning,
        ),
      ),
    );
  }

  Widget _buildAddress() {
    return Row(
      children: [
        Icon(Iconsax.location, size: 16.r, color: AppColors.textSecondaryLight),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            station.address,
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondaryLight),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingAndPrice() {
    return Row(
      children: [
        Icon(Iconsax.star1, size: 18.r, color: AppColors.ratingActive),
        SizedBox(width: 4.w),
        Text(
          station.rating.toStringAsFixed(1),
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
        ),
        Text(
          ' (${station.reviewCount} reviews)',
          style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondaryLight),
        ),
        const Spacer(),
        Text(
          '\$${station.pricePerKwh.toStringAsFixed(2)}/kWh',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: AppColors.primary),
        ),
      ],
    );
  }
}

