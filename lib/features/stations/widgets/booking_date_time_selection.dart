/// File: lib/features/stations/widgets/booking_date_time_selection.dart
/// Purpose: Booking date time selection widget
/// Belongs To: stations feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';

/// Booking date and time selection widget.
class BookingDateTimeSelection extends StatelessWidget {
  const BookingDateTimeSelection({
    required this.selectedDate, required this.selectedTime, required this.onDateChanged, required this.onTimeChanged, super.key,
  });

  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<TimeOfDay> onTimeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.selectTimeSlot, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(child: _buildDateBox(context)),
            SizedBox(width: 12.w),
            Expanded(child: _buildTimeBox(context)),
          ],
        ),
      ],
    );
  }

  Widget _buildDateBox(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 30)),
        );
        if (date != null) {
          onDateChanged(date);
        }
      },
      child: _SelectionBox(
        icon: Iconsax.calendar_1,
        label: '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
      ),
    );
  }

  Widget _buildTimeBox(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final time = await showTimePicker(context: context, initialTime: selectedTime);
        if (time != null) {
          onTimeChanged(time);
        }
      },
      child: _SelectionBox(icon: Iconsax.clock, label: selectedTime.format(context)),
    );
  }
}

class _SelectionBox extends StatelessWidget {
  const _SelectionBox({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.outlineLight),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20.r, color: AppColors.primary),
          SizedBox(width: 12.w),
          Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

