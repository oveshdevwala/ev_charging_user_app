/// File: lib/features/search/presentation/widgets/station_map_marker.dart
/// Purpose: Custom marker widget for stations on map
/// Belongs To: search feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../models/station_model.dart';

/// Custom marker widget for stations.
class StationMapMarker extends StatelessWidget {
  const StationMapMarker({
    required this.station,
    required this.onTap,
    super.key,
  });

  final StationModel station;
  final VoidCallback onTap;

  Color _getStatusColor() {
    if (!station.hasAvailableChargers) {
      return AppColors.offline;
    }
    final availableRatio = station.availableChargers / station.totalChargers;
    if (availableRatio > 0.5) {
      return AppColors.available;
    }
    return AppColors.occupied;
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main marker circle
          DecoratedBox(
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SizedBox(
              width: 50.r,
              height: 50.r,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '\$${station.pricePerKwh.toStringAsFixed(1)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (station.availableChargers > 0)
                      Text(
                        '${station.availableChargers}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8.sp,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          // Station name label (above marker) - only show on higher zoom
          // This will be controlled by map zoom level in the parent
          Positioned(
            bottom: 55.r,
            left: -40.w,
            right: -40.w,
            child: IgnorePointer(
              child: Container(
                constraints: BoxConstraints(maxWidth: 80.w),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.w,
                  ),
                ),
                child: Text(
                  station.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

