/// File: lib/features/trip_planner/ui/charging_stops_page.dart
/// Purpose: Charging stops list screen with full timeline and booking integration
/// Belongs To: trip_planner feature
/// Route: AppRoutes.chargingStops
/// Customization Guide:
///    - Add filtering options
///    - Add station availability refresh
// ignore_for_file: avoid_positional_boolean_parameters

library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../widgets/app_app_bar.dart';
import '../../../widgets/common_button.dart';
import '../bloc/bloc.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

/// Charging stops page with expandable cards and booking flow.
class ChargingStopsPage extends StatefulWidget {
  const ChargingStopsPage({super.key});

  @override
  State<ChargingStopsPage> createState() => _ChargingStopsPageState();
}

class _ChargingStopsPageState extends State<ChargingStopsPage> {
  // Track which stops are expanded
  final Set<int> _expandedStops = {};

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripPlannerCubit, TripPlannerState>(
      builder: (context, state) {
        final trip = state.currentTrip;
        if (trip == null) {
          return const Scaffold(body: Center(child: Text('No trip data')));
        }

        final stops = trip.chargingStops;

        return Scaffold(
          appBar: AppAppBar(
            title: 'Charging Stops',
            onBackPressed: () => context.read<TripPlannerCubit>().goToSummary(),
            actions: [
              // Expand/collapse all button
              IconButton(
                icon: Icon(
                  _expandedStops.length == stops.length
                      ? Iconsax.arrow_up_2
                      : Iconsax.arrow_down_1,
                  size: 22.r,
                ),
                onPressed: () {
                  setState(() {
                    if (_expandedStops.length == stops.length) {
                      _expandedStops.clear();
                    } else {
                      _expandedStops.addAll(
                        List.generate(stops.length, (i) => i),
                      );
                    }
                  });
                },
              ),
            ],
          ),
          body: stops.isEmpty
              ? _buildEmptyState(context)
              : _buildContent(context, state),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, TripPlannerState state) {
    final trip = state.currentTrip!;
    final stops = trip.chargingStops;
    final estimates = trip.estimates;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary card
          _buildSummaryCard(context, stops, estimates),
          SizedBox(height: 24.h),
          // Title
          Row(
            children: [
              Text(
                '${stops.length} Charging Stops',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              const Spacer(),
              // Expand all hint
              Text(
                'Tap card to expand',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textTertiaryLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // === FULL TIMELINE ===
          _buildFullTimeline(context, trip, stops, estimates),

          SizedBox(height: 24.h),
          // Tips card
          _buildTipsCard(context),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  /// Builds the full timeline from start to destination with all stops.
  Widget _buildFullTimeline(
    BuildContext context,
    TripModel trip,
    List<ChargingStopModel> stops,
    TripEstimates? estimates,
  ) {
    return Column(
      children: [
        // === START LOCATION ===
        _buildTimelineLocationCard(
          context,
          isStart: true,
          title: 'Start',
          location: trip.origin.shortDisplay,
          subtitle: trip.departureTime != null
              ? 'Depart ${_formatTime(trip.departureTime!)}'
              : null,
          socPercent: trip.vehicle.currentSocPercent,
          showTopLine: false,
          showBottomLine: stops.isNotEmpty,
        ),

        // === CHARGING STOPS ===
        ...stops.asMap().entries.map((entry) {
          final index = entry.key;
          final stop = entry.value;
          final isLast = index == stops.length - 1;

          return Column(
            children: [
              // Driving segment info before this stop
              _buildDrivingSegment(
                context,
                distanceKm: stop.distanceFromPreviousKm,
                fromLabel: index == 0
                    ? trip.origin.shortDisplay
                    : stops[index - 1].stationName,
                toLabel: stop.stationName,
              ),
              // The charging stop card
              ChargingStopCard(
                stop: stop,
                initiallyExpanded: _expandedStops.contains(index),
                onNavigateTap: () => _openDirections(context, stop),
                onReserveTap: () => _openBookingFlow(context, stop),
                onDetailsTap: () => _showStopDetails(context, stop),
              ),
              // Connection line to next or destination
              if (!isLast)
                const SizedBox.shrink()
              else
                _buildDrivingSegment(
                  context,
                  distanceKm:
                      (estimates?.totalDistanceKm ?? 0) -
                      stop.distanceFromStartKm,
                  fromLabel: stop.stationName,
                  toLabel: trip.destination.shortDisplay,
                ),
            ],
          );
        }),

        // === DESTINATION ===
        _buildTimelineLocationCard(
          context,
          isStart: false,
          title: 'Destination',
          location: trip.destination.shortDisplay,
          subtitle: estimates?.eta != null
              ? 'Arrive ${_formatTime(estimates!.eta!)}'
              : null,
          socPercent: estimates?.arrivalSocPercent ?? 0,
          showTopLine: stops.isNotEmpty,
          showBottomLine: false,
        ),
      ],
    );
  }

  /// Timeline location card (Start/Destination).
  Widget _buildTimelineLocationCard(
    BuildContext context, {
    required bool isStart,
    required String title,
    required String location,
    required double socPercent,
    required bool showTopLine,
    required bool showBottomLine,
    String? subtitle,
  }) {
    final color = isStart ? AppColors.primary : AppColors.error;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        SizedBox(
          width: 52.w,
          child: Column(
            children: [
              if (showTopLine)
                Container(
                  width: 3,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    isStart ? Iconsax.location : Iconsax.flag,
                    size: 20.r,
                    color: Colors.white,
                  ),
                ),
              ),
              if (showBottomLine)
                Container(
                  width: 3,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
            ],
          ),
        ),
        // Card content
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: 8.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        location,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryLight,
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Battery indicator
                Column(
                  children: [
                    BatteryProgressIndicator(
                      socPercent: socPercent,
                      width: 45.w,
                      height: 20.h,
                      showLabel: false,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${socPercent.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: socPercent < 20 ? AppColors.warning : color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Driving segment between stops.
  Widget _buildDrivingSegment(
    BuildContext context, {
    required double distanceKm,
    required String fromLabel,
    required String toLabel,
  }) {
    return Row(
      children: [
        // Timeline line
        SizedBox(
          width: 52.w,
          child: Center(
            child: Container(
              width: 2,
              height: 36.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.4),
                    AppColors.primary.withValues(alpha: 0.2),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Distance info
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4.h),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariantLight,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Iconsax.routing_2,
                  size: 14.r,
                  color: AppColors.textTertiaryLight,
                ),
                SizedBox(width: 6.w),
                Text(
                  '${distanceKm.toStringAsFixed(0)} km drive',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    List<ChargingStopModel> stops,
    TripEstimates? estimates,
  ) {
    final totalChargingTime = estimates?.totalChargingTimeMin ?? 0;
    final totalCost = estimates?.estimatedCost ?? 0.0;
    final totalEnergy = stops.fold<double>(
      0,
      (sum, s) => sum + s.energyToChargeKwh,
    );

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
            Iconsax.timer_1,
            _formatDuration(totalChargingTime),
            'Charging',
          ),
          Container(width: 1, height: 40.h, color: AppColors.outlineLight),
          _buildSummaryItem(
            Iconsax.flash_1,
            '${totalEnergy.toStringAsFixed(0)} kWh',
            'Energy',
          ),
          Container(width: 1, height: 40.h, color: AppColors.outlineLight),
          _buildSummaryItem(
            Iconsax.dollar_circle,
            '\$${totalCost.toStringAsFixed(2)}',
            'Total Cost',
          ),
        ],
      ),
    );
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) {
      return '${minutes}m';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return mins > 0 ? '${hours}h ${mins}m' : '${hours}h';
  }

  Widget _buildSummaryItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 22.r, color: AppColors.primary),
        SizedBox(height: 6.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryLight,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
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
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.flash_15,
                size: 40.r,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'No Charging Stops Needed',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryLight,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Your vehicle has enough charge to complete this trip without stopping.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipsCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Iconsax.lamp_charge, size: 20.r, color: AppColors.info),
              SizedBox(width: 8.w),
              Text(
                'Pro Tips',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.info,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _buildTipItem('Reserve charging spots in advance for busy routes'),
          SizedBox(height: 8.h),
          _buildTipItem('Arrive with 10-20% battery for fastest charging'),
          SizedBox(height: 8.h),
          _buildTipItem('Charge to 80% for optimal speed and battery health'),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 5.r,
          height: 5.r,
          margin: EdgeInsets.only(top: 6.h, right: 10.w),
          decoration: const BoxDecoration(
            color: AppColors.info,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ),
      ],
    );
  }

  void _showStopDetails(BuildContext context, ChargingStopModel stop) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          padding: EdgeInsets.all(20.r),
          child: ListView(
            controller: controller,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.outlineLight,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              // Station header with view details button
              Row(
                children: [
                  Expanded(
                    child: Text(
                      stop.stationName,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimaryLight,
                      ),
                    ),
                  ),
                  // View Station Details button
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      _navigateToStationDetails(context, stop.stationId);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Iconsax.building,
                            size: 16.r,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'View Station',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              // Network badge
              if (stop.network != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      stop.network!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 16.h),
              // Location
              if (stop.location.address != null)
                Row(
                  children: [
                    Icon(
                      Iconsax.location,
                      size: 16.r,
                      color: AppColors.textSecondaryLight,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        stop.location.address!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 20.h),
              // Charging info grid
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariantLight,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailInfoItem(
                            'Charger',
                            '${stop.chargerPowerKw.toStringAsFixed(0)} kW',
                          ),
                        ),
                        Expanded(
                          child: _buildDetailInfoItem(
                            'Type',
                            stop.chargerTypeDisplay,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailInfoItem(
                            'Price',
                            '\$${stop.pricePerKwh.toStringAsFixed(2)}/kWh',
                          ),
                        ),
                        Expanded(
                          child: _buildDetailInfoItem(
                            'Cost',
                            '\$${stop.estimatedCost.toStringAsFixed(2)}',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Amenities
              if (stop.amenities.isNotEmpty) ...[
                SizedBox(height: 16.h),
                Text(
                  'Amenities',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: stop.amenities
                      .map(
                        (amenity) => Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariantLight,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            amenity,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
              SizedBox(height: 24.h),
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: CommonButton(
                      label: 'View Station',
                      onPressed: () {
                        Navigator.pop(ctx);
                        _navigateToStationDetails(context, stop.stationId);
                      },
                      variant: ButtonVariant.outlined,
                      icon: Iconsax.building,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: CommonButton(
                      label: 'Book',
                      onPressed: () {
                        Navigator.pop(ctx);
                        _openBookingFlow(context, stop);
                      },
                      icon: Iconsax.calendar_tick,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11.sp, color: AppColors.textTertiaryLight),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }

  void _navigateToStationDetails(BuildContext context, String stationId) {
    context.push('/stationDetails/$stationId');
  }

  /// Open navigation to the charging station.
  Future<void> _openDirections(
    BuildContext context,
    ChargingStopModel stop,
  ) async {
    final lat = stop.location.latitude;
    final lng = stop.location.longitude;

    final googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
    );
    final appleMapsUrl = Uri.parse(
      'https://maps.apple.com/?daddr=$lat,$lng&dirflg=d',
    );

    try {
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(appleMapsUrl)) {
        await launchUrl(appleMapsUrl, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Navigate to: ${stop.stationName}')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not open maps: $e')));
      }
    }
  }

  /// Open booking flow for the charging stop.
  void _openBookingFlow(BuildContext context, ChargingStopModel stop) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _BookingFlowSheet(
        stop: stop,
        onBookingComplete: (success) {
          Navigator.pop(ctx);
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Iconsax.tick_circle, color: Colors.white, size: 20.r),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text('Booking confirmed for ${stop.stationName}'),
                    ),
                  ],
                ),
                backgroundColor: AppColors.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12
        ? time.hour - 12
        : (time.hour == 0 ? 12 : time.hour);
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}

/// Booking flow sheet with payment integration.
class _BookingFlowSheet extends StatefulWidget {
  const _BookingFlowSheet({
    required this.stop,
    required this.onBookingComplete,
  });

  final ChargingStopModel stop;
  final void Function(bool success) onBookingComplete;

  @override
  State<_BookingFlowSheet> createState() => _BookingFlowSheetState();
}

class _BookingFlowSheetState extends State<_BookingFlowSheet> {
  int _currentStep = 0;
  bool _isProcessing = false;
  String? _selectedPaymentMethod;

  final List<String> _paymentMethods = [
    'Visa •••• 4242',
    'Mastercard •••• 8888',
    'Apple Pay',
    'Google Pay',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        children: [
          // Handle
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.outlineLight,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (_currentStep > 0) {
                      setState(() => _currentStep--);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Icon(
                    Iconsax.arrow_left,
                    size: 24.r,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    _getStepTitle(),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          // Progress indicator
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: List.generate(3, (index) {
                final isActive = index <= _currentStep;
                return Expanded(
                  child: Container(
                    height: 4.h,
                    margin: EdgeInsets.only(right: index < 2 ? 8.w : 0),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primary
                          : AppColors.outlineLight,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 24.h),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: _buildStepContent(),
            ),
          ),
          // Bottom button
          _buildBottomButton(),
        ],
      ),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Confirm Booking';
      case 1:
        return 'Payment Method';
      case 2:
        return 'Processing...';
      default:
        return 'Booking';
    }
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildConfirmStep();
      case 1:
        return _buildPaymentStep();
      case 2:
        return _buildProcessingStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildConfirmStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Station info
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariantLight,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Row(
            children: [
              Container(
                width: 56.r,
                height: 56.r,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Iconsax.flash_15,
                  color: AppColors.primary,
                  size: 28.r,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.stop.stationName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryLight,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${widget.stop.chargerPowerKw.toStringAsFixed(0)} kW • ${widget.stop.network ?? "Charger"}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        // Booking details
        Text(
          'Booking Details',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryLight,
          ),
        ),
        SizedBox(height: 16.h),
        _buildDetailRow(
          Iconsax.clock,
          'Arrival Time',
          widget.stop.arrivalTime != null
              ? _formatDateTime(widget.stop.arrivalTime!)
              : 'TBD',
        ),
        SizedBox(height: 12.h),
        _buildDetailRow(
          Iconsax.timer_1,
          'Charging Duration',
          widget.stop.formattedChargeTime,
        ),
        SizedBox(height: 12.h),
        _buildDetailRow(
          Iconsax.flash_1,
          'Energy to Add',
          '${widget.stop.energyToChargeKwh.toStringAsFixed(1)} kWh',
        ),
        SizedBox(height: 12.h),
        _buildDetailRow(
          Iconsax.battery_charging,
          'Battery',
          '${widget.stop.arrivalSocPercent.toStringAsFixed(0)}% → ${widget.stop.departureSocPercent.toStringAsFixed(0)}%',
        ),
        SizedBox(height: 24.h),
        // Price breakdown
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Energy Cost',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                  Text(
                    '\$${widget.stop.estimatedCost.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reservation Fee',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                  Text(
                    r'$1.00',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
              Divider(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  Text(
                    '\$${(widget.stop.estimatedCost + 1.0).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Payment Method',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryLight,
          ),
        ),
        SizedBox(height: 16.h),
        ...List.generate(_paymentMethods.length, (index) {
          final method = _paymentMethods[index];
          final isSelected = _selectedPaymentMethod == method;
          final icon = method.contains('Visa')
              ? Iconsax.card
              : method.contains('Mastercard')
              ? Iconsax.card
              : method.contains('Apple')
              ? Iconsax.mobile
              : Iconsax.wallet;

          return GestureDetector(
            onTap: () => setState(() => _selectedPaymentMethod = method),
            child: Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : AppColors.surfaceVariantLight,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.outlineLight,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 24.r,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondaryLight,
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      method,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimaryLight,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Iconsax.tick_circle5,
                      size: 22.r,
                      color: AppColors.primary,
                    ),
                ],
              ),
            ),
          );
        }),
        SizedBox(height: 16.h),
        // Add new card option
        GestureDetector(
          onTap: () {
            // Show add card flow
          },
          child: Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.outlineLight),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.add, size: 20.r, color: AppColors.primary),
                SizedBox(width: 8.w),
                Text(
                  'Add New Card',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProcessingStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 60.h),
        if (_isProcessing) ...[
          SizedBox(
            width: 60.r,
            height: 60.r,
            child: const CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Processing Payment...',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryLight,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Please wait while we confirm your booking',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ] else ...[
          Container(
            width: 80.r,
            height: 80.r,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(Iconsax.tick_circle, size: 40.r, color: Colors.white),
          ),
          SizedBox(height: 24.h),
          Text(
            'Booking Confirmed!',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimaryLight,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Your charging spot is reserved',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
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
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: CommonButton(
          label: _getButtonLabel(),
          onPressed: _isProcessing ? null : _handleButtonPress,
          isLoading: _isProcessing,
          icon: _getButtonIcon(),
        ),
      ),
    );
  }

  String _getButtonLabel() {
    switch (_currentStep) {
      case 0:
        return 'Continue to Payment';
      case 1:
        return 'Pay \$${(widget.stop.estimatedCost + 1.0).toStringAsFixed(2)}';
      case 2:
        return _isProcessing ? 'Processing...' : 'Done';
      default:
        return 'Continue';
    }
  }

  IconData _getButtonIcon() {
    switch (_currentStep) {
      case 0:
        return Iconsax.arrow_right_1;
      case 1:
        return Iconsax.card;
      case 2:
        return Iconsax.tick_circle;
      default:
        return Iconsax.arrow_right_1;
    }
  }

  void _handleButtonPress() {
    switch (_currentStep) {
      case 0:
        setState(() => _currentStep = 1);
        break;
      case 1:
        if (_selectedPaymentMethod == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a payment method')),
          );
          return;
        }
        setState(() {
          _currentStep = 2;
          _isProcessing = true;
        });
        // Simulate payment processing
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() => _isProcessing = false);
            Future.delayed(const Duration(seconds: 1), () {
              widget.onBookingComplete(true);
            });
          }
        });
        break;
      case 2:
        if (!_isProcessing) {
          widget.onBookingComplete(true);
        }
        break;
    }
  }

  String _formatDateTime(DateTime time) {
    final hour = time.hour > 12
        ? time.hour - 12
        : (time.hour == 0 ? 12 : time.hour);
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final minute = time.minute.toString().padLeft(2, '0');
    final month = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ][time.month - 1];
    return '$month ${time.day}, $hour:$minute $period';
  }
}
