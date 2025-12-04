/// File: lib/features/trip_planner/ui/standalone_trip_summary_page.dart
/// Purpose: Standalone trip summary screen accessible from anywhere
/// Belongs To: trip_planner feature
/// Route: AppRoutes.tripSummary
/// Customization Guide:
///    - Independent of TripPlannerCubit flow
///    - Can be navigated to directly with tripId
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_app_bar.dart';
import '../../../widgets/common_button.dart';
import '../models/models.dart';
import '../repositories/repositories.dart';
import '../widgets/widgets.dart';

/// Standalone trip summary page that can be accessed directly with a tripId.
class StandaloneTripSummaryPage extends StatefulWidget {
  const StandaloneTripSummaryPage({
    required this.tripId,
    super.key,
  });

  final String tripId;

  @override
  State<StandaloneTripSummaryPage> createState() =>
      _StandaloneTripSummaryPageState();
}

class _StandaloneTripSummaryPageState extends State<StandaloneTripSummaryPage> {
  final _repository = DummyTripPlannerRepository();
  TripModel? _trip;
  bool _isLoading = true;
  String? _error;

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
          title: 'Trip Summary',
          onBackPressed: () => context.pop(),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _trip == null) {
      return Scaffold(
        appBar: AppAppBar(
          title: 'Trip Summary',
          onBackPressed: () => context.pop(),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Iconsax.warning_2,
                size: 64.r,
                color: AppColors.textTertiaryLight,
              ),
              SizedBox(height: 16.h),
              Text(
                _error ?? 'Trip not found',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textSecondaryLight,
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

    return Scaffold(
      appBar: AppAppBar(
        title: 'Trip Summary',
        onBackPressed: () => context.pop(),
        actions: [
          IconButton(
            icon: Icon(
              trip.isFavorite ? Iconsax.heart5 : Iconsax.heart,
              size: 22.r,
              color: trip.isFavorite ? AppColors.error : null,
            ),
            onPressed: () {
              // Toggle favorite locally
              setState(() {
                _trip = trip.copyWith(isFavorite: !trip.isFavorite);
              });
            },
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
            _buildRouteHeader(context, trip),
            SizedBox(height: 20.h),
            // Main stats
            _buildMainStats(context, trip),
            SizedBox(height: 20.h),
            // Quick actions
            _buildQuickActions(context, trip),
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
                onAction: () => _showAllStops(context, trip),
              ),
              SizedBox(height: 12.h),
              ...trip.chargingStops.take(2).map(
                    (stop) => ChargingStopCard(
                      stop: stop,
                      showTimeline: false,
                      onNavigateTap: () => _openDirections(context, stop),
                      onReserveTap: () => _openBooking(context, stop),
                    ),
                  ),
              if (trip.chargingStops.length > 2) ...[
                Center(
                  child: TextButton(
                    onPressed: () => _showAllStops(context, trip),
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
            // Edit Trip button
            CommonButton(
              label: 'Edit Trip',
              onPressed: () {
                // Navigate to trip planner to edit
                context.push('${AppRoutes.tripPlanner.path}?tripId=${widget.tripId}');
              },
              variant: ButtonVariant.outlined,
              icon: Iconsax.edit_2,
            ),
            SizedBox(height: 80.h),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context, trip),
    );
  }

  Widget _buildRouteHeader(BuildContext context, TripModel trip) {
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

  Widget _buildMainStats(BuildContext context, TripModel trip) {
    final estimates = trip.estimates;
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

  Widget _buildQuickActions(BuildContext context, TripModel trip) {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            context,
            icon: Iconsax.flash_1,
            label: 'Charging Stops',
            value: '${trip.chargingStops.length}',
            color: AppColors.warning,
            onTap: () => _showAllStops(context, trip),
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
            onTap: () => _showInsights(context, trip),
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
            onTap: () => _showFullRoute(context, trip),
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

  Widget _buildBottomBar(BuildContext context, TripModel trip) {
    final estimates = trip.estimates;

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
                onPressed: () => _startNavigation(context, trip),
                icon: Iconsax.direct_right,
                iconPosition: IconPosition.right,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatEta(DateTime eta) {
    final hour =
        eta.hour > 12 ? eta.hour - 12 : (eta.hour == 0 ? 12 : eta.hour);
    final period = eta.hour >= 12 ? 'PM' : 'AM';
    final minute = eta.minute.toString().padLeft(2, '0');
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
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Could not open maps: $e')));
      }
    }
  }

  void _openBooking(BuildContext context, ChargingStopModel stop) {
    context.push(AppRoutes.booking.id(stop.stationId));
  }

  void _showAllStops(BuildContext context, TripModel trip) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (_, scrollController) => DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.outlineLight,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${trip.chargingStops.length} Charging Stops',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Iconsax.close_circle, size: 24.r),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.all(16.r),
                  itemCount: trip.chargingStops.length,
                  itemBuilder: (_, index) {
                    final stop = trip.chargingStops[index];
                    return ChargingStopCard(
                      stop: stop,
                      isFirst: index == 0,
                      isLast: index == trip.chargingStops.length - 1,
                      onNavigateTap: () {
                        Navigator.pop(ctx);
                        _openDirections(context, stop);
                      },
                      onReserveTap: () {
                        Navigator.pop(ctx);
                        _openBooking(context, stop);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInsights(BuildContext context, TripModel trip) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, scrollController) => DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.outlineLight,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Trip Insights',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Iconsax.close_circle, size: 24.r),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Battery Graph
                      Text(
                        'Battery Level',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: AppColors.outlineLight),
                        ),
                        child: BatteryGraph(
                          dataPoints: trip.batteryGraphData,
                          reserveSocPercent: trip.vehicle.reserveSocPercent,
                          height: 200.h,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      // Cost Breakdown
                      if (trip.costBreakdown.isNotEmpty) ...[
                        Text(
                          'Cost Breakdown',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Container(
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: AppColors.outlineLight),
                          ),
                          child: CostPieChart(
                            costBreakdown: trip.costBreakdown,
                            totalCost: trip.estimates?.estimatedCost ?? 0,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFullRoute(BuildContext context, TripModel trip) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Iconsax.map, color: Colors.white, size: 20.r),
            SizedBox(width: 8.w),
            Text(
              'Route: ${trip.origin.shortDisplay} → ${trip.destination.shortDisplay}',
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _startNavigation(BuildContext context, TripModel trip) async {
    final lat = trip.destination.latitude;
    final lng = trip.destination.longitude;

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
            const SnackBar(content: Text('Could not open maps')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}

