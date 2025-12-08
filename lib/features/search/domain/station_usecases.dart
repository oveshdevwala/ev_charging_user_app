/// File: lib/features/search/domain/station_usecases.dart
/// Purpose: Use cases for station search operations
/// Belongs To: search feature
/// Customization Guide:
///    - Add new use cases as needed
library;

import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/errors/failure.dart';
import '../../../models/models.dart';
import '../data/station_api_service.dart';
import 'station_repository.dart';

/// Station filters model.
class StationFilters extends Equatable {
  const StationFilters({
    this.connectorTypes = const [],
    this.minPrice,
    this.maxPrice,
    this.minPower,
    this.maxPower,
    this.availableOnly = false,
    this.amenities = const [],
    this.minRating,
    this.maxDistance,
  });

  final List<ChargerType> connectorTypes;
  final double? minPrice;
  final double? maxPrice;
  final double? minPower;
  final double? maxPower;
  final bool availableOnly;
  final List<Amenity> amenities;
  final double? minRating;
  final double? maxDistance; // in km

  StationFilters copyWith({
    List<ChargerType>? connectorTypes,
    double? minPrice,
    double? maxPrice,
    double? minPower,
    double? maxPower,
    bool? availableOnly,
    List<Amenity>? amenities,
    double? minRating,
    double? maxDistance,
  }) {
    return StationFilters(
      connectorTypes: connectorTypes ?? this.connectorTypes,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minPower: minPower ?? this.minPower,
      maxPower: maxPower ?? this.maxPower,
      availableOnly: availableOnly ?? this.availableOnly,
      amenities: amenities ?? this.amenities,
      minRating: minRating ?? this.minRating,
      maxDistance: maxDistance ?? this.maxDistance,
    );
  }

  /// Check if any filter is active.
  bool get hasActiveFilters {
    return connectorTypes.isNotEmpty ||
        minPrice != null ||
        maxPrice != null ||
        minPower != null ||
        maxPower != null ||
        availableOnly ||
        amenities.isNotEmpty ||
        minRating != null ||
        maxDistance != null;
  }

  /// Clear all filters.
  StationFilters clear() {
    return const StationFilters();
  }

  @override
  List<Object?> get props => [
        connectorTypes,
        minPrice,
        maxPrice,
        minPower,
        maxPower,
        availableOnly,
        amenities,
        minRating,
        maxDistance,
      ];
}

/// Use case: Fetch stations by bounds.
class FetchStationsByBounds {
  FetchStationsByBounds(this._repository);

  final SearchStationRepository _repository;

  Future<Either<Failure, List<StationModel>>> call(Bounds bounds) {
    return _repository.fetchStationsByBounds(bounds);
  }
}

/// Use case: Search stations.
class SearchStations {
  SearchStations(this._repository);

  final SearchStationRepository _repository;

  Future<Either<Failure, List<StationModel>>> call(String query) {
    return _repository.searchStations(query);
  }
}

/// Use case: Get station by ID.
class GetStation {
  GetStation(this._repository);

  final SearchStationRepository _repository;

  Future<Either<Failure, StationModel>> call(String id) {
    return _repository.getStation(id);
  }
}

/// Use case: Fetch stations by location.
class FetchStationsByLocation {
  FetchStationsByLocation(this._repository);

  final SearchStationRepository _repository;

  Future<Either<Failure, List<StationModel>>> call(
    LatLng center,
    double radiusKm,
  ) {
    return _repository.fetchStationsByLocation(center, radiusKm);
  }
}

