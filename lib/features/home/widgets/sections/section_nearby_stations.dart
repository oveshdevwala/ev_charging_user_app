/// File: lib/features/home/widgets/sections/section_nearby_stations.dart
/// Purpose: Smart nearby stations section with horizontal slider
/// Belongs To: home feature
/// Customization Guide:
///    - Customize card appearance via StationCardHorizontal
///    - Adjust sorting/ranking in repository
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../models/station_model.dart';
import '../section_header.dart';
import '../components/station_card_horizontal.dart';

/// Nearby stations section with horizontal scrolling.
class SectionNearbyStations extends StatelessWidget {
  const SectionNearbyStations({
    super.key,
    required this.stations,
    required this.onStationTap,
    required this.onViewAllTap,
    this.onFavoriteTap,
  });

  /// List of nearby stations.
  final List<StationModel> stations;

  /// Callback when a station is tapped.
  final void Function(StationModel station) onStationTap;

  /// Callback when view all is tapped.
  final VoidCallback onViewAllTap;

  /// Callback when favorite is tapped.
  final void Function(String stationId)? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    if (stations.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: AppStrings.nearbyStations,
          onViewAll: onViewAllTap,
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 230.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            physics: const BouncingScrollPhysics(),
            itemCount: stations.length,
            itemBuilder: (context, index) {
              final station = stations[index];
              return StationCardHorizontal(
                station: station,
                onTap: () => onStationTap(station),
                onFavoriteTap: onFavoriteTap != null
                    ? () => onFavoriteTap!(station.id)
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }
}

