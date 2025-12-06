/// File: lib/features/trip_planner/ui/standalone_charging_stops_page.dart
/// Purpose: Standalone charging stops screen accessible from anywhere
/// Belongs To: trip_planner feature
/// Route: AppRoutes.chargingStops
/// Customization Guide:
///    - Independent of TripPlannerCubit flow
///    - Can be navigated to directly with tripId
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/extensions/context_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_app_bar.dart';
import '../../../widgets/common_button.dart';
import '../models/models.dart';
import '../repositories/repositories.dart';
import '../widgets/widgets.dart';

/// Standalone charging stops page that can be accessed directly with a tripId.
class StandaloneChargingStopsPage extends StatefulWidget {
  const StandaloneChargingStopsPage({
    required this.tripId,
    super.key,
  });

  final String tripId;

  @override
  State<StandaloneChargingStopsPage> createState() =>
      _StandaloneChargingStopsPageState();
}

class _StandaloneChargingStopsPageState
    extends State<StandaloneChargingStopsPage> {
  final _repository = DummyTripPlannerRepository();
  TripModel? _trip;
  bool _isLoading = true;
  String? _error;
  final Set<int> _expandedStops = {};

  @override
  void initState() {
    super.initState();
    _loadTrip();
  }

  Future<void> _loadTrip() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final trip = await _repository.fetchTripById(widget.tripId);
      if (mounted) {
        setState(() {
          _trip = trip;
          _isLoading = false;
          if (trip == null) {
            _error = 'Trip not found';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppAppBar(
          title: 'Charging Stops',
          onBackPressed: () => context.pop(),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _trip == null) {
      return Scaffold(
        appBar: AppAppBar(
          title: 'Charging Stops',
          onBackPressed: () => context.pop(),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Iconsax.warning_2,
                size: 64.r,
                color: context.appColors.textTertiary,
              ),
              SizedBox(height: 16.h),
              Text(
                _error ?? 'Trip not found',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: context.appColors.textSecondary,
                ),
              ),
              SizedBox(height: 24.h),
              CommonButton(
                label: 'Go Back',
                onPressed: () => context.pop(),
                variant: ButtonVariant.outlined,
              ),
            ],
          ),
        ),
      );
    }

    final trip = _trip!;
    final stops = trip.chargingStops;
    final estimates = trip.estimates;

    return Scaffold(
      appBar: AppAppBar(
        title: 'Charging Stops',
        onBackPressed: () => context.pop(),
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
          : _buildContent(context, trip, stops, estimates),
    );
  }

  Widget _buildContent(
    BuildContext context,
    TripModel trip,
    List<ChargingStopModel> stops,
    TripEstimates? estimates,
  ) {
    final colors = context.appColors;

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
                  color: colors.textPrimary,
                ),
              ),
              const Spacer(),
              // Expand all hint
              Text(
                'Tap card to expand',
                style: TextStyle(fontSize: 11.sp, color: colors.textTertiary),
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

  Widget _buildSummaryCard(
    BuildContext context,
    List<ChargingStopModel> stops,
    TripEstimates? estimates,
  ) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primary.withValues(alpha: 0.1),
            colors.secondary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Stops',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: colors.textSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${stops.length}',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.primary,
                  ),
                ),
              ],
            ),
          ),
          if (estimates != null) ...[
            Container(
              width: 1,
              height: 40.h,
              color: colors.outline,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Charging Time',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: colors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    estimates.formattedChargingTime,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 40.h,
              color: colors.outline,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Cost',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: colors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '\$${estimates.estimatedCost.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

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
                onReserveTap: () => _openBooking(context, stop),
                onDetailsTap: () => _showStopDetails(context, stop),
              ),
              // Connection line to next or destination
              if (!isLast)
                const SizedBox.shrink()
              else
                _buildDrivingSegment(
                  context,
                  distanceKm: (estimates?.totalDistanceKm ?? 0) -
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
    final colors = context.appColors;
    final color = isStart ? colors.primary : colors.danger;

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
                    color: colors.primary.withValues(alpha: 0.3),
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
                    color: colors.surface,
                  ),
                ),
              ),
              if (showBottomLine)
                Container(
                  width: 3,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.3),
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
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: color.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${socPercent.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  location,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDrivingSegment(
    BuildContext context, {
    required double distanceKm,
    required String fromLabel,
    required String toLabel,
  }) {
    final colors = context.appColors;

    return Padding(
      padding: EdgeInsets.only(left: 26.w, right: 16.w, bottom: 8.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: colors.surfaceVariant,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(
              Iconsax.routing_2,
              size: 16.r,
              color: colors.textSecondary,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                '${distanceKm.toStringAsFixed(0)} km drive',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: colors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipsCard(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: colors.warning.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Iconsax.lamp_charge,
                size: 20.r,
                color: colors.warning,
              ),
              SizedBox(width: 8.w),
              Text(
                'Tips',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.warning,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            '• Reserve charging slots in advance during peak hours\n'
            '• Arrive with at least 10% battery remaining\n'
            '• Check station availability before departing',
            style: TextStyle(
              fontSize: 12.sp,
              color: colors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colors = context.appColors;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.flash_1,
              size: 64.r,
              color: colors.textTertiary,
            ),
            SizedBox(height: 16.h),
            Text(
              'No Charging Stops Needed',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Your vehicle has enough charge to complete this trip without stopping.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open maps: $e')),
        );
      }
    }
  }

  void _openBooking(BuildContext context, ChargingStopModel stop) {
    context.push(AppRoutes.booking.id(stop.stationId));
  }

  void _showStopDetails(BuildContext context, ChargingStopModel stop) {
    context.push(AppRoutes.stationDetails.id(stop.stationId));
  }
}

