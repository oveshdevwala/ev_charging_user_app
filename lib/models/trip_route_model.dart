/// File: lib/models/trip_route_model.dart
/// Purpose: Trip route and trip stop models for EV trip planning
/// Belongs To: shared
/// Customization Guide:
///    - Add new fields for route optimization
///    - Extend TripStop for more charging details

import 'package:equatable/equatable.dart';

/// Trip stop model representing a charging stop on a route.
class TripStop extends Equatable {
  const TripStop({
    required this.id,
    required this.stationId,
    required this.stationName,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.estimatedChargeTimeMin = 30,
    this.estimatedCost = 0.0,
    this.distanceFromPrevious = 0.0,
    this.chargerPowerKw = 50.0,
  });

  final String id;
  final String stationId;
  final String stationName;
  final String address;
  final double latitude;
  final double longitude;
  final int estimatedChargeTimeMin;
  final double estimatedCost;
  final double distanceFromPrevious;
  final double chargerPowerKw;

  /// Create from JSON map.
  factory TripStop.fromJson(Map<String, dynamic> json) {
    return TripStop(
      id: json['id'] as String? ?? '',
      stationId: json['stationId'] as String? ?? '',
      stationName: json['stationName'] as String? ?? '',
      address: json['address'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      estimatedChargeTimeMin: json['estimatedChargeTimeMin'] as int? ?? 30,
      estimatedCost: (json['estimatedCost'] as num?)?.toDouble() ?? 0.0,
      distanceFromPrevious:
          (json['distanceFromPrevious'] as num?)?.toDouble() ?? 0.0,
      chargerPowerKw: (json['chargerPowerKw'] as num?)?.toDouble() ?? 50.0,
    );
  }

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stationId': stationId,
      'stationName': stationName,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'estimatedChargeTimeMin': estimatedChargeTimeMin,
      'estimatedCost': estimatedCost,
      'distanceFromPrevious': distanceFromPrevious,
      'chargerPowerKw': chargerPowerKw,
    };
  }

  /// Copy with new values.
  TripStop copyWith({
    String? id,
    String? stationId,
    String? stationName,
    String? address,
    double? latitude,
    double? longitude,
    int? estimatedChargeTimeMin,
    double? estimatedCost,
    double? distanceFromPrevious,
    double? chargerPowerKw,
  }) {
    return TripStop(
      id: id ?? this.id,
      stationId: stationId ?? this.stationId,
      stationName: stationName ?? this.stationName,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      estimatedChargeTimeMin:
          estimatedChargeTimeMin ?? this.estimatedChargeTimeMin,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      distanceFromPrevious: distanceFromPrevious ?? this.distanceFromPrevious,
      chargerPowerKw: chargerPowerKw ?? this.chargerPowerKw,
    );
  }

  @override
  List<Object?> get props => [
        id,
        stationId,
        stationName,
        address,
        latitude,
        longitude,
        estimatedChargeTimeMin,
        estimatedCost,
        distanceFromPrevious,
        chargerPowerKw,
      ];
}

/// Trip energy estimation model.
class TripEnergyEstimation extends Equatable {
  const TripEnergyEstimation({
    required this.totalDistanceKm,
    required this.estimatedEnergyKwh,
    required this.estimatedCost,
    required this.estimatedTimeMin,
    this.requiredStops = 0,
    this.batteryStartPercent = 80,
    this.batteryEndPercent = 20,
  });

  final double totalDistanceKm;
  final double estimatedEnergyKwh;
  final double estimatedCost;
  final int estimatedTimeMin;
  final int requiredStops;
  final int batteryStartPercent;
  final int batteryEndPercent;

  /// Format estimated time as hours:minutes.
  String get formattedTime {
    final hours = estimatedTimeMin ~/ 60;
    final minutes = estimatedTimeMin % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  /// Create from JSON map.
  factory TripEnergyEstimation.fromJson(Map<String, dynamic> json) {
    return TripEnergyEstimation(
      totalDistanceKm: (json['totalDistanceKm'] as num?)?.toDouble() ?? 0.0,
      estimatedEnergyKwh:
          (json['estimatedEnergyKwh'] as num?)?.toDouble() ?? 0.0,
      estimatedCost: (json['estimatedCost'] as num?)?.toDouble() ?? 0.0,
      estimatedTimeMin: json['estimatedTimeMin'] as int? ?? 0,
      requiredStops: json['requiredStops'] as int? ?? 0,
      batteryStartPercent: json['batteryStartPercent'] as int? ?? 80,
      batteryEndPercent: json['batteryEndPercent'] as int? ?? 20,
    );
  }

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'totalDistanceKm': totalDistanceKm,
      'estimatedEnergyKwh': estimatedEnergyKwh,
      'estimatedCost': estimatedCost,
      'estimatedTimeMin': estimatedTimeMin,
      'requiredStops': requiredStops,
      'batteryStartPercent': batteryStartPercent,
      'batteryEndPercent': batteryEndPercent,
    };
  }

  @override
  List<Object?> get props => [
        totalDistanceKm,
        estimatedEnergyKwh,
        estimatedCost,
        estimatedTimeMin,
        requiredStops,
        batteryStartPercent,
        batteryEndPercent,
      ];
}

/// Trip route model for saved/planned routes.
class TripRouteModel extends Equatable {
  const TripRouteModel({
    required this.id,
    required this.from,
    required this.to,
    required this.fromAddress,
    required this.toAddress,
    this.distance = 0.0,
    this.stops = const [],
    this.estimation,
    this.createdAt,
    this.isFavorite = false,
    this.name,
  });

  final String id;
  final String from;
  final String to;
  final String fromAddress;
  final String toAddress;
  final double distance;
  final List<TripStop> stops;
  final TripEnergyEstimation? estimation;
  final DateTime? createdAt;
  final bool isFavorite;
  final String? name;

  /// Display name for the route.
  String get displayName => name ?? '$from → $to';

  /// Total stops count.
  int get stopsCount => stops.length;

  /// Create from JSON map.
  factory TripRouteModel.fromJson(Map<String, dynamic> json) {
    return TripRouteModel(
      id: json['id'] as String? ?? '',
      from: json['from'] as String? ?? '',
      to: json['to'] as String? ?? '',
      fromAddress: json['fromAddress'] as String? ?? '',
      toAddress: json['toAddress'] as String? ?? '',
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      stops: (json['stops'] as List<dynamic>?)
              ?.map((e) => TripStop.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      estimation: json['estimation'] != null
          ? TripEnergyEstimation.fromJson(
              json['estimation'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      isFavorite: json['isFavorite'] as bool? ?? false,
      name: json['name'] as String?,
    );
  }

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from': from,
      'to': to,
      'fromAddress': fromAddress,
      'toAddress': toAddress,
      'distance': distance,
      'stops': stops.map((e) => e.toJson()).toList(),
      'estimation': estimation?.toJson(),
      'createdAt': createdAt?.toIso8601String(),
      'isFavorite': isFavorite,
      'name': name,
    };
  }

  /// Copy with new values.
  TripRouteModel copyWith({
    String? id,
    String? from,
    String? to,
    String? fromAddress,
    String? toAddress,
    double? distance,
    List<TripStop>? stops,
    TripEnergyEstimation? estimation,
    DateTime? createdAt,
    bool? isFavorite,
    String? name,
  }) {
    return TripRouteModel(
      id: id ?? this.id,
      from: from ?? this.from,
      to: to ?? this.to,
      fromAddress: fromAddress ?? this.fromAddress,
      toAddress: toAddress ?? this.toAddress,
      distance: distance ?? this.distance,
      stops: stops ?? this.stops,
      estimation: estimation ?? this.estimation,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [
        id,
        from,
        to,
        fromAddress,
        toAddress,
        distance,
        stops,
        estimation,
        createdAt,
        isFavorite,
        name,
      ];
}

