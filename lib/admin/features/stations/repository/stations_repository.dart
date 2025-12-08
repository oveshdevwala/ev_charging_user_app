/// File: lib/admin/features/stations/repository/stations_repository.dart
/// Purpose: Stations repository for admin panel
/// Belongs To: admin/features/stations
library;

import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../core/constants/admin_assets.dart';
import '../../../models/admin_station_model.dart';

/// Stations repository for managing station data.
class StationsRepository {
  StationsRepository();

  List<AdminStation> _cachedStations = [];

  /// Load all stations from dummy data.
  Future<List<AdminStation>> getStations({
    String? searchQuery,
    AdminStationStatus? status,
    String? sortBy,
    bool ascending = true,
  }) async {
    if (_cachedStations.isEmpty) {
      await _loadStations();
    }

    var stations = List<AdminStation>.from(_cachedStations);

    // Filter by search query
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      stations = stations.where((s) {
        return s.name.toLowerCase().contains(query) ||
            s.address.toLowerCase().contains(query) ||
            s.id.toLowerCase().contains(query);
      }).toList();
    }

    // Filter by status
    if (status != null) {
      stations = stations.where((s) => s.status == status).toList();
    }

    // Sort
    if (sortBy != null) {
      stations.sort((a, b) {
        int comparison;
        switch (sortBy) {
          case 'name':
            comparison = a.name.compareTo(b.name);
            break;
          case 'createdAt':
            comparison = a.createdAt.compareTo(b.createdAt);
            break;
          case 'rating':
            comparison = (a.rating ?? 0).compareTo(b.rating ?? 0);
            break;
          case 'totalSessions':
            comparison = (a.totalSessions ?? 0).compareTo(b.totalSessions ?? 0);
            break;
          case 'totalRevenue':
            comparison = (a.totalRevenue ?? 0).compareTo(b.totalRevenue ?? 0);
            break;
          default:
            comparison = 0;
        }
        return ascending ? comparison : -comparison;
      });
    }

    return stations;
  }

  /// Get station by ID.
  Future<AdminStation?> getStationById(String id) async {
    if (_cachedStations.isEmpty) {
      await _loadStations();
    }
    try {
      return _cachedStations.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Create a new station.
  Future<AdminStation> createStation(AdminStation station) async {
    final newStation = station.copyWith(
      id: 'st_${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _cachedStations.add(newStation);
    return newStation;
  }

  /// Update an existing station.
  Future<AdminStation> updateStation(AdminStation station) async {
    final index = _cachedStations.indexWhere((s) => s.id == station.id);
    if (index == -1) {
      throw Exception('Station not found');
    }
    final updatedStation = station.copyWith(updatedAt: DateTime.now());
    _cachedStations[index] = updatedStation;
    return updatedStation;
  }

  /// Delete a station.
  Future<void> deleteStation(String id) async {
    _cachedStations.removeWhere((s) => s.id == id);
  }

  /// Assign manager to station.
  Future<AdminStation> assignManager(
    String stationId,
    String managerId,
    String managerName,
  ) async {
    final station = await getStationById(stationId);
    if (station == null) {
      throw Exception('Station not found');
    }
    return updateStation(
      station.copyWith(managerId: managerId, managerName: managerName),
    );
  }

  /// Unassign manager from station.
  Future<AdminStation> unassignManager(String stationId) async {
    final station = await getStationById(stationId);
    if (station == null) {
      throw Exception('Station not found');
    }
    // Using empty string to clear manager
    return updateStation(
      AdminStation(
        id: station.id,
        name: station.name,
        address: station.address,
        latitude: station.latitude,
        longitude: station.longitude,
        status: station.status,
        createdAt: station.createdAt,
        description: station.description,
        phone: station.phone,
        email: station.email,
        imageUrl: station.imageUrl,
        chargers: station.chargers,
        amenities: station.amenities,
        operatingHours: station.operatingHours,
        rating: station.rating,
        totalReviews: station.totalReviews,
        totalSessions: station.totalSessions,
        totalRevenue: station.totalRevenue,
        updatedAt: DateTime.now(),
      ),
    );
  }

  /// Get station statistics.
  Future<StationStats> getStats() async {
    if (_cachedStations.isEmpty) {
      await _loadStations();
    }
    return StationStats(
      total: _cachedStations.length,
      active: _cachedStations
          .where((s) => s.status == AdminStationStatus.active)
          .length,
      inactive: _cachedStations
          .where((s) => s.status == AdminStationStatus.inactive)
          .length,
      maintenance: _cachedStations
          .where((s) => s.status == AdminStationStatus.maintenance)
          .length,
      totalChargers: _cachedStations.fold(0, (sum, s) => sum + s.totalChargers),
      totalSessions: _cachedStations.fold(
        0,
        (sum, s) => sum + (s.totalSessions ?? 0),
      ),
      totalRevenue: _cachedStations.fold(
        0,
        (sum, s) => sum + (s.totalRevenue ?? 0),
      ),
    );
  }

  Future<void> _loadStations() async {
    try {
      final jsonString = await rootBundle.loadString(AdminAssets.jsonStations);
      final jsonList = json.decode(jsonString) as List<dynamic>;
      _cachedStations = jsonList
          .map((json) => AdminStation.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // If loading fails, use empty list
      _cachedStations = [];
    }
  }
}

/// Station statistics.
class StationStats {
  const StationStats({
    required this.total,
    required this.active,
    required this.inactive,
    required this.maintenance,
    required this.totalChargers,
    required this.totalSessions,
    required this.totalRevenue,
  });

  final int total;
  final int active;
  final int inactive;
  final int maintenance;
  final int totalChargers;
  final int totalSessions;
  final double totalRevenue;
}
