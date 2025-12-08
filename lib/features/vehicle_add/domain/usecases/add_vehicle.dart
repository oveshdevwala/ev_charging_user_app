/// File: lib/features/vehicle_add/domain/usecases/add_vehicle.dart
/// Purpose: Add vehicle use case
/// Belongs To: vehicle_add feature
library;

import '../../../../core/errors/failure.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Use case for adding a vehicle.
class AddVehicle {
  AddVehicle(this.repository);

  final VehicleRepository repository;

  Future<Either<Failure, Vehicle>> call(AddVehicleParams params) {
    return repository.addVehicle(params);
  }
}

