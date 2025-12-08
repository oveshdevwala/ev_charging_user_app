/// File: lib/features/vehicle_add/domain/entities/vehicle.dart
/// Purpose: Vehicle domain entity
/// Belongs To: vehicle_add feature
/// Customization Guide:
///    - Add new fields as needed
///    - Keep domain layer pure (no Flutter dependencies)
library;

import 'package:equatable/equatable.dart';

/// Vehicle type enum.
enum VehicleType {
  BEV, // Battery Electric Vehicle
  PHEV, // Plug-in Hybrid Electric Vehicle
  HEV, // Hybrid Electric Vehicle
}

/// Vehicle domain entity.
class Vehicle extends Equatable {
  const Vehicle({
    required this.id,
    required this.userId,
    required this.nickName,
    required this.make,
    required this.model,
    required this.year,
    required this.batteryCapacityKWh,
    required this.vehicleType,
    this.licensePlate,
    this.isDefault = false,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String nickName;
  final String make;
  final String model;
  final int year;
  final double batteryCapacityKWh;
  final VehicleType vehicleType;
  final String? licensePlate;
  final bool isDefault;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Get display name (nickname or make + model).
  String get displayName => nickName.isNotEmpty ? nickName : '$make $model';

  /// Get full name (make + model + year).
  String get fullName => '$make $model ($year)';

  @override
  List<Object?> get props => [
        id,
        userId,
        nickName,
        make,
        model,
        year,
        batteryCapacityKWh,
        vehicleType,
        licensePlate,
        isDefault,
        imageUrl,
        createdAt,
        updatedAt,
      ];
}

