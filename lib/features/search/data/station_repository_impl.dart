/// File: lib/features/search/data/station_repository_impl.dart
/// Purpose: Implementation of SearchStationRepository
/// Belongs To: search feature
/// Customization Guide:
///    - Add caching logic here
///    - Add offline support with Hive
library;

import 'package:latlong2/latlong.dart';

import '../../../core/errors/failure.dart';
import '../../../models/station_model.dart';
import '../domain/station_repository.dart';
import 'station_api_service.dart';

/// Implementation of SearchStationRepository.
class SearchStationRepositoryImpl implements SearchStationRepository {
  SearchStationRepositoryImpl({
    required StationApiService apiService,
  })  : _apiService = apiService;

  final StationApiService _apiService;

  @override
  Future<Either<Failure, List<StationModel>>> fetchStationsByBounds(
    Bounds bounds,
  ) async {
    return _apiService.fetchStationsByBounds(bounds);
  }

  @override
  Future<Either<Failure, List<StationModel>>> searchStations(
    String query,
  ) async {
    return _apiService.searchStations(query);
  }

  @override
  Future<Either<Failure, StationModel>> getStation(String id) async {
    return _apiService.getStation(id);
  }

  @override
  Future<Either<Failure, List<StationModel>>> fetchStationsByLocation(
    LatLng center,
    double radiusKm,
  ) async {
    return _apiService.fetchStationsByLocation(
      center.latitude,
      center.longitude,
      radiusKm,
    );
  }
}

