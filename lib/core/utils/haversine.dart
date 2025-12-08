/// File: lib/core/utils/haversine.dart
/// Purpose: Haversine formula for calculating distance between two coordinates
/// Belongs To: shared
/// Customization Guide:
///    - Use this for calculating distances between stations and user location
library;

import 'dart:math';

/// Calculate distance between two coordinates using Haversine formula.
/// Returns distance in kilometers.
double calculateDistance(
  double lat1,
  double lon1,
  double lat2,
  double lon2,
) {
  const earthRadiusKm = 6371;

  final dLat = _degreesToRadians(lat2 - lat1);
  final dLon = _degreesToRadians(lon2 - lon1);

  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_degreesToRadians(lat1)) *
          cos(_degreesToRadians(lat2)) *
          sin(dLon / 2) *
          sin(dLon / 2);

  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  final distance = earthRadiusKm * c;

  return distance;
}

/// Convert degrees to radians.
double _degreesToRadians(double degrees) {
  return degrees * (pi / 180.0);
}

/// Calculate distance in meters.
double calculateDistanceMeters(
  double lat1,
  double lon1,
  double lat2,
  double lon2,
) {
  return calculateDistance(lat1, lon1, lat2, lon2) * 1000;
}

