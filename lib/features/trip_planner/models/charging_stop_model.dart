/// File: lib/features/trip_planner/models/charging_stop_model.dart
/// Purpose: Charging stop model for planned EV charging during trips
/// Belongs To: trip_planner feature
/// Customization Guide:
///    - Add fields for station amenities and real-time availability
///    - Extend for charging reservation support
library;

import 'package:equatable/equatable.dart';

import 'location_model.dart';

/// Charger type enum for charging stops.
enum ChargingStopType {
  /// Combined Charging System (CCS) - common in Europe/NA.
  ccs,

  /// CHAdeMO - common in Japan.
  chademo,

  /// Tesla Supercharger.
  tesla,

  /// Type 2 AC (slower).
  type2,

  /// Type 1 AC (slower).
  type1,
}

/// Charging stop model representing a planned charging stop.
class ChargingStopModel extends Equatable {
  const ChargingStopModel({
    required this.id,
    required this.stationId,
    required this.stationName,
    required this.location,
    required this.distanceFromStartKm,
    required this.distanceFromPreviousKm,
    required this.arrivalSocPercent,
    required this.departureSocPercent,
    required this.energyToChargeKwh,
    required this.estimatedChargeTimeMin,
    required this.estimatedCost,
    required this.chargerPowerKw,
    this.chargerType = ChargingStopType.ccs,
    this.pricePerKwh = 0.30,
    this.network,
    this.amenities = const [],
    this.isAvailable = true,
    this.arrivalTime,
    this.departureTime,
    this.stopNumber = 1,
  });

  /// Create from JSON map.
  factory ChargingStopModel.fromJson(Map<String, dynamic> json) {
    return ChargingStopModel(
      id: json['id'] as String? ?? '',
      stationId: json['stationId'] as String? ?? '',
      stationName: json['stationName'] as String? ?? '',
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'] as Map<String, dynamic>)
          : const LocationModel(latitude: 0, longitude: 0),
      distanceFromStartKm:
          (json['distanceFromStartKm'] as num?)?.toDouble() ?? 0.0,
      distanceFromPreviousKm:
          (json['distanceFromPreviousKm'] as num?)?.toDouble() ?? 0.0,
      arrivalSocPercent:
          (json['arrivalSocPercent'] as num?)?.toDouble() ?? 0.0,
      departureSocPercent:
          (json['departureSocPercent'] as num?)?.toDouble() ?? 80.0,
      energyToChargeKwh:
          (json['energyToChargeKwh'] as num?)?.toDouble() ?? 0.0,
      estimatedChargeTimeMin: json['estimatedChargeTimeMin'] as int? ?? 30,
      estimatedCost: (json['estimatedCost'] as num?)?.toDouble() ?? 0.0,
      chargerPowerKw: (json['chargerPowerKw'] as num?)?.toDouble() ?? 50.0,
      chargerType: ChargingStopType.values.firstWhere(
        (t) => t.name == json['chargerType'],
        orElse: () => ChargingStopType.ccs,
      ),
      pricePerKwh: (json['pricePerKwh'] as num?)?.toDouble() ?? 0.30,
      network: json['network'] as String?,
      amenities: (json['amenities'] as List<dynamic>?)?.cast<String>() ?? [],
      isAvailable: json['isAvailable'] as bool? ?? true,
      arrivalTime: json['arrivalTime'] != null
          ? DateTime.tryParse(json['arrivalTime'] as String)
          : null,
      departureTime: json['departureTime'] != null
          ? DateTime.tryParse(json['departureTime'] as String)
          : null,
      stopNumber: json['stopNumber'] as int? ?? 1,
    );
  }

  /// Unique stop identifier.
  final String id;

  /// Charging station ID.
  final String stationId;

  /// Station name.
  final String stationName;

  /// Station location.
  final LocationModel location;

  /// Distance from trip start to this stop (km).
  final double distanceFromStartKm;

  /// Distance from previous stop or origin (km).
  final double distanceFromPreviousKm;

  /// Expected SOC when arriving at this stop (%).
  final double arrivalSocPercent;

  /// Target SOC when departing this stop (%).
  final double departureSocPercent;

  /// Energy to charge at this stop (kWh).
  final double energyToChargeKwh;

  /// Estimated charging time in minutes.
  final int estimatedChargeTimeMin;

  /// Estimated cost for charging at this stop.
  final double estimatedCost;

  /// Charger power in kW.
  final double chargerPowerKw;

  /// Charger connector type.
  final ChargingStopType chargerType;

  /// Price per kWh at this station.
  final double pricePerKwh;

  /// Charging network name (e.g., "Electrify America").
  final String? network;

  /// Available amenities at this stop.
  final List<String> amenities;

  /// Whether the charger is currently available.
  final bool isAvailable;

  /// Expected arrival time.
  final DateTime? arrivalTime;

  /// Expected departure time after charging.
  final DateTime? departureTime;

  /// Stop number in sequence (1, 2, 3...).
  final int stopNumber;

  /// Get formatted charging time (e.g., "25 min").
  String get formattedChargeTime {
    if (estimatedChargeTimeMin >= 60) {
      final hours = estimatedChargeTimeMin ~/ 60;
      final mins = estimatedChargeTimeMin % 60;
      return mins > 0 ? '${hours}h ${mins}m' : '${hours}h';
    }
    return '${estimatedChargeTimeMin}m';
  }

  /// Get charger type display name.
  String get chargerTypeDisplay {
    switch (chargerType) {
      case ChargingStopType.ccs:
        return 'CCS';
      case ChargingStopType.chademo:
        return 'CHAdeMO';
      case ChargingStopType.tesla:
        return 'Tesla SC';
      case ChargingStopType.type2:
        return 'Type 2';
      case ChargingStopType.type1:
        return 'Type 1';
    }
  }

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stationId': stationId,
      'stationName': stationName,
      'location': location.toJson(),
      'distanceFromStartKm': distanceFromStartKm,
      'distanceFromPreviousKm': distanceFromPreviousKm,
      'arrivalSocPercent': arrivalSocPercent,
      'departureSocPercent': departureSocPercent,
      'energyToChargeKwh': energyToChargeKwh,
      'estimatedChargeTimeMin': estimatedChargeTimeMin,
      'estimatedCost': estimatedCost,
      'chargerPowerKw': chargerPowerKw,
      'chargerType': chargerType.name,
      'pricePerKwh': pricePerKwh,
      'network': network,
      'amenities': amenities,
      'isAvailable': isAvailable,
      'arrivalTime': arrivalTime?.toIso8601String(),
      'departureTime': departureTime?.toIso8601String(),
      'stopNumber': stopNumber,
    };
  }

  /// Copy with new values.
  ChargingStopModel copyWith({
    String? id,
    String? stationId,
    String? stationName,
    LocationModel? location,
    double? distanceFromStartKm,
    double? distanceFromPreviousKm,
    double? arrivalSocPercent,
    double? departureSocPercent,
    double? energyToChargeKwh,
    int? estimatedChargeTimeMin,
    double? estimatedCost,
    double? chargerPowerKw,
    ChargingStopType? chargerType,
    double? pricePerKwh,
    String? network,
    List<String>? amenities,
    bool? isAvailable,
    DateTime? arrivalTime,
    DateTime? departureTime,
    int? stopNumber,
  }) {
    return ChargingStopModel(
      id: id ?? this.id,
      stationId: stationId ?? this.stationId,
      stationName: stationName ?? this.stationName,
      location: location ?? this.location,
      distanceFromStartKm: distanceFromStartKm ?? this.distanceFromStartKm,
      distanceFromPreviousKm:
          distanceFromPreviousKm ?? this.distanceFromPreviousKm,
      arrivalSocPercent: arrivalSocPercent ?? this.arrivalSocPercent,
      departureSocPercent: departureSocPercent ?? this.departureSocPercent,
      energyToChargeKwh: energyToChargeKwh ?? this.energyToChargeKwh,
      estimatedChargeTimeMin:
          estimatedChargeTimeMin ?? this.estimatedChargeTimeMin,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      chargerPowerKw: chargerPowerKw ?? this.chargerPowerKw,
      chargerType: chargerType ?? this.chargerType,
      pricePerKwh: pricePerKwh ?? this.pricePerKwh,
      network: network ?? this.network,
      amenities: amenities ?? this.amenities,
      isAvailable: isAvailable ?? this.isAvailable,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      departureTime: departureTime ?? this.departureTime,
      stopNumber: stopNumber ?? this.stopNumber,
    );
  }

  @override
  List<Object?> get props => [
        id,
        stationId,
        stationName,
        location,
        distanceFromStartKm,
        distanceFromPreviousKm,
        arrivalSocPercent,
        departureSocPercent,
        energyToChargeKwh,
        estimatedChargeTimeMin,
        estimatedCost,
        chargerPowerKw,
        chargerType,
        pricePerKwh,
        network,
        amenities,
        isAvailable,
        arrivalTime,
        departureTime,
        stopNumber,
      ];
}

