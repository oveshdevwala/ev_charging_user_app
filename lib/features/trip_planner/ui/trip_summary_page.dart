/// File: lib/features/trip_planner/ui/trip_summary_page.dart
/// Purpose: Trip summary screen with route overview and estimates
/// Belongs To: trip_planner feature
/// Route: AppRoutes.tripSummary
/// Customization Guide:
///    - Add map integration
///    - Customize stats display
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/app_app_bar.dart';
import '../../../widgets/common_button.dart';
import '../bloc/bloc.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

/// Trip summary page.
class TripSummaryPage extends StatelessWidget {
  const TripSummaryPage({super.key});

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
            title: 'Trip Summary',
            onBackPressed: () =>
                context.read<TripPlannerCubit>().goBackToInput(),
            actions: [
              IconButton(
                icon: Icon(
                  trip.isFavorite ? Iconsax.heart5 : Iconsax.heart,
                  size: 22.r,
                  color: trip.isFavorite ? AppColors.error : null,
                ),
                onPressed: () => context
                    .read<TripPlannerCubit>()
                    .toggleTripFavorite(trip.id),
              ),
              IconButton(
                icon: Icon(Iconsax.share, size: 22.r),
                onPressed: () {},
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Route header
                _buildRouteHeader(context, state),
                SizedBox(height: 20.h),
                // Main stats
                _buildMainStats(context, state),
                SizedBox(height: 20.h),
                // Quick actions
                _buildQuickActions(context, state),
                SizedBox(height: 24.h),
                // Battery preview
                if (trip.batteryGraphData.isNotEmpty) ...[
                  _buildSectionHeader('Battery Level Along Route'),
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.outlineLight),
                    ),
                    child: BatteryGraph(
                      dataPoints: trip.batteryGraphData,
                      reserveSocPercent: trip.vehicle.reserveSocPercent,
                      height: 180.h,
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
                // Charging stops preview
                if (trip.chargingStops.isNotEmpty) ...[
                  _buildSectionHeader(
                    '${trip.chargingStops.length} Charging Stops',
                    action: 'View All',
                    onAction: () =>
                        context.read<TripPlannerCubit>().goToChargingStops(),
                  ),
                  SizedBox(height: 12.h),
                  ...trip.chargingStops
                      .take(2)
                      .map(
                        (stop) => ChargingStopCard(
                          stop: stop,
                          showTimeline: false,
                          onNavigateTap: () => _openDirections(context, stop),
                          onReserveTap: () =>
                              _showReservationSnackbar(context, stop),
                        ),
                      ),
                  if (trip.chargingStops.length > 2) ...[
                    Center(
                      child: TextButton(
                        onPressed: () => context
                            .read<TripPlannerCubit>()
                            .goToChargingStops(),
                        child: Text(
                          '+${trip.chargingStops.length - 2} more stops',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 24.h),
                ],
                // Cost breakdown
                if (trip.costBreakdown.isNotEmpty) ...[
                  _buildSectionHeader('Cost Breakdown'),
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.outlineLight),
                    ),
                    child: CostBarBreakdown(
                      costBreakdown: trip.costBreakdown,
                      totalCost: trip.estimates?.estimatedCost ?? 0,
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
                // Save button
                CommonButton(
                  label: 'Save Trip',
                  onPressed: () => _showSaveDialog(context),
                  variant: ButtonVariant.outlined,
                  icon: Iconsax.save_2,
                ),
                SizedBox(height: 80.h),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomBar(context, state),
        );
      },
    );
  }

  Widget _buildRouteHeader(BuildContext context, TripPlannerState state) {
    final trip = state.currentTrip!;

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
        children: [
          Row(
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Iconsax.location, size: 20.r, color: Colors.white),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'From',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                    Text(
                      trip.origin.shortDisplay,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 18.w),
            child: Row(
              children: [
                Container(
                  width: 2,
                  height: 24.h,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.primary, AppColors.error],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Iconsax.flag, size: 20.r, color: Colors.white),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'To',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                    Text(
                      trip.destination.shortDisplay,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainStats(BuildContext context, TripPlannerState state) {
    final estimates = state.currentTrip!.estimates;
    if (estimates == null) {
      return const SizedBox.shrink();
    }

    return TripSummaryStatsCard(
      stats: [
        TripStatData(
          icon: Iconsax.routing_2,
          label: 'Distance',
          value: '${estimates.totalDistanceKm.toStringAsFixed(0)} km',
          color: AppColors.primary,
        ),
        TripStatData(
          icon: Iconsax.clock,
          label: 'Total Time',
          value: estimates.formattedTotalTime,
          color: AppColors.secondary,
        ),
        TripStatData(
          icon: Iconsax.flash_1,
          label: 'Stops',
          value: '${estimates.requiredStops}',
          color: AppColors.warning,
        ),
        TripStatData(
          icon: Iconsax.dollar_circle,
          label: 'Est. Cost',
          value: '\$${estimates.estimatedCost.toStringAsFixed(0)}',
          color: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, TripPlannerState state) {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            context,
            icon: Iconsax.flash_1,
            label: 'Charging Stops',
            value: '${state.currentTrip!.chargingStops.length}',
            color: AppColors.warning,
            onTap: () => context.read<TripPlannerCubit>().goToChargingStops(),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildActionCard(
            context,
            icon: Iconsax.chart_2,
            label: 'Trip Insights',
            value: 'View',
            color: AppColors.tertiary,
            onTap: () => context.read<TripPlannerCubit>().goToInsights(),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildActionCard(
            context,
            icon: Iconsax.map,
            label: 'Full Route',
            value: 'View',
            color: AppColors.secondary,
            onTap: () => context.read<TripPlannerCubit>().goToDetail(),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 24.r, color: color),
            SizedBox(height: 8.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    String title, {
    String? action,
    VoidCallback? onAction,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryLight,
          ),
        ),
        if (action != null && onAction != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              action,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, TripPlannerState state) {
    final estimates = state.currentTrip!.estimates;

    return Container(
      padding: EdgeInsets.all(16.r),
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
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Arrival',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                  Text(
                    estimates?.eta != null ? _formatEta(estimates!.eta!) : '--',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: CommonButton(
                label: 'Start Navigation',
                onPressed: () {},
                icon: Iconsax.direct_right,
                iconPosition: IconPosition.right,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSaveDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Save Trip',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Trip name (optional)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<TripPlannerCubit>().saveCurrentTrip(
                name: controller.text.isNotEmpty ? controller.text : null,
              );
            },
            child: const Text(AppStrings.save),
          ),
        ],
      ),
    );
  }

  String _formatEta(DateTime eta) {
    final hour = eta.hour > 12
        ? eta.hour - 12
        : (eta.hour == 0 ? 12 : eta.hour);
    final period = eta.hour >= 12 ? 'PM' : 'AM';
    final minute = eta.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  /// Open navigation to the charging station using Google Maps or Apple Maps.
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

  /// Open booking flow for the stop - navigates to charging stops page.
  void _showReservationSnackbar(BuildContext context, ChargingStopModel stop) {
    // Navigate to charging stops page for full booking flow
    context.read<TripPlannerCubit>().goToChargingStops();

    // Show hint
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Iconsax.info_circle, color: Colors.white, size: 20.r),
            SizedBox(width: 8.w),
            const Expanded(
              child: Text('Tap Reserve on the stop to complete booking'),
            ),
          ],
        ),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
