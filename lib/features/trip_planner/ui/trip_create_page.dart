/// File: lib/features/trip_planner/ui/trip_create_page.dart
/// Purpose: Trip creation screen with origin/destination input
/// Belongs To: trip_planner feature
/// Route: AppRoutes.tripCreate
/// Customization Guide:
///    - Add more preferences options
///    - Customize waypoint handling
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/app_app_bar.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/common_text_field.dart';
import '../bloc/bloc.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

/// Trip create page.
class TripCreatePage extends StatefulWidget {
  const TripCreatePage({super.key});

  @override
  State<TripCreatePage> createState() => _TripCreatePageState();
}

class _TripCreatePageState extends State<TripCreatePage> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripPlannerCubit, TripPlannerState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppAppBar(
            title: 'Plan Your Trip',
            onBackPressed: () => context.read<TripPlannerCubit>().goToHome(),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Origin/Destination inputs
                      LocationInputPair(
                        origin: state.origin,
                        destination: state.destination,
                        onOriginTap: () => _showLocationSearch(true),
                        onDestinationTap: () => _showLocationSearch(false),
                        onSwap: () => context
                            .read<TripPlannerCubit>()
                            .swapOriginDestination(),
                        onOriginClear: () =>
                            context.read<TripPlannerCubit>().setOrigin(
                              const LocationModel(latitude: 0, longitude: 0),
                            ),
                        onDestinationClear: () =>
                            context.read<TripPlannerCubit>().setDestination(
                              const LocationModel(latitude: 0, longitude: 0),
                            ),
                      ),
                      // Waypoints
                      if (state.waypoints.isNotEmpty) ...[
                        SizedBox(height: 16.h),
                        ...state.waypoints.asMap().entries.map((entry) {
                          final index = entry.key;
                          final waypoint = entry.value;
                          return Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: LocationInput(
                                    type: LocationInputType.waypoint,
                                    location: waypoint,
                                    onTap: () {},
                                    onClear: () => context
                                        .read<TripPlannerCubit>()
                                        .removeWaypoint(index),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                      SizedBox(height: 24.h),
                      // Vehicle info
                      _buildVehicleCard(context, state),
                      SizedBox(height: 24.h),
                      // Preferences
                      _buildPreferencesSection(context, state),
                      SizedBox(height: 24.h),
                      // Departure time
                      _buildDepartureTimeSection(context, state),
                    ],
                  ),
                ),
              ),
              // Calculate button
              _buildBottomBar(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVehicleCard(BuildContext context, TripPlannerState state) {
    final vehicle = state.selectedVehicle;
    if (vehicle == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.appColors.outline),
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
                  color: context.appColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Iconsax.car,
                  size: 24.r,
                  color: context.appColors.primary,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: context.appColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${vehicle.batteryCapacityKwh.toStringAsFixed(0)} kWh battery',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: context.appColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => _showVehicleSelector(context),
                child: Text('Change', style: TextStyle(fontSize: 13.sp)),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // SOC Slider
          Row(
            children: [
              Text(
                'Current Charge',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: context.appColors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                '${vehicle.currentSocPercent.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: context.appColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 6.h,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.r),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 18.r),
            ),
            child: Slider(
              value: vehicle.currentSocPercent,
              max: 100,
              divisions: 100,
              activeColor: context.appColors.primary,
              inactiveColor: context.appColors.outline,
              onChanged: (value) =>
                  context.read<TripPlannerCubit>().updateVehicleSoc(value),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Range: ~${vehicle.usableRangeKm.toStringAsFixed(0)} km',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: context.appColors.textSecondary,
                ),
              ),
              Text(
                'Reserve: ${vehicle.reserveSocPercent.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: context.appColors.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesSection(
    BuildContext context,
    TripPlannerState state,
  ) {
    final prefs = state.preferences;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.appColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trip Preferences',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: context.appColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          _buildPreferenceSwitch(
            'Prefer Fast Chargers (150+ kW)',
            prefs.preferFastChargers,
            (value) => context.read<TripPlannerCubit>().updatePreferences(
              prefs.copyWith(preferFastChargers: value),
            ),
          ),
          _buildPreferenceSwitch(
            'Avoid Toll Roads',
            prefs.avoidTolls,
            (value) => context.read<TripPlannerCubit>().updatePreferences(
              prefs.copyWith(avoidTolls: value),
            ),
          ),
          _buildPreferenceSwitch(
            'Minimize Stops (Longer Charges)',
            prefs.minimizeStops,
            (value) => context.read<TripPlannerCubit>().updatePreferences(
              prefs.copyWith(minimizeStops: value),
            ),
          ),
          _buildPreferenceSwitch(
            'Minimize Charging Cost',
            prefs.minimizeCost,
            (value) => context.read<TripPlannerCubit>().updatePreferences(
              prefs.copyWith(minimizeCost: value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceSwitch(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: context.appColors.textPrimary,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: context.appColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildDepartureTimeSection(
    BuildContext context,
    TripPlannerState state,
  ) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.appColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Departure Time',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: context.appColors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildTimeOption(
                  context,
                  'Now',
                  state.departureTime == null,
                  () => context.read<TripPlannerCubit>().setDepartureTime(null),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: GestureDetector(
                  onTap: () => _pickDepartureTime(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: state.departureTime != null
                          ? context.appColors.primary.withValues(alpha: 0.1)
                          : context.appColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: state.departureTime != null
                            ? context.appColors.primary
                            : context.appColors.outline,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.clock,
                          size: 18.r,
                          color: state.departureTime != null
                              ? context.appColors.primary
                              : context.appColors.textSecondary,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          state.departureTime != null
                              ? _formatTime(state.departureTime!)
                              : 'Schedule',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: state.departureTime != null
                                ? context.appColors.primary
                                : context.appColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeOption(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? context.appColors.primary.withValues(alpha: 0.1)
              : context.appColors.surfaceVariant,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected
                ? context.appColors.primary
                : context.appColors.outline,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? context.appColors.primary
                  : context.appColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, TripPlannerState state) {
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
          label: state.isCalculating ? AppStrings.loading : 'Calculate Trip',
          onPressed: state.canCalculate && !state.isCalculating
              ? () => context.read<TripPlannerCubit>().calculateTrip()
              : null,
          isLoading: state.isCalculating,
          icon: Iconsax.routing_2,
        ),
      ),
    );
  }

  void _showLocationSearch(bool isOrigin) {
    // Get the cubit before opening bottom sheet to pass it down
    final cubit = context.read<TripPlannerCubit>();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BlocProvider.value(
        value: cubit,
        child: DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (sheetContext, controller) => _SearchSheet(
            controller: controller,
            isOrigin: isOrigin,
            searchController: _searchController,
            searchFocusNode: _searchFocusNode,
          ),
        ),
      ),
    );
  }

  void _showVehicleSelector(BuildContext context) {
    final cubit = context.read<TripPlannerCubit>();

    showModalBottomSheet<void>(
      context: context,
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
              children: [
                Text(
                  'Select Vehicle',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16.h),
                ...state.availableVehicles.map(
                  (vehicle) => ListTile(
                    onTap: () {
                      cubit.selectVehicle(vehicle);
                      Navigator.pop(ctx);
                    },
                    leading: Icon(
                      Iconsax.car,
                      color: context.appColors.primary,
                    ),
                    title: Text(
                      vehicle.name,
                      style: TextStyle(color: context.appColors.textPrimary),
                    ),
                    subtitle: Text(
                      '${vehicle.batteryCapacityKwh} kWh',
                      style: TextStyle(color: context.appColors.textSecondary),
                    ),
                    trailing: state.selectedVehicle?.id == vehicle.id
                        ? Icon(
                            Iconsax.tick_circle5,
                            color: context.appColors.primary,
                          )
                        : null,
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDepartureTime(BuildContext context) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );

    if (date != null && context.mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null && context.mounted) {
        final departureTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        context.read<TripPlannerCubit>().setDepartureTime(departureTime);
      }
    }
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

/// Search sheet widget that has access to TripPlannerCubit via BlocProvider.value.
class _SearchSheet extends StatelessWidget {
  const _SearchSheet({
    required this.controller,
    required this.isOrigin,
    required this.searchController,
    required this.searchFocusNode,
  });

  final ScrollController controller;
  final bool isOrigin;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
                color: context.appColors.outline,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          // Search bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CommonTextField(
              controller: searchController,
              focusNode: searchFocusNode,
              hint: isOrigin ? 'Search origin...' : 'Search destination...',
              prefixIcon: Iconsax.search_normal,
              autofocus: true,
              onChanged: (value) =>
                  context.read<TripPlannerCubit>().searchLocations(value),
            ),
          ),
          SizedBox(height: 12.h),
          // Results
          Expanded(
            child: BlocBuilder<TripPlannerCubit, TripPlannerState>(
              builder: (ctx, state) {
                return LocationSearchResults(
                  results: state.locationSearchResults,
                  isLoading: state.isSearching,
                  onLocationSelected: (location) {
                    if (isOrigin) {
                      context.read<TripPlannerCubit>().setOrigin(location);
                    } else {
                      context.read<TripPlannerCubit>().setDestination(location);
                    }
                    searchController.clear();
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
