/// File: lib/features/vehicle_add/data/models/vehicle_model.dart
/// Purpose: Vehicle data model with JSON serialization
/// Belongs To: vehicle_add feature
/// Customization Guide:
///    - Run build_runner to generate .g.dart file
///    - Command: flutter pub run build_runner build --delete-conflicting-outputs
library;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/entities.dart';

part 'vehicle_model.g.dart';

/// Vehicle data model.
@JsonSerializable()
class VehicleModel extends Equatable {
  const VehicleModel({
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

  factory VehicleModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleModelFromJson(json);

  factory VehicleModel.fromEntity(Vehicle entity) {
    return VehicleModel(
      id: entity.id,
      userId: entity.userId,
      nickName: entity.nickName,
      make: entity.make,
      model: entity.model,
      year: entity.year,
      batteryCapacityKWh: entity.batteryCapacityKWh,
      vehicleType: _vehicleTypeToString(entity.vehicleType),
      licensePlate: entity.licensePlate,
      isDefault: entity.isDefault,
      imageUrl: entity.imageUrl,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  final String id;
  final String userId;
  final String nickName;
  final String make;
  final String model;
  final int year;
  final double batteryCapacityKWh;

  @JsonKey(name: 'vehicleType')
  final String vehicleType; // Stored as string: "BEV", "PHEV", "HEV"

  final String? licensePlate;
  final bool isDefault;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() => _$VehicleModelToJson(this);

  /// Convert to domain entity.
  Vehicle toEntity() {
    return Vehicle(
      id: id,
      userId: userId,
      nickName: nickName,
      make: make,
      model: model,
      year: year,
      batteryCapacityKWh: batteryCapacityKWh,
      vehicleType: _stringToVehicleType(vehicleType),
      licensePlate: licensePlate,
      isDefault: isDefault,
      imageUrl: imageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Copy with new values.
  VehicleModel copyWith({
    String? id,
    String? userId,
    String? nickName,
    String? make,
    String? model,
    int? year,
    double? batteryCapacityKWh,
    String? vehicleType,
    String? licensePlate,
    bool? isDefault,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      nickName: nickName ?? this.nickName,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      batteryCapacityKWh: batteryCapacityKWh ?? this.batteryCapacityKWh,
      vehicleType: vehicleType ?? this.vehicleType,
      licensePlate: licensePlate ?? this.licensePlate,
      isDefault: isDefault ?? this.isDefault,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

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

  /// Helper: Convert VehicleType enum to string.
  static String _vehicleTypeToString(VehicleType type) {
    switch (type) {
      case VehicleType.BEV:
        return 'BEV';
      case VehicleType.PHEV:
        return 'PHEV';
      case VehicleType.HEV:
        return 'HEV';
    }
  }

  /// Helper: Convert string to VehicleType enum.
  static VehicleType _stringToVehicleType(String type) {
    switch (type.toUpperCase()) {
      case 'BEV':
        return VehicleType.BEV;
      case 'PHEV':
        return VehicleType.PHEV;
      case 'HEV':
        return VehicleType.HEV;
      default:
        return VehicleType.BEV; // Default fallback
    }
  }
}
