/// File: lib/features/search/presentation/widgets/map_controls.dart
/// Purpose: Map control buttons (zoom, location, etc.)
/// Belongs To: search feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_ext.dart';
import '../../../../core/theme/app_colors.dart';

/// Map controls widget.
class MapControls extends StatelessWidget {
  const MapControls({
    required this.mapController,
    required this.onMyLocationTap,
    super.key,
  });

  final MapController mapController;
  final VoidCallback onMyLocationTap;

  void _zoomIn() {
    final currentZoom = mapController.camera.zoom;
    final newZoom = (currentZoom + 1).clamp(5.0, 18.0);
    if (newZoom != currentZoom) {
      mapController.move(
        mapController.camera.center,
        newZoom,
      );
    }
  }

  void _zoomOut() {
    final currentZoom = mapController.camera.zoom;
    final newZoom = (currentZoom - 1).clamp(5.0, 18.0);
    if (newZoom != currentZoom) {
      mapController.move(
        mapController.camera.center,
        newZoom,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Zoom in button
        FloatingActionButton(
          mini: true,
          heroTag: 'zoom_in',
          onPressed: _zoomIn,
          backgroundColor: colors.surface,
          child: Icon(
            Icons.add,
            color: colors.textPrimary,
            size: 20.r,
          ),
        ),
        SizedBox(height: 8.h),
        // Zoom out button
        FloatingActionButton(
          mini: true,
          heroTag: 'zoom_out',
          onPressed: _zoomOut,
          backgroundColor: colors.surface,
          child: Icon(
            Icons.remove,
            color: colors.textPrimary,
            size: 20.r,
          ),
        ),
        SizedBox(height: 8.h),
        // My location button
        FloatingActionButton(
          mini: true,
          heroTag: 'my_location',
          onPressed: onMyLocationTap,
          backgroundColor: colors.surface,
          child: Icon(
            Icons.my_location,
            color: colors.primary,
            size: 20.r,
          ),
        ),
      ],
    );
  }
}

