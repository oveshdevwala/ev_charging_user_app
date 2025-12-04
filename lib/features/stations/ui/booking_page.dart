/// File: lib/features/stations/ui/booking_page.dart
/// Purpose: Booking creation screen with BLoC state management
/// Belongs To: stations feature
/// Route: /booking/:stationId
/// Customization Guide:
///    - Add payment integration
///    - Customize booking flow steps
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../repositories/station_repository.dart';
import '../../../widgets/app_app_bar.dart';
import '../../../widgets/common_button.dart';
import '../bloc/bloc.dart';
import '../widgets/booking_charger_selection.dart';
import '../widgets/booking_date_time_selection.dart';
import '../widgets/booking_duration_selection.dart';
import '../widgets/booking_station_info.dart';

/// Booking page for creating charging reservations.
/// Uses BLoC pattern for state management.
class BookingPage extends StatelessWidget {
  const BookingPage({required this.stationId, super.key});

  final String stationId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BookingCubit(stationRepository: DummyStationRepository())
            ..loadStation(stationId),
      child: const _BookingPageContent(),
    );
  }
}

/// Booking page content with BLoC consumer.
class _BookingPageContent extends StatelessWidget {
  const _BookingPageContent();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingCubit, BookingState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status || prev.error != curr.error,
      listener: (context, state) {
        // Handle success
        if (state.isSuccess) {
          _showSuccessDialog(context, state.bookingId ?? '');
        }

        // Handle error
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.read<BookingCubit>().clearError();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: const AppAppBar(title: 'Book Charger'),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, BookingState state) {
    switch (state.status) {
      case BookingPageStatus.initial:
      case BookingPageStatus.loading:
        return const _LoadingView();

      case BookingPageStatus.stationNotFound:
        return const _StationNotFoundView();

      case BookingPageStatus.loaded:
      case BookingPageStatus.submitting:
      case BookingPageStatus.success:
      case BookingPageStatus.error:
        return _BookingFormView(state: state);
    }
  }

  void _showSuccessDialog(BuildContext context, String bookingId) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.tick_circle5,
                color: Colors.white,
                size: 24.r,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              AppStrings.bookingSuccessful,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your charging session has been booked successfully!',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondaryLight,
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariantLight,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(Iconsax.receipt_1, size: 20.r, color: AppColors.primary),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Booking ID',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textTertiaryLight,
                          ),
                        ),
                        Text(
                          bookingId,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.pop();
            },
            child: Text(
              'View Bookings',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondaryLight,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Done',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Loading view widget.
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: 16.h),
          Text(
            'Loading station...',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

/// Station not found view widget.
class _StationNotFoundView extends StatelessWidget {
  const _StationNotFoundView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.r,
              height: 80.r,
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.warning_2,
                size: 40.r,
                color: AppColors.warning,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Station Not Available',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimaryLight,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'This charging station is not currently available for booking. Please try another station.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondaryLight,
              ),
            ),
            SizedBox(height: 32.h),
            CommonButton(
              label: 'Go Back',
              onPressed: () => context.pop(),
              icon: Iconsax.arrow_left_2,
            ),
          ],
        ),
      ),
    );
  }
}

/// Booking form view widget.
class _BookingFormView extends StatelessWidget {
  const _BookingFormView({required this.state});

  final BookingState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BookingCubit>();

    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Station info
              if (state.station != null)
                BookingStationInfo(station: state.station!),
              SizedBox(height: 24.h),

              // Charger selection
              if (state.station != null)
                BookingChargerSelection(
                  chargers: state.station!.chargers,
                  selectedCharger: state.selectedCharger,
                  onSelected: cubit.selectCharger,
                ),
              SizedBox(height: 24.h),

              // Date & time selection
              BookingDateTimeSelection(
                selectedDate: state.selectedDate ?? DateTime.now(),
                selectedTime: state.selectedTime ?? TimeOfDay.now(),
                onDateChanged: cubit.setDate,
                onTimeChanged: cubit.setTime,
              ),
              SizedBox(height: 24.h),

              // Duration selection
              BookingDurationSelection(
                selectedDuration: state.duration,
                onDurationChanged: cubit.setDuration,
              ),
              SizedBox(height: 24.h),

              // Booking summary
              _buildEnhancedSummary(context, state),
              SizedBox(height: 32.h),

              // Book button
              CommonButton(
                label: state.isSubmitting ? 'Booking...' : AppStrings.bookNow,
                onPressed: state.isSubmitting ? null : cubit.submitBooking,
                isLoading: state.isSubmitting,
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),

        // Loading overlay during submission
        if (state.isSubmitting)
          ColoredBox(
            color: Colors.black.withValues(alpha: 0.3),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(24.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: AppColors.primary),
                    SizedBox(height: 16.h),
                    Text(
                      'Processing your booking...',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEnhancedSummary(BuildContext context, BookingState state) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.secondary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Summary',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimaryLight,
            ),
          ),
          SizedBox(height: 16.h),
          _buildSummaryRow(
            'Charger',
            state.selectedCharger?.name ?? '-',
            Iconsax.flash_1,
          ),
          _buildSummaryRow(
            'Power',
            '${state.selectedCharger?.power.toStringAsFixed(0) ?? '-'} kW',
            Iconsax.electricity,
          ),
          _buildSummaryRow(
            'Duration',
            '${state.duration} min',
            Iconsax.timer_1,
          ),
          _buildSummaryRow(
            'Date & Time',
            state.formattedBookingTime,
            Iconsax.calendar,
          ),
          _buildSummaryRow(
            'Est. Energy',
            '${state.estimatedEnergy.toStringAsFixed(1)} kWh',
            Iconsax.battery_charging,
          ),
          Divider(color: AppColors.outlineLight, height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Estimated Cost',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              Text(
                '\$${state.estimatedCost.toStringAsFixed(2)}',
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

  Widget _buildSummaryRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Icon(icon, size: 18.r, color: AppColors.textSecondaryLight),
          SizedBox(width: 10.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textSecondaryLight,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
