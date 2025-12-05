/// File: lib/core/utils/geo_fence_utils.dart
/// Purpose: Geo-fencing and distance calculation utilities
/// Belongs To: shared
library;

import 'dart:math' as math;

class GeoFenceUtils {
  /// Earth radius in kilometers.
  static const double _earthRadiusKm = 6371;

  /// Calculate Haversine distance between two points in kilometers.
  static double calculateDistanceKm(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    final dLat = _degreesToRadians(endLat - startLat);
    final dLng = _degreesToRadians(endLng - startLng);

    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(startLat)) *
            math.cos(_degreesToRadians(endLat)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return _earthRadiusKm * c;
  }

  /// Check if a point is within a radius of another point.
  static bool isWithinRadius({
    required double centerLat,
    required double centerLng,
    required double targetLat,
    required double targetLng,
    required double radiusKm,
  }) {
    final distance = calculateDistanceKm(
      centerLat,
      centerLng,
      targetLat,
      targetLng,
    );
    return distance <= radiusKm;
  }

  /// Convert degrees to radians.
  static double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }
}
