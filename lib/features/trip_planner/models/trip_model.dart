/// File: lib/features/trip_planner/models/trip_model.dart
/// Purpose: Main trip model containing all trip planning data
/// Belongs To: trip_planner feature
/// Customization Guide:
///    - Add fields for multi-day trips and overnight stops
///    - Extend for alternative route options
library;

import 'package:equatable/equatable.dart';

import 'charging_stop_model.dart';
import 'location_model.dart';
import 'vehicle_profile_model.dart';

/// Trip preferences for customizing route calculation.
class TripPreferences extends Equatable {
  const TripPreferences({
    this.preferFastChargers = true,
    this.avoidTolls = false,
    this.avoidHighways = false,
    this.minimizeStops = false,
    this.minimizeCost = false,
    this.targetArrivalSoc = 20,
    this.maxChargePerStop = 80,
    this.preferredNetworks = const [],
  });

  factory TripPreferences.fromJson(Map<String, dynamic> json) {
    return TripPreferences(
      preferFastChargers: json['preferFastChargers'] as bool? ?? true,
      avoidTolls: json['avoidTolls'] as bool? ?? false,
      avoidHighways: json['avoidHighways'] as bool? ?? false,
      minimizeStops: json['minimizeStops'] as bool? ?? false,
      minimizeCost: json['minimizeCost'] as bool? ?? false,
      targetArrivalSoc:
          (json['targetArrivalSoc'] as num?)?.toDouble() ?? 20.0,
      maxChargePerStop:
          (json['maxChargePerStop'] as num?)?.toDouble() ?? 80.0,
      preferredNetworks:
          (json['preferredNetworks'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  /// Prefer fast chargers (150+ kW) over slower ones.
  final bool preferFastChargers;

  /// Avoid toll roads.
  final bool avoidTolls;

  /// Avoid highways (scenic route).
  final bool avoidHighways;

  /// Minimize number of stops (longer charges).
  final bool minimizeStops;

  /// Minimize total charging cost.
  final bool minimizeCost;

  /// Target SOC at final destination (%).
  final double targetArrivalSoc;

  /// Maximum SOC to charge to per stop (%).
  final double maxChargePerStop;

  /// Preferred charging networks.
  final List<String> preferredNetworks;

  Map<String, dynamic> toJson() {
    return {
      'preferFastChargers': preferFastChargers,
      'avoidTolls': avoidTolls,
      'avoidHighways': avoidHighways,
      'minimizeStops': minimizeStops,
      'minimizeCost': minimizeCost,
      'targetArrivalSoc': targetArrivalSoc,
      'maxChargePerStop': maxChargePerStop,
      'preferredNetworks': preferredNetworks,
    };
  }

  TripPreferences copyWith({
    bool? preferFastChargers,
    bool? avoidTolls,
    bool? avoidHighways,
    bool? minimizeStops,
    bool? minimizeCost,
    double? targetArrivalSoc,
    double? maxChargePerStop,
    List<String>? preferredNetworks,
  }) {
    return TripPreferences(
      preferFastChargers: preferFastChargers ?? this.preferFastChargers,
      avoidTolls: avoidTolls ?? this.avoidTolls,
      avoidHighways: avoidHighways ?? this.avoidHighways,
      minimizeStops: minimizeStops ?? this.minimizeStops,
      minimizeCost: minimizeCost ?? this.minimizeCost,
      targetArrivalSoc: targetArrivalSoc ?? this.targetArrivalSoc,
      maxChargePerStop: maxChargePerStop ?? this.maxChargePerStop,
      preferredNetworks: preferredNetworks ?? this.preferredNetworks,
    );
  }

  @override
  List<Object?> get props => [
        preferFastChargers,
        avoidTolls,
        avoidHighways,
        minimizeStops,
        minimizeCost,
        targetArrivalSoc,
        maxChargePerStop,
        preferredNetworks,
      ];
}

/// Trip estimates containing all calculated values.
class TripEstimates extends Equatable {
  const TripEstimates({
    required this.totalDistanceKm,
    required this.totalDriveTimeMin,
    required this.totalChargingTimeMin,
    required this.estimatedEnergyKwh,
    required this.estimatedCost,
    required this.arrivalSocPercent,
    required this.requiredStops,
    this.eta,
    this.tollsCost = 0,
    this.socAtEachStopArrival = const [],
    this.socAtEachStopDeparture = const [],
    this.distancePerLeg = const [],
  });

  factory TripEstimates.fromJson(Map<String, dynamic> json) {
    return TripEstimates(
      totalDistanceKm: (json['totalDistanceKm'] as num?)?.toDouble() ?? 0.0,
      totalDriveTimeMin: json['totalDriveTimeMin'] as int? ?? 0,
      totalChargingTimeMin: json['totalChargingTimeMin'] as int? ?? 0,
      estimatedEnergyKwh:
          (json['estimatedEnergyKwh'] as num?)?.toDouble() ?? 0.0,
      estimatedCost: (json['estimatedCost'] as num?)?.toDouble() ?? 0.0,
      arrivalSocPercent:
          (json['arrivalSocPercent'] as num?)?.toDouble() ?? 0.0,
      requiredStops: json['requiredStops'] as int? ?? 0,
      eta: json['eta'] != null
          ? DateTime.tryParse(json['eta'] as String)
          : null,
      tollsCost: (json['tollsCost'] as num?)?.toDouble() ?? 0.0,
      socAtEachStopArrival: (json['socAtEachStopArrival'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      socAtEachStopDeparture:
          (json['socAtEachStopDeparture'] as List<dynamic>?)
                  ?.map((e) => (e as num).toDouble())
                  .toList() ??
              [],
      distancePerLeg: (json['distancePerLeg'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
    );
  }

  /// Total distance in kilometers.
  final double totalDistanceKm;

  /// Total drive time in minutes (excluding charging).
  final int totalDriveTimeMin;

  /// Total charging time in minutes.
  final int totalChargingTimeMin;

  /// Total energy consumption in kWh.
  final double estimatedEnergyKwh;

  /// Total estimated cost (charging + tolls).
  final double estimatedCost;

  /// Expected SOC at final destination.
  final double arrivalSocPercent;

  /// Number of charging stops required.
  final int requiredStops;

  /// Estimated time of arrival.
  final DateTime? eta;

  /// Estimated toll costs.
  final double tollsCost;

  /// SOC at arrival of each stop.
  final List<double> socAtEachStopArrival;

  /// SOC at departure of each stop.
  final List<double> socAtEachStopDeparture;

  /// Distance for each leg of the trip.
  final List<double> distancePerLeg;

  /// Get total trip time in minutes.
  int get totalTripTimeMin => totalDriveTimeMin + totalChargingTimeMin;

  /// Get formatted total time.
  String get formattedTotalTime {
    final hours = totalTripTimeMin ~/ 60;
    final mins = totalTripTimeMin % 60;
    if (hours > 0) {
      return mins > 0 ? '${hours}h ${mins}m' : '${hours}h';
    }
    return '${mins}m';
  }

  /// Get formatted drive time.
  String get formattedDriveTime {
    final hours = totalDriveTimeMin ~/ 60;
    final mins = totalDriveTimeMin % 60;
    if (hours > 0) {
      return mins > 0 ? '${hours}h ${mins}m' : '${hours}h';
    }
    return '${mins}m';
  }

  /// Get formatted charging time.
  String get formattedChargingTime {
    final hours = totalChargingTimeMin ~/ 60;
    final mins = totalChargingTimeMin % 60;
    if (hours > 0) {
      return mins > 0 ? '${hours}h ${mins}m' : '${hours}h';
    }
    return '${mins}m';
  }

  Map<String, dynamic> toJson() {
    return {
      'totalDistanceKm': totalDistanceKm,
      'totalDriveTimeMin': totalDriveTimeMin,
      'totalChargingTimeMin': totalChargingTimeMin,
      'estimatedEnergyKwh': estimatedEnergyKwh,
      'estimatedCost': estimatedCost,
      'arrivalSocPercent': arrivalSocPercent,
      'requiredStops': requiredStops,
      'eta': eta?.toIso8601String(),
      'tollsCost': tollsCost,
      'socAtEachStopArrival': socAtEachStopArrival,
      'socAtEachStopDeparture': socAtEachStopDeparture,
      'distancePerLeg': distancePerLeg,
    };
  }

  @override
  List<Object?> get props => [
        totalDistanceKm,
        totalDriveTimeMin,
        totalChargingTimeMin,
        estimatedEnergyKwh,
        estimatedCost,
        arrivalSocPercent,
        requiredStops,
        eta,
        tollsCost,
        socAtEachStopArrival,
        socAtEachStopDeparture,
        distancePerLeg,
      ];
}

/// Battery data point for graphs.
class BatteryDataPoint extends Equatable {
  const BatteryDataPoint({
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

/// Cost breakdown item for pie chart.
class CostBreakdownItem extends Equatable {
  const CostBreakdownItem({
    required this.label,
    required this.amount,
    required this.colorHex,
  });

  final String label;
  final double amount;
  final String colorHex;

  @override
  List<Object?> get props => [label, amount, colorHex];
}

/// Main trip model.
class TripModel extends Equatable {
  const TripModel({
    required this.id,
    required this.origin,
    required this.destination,
    required this.vehicle,
    this.waypoints = const [],
    this.chargingStops = const [],
    this.preferences = const TripPreferences(),
    this.estimates,
    this.departureTime,
    this.name,
    this.isFavorite = false,
    this.createdAt,
    this.updatedAt,
    this.routePolyline,
    this.batteryGraphData = const [],
    this.costBreakdown = const [],
  });

  /// Create from JSON map.
  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'] as String? ?? '',
      origin: json['origin'] != null
          ? LocationModel.fromJson(json['origin'] as Map<String, dynamic>)
          : const LocationModel(latitude: 0, longitude: 0),
      destination: json['destination'] != null
          ? LocationModel.fromJson(json['destination'] as Map<String, dynamic>)
          : const LocationModel(latitude: 0, longitude: 0),
      vehicle: json['vehicle'] != null
          ? VehicleProfileModel.fromJson(
              json['vehicle'] as Map<String, dynamic>)
          : const VehicleProfileModel(
              id: '', name: '', batteryCapacityKwh: 75),
      waypoints: (json['waypoints'] as List<dynamic>?)
              ?.map((e) => LocationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      chargingStops: (json['chargingStops'] as List<dynamic>?)
              ?.map(
                  (e) => ChargingStopModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      preferences: json['preferences'] != null
          ? TripPreferences.fromJson(
              json['preferences'] as Map<String, dynamic>)
          : const TripPreferences(),
      estimates: json['estimates'] != null
          ? TripEstimates.fromJson(json['estimates'] as Map<String, dynamic>)
          : null,
      departureTime: json['departureTime'] != null
          ? DateTime.tryParse(json['departureTime'] as String)
          : null,
      name: json['name'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      routePolyline: json['routePolyline'] as String?,
    );
  }

  /// Unique trip identifier.
  final String id;

  /// Trip origin location.
  final LocationModel origin;

  /// Trip destination location.
  final LocationModel destination;

  /// Vehicle profile used for this trip.
  final VehicleProfileModel vehicle;

  /// Optional waypoints along the route.
  final List<LocationModel> waypoints;

  /// Planned charging stops.
  final List<ChargingStopModel> chargingStops;

  /// Trip preferences.
  final TripPreferences preferences;

  /// Calculated trip estimates.
  final TripEstimates? estimates;

  /// Planned departure time.
  final DateTime? departureTime;

  /// Optional trip name.
  final String? name;

  /// Whether trip is saved as favorite.
  final bool isFavorite;

  /// Creation timestamp.
  final DateTime? createdAt;

  /// Last update timestamp.
  final DateTime? updatedAt;

  /// Encoded route polyline for map display.
  final String? routePolyline;

  /// Battery level data points for graph.
  final List<BatteryDataPoint> batteryGraphData;

  /// Cost breakdown for pie chart.
  final List<CostBreakdownItem> costBreakdown;

  /// Get display name.
  String get displayName {
    if (name != null && name!.isNotEmpty) {
      return name!;
    }
    return '${origin.shortDisplay} → ${destination.shortDisplay}';
  }

  /// Check if trip requires charging stops.
  bool get requiresCharging => chargingStops.isNotEmpty;

  /// Get total number of stops (waypoints + charging).
  int get totalStops => waypoints.length + chargingStops.length;

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'origin': origin.toJson(),
      'destination': destination.toJson(),
      'vehicle': vehicle.toJson(),
      'waypoints': waypoints.map((w) => w.toJson()).toList(),
      'chargingStops': chargingStops.map((s) => s.toJson()).toList(),
      'preferences': preferences.toJson(),
      'estimates': estimates?.toJson(),
      'departureTime': departureTime?.toIso8601String(),
      'name': name,
      'isFavorite': isFavorite,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'routePolyline': routePolyline,
    };
  }

  /// Copy with new values.
  TripModel copyWith({
    String? id,
    LocationModel? origin,
    LocationModel? destination,
    VehicleProfileModel? vehicle,
    List<LocationModel>? waypoints,
    List<ChargingStopModel>? chargingStops,
    TripPreferences? preferences,
    TripEstimates? estimates,
    DateTime? departureTime,
    String? name,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? routePolyline,
    List<BatteryDataPoint>? batteryGraphData,
    List<CostBreakdownItem>? costBreakdown,
  }) {
    return TripModel(
      id: id ?? this.id,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      vehicle: vehicle ?? this.vehicle,
      waypoints: waypoints ?? this.waypoints,
      chargingStops: chargingStops ?? this.chargingStops,
      preferences: preferences ?? this.preferences,
      estimates: estimates ?? this.estimates,
      departureTime: departureTime ?? this.departureTime,
      name: name ?? this.name,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      routePolyline: routePolyline ?? this.routePolyline,
      batteryGraphData: batteryGraphData ?? this.batteryGraphData,
      costBreakdown: costBreakdown ?? this.costBreakdown,
    );
  }

  @override
  List<Object?> get props => [
        id,
        origin,
        destination,
        vehicle,
        waypoints,
        chargingStops,
        preferences,
        estimates,
        departureTime,
        name,
        isFavorite,
        createdAt,
        updatedAt,
        routePolyline,
        batteryGraphData,
        costBreakdown,
      ];
}

