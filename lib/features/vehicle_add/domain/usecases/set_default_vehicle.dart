/// File: lib/features/vehicle_add/domain/usecases/set_default_vehicle.dart
/// Purpose: Set default vehicle use case
/// Belongs To: vehicle_add feature
library;

import '../../../../core/errors/failure.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Use case for setting a default vehicle.
class SetDefaultVehicle {
  SetDefaultVehicle(this.repository);

  final VehicleRepository repository;

  Future<Either<Failure, Vehicle>> call(String userId, String vehicleId) {
    return repository.setDefaultVehicle(userId, vehicleId);
  }
}
