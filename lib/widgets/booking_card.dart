/// File: lib/widgets/booking_card.dart
/// Purpose: Reusable booking card widget for displaying bookings
/// Belongs To: shared
/// Customization Guide:
///    - Customize via parameters (compact, showActions, etc.)
///    - Used in booking lists

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../core/theme/app_colors.dart';
import '../core/extensions/date_ext.dart';
import '../models/booking_model.dart';

/// Booking card widget for displaying booking info.
class BookingCard extends StatelessWidget {
  const BookingCard({
    super.key,
    required this.booking,
    required this.onTap,
    this.onCancelTap,
    this.compact = false,
    this.showActions = true,
  });
  
  final BookingModel booking;
  final VoidCallback onTap;
  final VoidCallback? onCancelTap;
  final bool compact;
  final bool showActions;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.outlineLight, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    _getStatusIcon(booking.status),
                    size: 24.r,
                    color: _getStatusColor(booking.status),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.stationName ?? 'Charging Station',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        booking.chargerName ?? 'Charger',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(booking.status),
              ],
            ),
            
            SizedBox(height: 16.h),
            
            // Details
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariantLight,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildDetailItem(
                      icon: Iconsax.calendar_1,
                      label: 'Date',
                      value: booking.startTime.formatted,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40.h,
                    color: AppColors.outlineLight,
                  ),
                  Expanded(
                    child: _buildDetailItem(
                      icon: Iconsax.clock,
                      label: 'Time',
                      value: booking.startTime.formattedTime,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40.h,
                    color: AppColors.outlineLight,
                  ),
                  Expanded(
                    child: _buildDetailItem(
                      icon: Iconsax.timer_1,
                      label: 'Duration',
                      value: booking.durationDisplay,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 16.h),
            
            // Footer
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Cost',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                    Text(
                      booking.costDisplay,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                if (showActions && booking.isUpcoming && onCancelTap != null)
                  TextButton(
                    onPressed: onCancelTap,
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Details',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 18.r,
          color: AppColors.textSecondaryLight,
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: AppColors.textSecondaryLight,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryLight,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  
  Widget _buildStatusBadge(BookingStatus status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        _getStatusText(status),
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: _getStatusColor(status),
        ),
      ),
    );
  }
  
  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return AppColors.warning;
      case BookingStatus.confirmed:
        return AppColors.info;
      case BookingStatus.inProgress:
        return AppColors.charging;
      case BookingStatus.completed:
        return AppColors.success;
      case BookingStatus.cancelled:
        return AppColors.error;
      case BookingStatus.failed:
        return AppColors.error;
    }
  }
  
  IconData _getStatusIcon(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Iconsax.clock;
      case BookingStatus.confirmed:
        return Iconsax.tick_circle;
      case BookingStatus.inProgress:
        return Iconsax.flash_1;
      case BookingStatus.completed:
        return Iconsax.tick_circle;
      case BookingStatus.cancelled:
        return Iconsax.close_circle;
      case BookingStatus.failed:
        return Iconsax.danger;
    }
  }
  
  String _getStatusText(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.inProgress:
        return 'Charging';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.failed:
        return 'Failed';
    }
  }
}

