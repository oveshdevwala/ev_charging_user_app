/// File: lib/features/vehicle_add/data/datasources/vehicle_remote_data_source.dart
/// Purpose: Remote data source for vehicles (API integration)
/// Belongs To: vehicle_add feature
/// Customization Guide:
///    - Replace with actual API client when backend is ready
///    - Add authentication headers
///    - Handle network errors appropriately
library;

import '../models/models.dart';

/// Remote data source interface for vehicles.
abstract class VehicleRemoteDataSource {
  /// Add a vehicle via API.
  Future<VehicleModel> addVehicle(VehicleModel vehicle);

  /// Get all vehicles for a user via API.
  Future<List<VehicleModel>> getVehicles(String userId);

  /// Get a vehicle by ID via API.
  Future<VehicleModel> getVehicle(String vehicleId);

  /// Update a vehicle via API.
  Future<VehicleModel> updateVehicle(VehicleModel vehicle);

  /// Delete a vehicle via API.
  Future<void> deleteVehicle(String vehicleId);

  /// Set default vehicle via API.
  Future<VehicleModel> setDefaultVehicle(String userId, String vehicleId);
}

/// Implementation of remote data source (currently mock).
class VehicleRemoteDataSourceImpl implements VehicleRemoteDataSource {
  VehicleRemoteDataSourceImpl();

  // TODO: Replace with actual HTTP client
  // final Dio _dio;
  // final String _baseUrl;

  @override
  Future<VehicleModel> addVehicle(VehicleModel vehicle) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // TODO: Replace with actual API call
    // final response = await _dio.post(
    //   '$_baseUrl/v1/users/${vehicle.userId}/vehicles',
    //   data: vehicle.toJson(),
    // );
    // return VehicleModel.fromJson(response.data);

    // Mock implementation
    final now = DateTime.now();
    return vehicle.copyWith(
      id: 'veh_${DateTime.now().millisecondsSinceEpoch}',
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  Future<List<VehicleModel>> getVehicles(String userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // TODO: Replace with actual API call
    // final response = await _dio.get('$_baseUrl/v1/users/$userId/vehicles');
    // return (response.data as List)
    //     .map((json) => VehicleModel.fromJson(json))
    //     .toList();

    // Mock implementation - return empty list
    // Real data comes from local data source when useMock is true
    return [];
  }

  @override
  Future<VehicleModel> getVehicle(String vehicleId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // TODO: Replace with actual API call
    throw UnimplementedError('getVehicle not implemented');
  }

  @override
  Future<VehicleModel> updateVehicle(VehicleModel vehicle) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // TODO: Replace with actual API call
    // final response = await _dio.put(
    //   '$_baseUrl/v1/users/${vehicle.userId}/vehicles/${vehicle.id}',
    //   data: vehicle.toJson(),
    // );
    // return VehicleModel.fromJson(response.data);

    return vehicle.copyWith(updatedAt: DateTime.now());
  }

  @override
  Future<void> deleteVehicle(String vehicleId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // TODO: Replace with actual API call
    // await _dio.delete('$_baseUrl/v1/users/{userId}/vehicles/$vehicleId');
  }

  @override
  Future<VehicleModel> setDefaultVehicle(
    String userId,
    String vehicleId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // TODO: Replace with actual API call
    // final response = await _dio.put(
    //   '$_baseUrl/v1/users/$userId/vehicles/$vehicleId/set-default',
    // );
    // return VehicleModel.fromJson(response.data);

    throw UnimplementedError('setDefaultVehicle not implemented');
  }
}

