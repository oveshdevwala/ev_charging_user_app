/// File: lib/features/trip_planner/ui/trip_planner_home_page.dart
/// Purpose: Trip planner home screen with saved trips and quick create
/// Belongs To: trip_planner feature
/// Route: AppRoutes.tripPlanner
/// Customization Guide:
///    - Adjust layout for different screen sizes
///    - Add additional sections as needed
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_app_bar.dart';
import '../../../widgets/common_button.dart';
import '../bloc/bloc.dart';
import '../widgets/widgets.dart';

/// Trip planner home page.
class TripPlannerHomePage extends StatelessWidget {
  const TripPlannerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripPlannerCubit, TripPlannerState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppAppBar(
            title: AppStrings.tripPlannerTitle,
            onBackPressed: () => context.pop(),
            actions: [
              IconButton(
                icon: Icon(Iconsax.setting_2, size: 22.r),
                onPressed: () => _showVehicleSettings(context),
              ),
            ],
          ),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildContent(context, state),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _startNewTrip(context),
            backgroundColor: AppColors.primary,
            icon: Icon(Iconsax.add, color: Colors.white, size: 20.r),
            label: Text(
              'Plan Trip',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, TripPlannerState state) {
    return RefreshIndicator(
      onRefresh: () => context.read<TripPlannerCubit>().initialize(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick action card
            _buildQuickActionCard(context, state),
            SizedBox(height: 24.h),
            // Recent trips
            if (state.recentTrips.isNotEmpty) ...[
              _buildSectionHeader('Recent Trips', onSeeAll: () {}),
              SizedBox(height: 12.h),
              ...state.recentTrips.take(3).map((trip) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: SavedTripCard(
                      trip: trip,
                      compact: true,
                      onTap: () => _loadTrip(context, trip.id),
                      onFavoriteTap: () =>
                          context.read<TripPlannerCubit>().toggleTripFavorite(trip.id),
                    ),
                  )),
              SizedBox(height: 16.h),
            ],
            // Favorite trips
            if (state.favoriteTrips.isNotEmpty) ...[
              _buildSectionHeader('Favorite Trips'),
              SizedBox(height: 12.h),
              ...state.favoriteTrips.map((trip) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: SavedTripCard(
                      trip: trip,
                      onTap: () => _loadTrip(context, trip.id),
                      onFavoriteTap: () =>
                          context.read<TripPlannerCubit>().toggleTripFavorite(trip.id),
                      onDeleteTap: () => _confirmDelete(context, trip.id),
                    ),
                  )),
            ],
            // Empty state
            if (state.savedTrips.isEmpty && state.recentTrips.isEmpty)
              _buildEmptyState(context),
            SizedBox(height: 80.h), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(BuildContext context, TripPlannerState state) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Iconsax.routing_2,
                  size: 24.r,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Plan Your Journey',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Find charging stops along your route',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Vehicle selector
          if (state.selectedVehicle != null)
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Iconsax.car,
                    size: 20.r,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.selectedVehicle!.name,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${state.selectedVehicle!.currentSocPercent.toStringAsFixed(0)}% • ${state.selectedVehicle!.batteryCapacityKwh.toStringAsFixed(0)} kWh',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Iconsax.arrow_right_3,
                    size: 16.r,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ],
              ),
            ),
          SizedBox(height: 16.h),
          CommonButton(
            label: 'Start Planning',
            onPressed: () => _startNewTrip(context),
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primary,
            icon: Iconsax.arrow_right_1,
            iconPosition: IconPosition.right,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryLight,
          ),
        ),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: Text(
              AppStrings.seeAll,
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

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.r),
      child: Column(
        children: [
          Container(
            width: 80.r,
            height: 80.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Iconsax.routing_2,
              size: 40.r,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'No trips planned yet',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryLight,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Plan your first trip to find the best charging stops along your route',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondaryLight,
            ),
          ),
          SizedBox(height: 24.h),
          CommonButton(
            label: 'Plan Your First Trip',
            onPressed: () => _startNewTrip(context),
            icon: Iconsax.add,
            isFullWidth: false,
          ),
        ],
      ),
    );
  }

  void _startNewTrip(BuildContext context) {
    context.read<TripPlannerCubit>().startNewTrip();
  }

  void _loadTrip(BuildContext context, String tripId) {
    // Navigate directly to standalone trip summary page
    context.push(AppRoutes.tripSummary.id(tripId));
  }

  void _confirmDelete(BuildContext context, String tripId) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Delete Trip',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to delete this trip?',
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<TripPlannerCubit>().deleteTrip(tripId);
            },
            child: const Text(
              AppStrings.delete,
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showVehicleSettings(BuildContext context) {
    final cubit = context.read<TripPlannerCubit>();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BlocProvider.value(
        value: cubit,
        child: BlocBuilder<TripPlannerCubit, TripPlannerState>(
          builder: (sheetContext, state) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            padding: EdgeInsets.all(20.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Text(
                  'Select Vehicle',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                SizedBox(height: 16.h),
                ...state.availableVehicles.map((vehicle) => ListTile(
                      onTap: () {
                        cubit.selectVehicle(vehicle);
                        Navigator.pop(ctx);
                      },
                      leading: Container(
                        width: 44.r,
                        height: 44.r,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Iconsax.car,
                          size: 22.r,
                          color: AppColors.primary,
                        ),
                      ),
                      title: Text(
                        vehicle.name,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        '${vehicle.batteryCapacityKwh.toStringAsFixed(0)} kWh • ${vehicle.currentSocPercent.toStringAsFixed(0)}%',
                        style: TextStyle(fontSize: 12.sp),
                      ),
                      trailing: state.selectedVehicle?.id == vehicle.id
                          ? Icon(
                              Iconsax.tick_circle5,
                              size: 22.r,
                              color: AppColors.primary,
                            )
                          : null,
                    )),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

