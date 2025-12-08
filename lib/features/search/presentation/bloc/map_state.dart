/// File: lib/features/search/presentation/bloc/map_state.dart
/// Purpose: States for MapBloc
/// Belongs To: search feature
library;

import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

import '../../../../models/station_model.dart';

/// Base class for map states.
abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

/// Initial map state.
class MapInitial extends MapState {
  const MapInitial();
}

/// Map loading state.
class MapLoading extends MapState {
  const MapLoading();
}

/// Map loaded state with markers.
class MapLoaded extends MapState {
  const MapLoaded({
    required this.stations,
    this.selectedStation,
    this.userLocation,
  });

  final List<StationModel> stations;
  final StationModel? selectedStation;
  final LatLng? userLocation;

  MapLoaded copyWith({
    List<StationModel>? stations,
    StationModel? selectedStation,
    LatLng? userLocation,
  }) {
    return MapLoaded(
      stations: stations ?? this.stations,
      selectedStation: selectedStation ?? this.selectedStation,
      userLocation: userLocation ?? this.userLocation,
    );
  }

  @override
  List<Object?> get props => [stations, selectedStation, userLocation];
}

/// Map error state.
class MapError extends MapState {
  const MapError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

