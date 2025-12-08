/// File: lib/features/vehicle_add/domain/repositories/vehicle_repository.dart
/// Purpose: Vehicle repository interface
/// Belongs To: vehicle_add feature
/// Customization Guide:
///    - Add new repository methods as needed
library;

import '../../core/errors/failure.dart';
import '../entities/entities.dart';

/// Parameters for adding a vehicle.
class AddVehicleParams {
  const AddVehicleParams({
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
  });

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
}

/// Parameters for updating a vehicle.
class UpdateVehicleParams {
  const UpdateVehicleParams({
    required this.vehicleId,
    this.nickName,
    this.make,
    this.model,
    this.year,
    this.batteryCapacityKWh,
    this.vehicleType,
    this.licensePlate,
    this.isDefault,
    this.imageUrl,
  });

  final String vehicleId;
  final String? nickName;
  final String? make;
  final String? model;
  final int? year;
  final double? batteryCapacityKWh;
  final VehicleType? vehicleType;
  final String? licensePlate;
  final bool? isDefault;
  final String? imageUrl;
}

/// Vehicle repository interface.
abstract class VehicleRepository {
  /// Add a new vehicle.
  Future<Either<Failure, Vehicle>> addVehicle(AddVehicleParams params);

  /// Get all vehicles for a user.
  Future<Either<Failure, List<Vehicle>>> getVehicles(String userId);

  /// Get a vehicle by ID.
  Future<Either<Failure, Vehicle>> getVehicle(String vehicleId);

  /// Update a vehicle.
  Future<Either<Failure, Vehicle>> updateVehicle(UpdateVehicleParams params);

  /// Delete a vehicle.
  Future<Either<Failure, void>> deleteVehicle(String vehicleId);

  /// Set a vehicle as default.
  Future<Either<Failure, Vehicle>> setDefaultVehicle(
    String userId,
    String vehicleId,
  );
}

