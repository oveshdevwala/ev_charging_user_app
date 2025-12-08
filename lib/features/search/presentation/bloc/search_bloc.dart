/// File: lib/features/search/presentation/bloc/search_bloc.dart
/// Purpose: BLoC for managing search state
/// Belongs To: search feature
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/debounce.dart';
import '../../../../models/charger_model.dart';
import '../../../../models/station_model.dart';
import '../../domain/station_usecases.dart';
import 'search_event.dart';
import 'search_state.dart';

/// Search BLoC for managing search operations.
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({
    required SearchStations searchStations,
    required FetchStationsByBounds fetchStationsByBounds,
  })  : _searchStations = searchStations,
        _fetchStationsByBounds = fetchStationsByBounds,
        super(const SearchInitial()) {
    on<SearchStarted>(_onSearchStarted);
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<FiltersApplied>(_onFiltersApplied);
    on<RefreshRequested>(_onRefreshRequested);
    on<ClearSearch>(_onClearSearch);

    _debouncer = Debouncer();
  }

  final SearchStations _searchStations;
  final FetchStationsByBounds _fetchStationsByBounds;
  late final Debouncer _debouncer;
  String _currentQuery = '';
  StationFilters? _currentFilters;

  @override
  Future<void> close() {
    _debouncer.dispose();
    return super.close();
  }

  Future<void> _onSearchStarted(
    SearchStarted event,
    Emitter<SearchState> emit,
  ) async {
    emit(const SearchLoadInProgress());
    // Initial load - fetch all stations or nearby
    // For now, emit initial state
    emit(const SearchInitial());
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    _currentQuery = event.query;

    if (event.query.isEmpty) {
      emit(const SearchInitial());
      return;
    }

    emit(const SearchLoadInProgress());

    await _debouncer.call(() async {
      if (!emit.isDone) {
        final result = await _searchStations(event.query);
        if (!emit.isDone) {
          result.fold(
            (failure) => emit(SearchLoadFailure(failure.message ?? 'Search failed')),
            (stations) {
              final filtered = _applyFilters(stations);
              emit(SearchLoadSuccess(
                stations: filtered,
                query: event.query,
                filters: _currentFilters,
              ));
            },
          );
        }
      }
    });
  }

  Future<void> _onFiltersApplied(
    FiltersApplied event,
    Emitter<SearchState> emit,
  ) async {
    _currentFilters = event.filters;

    if (state is SearchLoadSuccess) {
      final currentState = state as SearchLoadSuccess;
      final filtered = _applyFilters(currentState.stations);
      emit(currentState.copyWith(
        stations: filtered,
        filters: event.filters,
      ));
    }
  }

  Future<void> _onRefreshRequested(
    RefreshRequested event,
    Emitter<SearchState> emit,
  ) async {
    if (_currentQuery.isNotEmpty) {
      emit(const SearchLoadInProgress());
      final result = await _searchStations(_currentQuery);
      result.fold(
        (failure) => emit(SearchLoadFailure(failure.message ?? 'Refresh failed')),
        (stations) {
          final filtered = _applyFilters(stations);
          emit(SearchLoadSuccess(
            stations: filtered,
            query: _currentQuery,
            filters: _currentFilters,
          ));
        },
      );
    }
  }

  Future<void> _onClearSearch(
    ClearSearch event,
    Emitter<SearchState> emit,
  ) async {
    _currentQuery = '';
    _currentFilters = null;
    emit(const SearchInitial());
  }

  List<StationModel> _applyFilters(List<StationModel> stations) {
    if (_currentFilters == null || !_currentFilters!.hasActiveFilters) {
      return stations;
    }

    final filters = _currentFilters!;
    return stations.where((station) {
      // Connector types filter
      if (filters.connectorTypes.isNotEmpty) {
        final hasMatchingConnector = station.chargers.any(
          (ChargerModel charger) => filters.connectorTypes.contains(charger.type),
        );
        if (!hasMatchingConnector) return false;
      }

      // Price filter
      if (filters.minPrice != null && station.pricePerKwh < filters.minPrice!) {
        return false;
      }
      if (filters.maxPrice != null && station.pricePerKwh > filters.maxPrice!) {
        return false;
      }

      // Power filter
      if (filters.minPower != null || filters.maxPower != null) {
        final maxPower = station.chargers
            .map<double>((ChargerModel c) => c.power)
            .fold<double>(0, (double a, double b) => a > b ? a : b);
        if (filters.minPower != null && maxPower < filters.minPower!) {
          return false;
        }
        if (filters.maxPower != null && maxPower > filters.maxPower!) {
          return false;
        }
      }

      // Available only filter
      if (filters.availableOnly && !station.hasAvailableChargers) {
        return false;
      }

      // Amenities filter
      if (filters.amenities.isNotEmpty) {
        final hasAllAmenities = filters.amenities.every(
          (amenity) => station.amenities.contains(amenity),
        );
        if (!hasAllAmenities) return false;
      }

      // Rating filter
      if (filters.minRating != null && station.rating < filters.minRating!) {
        return false;
      }

      return true;
    }).toList();
  }
}

