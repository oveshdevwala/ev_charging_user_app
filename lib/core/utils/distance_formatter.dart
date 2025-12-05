/// File: lib/core/utils/distance_formatter.dart
/// Purpose: Distance formatting utilities
/// Belongs To: shared
library;

class DistanceFormatter {
  /// Format distance in meters or kilometers.
  ///
  /// Examples:
  /// - 500 -> "500 m"
  /// - 1500 -> "1.5 km"
  static String formatDistance(double distanceKm) {
    if (distanceKm < 1.0) {
      final meters = (distanceKm * 1000).round();
      return '$meters m';
    } else {
      return '${distanceKm.toStringAsFixed(1)} km';
    }
  }
}
