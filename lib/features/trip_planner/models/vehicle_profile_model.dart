/// File: lib/features/trip_planner/models/vehicle_profile_model.dart
/// Purpose: Vehicle profile model for EV trip planning calculations
/// Belongs To: trip_planner feature
/// Customization Guide:
///    - Adjust default values for different vehicle types
///    - Add fields for advanced efficiency modeling
library;

import 'package:equatable/equatable.dart';

/// Vehicle profile model for EV trip calculations.
/// Contains all vehicle-specific parameters needed for
/// energy consumption and charging time estimates.
class VehicleProfileModel extends Equatable {
  const VehicleProfileModel({
    required this.id,
    required this.name,
    required this.batteryCapacityKwh,
    this.currentSocPercent = 80,
    this.consumptionWhPerKm = 150,
    this.maxChargePowerKw = 150,
    this.reserveSocPercent = 10,
    this.imageUrl,
    this.manufacturer,
    this.model,
    this.year,
    this.isDefault = false,
  });

  /// Create from JSON map.
  factory VehicleProfileModel.fromJson(Map<String, dynamic> json) {
    return VehicleProfileModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      batteryCapacityKwh:
          (json['batteryCapacityKwh'] as num?)?.toDouble() ?? 75.0,
      currentSocPercent:
          (json['currentSocPercent'] as num?)?.toDouble() ?? 80.0,
      consumptionWhPerKm:
          (json['consumptionWhPerKm'] as num?)?.toDouble() ?? 150.0,
      maxChargePowerKw:
          (json['maxChargePowerKw'] as num?)?.toDouble() ?? 150.0,
      reserveSocPercent:
          (json['reserveSocPercent'] as num?)?.toDouble() ?? 10.0,
      imageUrl: json['imageUrl'] as String?,
      manufacturer: json['manufacturer'] as String?,
      model: json['model'] as String?,
      year: json['year'] as int?,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  /// Unique identifier.
  final String id;

  /// Display name (e.g., "My Tesla Model 3").
  final String name;

  /// Usable battery capacity in kWh.
  /// Note: This is usable capacity, not total capacity.
  final double batteryCapacityKwh;

  /// Current state of charge as percentage (0-100).
  final double currentSocPercent;

  /// Energy consumption in Wh per km.
  /// Typical values: 130-200 Wh/km depending on vehicle and conditions.
  final double consumptionWhPerKm;

  /// Maximum charging power in kW that the vehicle can accept.
  /// This is used to estimate charging times.
  final double maxChargePowerKw;

  /// Minimum desired SOC upon arrival (safety reserve).
  /// Trip planner will ensure SOC never drops below this.
  final double reserveSocPercent;

  /// Optional vehicle image URL.
  final String? imageUrl;

  /// Vehicle manufacturer.
  final String? manufacturer;

  /// Vehicle model name.
  final String? model;

  /// Vehicle year.
  final int? year;

  /// Whether this is the default vehicle.
  final bool isDefault;

  /// Get the full vehicle name.
  String get fullName {
    if (manufacturer != null && model != null) {
      return '$manufacturer $model${year != null ? ' ($year)' : ''}';
    }
    return name;
  }

  /// Get consumption in kWh per 100km (common display format).
  double get consumptionKwhPer100Km => consumptionWhPerKm / 10;

  /// Get current energy available in kWh.
  double get currentEnergyKwh =>
      batteryCapacityKwh * (currentSocPercent / 100);

  /// Get usable energy above reserve in kWh.
  double get usableEnergyKwh =>
      batteryCapacityKwh * ((currentSocPercent - reserveSocPercent) / 100);

  /// Get current range in km.
  double get currentRangeKm {
    if (consumptionWhPerKm <= 0) {
      return 0;
    }
    return (currentEnergyKwh * 1000) / consumptionWhPerKm;
  }

  /// Get usable range (above reserve) in km.
  double get usableRangeKm {
    if (consumptionWhPerKm <= 0) {
      return 0;
    }
    return (usableEnergyKwh * 1000) / consumptionWhPerKm;
  }

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'batteryCapacityKwh': batteryCapacityKwh,
      'currentSocPercent': currentSocPercent,
      'consumptionWhPerKm': consumptionWhPerKm,
      'maxChargePowerKw': maxChargePowerKw,
      'reserveSocPercent': reserveSocPercent,
      'imageUrl': imageUrl,
      'manufacturer': manufacturer,
      'model': model,
      'year': year,
      'isDefault': isDefault,
    };
  }

  /// Copy with new values.
  VehicleProfileModel copyWith({
    String? id,
    String? name,
    double? batteryCapacityKwh,
    double? currentSocPercent,
    double? consumptionWhPerKm,
    double? maxChargePowerKw,
    double? reserveSocPercent,
    String? imageUrl,
    String? manufacturer,
    String? model,
    int? year,
    bool? isDefault,
  }) {
    return VehicleProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      batteryCapacityKwh: batteryCapacityKwh ?? this.batteryCapacityKwh,
      currentSocPercent: currentSocPercent ?? this.currentSocPercent,
      consumptionWhPerKm: consumptionWhPerKm ?? this.consumptionWhPerKm,
      maxChargePowerKw: maxChargePowerKw ?? this.maxChargePowerKw,
      reserveSocPercent: reserveSocPercent ?? this.reserveSocPercent,
      imageUrl: imageUrl ?? this.imageUrl,
      manufacturer: manufacturer ?? this.manufacturer,
      model: model ?? this.model,
      year: year ?? this.year,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        batteryCapacityKwh,
        currentSocPercent,
        consumptionWhPerKm,
        maxChargePowerKw,
        reserveSocPercent,
        imageUrl,
        manufacturer,
        model,
        year,
        isDefault,
      ];
}

