/// File: lib/features/search/bloc/search_cubit.dart
/// Purpose: Search page Cubit for managing search state
/// Belongs To: search feature
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repositories/station_repository.dart';
import 'search_state.dart';

/// Search page Cubit.
class SearchCubit extends Cubit<SearchState> {
  SearchCubit({required StationRepository stationRepository})
      : _stationRepository = stationRepository,
        super(SearchState.initial());

  final StationRepository _stationRepository;

  /// Load all stations.
  Future<void> loadStations() async {
    emit(state.copyWith(isLoading: true));

    try {
      final stations = await _stationRepository.getStations();
      emit(state.copyWith(isLoading: false, stations: stations));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// Search stations by query.
  Future<void> search(String query) async {
    emit(state.copyWith(isLoading: true, query: query));

    try {
      final stations = query.isEmpty
          ? await _stationRepository.getStations()
          : await _stationRepository.searchStations(query);
      emit(state.copyWith(isLoading: false, stations: stations));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// Toggle favorite for a station.
  Future<void> toggleFavorite(String stationId) async {
    await _stationRepository.toggleFavorite(stationId);
    await search(state.query);
  }
}

