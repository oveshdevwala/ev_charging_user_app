/// File: lib/core/services/recent_stations_service.dart
/// Purpose: Service to track and retrieve recently viewed stations
/// Belongs To: shared
/// Customization Guide:
///    - Uses SharedPreferences for persistence
///    - Stores station IDs with timestamps
///    - Limits to last 10 stations
library;

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/station_model.dart';
import '../../repositories/station_repository.dart';

/// Service for managing recently viewed stations.
class RecentStationsService {
  RecentStationsService({required StationRepository stationRepository})
    : _stationRepository = stationRepository;

  final StationRepository _stationRepository;
  static const String _key = 'recent_stations';
  static const int _maxRecentStations = 10;

  /// Add a station to recent list.
  Future<void> addRecentStation(String stationId) async {
    final prefs = await SharedPreferences.getInstance();
    final recentList = await getRecentStationIdsAsync()
      ..remove(stationId)
      ..insert(0, stationId);

    // Limit to max
    if (recentList.length > _maxRecentStations) {
      recentList.removeRange(_maxRecentStations, recentList.length);
    }

    await prefs.setStringList(_key, recentList);
  }

  /// Get recent station IDs asynchronously.
  Future<List<String>> getRecentStationIdsAsync() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  /// Get recent stations with full details.
  Future<List<StationModel>> getRecentStations() async {
    final stationIds = await getRecentStationIdsAsync();

    // If no recent stations, return dummy data for UI template
    if (stationIds.isEmpty) {
      return _getDummyRecentStations();
    }

    final stations = <StationModel>[];
    for (final id in stationIds) {
      try {
        final station = await _stationRepository.getStationById(id);
        if (station != null) {
          stations.add(station);
        }
      } catch (e) {
        // Skip if station not found
        continue;
      }
    }

    // If we have less than 3 stations, add dummy ones for UI template
    if (stations.length < 3) {
      final dummyStations = await _getDummyRecentStations();
      stations.addAll(dummyStations.take(3 - stations.length));
    }

    return stations;
  }

  /// Get dummy recent stations for UI template.
  Future<List<StationModel>> _getDummyRecentStations() async {
    final allStations = await _stationRepository.getStations(limit: 10);
    // Return first 4 stations as dummy recent
    return allStations.take(4).toList();
  }

  /// Clear recent stations.
  Future<void> clearRecentStations() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
