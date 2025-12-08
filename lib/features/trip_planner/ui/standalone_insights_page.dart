/// File: lib/features/trip_planner/ui/standalone_insights_page.dart
/// Purpose: Standalone trip insights screen accessible from anywhere
/// Belongs To: trip_planner feature
/// Route: AppRoutes.tripInsights
/// Customization Guide:
///    - Independent of TripPlannerCubit flow
///    - Can be navigated to directly with tripId
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/app_app_bar.dart';
import '../../../widgets/common_button.dart';
import '../../trip_history/domain/repositories/trip_repository.dart';
import '../../trip_history/utils/completed_trip_converter.dart';
import '../models/models.dart';
import '../repositories/repositories.dart';
import '../widgets/widgets.dart';

/// Standalone insights page that can be accessed directly with a tripId.
class StandaloneInsightsPage extends StatefulWidget {
  const StandaloneInsightsPage({required this.tripId, super.key});

  final String tripId;

  @override
  State<StandaloneInsightsPage> createState() => _StandaloneInsightsPageState();
}

class _StandaloneInsightsPageState extends State<StandaloneInsightsPage> {
  final _tripPlannerRepo = DummyTripPlannerRepository();
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
      // First try trip planner repository
      var trip = await _tripPlannerRepo.fetchTripById(widget.tripId);
      
      // If not found, try trip history repository
      if (trip == null) {
        try {
          final tripHistoryRepo = sl<TripRepository>();
          final completedTrip = await tripHistoryRepo.getTripById(widget.tripId);
          if (completedTrip != null) {
            trip = CompletedTripConverter.toTripModel(completedTrip);
          }
        } catch (e) {
          // Ignore trip history errors, will show "Trip not found" below
        }
      }

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
          title: 'Trip Insights',
          onBackPressed: () => context.pop(),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _trip == null) {
      return Scaffold(
        appBar: AppAppBar(
          title: 'Trip Insights',
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

    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppAppBar(
        title: 'Trip Insights',
        onBackPressed: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context, trip),
            SizedBox(height: 24.h),
            // Battery graph
            _buildBatterySection(context, trip),
            SizedBox(height: 24.h),
            // Time breakdown
            _buildTimeBreakdown(context, trip),
            SizedBox(height: 24.h),
            // Cost breakdown
            _buildCostSection(context, trip),
            SizedBox(height: 24.h),
            // Energy stats
            _buildEnergyStats(context, trip),
            SizedBox(height: 24.h),
            // Environmental impact
            _buildEnvironmentalImpact(context, trip),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, TripModel trip) {
    final colors = context.appColors;
    final estimates = trip.estimates;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? colors.surface : AppColors.onTertiaryContainer;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.primary, colors.primary],
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Text(
            'Trip Analysis',
            style: TextStyle(
              fontSize: 14.sp,
              color: textColor.withValues(alpha: 0.8),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            trip.displayName,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildHeaderStat(
                estimates?.totalDistanceKm.toStringAsFixed(0) ?? '0',
                'km',
                textColor,
              ),
              Container(
                width: 1,
                height: 30.h,
                color: textColor.withValues(alpha: 0.3),
              ),
              _buildHeaderStat(
                estimates?.formattedTotalTime ?? '--',
                'total',
                textColor,
              ),
              Container(
                width: 1,
                height: 30.h,
                color: textColor.withValues(alpha: 0.3),
              ),
              _buildHeaderStat(
                '\$${estimates?.estimatedCost.toStringAsFixed(0) ?? '0'}',
                'cost',
                textColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String value, String label, Color textColor) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: textColor.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildBatterySection(BuildContext context, TripModel trip) {
    return _buildCard(
      context,
      title: 'Battery Level vs Distance',
      icon: Iconsax.battery_charging,
      child: Column(
        children: [
          BatteryGraph(
            dataPoints: trip.batteryGraphData,
            reserveSocPercent: trip.vehicle.reserveSocPercent,
            height: 200.h,
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(context, 'Driving', context.appColors.primary),
              SizedBox(width: 16.w),
              _buildLegendItem(
                context,
                'Charging',
                context.appColors.secondary,
              ),
              SizedBox(width: 16.w),
              _buildLegendItem(context, 'Reserve', context.appColors.warning),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBreakdown(BuildContext context, TripModel trip) {
    final colors = context.appColors;
    final estimates = trip.estimates;
    if (estimates == null) {
      return const SizedBox.shrink();
    }

    final driveTime = estimates.totalDriveTimeMin;
    final chargeTime = estimates.totalChargingTimeMin;
    final totalTime = driveTime + chargeTime;
    final drivePercent = totalTime > 0 ? (driveTime / totalTime * 100) : 0;
    final chargePercent = totalTime > 0 ? (chargeTime / totalTime * 100) : 0;

    return _buildCard(
      context,
      title: 'Time Distribution',
      icon: Iconsax.clock,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: drivePercent.round().clamp(1, 99),
                child: Container(
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(8.r),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${drivePercent.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: chargePercent.round().clamp(1, 99),
                child: Container(
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: colors.secondary,
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(8.r),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${chargePercent.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildTimeItem(
                  context,
                  'Driving',
                  estimates.formattedDriveTime,
                  colors.primary,
                ),
              ),
              Container(width: 1, height: 40.h, color: colors.outline),
              Expanded(
                child: _buildTimeItem(
                  context,
                  'Charging',
                  estimates.formattedChargingTime,
                  colors.secondary,
                ),
              ),
              Container(width: 1, height: 40.h, color: colors.outline),
              Expanded(
                child: _buildTimeItem(
                  context,
                  'Total',
                  estimates.formattedTotalTime,
                  colors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeItem(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    final colors = context.appColors;

    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: colors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildCostSection(BuildContext context, TripModel trip) {
    return _buildCard(
      context,
      title: 'Cost Breakdown',
      icon: Iconsax.dollar_circle,
      child: CostPieChart(
        costBreakdown: trip.costBreakdown,
        totalCost: trip.estimates?.estimatedCost ?? 0,
        size: 160.r,
      ),
    );
  }

  Widget _buildEnergyStats(BuildContext context, TripModel trip) {
    final estimates = trip.estimates;
    final vehicle = trip.vehicle;
    final colors = context.appColors;

    return _buildCard(
      context,
      title: 'Energy Statistics',
      icon: Iconsax.flash_1,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatBox(
                  context,
                  'Energy Used',
                  '${estimates?.estimatedEnergyKwh.toStringAsFixed(1) ?? '0'} kWh',
                  colors.primary,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildStatBox(
                  context,
                  'Efficiency',
                  '${vehicle.consumptionKwhPer100Km.toStringAsFixed(1)} kWh/100km',
                  colors.secondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildStatBox(
                  context,
                  'Start SOC',
                  '${vehicle.currentSocPercent.toStringAsFixed(0)}%',
                  colors.success,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildStatBox(
                  context,
                  'End SOC',
                  '${estimates?.arrivalSocPercent.toStringAsFixed(0) ?? '0'}%',
                  estimates?.arrivalSocPercent != null &&
                          estimates!.arrivalSocPercent < 20
                      ? colors.warning
                      : colors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, color: colors.textSecondary),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnvironmentalImpact(BuildContext context, TripModel trip) {
    final colors = context.appColors;
    final estimates = trip.estimates;
    if (estimates == null) {
      return const SizedBox.shrink();
    }

    // Approximate CO2 savings (compared to gas car)
    // Average gas car: ~120g CO2/km, EV: ~40g CO2/km (including grid emissions)
    final co2Saved = estimates.totalDistanceKm * 0.08; // kg CO2 saved

    return _buildCard(
      context,
      title: 'Environmental Impact',
      icon: Iconsax.tree,
      child: Column(
        children: [
          FeaturedStatWidget(
            icon: Iconsax.tree,
            label: 'CO₂ Saved vs Gas Car',
            value: co2Saved.toStringAsFixed(1),
            unit: 'kg',
            color: colors.success,
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: colors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Icon(Iconsax.info_circle, size: 18.r, color: colors.success),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Equivalent to planting ${(co2Saved / 21).toStringAsFixed(1)} trees per year',
                    style: TextStyle(fontSize: 13.sp, color: colors.success),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20.r, color: colors.primary),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    final colors = context.appColors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12.r,
          height: 12.r,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3.r),
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: colors.textSecondary),
        ),
      ],
    );
  }
}
