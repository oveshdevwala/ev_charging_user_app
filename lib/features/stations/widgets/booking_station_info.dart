/// File: lib/features/stations/widgets/booking_station_info.dart
/// Purpose: Booking station info widget
/// Belongs To: stations feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/station_model.dart';

/// Booking station info card.
class BookingStationInfo extends StatelessWidget {
  const BookingStationInfo({required this.station, super.key});

  final StationModel station;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariantLight,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            width: 56.r,
            height: 56.r,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Iconsax.flash_1, color: AppColors.primary, size: 28.r),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(station.name, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                Text(
                  station.address,
                  style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondaryLight),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

