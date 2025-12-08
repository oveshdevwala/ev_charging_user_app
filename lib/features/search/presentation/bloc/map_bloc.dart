/// File: lib/features/search/presentation/bloc/map_bloc.dart
/// Purpose: BLoC for managing map state
/// Belongs To: search feature
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/debounce.dart';
import '../../../../models/station_model.dart';
import '../../data/station_api_service.dart';
import '../../domain/station_usecases.dart';
import 'map_event.dart';
import 'map_state.dart';

/// Map BLoC for managing map operations.
class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc({required FetchStationsByBounds fetchStationsByBounds})
    : _fetchStationsByBounds = fetchStationsByBounds,
      super(const MapInitial()) {
    on<MapMoved>(_onMapMoved);
    on<MarkerTapped>(_onMarkerTapped);
    on<LoadMarkersForBounds>(_onLoadMarkersForBounds);
    on<ClearSelectedStation>(_onClearSelectedStation);
    on<UserLocationUpdated>(_onUserLocationUpdated);

    _debouncer = Debouncer(duration: const Duration(milliseconds: 500));
  }

  final FetchStationsByBounds _fetchStationsByBounds;
  late final Debouncer _debouncer;
  bool _isLoading = false;

  @override
  Future<void> close() {
    _debouncer.dispose();
    return super.close();
  }

  Future<void> _onMapMoved(MapMoved event, Emitter<MapState> emit) async {
    // Skip if already loading to prevent state fluctuation
    if (_isLoading) {
      return;
    }

    // Debounce map movements to avoid spamming API
    await _debouncer.call(() async {
      if (!emit.isDone && !_isLoading) {
        _isLoading = true;
        if (state is! MapLoading) {
          emit(const MapLoading());
        }
        final result = await _fetchStationsByBounds(event.bounds);
        _isLoading = false;
        if (!emit.isDone) {
          result.fold(
            (failure) =>
                emit(MapError(failure.message ?? 'Failed to load stations')),
            (stations) {
              if (state is MapLoaded) {
                final currentState = state as MapLoaded;
                emit(currentState.copyWith(stations: stations));
              } else {
                emit(MapLoaded(stations: stations));
              }
            },
          );
        }
      }
    });
  }

  Future<void> _onLoadMarkersForBounds(
    LoadMarkersForBounds event,
    Emitter<MapState> emit,
  ) async {
    // Skip if already loading to prevent state fluctuation
    if (_isLoading) {
      return;
    }

    if (!emit.isDone) {
      _isLoading = true;
      if (state is! MapLoading) {
        emit(const MapLoading());
      }
      final result = await _fetchStationsByBounds(event.bounds);
      _isLoading = false;
      if (!emit.isDone) {
        result.fold(
          (failure) =>
              emit(MapError(failure.message ?? 'Failed to load stations')),
          (stations) => emit(MapLoaded(stations: stations)),
        );
      }
    }
  }

  Future<void> _onMarkerTapped(
    MarkerTapped event,
    Emitter<MapState> emit,
  ) async {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      final station = currentState.stations.firstWhere(
        (StationModel s) => s.id == event.stationId,
        orElse: () => currentState.stations.first,
      );
      emit(currentState.copyWith(selectedStation: station));
    }
  }

  Future<void> _onClearSelectedStation(
    ClearSelectedStation event,
    Emitter<MapState> emit,
  ) async {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      emit(currentState.copyWith());
    }
  }

  Future<void> _onUserLocationUpdated(
    UserLocationUpdated event,
    Emitter<MapState> emit,
  ) async {
    if (!emit.isDone) {
      if (state is MapLoaded) {
        final currentState = state as MapLoaded;
        // Only update location, don't reload stations if already loaded
        emit(currentState.copyWith(userLocation: event.location));
      } else if (!_isLoading) {
        // Load stations for user location only if not already loading
        const radius = 0.15; // ~15km radius for more stations
        final bounds = Bounds(
          north: event.location.latitude + radius,
          south: event.location.latitude - radius,
          east: event.location.longitude + radius,
          west: event.location.longitude - radius,
        );
        _isLoading = true;
        if (state is! MapLoading) {
          emit(const MapLoading());
        }
        final result = await _fetchStationsByBounds(bounds);
        _isLoading = false;
        if (!emit.isDone) {
          result.fold(
            (failure) =>
                emit(MapError(failure.message ?? 'Failed to load stations')),
            (stations) => emit(
              MapLoaded(stations: stations, userLocation: event.location),
            ),
          );
        }
      }
    }
  }
}
