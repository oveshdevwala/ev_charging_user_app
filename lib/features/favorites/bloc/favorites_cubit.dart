/// File: lib/features/favorites/bloc/favorites_cubit.dart
/// Purpose: Favorites page Cubit for managing favorites state
/// Belongs To: favorites feature
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repositories/station_repository.dart';
import 'favorites_state.dart';

/// Favorites page Cubit.
class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit({required StationRepository stationRepository})
      : _stationRepository = stationRepository,
        super(FavoritesState.initial());

  final StationRepository _stationRepository;

  /// Load favorite stations.
  Future<void> loadFavorites() async {
    emit(state.copyWith(isLoading: true));

    try {
      final favorites = await _stationRepository.getFavoriteStations();
      emit(state.copyWith(isLoading: false, favorites: favorites));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// Remove station from favorites.
  Future<void> removeFavorite(String stationId) async {
    await _stationRepository.toggleFavorite(stationId);
    await loadFavorites();
  }
}

