/// File: lib/features/home/widgets/sections/section_trip_planner.dart
/// Purpose: Trip planner section with saved routes
/// Belongs To: home feature
/// Customization Guide:
///    - Customize trip cards via TripCard component
///    - Add more trip planning features as needed
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../models/trip_route_model.dart';
import '../section_header.dart';
import '../components/trip_card.dart';

/// Trip planner section with saved routes.
class SectionTripPlanner extends StatelessWidget {
  const SectionTripPlanner({
    super.key,
    required this.savedRoutes,
    required this.onRouteTap,
    required this.onPlanTripTap,
    required this.onViewAllTap,
  });

  /// List of saved routes.
  final List<TripRouteModel> savedRoutes;

  /// Callback when a route is tapped.
  final void Function(TripRouteModel route) onRouteTap;

  /// Callback when plan trip is tapped.
  final VoidCallback onPlanTripTap;

  /// Callback when view all is tapped.
  final VoidCallback onViewAllTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: AppStrings.tripPlannerTitle,
          onViewAll: onViewAllTap,
          showAction: savedRoutes.isNotEmpty,
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 195.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            physics: const BouncingScrollPhysics(),
            itemCount: savedRoutes.length + 1, // +1 for plan trip card
            itemBuilder: (context, index) {
              if (index == 0) {
                return TripPlannerCard(onPlanTripTap: onPlanTripTap);
              }
              final route = savedRoutes[index - 1];
              return TripCard(
                route: route,
                onTap: () => onRouteTap(route),
              );
            },
          ),
        ),
      ],
    );
  }
}

