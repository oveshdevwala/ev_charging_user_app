/// File: lib/features/bookings/ui/booking_details_page.dart
/// Purpose: Booking details view
/// Belongs To: bookings feature
/// Route: /bookingDetails/:id
library;

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
    return Scaffold(
      appBar: const AppAppBar(title: AppStrings.bookingDetails),
      body: LoadingWrapper(
        isLoading: _isLoading,
        error: _booking == null && !_isLoading ? 'Booking not found' : null,
        child: _booking != null ? _buildContent() : const SizedBox(),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Column(
        children: [
          _buildStatusCard(),
          SizedBox(height: 20.h),
          _buildDetailsCard(),
          SizedBox(height: 20.h),
          _buildPaymentCard(),
          SizedBox(height: 32.h),
          if (_booking!.isUpcoming)
            CommonButton(
              label: AppStrings.cancelBooking,
              variant: ButtonVariant.outlined,
              foregroundColor: AppColors.error,
              borderColor: AppColors.error,
              onPressed: _onCancelPressed,
            ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    final color = _getStatusColor(_booking!.status);
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
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondaryLight,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.outlineLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Details',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16.h),
          _buildDetailRow(
            Iconsax.flash_1,
            'Station',
            _booking!.stationName ?? '-',
          ),
          _buildDetailRow(Iconsax.cpu, 'Charger', _booking!.chargerName ?? '-'),
          _buildDetailRow(
            Iconsax.calendar_1,
            'Date',
            _booking!.startTime.formatted,
          ),
          _buildDetailRow(
            Iconsax.clock,
            'Time',
            _booking!.startTime.formattedTime,
          ),
          _buildDetailRow(
            Iconsax.timer_1,
            'Duration',
            _booking!.durationDisplay,
          ),
          if (_booking!.energyDelivered != null)
            _buildDetailRow(
              Iconsax.battery_charging,
              'Energy',
              '${_booking!.energyDelivered!.toStringAsFixed(1)} kWh',
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.outlineLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16.h),
          _buildPaymentRow(
            'Estimated Cost',
            '\$${_booking!.estimatedCost.toStringAsFixed(2)}',
          ),
          if (_booking!.actualCost != null)
            _buildPaymentRow(
              'Actual Cost',
              '\$${_booking!.actualCost!.toStringAsFixed(2)}',
            ),
          Divider(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
              Text(
                _booking!.costDisplay,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(icon, size: 20.r, color: AppColors.textSecondaryLight),
          SizedBox(width: 12.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondaryLight,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondaryLight,
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
        ],
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
      case BookingStatus.failed:
        return Iconsax.close_circle;
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

  void _onCancelPressed() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _bookingRepository.cancelBooking(_booking!.id);
             await _loadBooking();
            },
            child: const Text('Yes', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
