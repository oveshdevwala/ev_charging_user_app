/// File: lib/features/vehicle_add/domain/usecases/delete_vehicle.dart
/// Purpose: Delete vehicle use case
/// Belongs To: vehicle_add feature
library;

import '../../../../core/errors/failure.dart';
import '../repositories/repositories.dart';

/// Use case for deleting a vehicle.
class DeleteVehicle {
  DeleteVehicle(this.repository);

  final VehicleRepository repository;

  Future<Either<Failure, void>> call(String vehicleId) {
    return repository.deleteVehicle(vehicleId);
  }
}

