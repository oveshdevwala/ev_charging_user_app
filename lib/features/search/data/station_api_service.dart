/// File: lib/features/search/data/station_api_service.dart
/// Purpose: Low-level API service for station data
/// Belongs To: search feature
/// Customization Guide:
///    - Replace with actual API endpoints
///    - Update query parameters as needed
library;

import '../../../core/errors/failure.dart';
import '../../../models/models.dart';
import '../../../repositories/station_repository.dart';

/// Bounding box for map queries.
class Bounds {
  const Bounds({
    required this.north,
    required this.south,
    required this.east,
    required this.west,
  });

  final double north;
  final double south;
  final double east;
  final double west;

  Map<String, dynamic> toQueryParams() {
    return {
      'north': north,
      'south': south,
      'east': east,
      'west': west,
    };
  }
}

/// Station API service for network calls.
/// This is a wrapper around the existing StationRepository.
class StationApiService {
  StationApiService({required StationRepository stationRepository})
      : _stationRepository = stationRepository;

  final StationRepository _stationRepository;

  /// Fetch stations within bounding box.
  Future<Either<Failure, List<StationModel>>> fetchStationsByBounds(
    Bounds bounds,
  ) async {
    try {
      // Get all stations (no pagination limit for map view)
      final allStations = await _stationRepository.getStations(limit: 100);
      
      // Filter stations within bounds (simplified - in production, API would do this)
      final filtered = allStations.where((station) {
        return station.latitude >= bounds.south &&
            station.latitude <= bounds.north &&
            station.longitude >= bounds.west &&
            station.longitude <= bounds.east;
      }).toList();

      return Either.right(filtered);
    } catch (e) {
      return Either.left(NetworkFailure(message: e.toString()));
    }
  }

  /// Search stations by query.
  Future<Either<Failure, List<StationModel>>> searchStations(
    String query,
  ) async {
    try {
      final stations = await _stationRepository.searchStations(query);
      return Either.right(stations);
    } catch (e) {
      return Either.left(NetworkFailure(message: e.toString()));
    }
  }

  /// Get station by ID.
  Future<Either<Failure, StationModel>> getStation(String id) async {
    try {
      final station = await _stationRepository.getStationById(id);
      if (station == null) {
        return const Either.left(
          NetworkFailure(message: 'Station not found'),
        );
      }
      return Either.right(station);
    } catch (e) {
      return Either.left(NetworkFailure(message: e.toString()));
    }
  }

  /// Fetch stations by location and radius.
  Future<Either<Failure, List<StationModel>>> fetchStationsByLocation(
    double latitude,
    double longitude,
    double radiusKm,
  ) async {
    try {
      final stations = await _stationRepository.getNearbyStations(
        latitude: latitude,
        longitude: longitude,
        radius: radiusKm,
      );
      return Either.right(stations);
    } catch (e) {
      return Either.left(NetworkFailure(message: e.toString()));
    }
  }
}

