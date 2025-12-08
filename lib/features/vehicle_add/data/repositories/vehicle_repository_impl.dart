/// File: lib/features/vehicle_add/data/repositories/vehicle_repository_impl.dart
/// Purpose: Vehicle repository implementation
/// Belongs To: vehicle_add feature
/// Customization Guide:
///    - Adjust error handling as needed
///    - Modify retry logic
library;

import '../../core/config/config.dart';
import '../../core/errors/failure.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/datasources.dart';
import '../models/models.dart';

/// Vehicle repository implementation.
class VehicleRepositoryImpl implements VehicleRepository {
  VehicleRepositoryImpl({
    required VehicleRemoteDataSource remoteDataSource,
    required VehicleLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final VehicleRemoteDataSource _remoteDataSource;
  final VehicleLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, Vehicle>> addVehicle(AddVehicleParams params) async {
    try {
      final model = VehicleModel(
        id: '',
        userId: params.userId,
        nickName: params.nickName,
        make: params.make,
        model: params.model,
        year: params.year,
        batteryCapacityKWh: params.batteryCapacityKWh,
        vehicleType: _vehicleTypeToString(params.vehicleType),
        licensePlate: params.licensePlate,
        isDefault: params.isDefault,
        imageUrl: params.imageUrl,
      );

      VehicleModel result;
      if (Config.useMock) {
        result = await _localDataSource.addVehicle(model);
      } else {
        try {
          result = await _remoteDataSource.addVehicle(model);
          // Cache the result
          await _localDataSource.addVehicle(result);
        } catch (e) {
          // Fallback to local on network error
          result = await _localDataSource.addVehicle(model);
          return Either.left(
            NetworkFailure(message: 'Network error: ${e.toString()}'),
          );
        }
      }

      return Either.right(result.toEntity());
    } on ValidationFailure catch (e) {
      return Either.left(e);
    } catch (e) {
      return Either.left(
        UnknownFailure(message: 'Failed to add vehicle: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Vehicle>>> getVehicles(String userId) async {
    try {
      List<VehicleModel> models;
      if (Config.useMock) {
        models = await _localDataSource.getVehicles(userId);
      } else {
        try {
          models = await _remoteDataSource.getVehicles(userId);
          // Cache the results
          await _localDataSource.cacheVehicles(models);
        } catch (e) {
          // Fallback to local on network error
          models = await _localDataSource.getVehicles(userId);
          if (models.isEmpty) {
            return Either.left(
              NetworkFailure(message: 'Network error: ${e.toString()}'),
            );
          }
        }
      }

      return Either.right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Either.left(
        UnknownFailure(message: 'Failed to get vehicles: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Vehicle>> getVehicle(String vehicleId) async {
    try {
      VehicleModel? model;
      if (Config.useMock) {
        model = await _localDataSource.getVehicle(vehicleId);
      } else {
        try {
          model = await _remoteDataSource.getVehicle(vehicleId);
        } catch (e) {
          model = await _localDataSource.getVehicle(vehicleId);
        }
      }

      if (model == null) {
        return Either.left(
          UnknownFailure(message: 'Vehicle not found'),
        );
      }

      return Either.right(model.toEntity());
    } catch (e) {
      return Either.left(
        UnknownFailure(message: 'Failed to get vehicle: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Vehicle>> updateVehicle(
    UpdateVehicleParams params,
  ) async {
    try {
      final existing = await _localDataSource.getVehicle(params.vehicleId);
      if (existing == null) {
        return Either.left(
          UnknownFailure(message: 'Vehicle not found'),
        );
      }

      final updated = existing.copyWith(
        nickName: params.nickName,
        make: params.make,
        model: params.model,
        year: params.year,
        batteryCapacityKWh: params.batteryCapacityKWh,
        vehicleType: params.vehicleType != null
            ? _vehicleTypeToString(params.vehicleType!)
            : null,
        licensePlate: params.licensePlate,
        isDefault: params.isDefault,
        imageUrl: params.imageUrl,
      );

      VehicleModel result;
      if (Config.useMock) {
        result = await _localDataSource.updateVehicle(updated);
      } else {
        try {
          result = await _remoteDataSource.updateVehicle(updated);
          await _localDataSource.updateVehicle(result);
        } catch (e) {
          result = await _localDataSource.updateVehicle(updated);
          return Either.left(
            NetworkFailure(message: 'Network error: ${e.toString()}'),
          );
        }
      }

      return Either.right(result.toEntity());
    } catch (e) {
      return Either.left(
        UnknownFailure(message: 'Failed to update vehicle: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteVehicle(String vehicleId) async {
    try {
      if (Config.useMock) {
        await _localDataSource.deleteVehicle(vehicleId);
      } else {
        try {
          await _remoteDataSource.deleteVehicle(vehicleId);
          await _localDataSource.deleteVehicle(vehicleId);
        } catch (e) {
          await _localDataSource.deleteVehicle(vehicleId);
          return Either.left(
            NetworkFailure(message: 'Network error: ${e.toString()}'),
          );
        }
      }

      return Either.right(null);
    } catch (e) {
      return Either.left(
        UnknownFailure(message: 'Failed to delete vehicle: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Vehicle>> setDefaultVehicle(
    String userId,
    String vehicleId,
  ) async {
    try {
      VehicleModel result;
      if (Config.useMock) {
        result = await _localDataSource.setDefaultVehicle(userId, vehicleId);
      } else {
        try {
          result = await _remoteDataSource.setDefaultVehicle(userId, vehicleId);
          // Update local cache
          final vehicles = await _localDataSource.getVehicles(userId);
          final updatedVehicles = vehicles.map((v) {
            if (v.id == vehicleId) {
              return v.copyWith(isDefault: true);
            } else if (v.isDefault) {
              return v.copyWith(isDefault: false);
            }
            return v;
          }).toList();
          await _localDataSource.cacheVehicles(updatedVehicles);
        } catch (e) {
          result = await _localDataSource.setDefaultVehicle(userId, vehicleId);
          return Either.left(
            NetworkFailure(message: 'Network error: ${e.toString()}'),
          );
        }
      }

      return Either.right(result.toEntity());
    } catch (e) {
      return Either.left(
        UnknownFailure(
          message: 'Failed to set default vehicle: ${e.toString()}',
        ),
      );
    }
  }

  /// Helper: Convert VehicleType enum to string.
  String _vehicleTypeToString(VehicleType type) {
    switch (type) {
      case VehicleType.BEV:
        return 'BEV';
      case VehicleType.PHEV:
        return 'PHEV';
      case VehicleType.HEV:
        return 'HEV';
    }
  }
}

