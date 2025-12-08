/// File: lib/features/vehicle_add/data/datasources/vehicle_local_data_source.dart
/// Purpose: Local data source for vehicles (SharedPreferences + dummy data)
/// Belongs To: vehicle_add feature
/// Customization Guide:
///    - Adjust dummy data as needed
///    - Modify cache expiration logic
library;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';

/// Local data source for vehicles.
class VehicleLocalDataSource {
  VehicleLocalDataSource(this._prefs);

  final SharedPreferences _prefs;
  static const String _vehiclesKey = 'vehicles_cache';
  static const String _vehiclesVersionKey = 'vehicles_cache_version';
  static const int _currentVersion = 1;

  /// Seed dummy data (4 vehicles as per requirements).
  List<VehicleModel> _getDummyVehicles() {
    return [
      VehicleModel(
        id: 'veh_001',
        userId: 'user_abc',
        nickName: 'Daily Bolt',
        make: 'Chevrolet',
        model: 'Bolt EV',
        year: 2021,
        batteryCapacityKWh: 66,
        vehicleType: 'BEV',
        licensePlate: 'MH12AB1234',
        isDefault: true,
        imageUrl: '',
        createdAt: DateTime.parse('2024-06-01T10:00:00Z'),
        updatedAt: DateTime.parse('2024-06-01T10:00:00Z'),
      ),
      VehicleModel(
        id: 'veh_002',
        userId: 'user_abc',
        nickName: 'Family Model',
        make: 'Toyota',
        model: 'Prius Prime',
        year: 2019,
        batteryCapacityKWh: 8.8,
        vehicleType: 'PHEV',
        licensePlate: 'MH14XY4321',
        imageUrl: '',
        createdAt: DateTime.parse('2024-06-02T11:00:00Z'),
        updatedAt: DateTime.parse('2024-06-02T11:00:00Z'),
      ),
      VehicleModel(
        id: 'veh_003',
        userId: 'user_abc',
        nickName: 'Long Trip',
        make: 'Hyundai',
        model: 'Ioniq 5',
        year: 2023,
        batteryCapacityKWh: 77.4,
        vehicleType: 'BEV',
        licensePlate: 'MH12GH6789',
        imageUrl: '',
        createdAt: DateTime.parse('2024-07-10T09:30:00Z'),
        updatedAt: DateTime.parse('2024-07-10T09:30:00Z'),
      ),
      VehicleModel(
        id: 'veh_004',
        userId: 'user_abc',
        nickName: 'Work Runabout',
        make: 'Honda',
        model: 'Civic Hybrid',
        year: 2018,
        batteryCapacityKWh: 1.3,
        vehicleType: 'HEV',
        licensePlate: 'MH12TR5555',
        imageUrl: '',
        createdAt: DateTime.parse('2024-08-20T12:15:00Z'),
        updatedAt: DateTime.parse('2024-08-20T12:15:00Z'),
      ),
    ];
  }

  /// Initialize cache with dummy data if empty.
  Future<void> _initializeCacheIfNeeded() async {
    final version = _prefs.getInt(_vehiclesVersionKey) ?? 0;
    if (version < _currentVersion) {
      // Clear old cache on version change
      await _prefs.remove(_vehiclesKey);
      await _prefs.setInt(_vehiclesVersionKey, _currentVersion);
    }

    final cached = _prefs.getString(_vehiclesKey);
    if (cached == null || cached.isEmpty) {
      // Seed with dummy data
      final dummyVehicles = _getDummyVehicles();
      await cacheVehicles(dummyVehicles);
    }
  }

  /// Get all vehicles from cache.
  Future<List<VehicleModel>> getVehicles(String userId) async {
    await _initializeCacheIfNeeded();

    final cached = _prefs.getString(_vehiclesKey);
    if (cached == null || cached.isEmpty) {
      return [];
    }

    try {
      final jsonList = jsonDecode(cached) as List<dynamic>;
      final vehicles = jsonList
          .map((json) => VehicleModel.fromJson(json as Map<String, dynamic>))
          .where((v) => v.userId == userId)
          .toList();
      return vehicles;
    } catch (e) {
      return [];
    }
  }

  /// Get a vehicle by ID.
  Future<VehicleModel?> getVehicle(String vehicleId) async {
    final vehicles = await getVehicles('');
    try {
      return vehicles.firstWhere((v) => v.id == vehicleId);
    } catch (e) {
      return null;
    }
  }

  /// Cache vehicles list.
  Future<void> cacheVehicles(List<VehicleModel> vehicles) async {
    final jsonList = vehicles.map((v) => v.toJson()).toList();
    await _prefs.setString(_vehiclesKey, jsonEncode(jsonList));
  }

  /// Add a vehicle to cache.
  Future<VehicleModel> addVehicle(VehicleModel vehicle) async {
    final vehicles = await getVehicles('');
    final now = DateTime.now();
    final newVehicle = vehicle.copyWith(
      id: vehicle.id.isEmpty
          ? 'veh_${now.millisecondsSinceEpoch}'
          : vehicle.id,
      createdAt: vehicle.createdAt ?? now,
      updatedAt: now,
    );

    // If setting as default, unset other defaults
    if (newVehicle.isDefault) {
      final updatedVehicles = vehicles.map((v) {
        if (v.isDefault && v.id != newVehicle.id) {
          return v.copyWith(isDefault: false);
        }
        return v;
      }).toList();
      updatedVehicles.add(newVehicle);
      await cacheVehicles(updatedVehicles);
    } else {
      vehicles.add(newVehicle);
      await cacheVehicles(vehicles);
    }

    return newVehicle;
  }

  /// Update a vehicle in cache.
  Future<VehicleModel> updateVehicle(VehicleModel vehicle) async {
    final vehicles = await getVehicles('');
    final index = vehicles.indexWhere((v) => v.id == vehicle.id);
    if (index == -1) {
      throw Exception('Vehicle not found');
    }

    final updated = vehicle.copyWith(updatedAt: DateTime.now());

    // If setting as default, unset other defaults
    if (updated.isDefault) {
      final updatedVehicles = vehicles.map((v) {
        if (v.id == updated.id) {
          return updated;
        } else if (v.isDefault) {
          return v.copyWith(isDefault: false);
        }
        return v;
      }).toList();
      await cacheVehicles(updatedVehicles);
    } else {
      vehicles[index] = updated;
      await cacheVehicles(vehicles);
    }

    return updated;
  }

  /// Delete a vehicle from cache.
  Future<void> deleteVehicle(String vehicleId) async {
    final vehicles = await getVehicles('');
    vehicles.removeWhere((v) => v.id == vehicleId);
    await cacheVehicles(vehicles);
  }

  /// Set default vehicle.
  Future<VehicleModel> setDefaultVehicle(
    String userId,
    String vehicleId,
  ) async {
    final vehicles = await getVehicles(userId);
    final updatedVehicles = vehicles.map((v) {
      if (v.id == vehicleId) {
        return v.copyWith(isDefault: true);
      } else if (v.isDefault) {
        return v.copyWith(isDefault: false);
      }
      return v;
    }).toList();

    await cacheVehicles(updatedVehicles);
    return updatedVehicles.firstWhere((v) => v.id == vehicleId);
  }

  /// Clear all cached vehicles.
  Future<void> clearCache() async {
    await _prefs.remove(_vehiclesKey);
  }
}

