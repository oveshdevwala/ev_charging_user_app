/// File: lib/features/vehicle_add/domain/usecases/get_user_vehicles.dart
/// Purpose: Get user vehicles use case
/// Belongs To: vehicle_add feature
library;

import '../../../../core/errors/failure.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Use case for getting user vehicles.
class GetUserVehicles {
  GetUserVehicles(this.repository);

  final VehicleRepository repository;

  Future<Either<Failure, List<Vehicle>>> call(String userId) {
    return repository.getVehicles(userId);
  }
}

