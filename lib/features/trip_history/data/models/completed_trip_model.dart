/// File: lib/features/trip_history/data/models/completed_trip_model.dart
/// Purpose: Data model for completed trips with JSON serialization
/// Belongs To: trip_history feature
/// Customization Guide:
///    - Extend JSON mapping for additional fields
library;

import 'package:equatable/equatable.dart';


import '../../../trip_planner/models/models.dart';
import '../../domain/entities/completed_trip.dart';

/// Data model for completed trip with JSON serialization.
class CompletedTripModel extends Equatable {
  const CompletedTripModel({
    required this.id,
    required this.title,
    required this.from,
    required this.to,
    required this.distanceKm,
    required this.totalTimeMinutes,
    required this.stopCount,
    required this.estimatedCost,
    required this.batteryTimeline,
    required this.chargingStops,
    required this.createdAt,
    this.isFavorite = false,
    this.drivingTimeMinutes,
    this.chargingTimeMinutes,
    this.actualCost,
    this.energyConsumedKwh,
    this.vehicleName,
  });

  factory CompletedTripModel.fromJson(Map<String, dynamic> json) {
    return CompletedTripModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      from: LocationPointModel.fromJson(json['from'] as Map<String, dynamic>),
      to: LocationPointModel.fromJson(json['to'] as Map<String, dynamic>),
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
      totalTimeMinutes: json['totalTimeMinutes'] as int? ?? 0,
      stopCount: json['stopCount'] as int? ?? 0,
      estimatedCost: (json['estimatedCost'] as num?)?.toDouble() ?? 0.0,
      batteryTimeline: (json['batteryTimeline'] as List<dynamic>?)
              ?.map((e) => BatteryPointModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      chargingStops: (json['chargingStops'] as List<dynamic>?)
              ?.map((e) =>
                  ChargingStopModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      isFavorite: json['isFavorite'] as bool? ?? false,
      drivingTimeMinutes: json['drivingTimeMinutes'] as int?,
      chargingTimeMinutes: json['chargingTimeMinutes'] as int?,
      actualCost: (json['actualCost'] as num?)?.toDouble(),
      energyConsumedKwh: (json['energyConsumedKwh'] as num?)?.toDouble(),
      vehicleName: json['vehicleName'] as String?,
    );
  }

  final String id;
  final String title;
  final LocationPointModel from;
  final LocationPointModel to;
  final double distanceKm;
  final int totalTimeMinutes;
  final int stopCount;
  final double estimatedCost;
  final List<BatteryPointModel> batteryTimeline;
  final List<ChargingStopModel> chargingStops;
  final DateTime? createdAt;
  final bool isFavorite;
  final int? drivingTimeMinutes;
  final int? chargingTimeMinutes;
  final double? actualCost;
  final double? energyConsumedKwh;
  final String? vehicleName;

  /// Convert to domain entity.
  CompletedTrip toEntity() {
    return CompletedTrip(
      id: id,
      title: title,
      from: from.toEntity(),
      to: to.toEntity(),
      distanceKm: distanceKm,
      totalTime: Duration(minutes: totalTimeMinutes),
      stopCount: stopCount,
      estimatedCost: estimatedCost,
      batteryTimeline: batteryTimeline.map((e) => e.toEntity()).toList(),
      chargingStops: chargingStops,
      createdAt: createdAt ?? DateTime.now(),
      isFavorite: isFavorite,
      drivingTime:
          drivingTimeMinutes != null ? Duration(minutes: drivingTimeMinutes!) : null,
      chargingTime: chargingTimeMinutes != null
          ? Duration(minutes: chargingTimeMinutes!)
          : null,
      actualCost: actualCost,
      energyConsumedKwh: energyConsumedKwh,
      vehicleName: vehicleName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'from': from.toJson(),
      'to': to.toJson(),
      'distanceKm': distanceKm,
      'totalTimeMinutes': totalTimeMinutes,
      'stopCount': stopCount,
      'estimatedCost': estimatedCost,
      'batteryTimeline': batteryTimeline.map((e) => e.toJson()).toList(),
      'chargingStops': chargingStops.map((e) => e.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'isFavorite': isFavorite,
      'drivingTimeMinutes': drivingTimeMinutes,
      'chargingTimeMinutes': chargingTimeMinutes,
      'actualCost': actualCost,
      'energyConsumedKwh': energyConsumedKwh,
      'vehicleName': vehicleName,
    };
  }

  CompletedTripModel copyWith({
    String? id,
    String? title,
    LocationPointModel? from,
    LocationPointModel? to,
    double? distanceKm,
    int? totalTimeMinutes,
    int? stopCount,
    double? estimatedCost,
    List<BatteryPointModel>? batteryTimeline,
    List<ChargingStopModel>? chargingStops,
    DateTime? createdAt,
    bool? isFavorite,
    int? drivingTimeMinutes,
    int? chargingTimeMinutes,
    double? actualCost,
    double? energyConsumedKwh,
    String? vehicleName,
  }) {
    return CompletedTripModel(
      id: id ?? this.id,
      title: title ?? this.title,
      from: from ?? this.from,
      to: to ?? this.to,
      distanceKm: distanceKm ?? this.distanceKm,
      totalTimeMinutes: totalTimeMinutes ?? this.totalTimeMinutes,
      stopCount: stopCount ?? this.stopCount,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      batteryTimeline: batteryTimeline ?? this.batteryTimeline,
      chargingStops: chargingStops ?? this.chargingStops,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
      drivingTimeMinutes: drivingTimeMinutes ?? this.drivingTimeMinutes,
      chargingTimeMinutes: chargingTimeMinutes ?? this.chargingTimeMinutes,
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
        totalTimeMinutes,
        stopCount,
        estimatedCost,
        batteryTimeline,
        chargingStops,
        createdAt,
        isFavorite,
        drivingTimeMinutes,
        chargingTimeMinutes,
        actualCost,
        energyConsumedKwh,
        vehicleName,
      ];
}

/// Location point model for JSON serialization.
class LocationPointModel extends Equatable {
  const LocationPointModel({
    required this.name,
    required this.location,
    this.address,
  });

  factory LocationPointModel.fromJson(Map<String, dynamic> json) {
    return LocationPointModel(
      name: json['name'] as String? ?? '',
      location: LocationModel.fromJson(json['location'] as Map<String, dynamic>),
      address: json['address'] as String?,
    );
  }

  final String name;
  final LocationModel location;
  final String? address;

  LocationPoint toEntity() {
    return LocationPoint(
      name: name,
      location: location,
      address: address,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location.toJson(),
      'address': address,
    };
  }

  @override
  List<Object?> get props => [name, location, address];
}

/// Battery point model for JSON serialization.
class BatteryPointModel extends Equatable {
  const BatteryPointModel({
    required this.distanceKm,
    required this.socPercent,
    this.isChargingStop = false,
    this.label,
  });

  factory BatteryPointModel.fromJson(Map<String, dynamic> json) {
    return BatteryPointModel(
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
      socPercent: (json['socPercent'] as num?)?.toDouble() ?? 0.0,
      isChargingStop: json['isChargingStop'] as bool? ?? false,
      label: json['label'] as String?,
    );
  }

  final double distanceKm;
  final double socPercent;
  final bool isChargingStop;
  final String? label;

  BatteryPoint toEntity() {
    return BatteryPoint(
      distanceKm: distanceKm,
      socPercent: socPercent,
      isChargingStop: isChargingStop,
      label: label,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'distanceKm': distanceKm,
      'socPercent': socPercent,
      'isChargingStop': isChargingStop,
      'label': label,
    };
  }

  @override
  List<Object?> get props => [distanceKm, socPercent, isChargingStop, label];
}
