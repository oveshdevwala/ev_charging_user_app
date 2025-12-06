/// File: lib/features/stations/widgets/booking_charger_selection.dart
/// Purpose: Booking charger selection widget
/// Belongs To: stations feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../models/charger_model.dart';

/// Booking charger selection widget.
class BookingChargerSelection extends StatelessWidget {
  const BookingChargerSelection({
    required this.chargers,
    required this.selectedCharger,
    required this.onSelected,
    super.key,
  });

  final List<ChargerModel> chargers;
  final ChargerModel? selectedCharger;
  final ValueChanged<ChargerModel> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.selectCharger,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: colors.textPrimary),
        ),
        SizedBox(height: 12.h),
        ...chargers.map((charger) {
          final isSelected = selectedCharger?.id == charger.id;
          return GestureDetector(
            onTap: charger.isAvailable ? () => onSelected(charger) : null,
            child: Container(
              margin: EdgeInsets.only(bottom: 8.h),
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: isSelected
                    ? colors.primaryContainer
                    : colors.surface,
                border: Border.all(
                  color: isSelected
                      ? colors.primary
                      : colors.outline,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Iconsax.flash_1,
                    color: isSelected
                        ? colors.primary
                        : colors.textSecondary,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          charger.name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                        ),
                        Text(
                          '${charger.typeDisplayName} • ${charger.powerDisplay}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: charger.isAvailable
                          ? colors.successContainer
                          : colors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      charger.isAvailable ? 'Available' : 'In Use',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: charger.isAvailable
                            ? colors.success
                            : colors.textSecondary,
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
