/// File: lib/features/bookings/ui/booking_details_page.dart
/// Purpose: Booking details view
/// Belongs To: bookings feature
/// Route: /bookingDetails/:id
library;

import 'package:ev_charging_user_app/core/extensions/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/date_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/booking_model.dart';
import '../../../repositories/booking_repository.dart';
import '../../../widgets/app_app_bar.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/loading_wrapper.dart';

/// Booking details page showing full booking information.
class BookingDetailsPage extends StatefulWidget {
  const BookingDetailsPage({required this.bookingId, super.key});

  final String bookingId;

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  final _bookingRepository = DummyBookingRepository();
  BookingModel? _booking;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBooking();
  }

  Future<void> _loadBooking() async {
    final booking = await _bookingRepository.getBookingById(widget.bookingId);
    if (mounted) {
      setState(() {
        _booking = booking;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: const AppAppBar(title: AppStrings.bookingDetails),
      body: LoadingWrapper(
        isLoading: _isLoading,
        error: _booking == null && !_isLoading ? 'Booking not found' : null,
        child: _booking != null ? _buildContent(context) : const SizedBox(),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final colors = context.appColors;

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Column(
        children: [
          _buildStatusCard(context),
          SizedBox(height: 20.h),
          _buildDetailsCard(context),
          SizedBox(height: 20.h),
          _buildPaymentCard(context),
          SizedBox(height: 32.h),
          if (_booking!.isUpcoming)
            CommonButton(
              label: AppStrings.cancelBooking,
              variant: ButtonVariant.outlined,
              foregroundColor: colors.danger,
              borderColor: colors.danger,
              onPressed: _onCancelPressed,
            ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    final colors = context.appColors;
    final color = _getStatusColor(context, _booking!.status);

    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Icon(_getStatusIcon(_booking!.status), size: 56.r, color: color),
          SizedBox(height: 16.h),
          Text(
            _getStatusText(_booking!.status),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          if (_booking!.status == BookingStatus.confirmed) ...[
            SizedBox(height: 8.h),
            Text(
              'Starts at ${_booking!.startTime.formattedTime}',
              style: TextStyle(fontSize: 14.sp, color: colors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Details',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          _buildDetailRow(
            context,
            Iconsax.flash_1,
            'Station',
            _booking!.stationName ?? '-',
          ),
          _buildDetailRow(
            context,
            Iconsax.cpu,
            'Charger',
            _booking!.chargerName ?? '-',
          ),
          _buildDetailRow(
            context,
            Iconsax.calendar_1,
            'Date',
            _booking!.startTime.formatted,
          ),
          _buildDetailRow(
            context,
            Iconsax.clock,
            'Time',
            '${_booking!.startTime.formattedTime} - ${_booking!.endTime?.formattedTime}',
          ),
          _buildDetailRow(
            context,
            Iconsax.timer_1,
            'Duration',
            '${_booking!.durationDisplay} minutes',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final colors = context.appColors;

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Icon(icon, size: 20.r, color: colors.textSecondary),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: colors.textSecondary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Cost',
                style: TextStyle(fontSize: 14.sp, color: colors.textSecondary),
              ),
              Text(
                '\$${_booking!.actualCost?.toStringAsFixed(2) ?? '0.00'}',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(BuildContext context, BookingStatus status) {
    final colors = context.appColors;

    switch (status) {
      case BookingStatus.confirmed:
        return colors.success;
      case BookingStatus.cancelled:
        return colors.danger;
      case BookingStatus.completed:
        return colors.primary;
      case BookingStatus.pending:
        return colors.warning;
      case BookingStatus.inProgress:
        return colors.primary;
      case BookingStatus.failed:
        return colors.danger;
    }
  }

  IconData _getStatusIcon(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return Iconsax.tick_circle;
      case BookingStatus.cancelled:
        return Iconsax.close_circle;
      case BookingStatus.completed:
        return Iconsax.tick_circle;
      case BookingStatus.pending:
        return Iconsax.clock;
      case BookingStatus.inProgress:
        return Iconsax.flash_1;
      case BookingStatus.failed:
        return Iconsax.danger;
    }
  }

  String _getStatusText(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.failed:
        return 'Failed';
    }
  }

  void _onCancelPressed() {
    // TODO: Implement cancel booking
  }
}
