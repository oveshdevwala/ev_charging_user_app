/// File: lib/features/search/domain/station_repository.dart
/// Purpose: Domain repository interface for station search
/// Belongs To: search feature
/// Customization Guide:
///    - Add new methods as needed
library;

import 'package:latlong2/latlong.dart';

import '../../../core/errors/failure.dart';
import '../../../models/models.dart';
import '../data/station_api_service.dart';

/// Station repository interface for search feature.
abstract class SearchStationRepository {
  /// Fetch stations within bounding box.
  Future<Either<Failure, List<StationModel>>> fetchStationsByBounds(
    Bounds bounds,
  );

  /// Search stations by query string.
  Future<Either<Failure, List<StationModel>>> searchStations(String query);

  /// Get station by ID.
  Future<Either<Failure, StationModel>> getStation(String id);

  /// Fetch stations by location and radius.
  Future<Either<Failure, List<StationModel>>> fetchStationsByLocation(
    LatLng center,
    double radiusKm,
  );
}

