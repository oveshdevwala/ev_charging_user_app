/// File: lib/features/trip_history/services/trip_analytics_service.dart
/// Purpose: Service for computing trip analytics and chart data
/// Belongs To: trip_history feature
/// Customization Guide:
///    - Add more analytics calculations as needed
library;

import '../domain/entities/completed_trip.dart';

/// Service for computing trip analytics.
class TripAnalyticsService {
  /// Get battery vs distance chart data points.
  static List<BatteryPoint> getBatteryVsDistance(CompletedTrip trip) {
    return trip.batteryTimeline;
  }

  /// Get time distribution percentages.
  static TimeDistribution getTimeDistribution(CompletedTrip trip) {
    final totalMinutes = trip.totalTime.inMinutes;
    final drivingMinutes = trip.drivingTime?.inMinutes ?? 0;
    final chargingMinutes = trip.chargingTime?.inMinutes ?? 0;

    if (totalMinutes == 0) {
      return const TimeDistribution(
        drivingPercent: 0,
        chargingPercent: 0,
        drivingMinutes: 0,
        chargingMinutes: 0,
        totalMinutes: 0,
      );
    }

    final drivingPercent = (drivingMinutes / totalMinutes) * 100;
    final chargingPercent = (chargingMinutes / totalMinutes) * 100;

    return TimeDistribution(
      drivingPercent: drivingPercent,
      chargingPercent: chargingPercent,
      drivingMinutes: drivingMinutes,
      chargingMinutes: chargingMinutes,
      totalMinutes: totalMinutes,
    );
  }

  /// Get cost analysis data.
  static CostAnalysis getCostAnalysis(CompletedTrip trip) {
    return CostAnalysis(
      estimatedCost: trip.estimatedCost,
      actualCost: trip.actualCost ?? trip.estimatedCost,
      savings: trip.actualCost != null
          ? (trip.estimatedCost - trip.actualCost!).clamp(0, double.infinity)
          : 0,
    );
  }
}

/// Time distribution data.
class TimeDistribution {
  const TimeDistribution({
    required this.drivingPercent,
    required this.chargingPercent,
    required this.drivingMinutes,
    required this.chargingMinutes,
    required this.totalMinutes,
  });

  final double drivingPercent;
  final double chargingPercent;
  final int drivingMinutes;
  final int chargingMinutes;
  final int totalMinutes;

  String get formattedDrivingTime {
    final hours = drivingMinutes ~/ 60;
    final mins = drivingMinutes % 60;
    if (hours > 0) {
      return mins > 0 ? '${hours}h ${mins}m' : '${hours}h';
    }
    return '${mins}m';
  }

  String get formattedChargingTime {
    final hours = chargingMinutes ~/ 60;
    final mins = chargingMinutes % 60;
    if (hours > 0) {
      return mins > 0 ? '${hours}h ${mins}m' : '${hours}h';
    }
    return '${mins}m';
  }

  String get formattedTotalTime {
    final hours = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;
    if (hours > 0) {
      return mins > 0 ? '${hours}h ${mins}m' : '${hours}h';
    }
    return '${mins}m';
  }
}

/// Cost analysis data.
class CostAnalysis {
  const CostAnalysis({
    required this.estimatedCost,
    required this.actualCost,
    required this.savings,
  });

  final double estimatedCost;
  final double actualCost;
  final double savings;
}
