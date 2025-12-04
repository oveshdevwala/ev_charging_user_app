/// File: lib/features/stations/widgets/station_charger_list.dart
/// Purpose: Station charger list widget
/// Belongs To: stations feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/charger_model.dart';

/// Station charger list showing available chargers.
class StationChargerList extends StatelessWidget {
  const StationChargerList({required this.chargers, super.key});

  final List<ChargerModel> chargers;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.chargerTypes, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
        SizedBox(height: 12.h),
        ...chargers.map(_buildChargerItem),
      ],
    );
  }

  Widget _buildChargerItem(ChargerModel charger) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.outlineLight),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: charger.isAvailable ? AppColors.successContainer : AppColors.surfaceVariantLight,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Iconsax.flash_1,
              size: 24.r,
              color: charger.isAvailable ? AppColors.success : AppColors.textSecondaryLight,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(charger.name, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                Text(
                  '${charger.typeDisplayName} • ${charger.powerDisplay}',
                  style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondaryLight),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: charger.isAvailable ? AppColors.successContainer : AppColors.surfaceVariantLight,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              charger.isAvailable ? 'Available' : 'In Use',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: charger.isAvailable ? AppColors.success : AppColors.textSecondaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

