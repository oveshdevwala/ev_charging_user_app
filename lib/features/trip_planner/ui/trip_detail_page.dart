/// File: lib/features/trip_planner/ui/trip_detail_page.dart
/// Purpose: Detailed trip itinerary with map and step-by-step directions
/// Belongs To: trip_planner feature
/// Route: AppRoutes.tripDetail
/// Customization Guide:
///    - Add real map integration
///    - Add turn-by-turn navigation
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/extensions/context_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/app_app_bar.dart';
import '../../../widgets/common_button.dart';
import '../bloc/bloc.dart';
import '../widgets/widgets.dart';

/// Trip detail page.
class TripDetailPage extends StatelessWidget {
  const TripDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripPlannerCubit, TripPlannerState>(
      builder: (context, state) {
        final trip = state.currentTrip;
        if (trip == null) {
          return const Scaffold(body: Center(child: Text('No trip data')));
        }

        return Scaffold(
          appBar: AppAppBar(
            title: 'Trip Itinerary',
            onBackPressed: () => context.read<TripPlannerCubit>().goToSummary(),
            actions: [
              IconButton(
                icon: Icon(Iconsax.share, size: 22.r),
                onPressed: () {},
              ),
            ],
          ),
          body: Column(
            children: [
              // Map placeholder
              _buildMapPlaceholder(context, state),
              // Itinerary
              Expanded(child: _buildItinerary(context, state)),
            ],
          ),
          bottomNavigationBar: _buildBottomBar(context),
        );
      },
    );
  }

  Widget _buildMapPlaceholder(BuildContext context, TripPlannerState state) {
    final trip = state.currentTrip!;

    return Container(
      height: 200.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.appColors.surfaceVariant,
        border: Border(bottom: BorderSide(color: context.appColors.outline)),
      ),
      child: Stack(
        children: [
          // Map placeholder background
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  context.appColors.primary.withValues(alpha: 0.1),
                  context.appColors.secondary.withValues(alpha: 0.05),
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.map,
                    size: 48.r,
                    color: context.appColors.primary.withValues(alpha: 0.5),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Map View',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: context.appColors.textSecondary,
                    ),
                  ),
                  Text(
                    'Integrate with Google Maps or flutter_map',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: context.appColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Route info overlay
          Positioned(
            left: 12.w,
            right: 12.w,
            bottom: 12.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: context.appColors.surface,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(color: context.appColors.shadow, blurRadius: 8),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Iconsax.routing_2,
                    size: 20.r,
                    color: context.appColors.primary,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      '${trip.origin.shortDisplay} → ${trip.destination.shortDisplay}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: context.appColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${trip.estimates?.totalDistanceKm.toStringAsFixed(0) ?? '0'} km',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: context.appColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItinerary(BuildContext context, TripPlannerState state) {
    final trip = state.currentTrip!;
    final stops = trip.chargingStops;
    final estimates = trip.estimates;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick stats
          TripSummaryStatsCard(
            stats: [
              TripStatData(
                icon: Iconsax.clock,
                label: 'Duration',
                value: estimates?.formattedTotalTime ?? '--',
              ),
              TripStatData(
                icon: Iconsax.flash_1,
                label: 'Stops',
                value: '${stops.length}',
              ),
              TripStatData(
                icon: Iconsax.battery_charging,
                label: 'Arrive',
                value:
                    '${estimates?.arrivalSocPercent.toStringAsFixed(0) ?? '0'}%',
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Itinerary header
          Text(
            'Step-by-Step Itinerary',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: context.appColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          // Start
          _buildItineraryItem(
            context,
            type: _ItineraryType.start,
            title: 'Depart',
            subtitle: trip.origin.shortDisplay,
            detail: trip.departureTime != null
                ? _formatTime(trip.departureTime!)
                : 'Now',
            icon: Iconsax.location,
            color: context.appColors.primary,
          ),
          // Legs and stops
          for (var i = 0; i <= stops.length; i++) ...[
            // Driving leg
            _buildDrivingLeg(
              context,
              distance: i == 0
                  ? (stops.isNotEmpty
                        ? stops[0].distanceFromPreviousKm
                        : estimates?.totalDistanceKm ?? 0)
                  : (i < stops.length
                        ? stops[i].distanceFromPreviousKm
                        : (estimates?.totalDistanceKm ?? 0) -
                              (stops.isNotEmpty
                                  ? stops.last.distanceFromStartKm
                                  : 0)),
              duration: i == 0
                  ? (stops.isNotEmpty
                        ? (stops[0].distanceFromPreviousKm / 80 * 60).round()
                        : estimates?.totalDriveTimeMin ?? 0)
                  : 30, // Simplified
            ),
            // Charging stop
            if (i < stops.length)
              _buildItineraryItem(
                context,
                type: _ItineraryType.charge,
                title: 'Charge at ${stops[i].stationName}',
                subtitle:
                    '${stops[i].arrivalSocPercent.toStringAsFixed(0)}% → ${stops[i].departureSocPercent.toStringAsFixed(0)}%',
                detail: stops[i].formattedChargeTime,
                icon: Iconsax.flash_1,
                color: context.appColors.warning,
                extraInfo:
                    '+${stops[i].energyToChargeKwh.toStringAsFixed(1)} kWh',
              ),
          ],
          // Destination
          _buildItineraryItem(
            context,
            type: _ItineraryType.end,
            title: 'Arrive',
            subtitle: trip.destination.shortDisplay,
            detail: estimates?.eta != null
                ? _formatTime(estimates!.eta!)
                : '--',
            icon: Iconsax.flag,
            color: context.appColors.danger,
            extraInfo:
                '${estimates?.arrivalSocPercent.toStringAsFixed(0) ?? '0'}% SOC',
          ),
          SizedBox(height: 80.h),
        ],
      ),
    );
  }

  Widget _buildItineraryItem(
    BuildContext context, {
    required _ItineraryType type,
    required String title,
    required String subtitle,
    required String detail,
    required IconData icon,
    required Color color,
    String? extraInfo,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline
        SizedBox(
          width: 40.w,
          child: Column(
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Icon(icon, size: 18.r, color: context.appColors.surface),
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        // Content
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: 8.h),
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: context.appColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        detail,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: context.appColors.textSecondary,
                  ),
                ),
                if (extraInfo != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    extraInfo,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: color,
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

  Widget _buildDrivingLeg(
    BuildContext context, {
    required double distance,
    required int duration,
  }) {
    if (distance <= 0) {
      return const SizedBox.shrink();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline connector
        SizedBox(
          width: 40.w,
          child: Center(
            child: Container(
              width: 2,
              height: 50.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    context.appColors.primary.withValues(alpha: 0.5),
                    context.appColors.secondary.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        // Driving info
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.h),
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: context.appColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(
                  Iconsax.car,
                  size: 16.r,
                  color: context.appColors.textSecondary,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Drive ${distance.toStringAsFixed(0)} km',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: context.appColors.textSecondary,
                  ),
                ),
                Text(
                  ' • ~${duration}min',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: context.appColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: CommonButton(
          label: 'Start Navigation',
          onPressed: () {},
          icon: Iconsax.direct_right,
          iconPosition: IconPosition.right,
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
}

enum _ItineraryType { start, charge, end }
