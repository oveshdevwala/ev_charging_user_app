/// File: lib/admin/features/stations/bloc/stations_bloc.dart
/// Purpose: Stations BLoC for managing stations state
/// Belongs To: admin/features/stations
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/admin_station_model.dart';
import '../repository/stations_repository.dart';
import 'stations_event.dart';
import 'stations_state.dart';

/// Stations BLoC.
class StationsBloc extends Bloc<StationsEvent, StationsState> {
  StationsBloc({
    StationsRepository? repository,
  })  : _repository = repository ?? StationsRepository(),
        super(const StationsState()) {
    on<StationsLoadRequested>(_onLoadRequested);
    on<StationsRefreshRequested>(_onRefreshRequested);
    on<StationsSearchChanged>(_onSearchChanged);
    on<StationsFilterChanged>(_onFilterChanged);
    on<StationsSortChanged>(_onSortChanged);
    on<StationsPageChanged>(_onPageChanged);
    on<StationsSelectionChanged>(_onSelectionChanged);
    on<StationDeleteRequested>(_onDeleteRequested);
    on<StationDetailLoadRequested>(_onDetailLoadRequested);
  }

  final StationsRepository _repository;

  Future<void> _onLoadRequested(
    StationsLoadRequested event,
    Emitter<StationsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final stations = await _repository.getStations(
        searchQuery: state.searchQuery,
        status: state.filterStatus,
        sortBy: state.sortBy,
        ascending: state.sortAscending,
      );
      final stats = await _repository.getStats();

      emit(state.copyWith(
        isLoading: false,
        stations: stations,
        totalStations: stations.length,
        stats: stats,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onRefreshRequested(
    StationsRefreshRequested event,
    Emitter<StationsState> emit,
  ) async {
    add(const StationsLoadRequested());
  }

  Future<void> _onSearchChanged(
    StationsSearchChanged event,
    Emitter<StationsState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query, currentPage: 1));
    add(const StationsLoadRequested());
  }

  Future<void> _onFilterChanged(
    StationsFilterChanged event,
    Emitter<StationsState> emit,
  ) async {
    emit(state.copyWith(filterStatus: event.status, currentPage: 1));
    add(const StationsLoadRequested());
  }

  Future<void> _onSortChanged(
    StationsSortChanged event,
    Emitter<StationsState> emit,
  ) async {
    final newAscending = state.sortBy == event.sortBy ? !state.sortAscending : true;
    emit(state.copyWith(
      sortBy: event.sortBy,
      sortAscending: newAscending,
    ));
    add(const StationsLoadRequested());
  }

  Future<void> _onPageChanged(
    StationsPageChanged event,
    Emitter<StationsState> emit,
  ) async {
    emit(state.copyWith(currentPage: event.page));
  }

  Future<void> _onSelectionChanged(
    StationsSelectionChanged event,
    Emitter<StationsState> emit,
  ) async {
    emit(state.copyWith(selectedStationIds: event.selectedIds));
  }

  Future<void> _onDeleteRequested(
    StationDeleteRequested event,
    Emitter<StationsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      await _repository.deleteStation(event.stationId);
      add(const StationsLoadRequested());
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onDetailLoadRequested(
    StationDetailLoadRequested event,
    Emitter<StationsState> emit,
  ) async {
    emit(state.copyWith(isLoadingDetail: true, selectedStation: null));

    try {
      final station = await _repository.getStationById(event.stationId);
      emit(state.copyWith(
        isLoadingDetail: false,
        selectedStation: station,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingDetail: false,
        error: e.toString(),
      ));
    }
  }
}

