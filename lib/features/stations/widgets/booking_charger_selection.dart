/// File: lib/features/stations/widgets/booking_charger_selection.dart
/// Purpose: Booking charger selection widget
/// Belongs To: stations feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../models/charger_model.dart';

/// Booking charger selection widget.
class BookingChargerSelection extends StatelessWidget {
  const BookingChargerSelection({
    super.key,
    required this.chargers,
    required this.selectedCharger,
    required this.onSelected,
  });

  final List<ChargerModel> chargers;
  final ChargerModel? selectedCharger;
  final ValueChanged<ChargerModel> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.selectCharger, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
        SizedBox(height: 12.h),
        ...chargers.map((charger) {
          final isSelected = selectedCharger?.id == charger.id;
          return GestureDetector(
            onTap: charger.isAvailable ? () => onSelected(charger) : null,
            child: Container(
              margin: EdgeInsets.only(bottom: 8.h),
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryContainer : Colors.white,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.outlineLight,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(Iconsax.flash_1, color: isSelected ? AppColors.primary : AppColors.textSecondaryLight),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(charger.name, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                        Text(
                          '${charger.typeDisplayName} • ${charger.powerDisplay}',
                          style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondaryLight),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: charger.isAvailable ? AppColors.successContainer : AppColors.surfaceVariantLight,
                      borderRadius: BorderRadius.circular(12.r),
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
            ),
          );
        }),
      ],
    );
  }
}

