/// File: lib/features/stations/widgets/station_amenities.dart
/// Purpose: Station amenities widget
/// Belongs To: stations feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/station_model.dart';

/// Station amenities widget showing available amenities.
class StationAmenities extends StatelessWidget {
  const StationAmenities({required this.amenities, super.key});

  final List<Amenity> amenities;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.amenities, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: amenities.map((amenity) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariantLight,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_getAmenityIcon(amenity), size: 16.r),
                  SizedBox(width: 6.w),
                  Text(amenity.name.toUpperCase(), style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500)),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  IconData _getAmenityIcon(Amenity amenity) {
    switch (amenity) {
      case Amenity.wifi:
        return Iconsax.wifi;
      case Amenity.restroom:
        return Icons.wc_rounded;
      case Amenity.cafe:
        return Iconsax.coffee;
      case Amenity.restaurant:
        return Iconsax.reserve;
      case Amenity.parking:
        return Icons.local_parking_rounded;
      case Amenity.shopping:
        return Iconsax.shopping_bag;
      case Amenity.lounge:
        return Iconsax.home_2;
      case Amenity.playground:
        return Icons.child_care_rounded;
    }
  }
}

