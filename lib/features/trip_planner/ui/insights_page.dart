/// File: lib/features/trip_planner/ui/insights_page.dart
/// Purpose: Trip insights screen with graphs and analytics
/// Belongs To: trip_planner feature
/// Route: AppRoutes.tripInsights
/// Customization Guide:
///    - Add more chart types
///    - Add comparison with previous trips
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/theme/app_colors.dart';
import '../../../widgets/app_app_bar.dart';
import '../bloc/bloc.dart';
import '../widgets/widgets.dart';

/// Insights page.
class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripPlannerCubit, TripPlannerState>(
      builder: (context, state) {
        final trip = state.currentTrip;
        if (trip == null) {
          return const Scaffold(body: Center(child: Text('No trip data')));
        }

        return Scaffold(
          backgroundColor: context.appColors.background,
          appBar: AppAppBar(
            title: 'Trip Insights',
            onBackPressed: () => context.read<TripPlannerCubit>().goToSummary(),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(context, state),
                SizedBox(height: 24.h),
                // Battery graph
                _buildBatterySection(context, state),
                SizedBox(height: 24.h),
                // Time breakdown
                _buildTimeBreakdown(context, state),
                SizedBox(height: 24.h),
                // Cost breakdown
                _buildCostSection(context, state),
                SizedBox(height: 24.h),
                // Energy stats
                _buildEnergyStats(context, state),
                SizedBox(height: 24.h),
                // Environmental impact
                _buildEnvironmentalImpact(context, state),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, TripPlannerState state) {
    final colors = context.appColors;
    final trip = state.currentTrip!;
    final estimates = trip.estimates;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.tertiary, colors.tertiaryContainer],
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Text(
            'Trip Analysis',
            style: TextStyle(
              fontSize: 14.sp,
              color: context.appColors.surface.withValues(alpha: 0.8),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            trip.displayName,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: context.appColors.surface,
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
                context,
              ),
              Container(
                width: 1,
                height: 30.h,
                color: context.appColors.surface.withValues(alpha: 0.3),
              ),
              _buildHeaderStat(
                estimates?.formattedTotalTime ?? '--',
                'total',
                context,
              ),
              Container(
                width: 1,
                height: 30.h,
                color: context.appColors.surface.withValues(alpha: 0.3),
              ),
              _buildHeaderStat(
                '\$${estimates?.estimatedCost.toStringAsFixed(0) ?? '0'}',
                'cost',
                context,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String value, String label, BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: context.appColors.surface,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: context.appColors.surface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildBatterySection(BuildContext context, TripPlannerState state) {
    final trip = state.currentTrip!;

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

  Widget _buildTimeBreakdown(BuildContext context, TripPlannerState state) {
    final colors = context.appColors;
    final estimates = state.currentTrip!.estimates;
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

  Widget _buildCostSection(BuildContext context, TripPlannerState state) {
    final trip = state.currentTrip!;

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

  Widget _buildEnergyStats(BuildContext context, TripPlannerState state) {
    final trip = state.currentTrip!;
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

  Widget _buildEnvironmentalImpact(
    BuildContext context,
    TripPlannerState state,
  ) {
    final colors = context.appColors;
    final estimates = state.currentTrip!.estimates;
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
