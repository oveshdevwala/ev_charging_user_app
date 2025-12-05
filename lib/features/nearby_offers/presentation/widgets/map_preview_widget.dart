/// File: lib/features/nearby_offers/presentation/widgets/map_preview_widget.dart
/// Purpose: Static map preview placeholder
/// Belongs To: nearby_offers feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MapPreviewWidget extends StatelessWidget {
  const MapPreviewWidget({
    required this.latitude,
    required this.longitude,
    super.key,
    this.height,
  });

  final double latitude;
  final double longitude;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: height ?? 150.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer.withOpacity(0.3),
            theme.colorScheme.secondaryContainer.withOpacity(0.2),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Map placeholder content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.map_outlined,
                  size: 32.sp,
                  color: theme.colorScheme.primary,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Map Preview',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          // Open in Maps button
          Positioned(
            bottom: 12.h,
            right: 12.w,
            child: FloatingActionButton.small(
              heroTag: 'open_maps_fab_${latitude}_${longitude}',
              onPressed: () {
                // TODO: Launch maps app with coordinates
                // final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
                // launchUrl(Uri.parse(url));
              },
              child: const Icon(Icons.directions_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
