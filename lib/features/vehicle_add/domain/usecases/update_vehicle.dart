/// File: lib/features/vehicle_add/domain/usecases/update_vehicle.dart
/// Purpose: Update vehicle use case
/// Belongs To: vehicle_add feature
library;

import '../../../../core/errors/failure.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Use case for updating a vehicle.
class UpdateVehicle {
  UpdateVehicle(this.repository);

  final VehicleRepository repository;

  Future<Either<Failure, Vehicle>> call(UpdateVehicleParams params) {
    return repository.updateVehicle(params);
  }
}
