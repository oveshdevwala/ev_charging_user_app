/// File: lib/features/stations/widgets/booking_duration_selection.dart
/// Purpose: Booking duration selection widget
/// Belongs To: stations feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';

/// Booking duration selection widget.
class BookingDurationSelection extends StatelessWidget {
  const BookingDurationSelection({
    super.key,
    required this.selectedDuration,
    required this.onDurationChanged,
  });

  final int selectedDuration;
  final ValueChanged<int> onDurationChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Duration', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
        SizedBox(height: 12.h),
        Row(
          children: [30, 60, 90, 120].map((mins) {
            final isSelected = selectedDuration == mins;
            return Expanded(
              child: GestureDetector(
                onTap: () => onDurationChanged(mins),
                child: Container(
                  margin: EdgeInsets.only(right: mins != 120 ? 8.w : 0),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    border: Border.all(color: isSelected ? AppColors.primary : AppColors.outlineLight),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Text(
                      _formatDuration(mins),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.textPrimaryLight,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _formatDuration(int mins) {
    if (mins < 60) return '$mins min';
    final hours = mins ~/ 60;
    final remainder = mins % 60;
    return remainder > 0 ? '${hours}h ${remainder}m' : '${hours}h';
  }
}

