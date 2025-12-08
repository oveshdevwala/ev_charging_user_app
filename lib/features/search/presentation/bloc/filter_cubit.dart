/// File: lib/features/search/presentation/bloc/filter_cubit.dart
/// Purpose: Cubit for managing filter state
/// Belongs To: search feature
library;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../models/charger_model.dart';
import '../../../../models/station_model.dart';
import '../../domain/station_usecases.dart';

/// Filter Cubit for managing station filters.
class FilterCubit extends Cubit<StationFilters> {
  FilterCubit({required SharedPreferences prefs})
    : _prefs = prefs,
      super(const StationFilters()) {
    _loadSavedFilters();
  }

  final SharedPreferences _prefs;
  static const String _filtersKey = 'station_filters';

  /// Load saved filters from SharedPreferences.
  void _loadSavedFilters() {
    final saved = _prefs.getString(_filtersKey);
    if (saved != null) {
      try {
        // For now, just emit default - in production, parse JSON
        emit(const StationFilters());
      } catch (e) {
        // Ignore parse errors
        emit(const StationFilters());
      }
    }
  }

  /// Save filters to SharedPreferences.
  Future<void> saveFilters() async {
    // For now, just save a flag - in production, serialize to JSON
    await _prefs.setBool('has_saved_filters', state.hasActiveFilters);
  }

  /// Update connector types filter.
  void updateConnectorTypes(List<ChargerType> types) {
    emit(state.copyWith(connectorTypes: types));
  }

  /// Update price range filter.
  void updatePriceRange(double? min, double? max) {
    emit(state.copyWith(minPrice: min, maxPrice: max));
  }

  /// Update power range filter.
  void updatePowerRange(double? min, double? max) {
    emit(state.copyWith(minPower: min, maxPower: max));
  }

  /// Toggle available only filter.
  void toggleAvailableOnly() {
    emit(state.copyWith(availableOnly: !state.availableOnly));
  }

  /// Update amenities filter.
  void updateAmenities(List<Amenity> amenities) {
    emit(state.copyWith(amenities: amenities));
  }

  /// Update rating filter.
  void updateMinRating(double? rating) {
    emit(state.copyWith(minRating: rating));
  }

  /// Update max distance filter.
  void updateMaxDistance(double? distanceKm) {
    emit(state.copyWith(maxDistance: distanceKm));
  }

  /// Clear all filters.
  void clearFilters() {
    emit(const StationFilters());
    _prefs.remove(_filtersKey);
  }

  /// Apply filters (notify search bloc).
  void applyFilters() {
    // Filters are applied via SearchBloc when FiltersApplied event is dispatched
    saveFilters();
  }
}
