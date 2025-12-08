/// File: lib/features/search/presentation/bloc/map_event.dart
/// Purpose: Events for MapBloc
/// Belongs To: search feature
library;

import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

import '../../data/station_api_service.dart' as search_api;

/// Base class for map events.
abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

/// Map moved event (bounds changed).
class MapMoved extends MapEvent {
  const MapMoved(this.bounds);

  final search_api.Bounds bounds;

  @override
  List<Object?> get props => [bounds];
}

/// Marker tapped event.
class MarkerTapped extends MapEvent {
  const MarkerTapped(this.stationId);

  final String stationId;

  @override
  List<Object?> get props => [stationId];
}

/// Load markers for bounds event.
class LoadMarkersForBounds extends MapEvent {
  const LoadMarkersForBounds(this.bounds);

  final search_api.Bounds bounds;

  @override
  List<Object?> get props => [bounds];
}

/// Clear selected station event.
class ClearSelectedStation extends MapEvent {
  const ClearSelectedStation();
}

/// User location updated event.
class UserLocationUpdated extends MapEvent {
  const UserLocationUpdated(this.location);

  final LatLng location;

  @override
  List<Object?> get props => [location];
}

