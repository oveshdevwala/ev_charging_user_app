/// File: lib/features/trip_history/domain/entities/completed_trip.dart
/// Purpose: Domain entity for completed trips (trip history)
/// Belongs To: trip_history feature
/// Customization Guide:
///    - Add fields for additional trip metadata
///    - Extend battery timeline for more granular data
library;

import 'package:equatable/equatable.dart';

import '../../../trip_planner/models/charging_stop_model.dart';
import '../../../trip_planner/models/location_model.dart';

/// Battery point representing state of charge at a specific distance.
class BatteryPoint extends Equatable {
  const BatteryPoint({
    required this.distanceKm,
    required this.socPercent,
    this.isChargingStop = false,
    this.label,
  });

  final double distanceKm;
  final double socPercent;
  final bool isChargingStop;
  final String? label;

  @override
  List<Object?> get props => [distanceKm, socPercent, isChargingStop, label];
}

/// Location point for trip from/to locations.
class LocationPoint extends Equatable {
  const LocationPoint({
    required this.name,
    required this.location,
    this.address,
  });

  final String name;
  final LocationModel location;
  final String? address;

  @override
  List<Object?> get props => [name, location, address];
}

/// Completed trip entity representing a finished trip in trip history.
class CompletedTrip extends Equatable {
  const CompletedTrip({
    required this.id,
    required this.title,
    required this.from,
    required this.to,
    required this.distanceKm,
    required this.totalTime,
    required this.stopCount,
    required this.estimatedCost,
    required this.batteryTimeline,
    required this.chargingStops,
    required this.createdAt,
    this.isFavorite = false,
    this.drivingTime,
    this.chargingTime,
    this.actualCost,
    this.energyConsumedKwh,
    this.vehicleName,
  });

  final String id;
  final String title;
  final LocationPoint from;
  final LocationPoint to;
  final double distanceKm;
  final Duration totalTime;
  final int stopCount;
  final double estimatedCost;
  final List<BatteryPoint> batteryTimeline;
  final List<ChargingStopModel> chargingStops;
  final DateTime createdAt;
  final bool isFavorite;
  final Duration? drivingTime;
  final Duration? chargingTime;
  final double? actualCost;
  final double? energyConsumedKwh;
  final String? vehicleName;

  /// Get formatted distance string.
  String get formattedDistance => '${distanceKm.toStringAsFixed(0)} km';

  /// Get formatted total time.
  String get formattedTotalTime {
    final hours = totalTime.inHours;
    final minutes = totalTime.inMinutes % 60;
    if (hours > 0) {
      return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
    }
    return '${minutes}m';
  }

  /// Get formatted driving time.
  String get formattedDrivingTime {
    if (drivingTime == null) return '--';
    final hours = drivingTime!.inHours;
    final minutes = drivingTime!.inMinutes % 60;
    if (hours > 0) {
      return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
    }
    return '${minutes}m';
  }

  /// Get formatted charging time.
  String get formattedChargingTime {
    if (chargingTime == null) return '--';
    final hours = chargingTime!.inHours;
    final minutes = chargingTime!.inMinutes % 60;
    if (hours > 0) {
      return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
    }
    return '${minutes}m';
  }

  CompletedTrip copyWith({
    String? id,
    String? title,
    LocationPoint? from,
    LocationPoint? to,
    double? distanceKm,
    Duration? totalTime,
    int? stopCount,
    double? estimatedCost,
    List<BatteryPoint>? batteryTimeline,
    List<ChargingStopModel>? chargingStops,
    DateTime? createdAt,
    bool? isFavorite,
    Duration? drivingTime,
    Duration? chargingTime,
    double? actualCost,
    double? energyConsumedKwh,
    String? vehicleName,
  }) {
    return CompletedTrip(
      id: id ?? this.id,
      title: title ?? this.title,
      from: from ?? this.from,
      to: to ?? this.to,
      distanceKm: distanceKm ?? this.distanceKm,
      totalTime: totalTime ?? this.totalTime,
      stopCount: stopCount ?? this.stopCount,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      batteryTimeline: batteryTimeline ?? this.batteryTimeline,
      chargingStops: chargingStops ?? this.chargingStops,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
      drivingTime: drivingTime ?? this.drivingTime,
      chargingTime: chargingTime ?? this.chargingTime,
      actualCost: actualCost ?? this.actualCost,
      energyConsumedKwh: energyConsumedKwh ?? this.energyConsumedKwh,
      vehicleName: vehicleName ?? this.vehicleName,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        from,
        to,
        distanceKm,
        totalTime,
        stopCount,
        estimatedCost,
        batteryTimeline,
        chargingStops,
        createdAt,
        isFavorite,
        drivingTime,
        chargingTime,
        actualCost,
        energyConsumedKwh,
        vehicleName,
      ];
}
