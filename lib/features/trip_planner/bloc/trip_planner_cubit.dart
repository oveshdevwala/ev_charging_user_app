/// File: lib/features/trip_planner/bloc/trip_planner_cubit.dart
/// Purpose: Trip planner Cubit for managing all trip planning operations
/// Belongs To: trip_planner feature
/// Customization Guide:
///    - Add new methods for additional trip planning features
///    - All async operations should handle errors properly
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/models.dart';
import '../repositories/trip_planner_repository.dart';
import 'trip_planner_state.dart';

/// Trip planner Cubit managing all trip planning operations.
class TripPlannerCubit extends Cubit<TripPlannerState> {
  TripPlannerCubit({
    required TripPlannerRepository repository,
  })  : _repository = repository,
        super(TripPlannerState.initial());

  final TripPlannerRepository _repository;

  // ============================================================
  // INITIALIZATION
  // ============================================================

  /// Initialize trip planner with necessary data.
  Future<void> initialize() async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      // Load vehicles, saved trips, and recent trips in parallel
      final vehiclesFuture = _repository.fetchVehicleProfiles();
      final defaultVehicleFuture = _repository.fetchDefaultVehicle();
      final savedTripsFuture = _repository.fetchSavedTrips();
      final recentTripsFuture = _repository.fetchRecentTrips();
      final favoriteTripsFuture = _repository.fetchFavoriteTrips();

      final vehicles = await vehiclesFuture;
      final defaultVehicle = await defaultVehicleFuture;
      final savedTrips = await savedTripsFuture;
      final recentTrips = await recentTripsFuture;
      final favoriteTrips = await favoriteTripsFuture;

      emit(state.copyWith(
        isLoading: false,
        availableVehicles: vehicles,
        selectedVehicle: defaultVehicle,
        savedTrips: savedTrips,
        recentTrips: recentTrips,
        favoriteTrips: favoriteTrips,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  /// Initialize trip planner and optionally load a specific trip directly.
  Future<void> initializeWithTrip(String? tripId) async {
    await initialize();
    
    // If a trip ID is provided, load that trip and go to summary
    if (tripId != null && tripId.isNotEmpty) {
      await loadTrip(tripId);
    }
  }

  /// Load a trip directly and show its summary (for external navigation).
  Future<void> loadTripDirectly(TripModel trip) async {
    emit(state.copyWith(
      currentTrip: trip,
      origin: trip.origin,
      destination: trip.destination,
      waypoints: trip.waypoints,
      selectedVehicle: trip.vehicle,
      preferences: trip.preferences,
      departureTime: trip.departureTime,
      step: TripPlanningStep.summary,
    ));
  }

  // ============================================================
  // LOCATION SELECTION
  // ============================================================

  /// Search for locations.
  Future<void> searchLocations(String query) async {
    if (query.isEmpty) {
      emit(state.copyWith(clearSearchResults: true, isSearching: false));
      return;
    }

    emit(state.copyWith(isSearching: true, searchQuery: query));

    try {
      final results = await _repository.searchLocations(query);
      emit(state.copyWith(
        locationSearchResults: results,
        isSearching: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isSearching: false,
        error: e.toString(),
      ));
    }
  }

  /// Set origin location.
  void setOrigin(LocationModel location) {
    emit(state.copyWith(
      origin: location,
      clearSearchResults: true,
      clearCurrentTrip: true,
    ));
  }

  /// Set destination location.
  void setDestination(LocationModel location) {
    emit(state.copyWith(
      destination: location,
      clearSearchResults: true,
      clearCurrentTrip: true,
    ));
  }

  /// Add a waypoint.
  void addWaypoint(LocationModel waypoint) {
    final waypoints = List<LocationModel>.from(state.waypoints)..add(waypoint);
    emit(state.copyWith(
      waypoints: waypoints,
      clearSearchResults: true,
      clearCurrentTrip: true,
    ));
  }

  /// Remove a waypoint at index.
  void removeWaypoint(int index) {
    if (index >= 0 && index < state.waypoints.length) {
      final waypoints = List<LocationModel>.from(state.waypoints)
        ..removeAt(index);
      emit(state.copyWith(
        waypoints: waypoints,
        clearCurrentTrip: true,
      ));
    }
  }

  /// Swap origin and destination.
  void swapOriginDestination() {
    if (state.origin != null && state.destination != null) {
      emit(state.copyWith(
        origin: state.destination,
        destination: state.origin,
        clearCurrentTrip: true,
      ));
    }
  }

  /// Clear all locations.
  void clearLocations() {
    emit(state.copyWith(
      clearOrigin: true,
      clearDestination: true,
      waypoints: const [],
      clearCurrentTrip: true,
    ));
  }

  /// Clear search results.
  void clearSearchResults() {
    emit(state.copyWith(clearSearchResults: true));
  }

  // ============================================================
  // VEHICLE SELECTION
  // ============================================================

  /// Select a vehicle.
  void selectVehicle(VehicleProfileModel vehicle) {
    emit(state.copyWith(
      selectedVehicle: vehicle,
      clearCurrentTrip: true,
    ));
  }

  /// Update vehicle SOC.
  void updateVehicleSoc(double socPercent) {
    if (state.selectedVehicle != null) {
      final updatedVehicle = state.selectedVehicle!.copyWith(
        currentSocPercent: socPercent.clamp(0, 100),
      );
      emit(state.copyWith(
        selectedVehicle: updatedVehicle,
        clearCurrentTrip: true,
      ));
    }
  }

  // ============================================================
  // PREFERENCES
  // ============================================================

  /// Update trip preferences.
  void updatePreferences(TripPreferences preferences) {
    emit(state.copyWith(
      preferences: preferences,
      clearCurrentTrip: true,
    ));
  }

  /// Set departure time.
  void setDepartureTime(DateTime? time) {
    emit(state.copyWith(
      departureTime: time,
      clearCurrentTrip: true,
    ));
  }

  // ============================================================
  // TRIP CALCULATION
  // ============================================================

  /// Calculate trip with current settings.
  Future<void> calculateTrip() async {
    if (!state.canCalculate) {
      emit(state.copyWith(
        error: 'Please select origin, destination, and vehicle',
      ));
      return;
    }

    emit(state.copyWith(
      isCalculating: true,
      clearError: true,
      step: TripPlanningStep.calculating,
    ));

    try {
      final trip = await _repository.calculateTrip(
        origin: state.origin!,
        destination: state.destination!,
        vehicle: state.selectedVehicle!,
        waypoints: state.waypoints,
        preferences: state.preferences,
        departureTime: state.departureTime,
      );

      emit(state.copyWith(
        isCalculating: false,
        currentTrip: trip,
        step: TripPlanningStep.summary,
      ));
    } catch (e) {
      emit(state.copyWith(
        isCalculating: false,
        error: e.toString(),
        step: TripPlanningStep.input,
      ));
    }
  }

  /// Recalculate trip with updated settings.
  Future<void> recalculateTrip() async {
    if (state.currentTrip != null) {
      await calculateTrip();
    }
  }

  // ============================================================
  // NAVIGATION
  // ============================================================

  /// Go to a specific step.
  void goToStep(TripPlanningStep step) {
    emit(state.copyWith(step: step));
  }

  /// Go back to input step.
  void goBackToInput() {
    emit(state.copyWith(step: TripPlanningStep.input));
  }

  /// Go to home step.
  void goToHome() {
    emit(state.copyWith(step: TripPlanningStep.home));
  }

  /// Go to summary step.
  void goToSummary() {
    if (state.hasTripCalculated) {
      emit(state.copyWith(step: TripPlanningStep.summary));
    }
  }

  /// Go to charging stops step.
  void goToChargingStops() {
    if (state.hasTripCalculated) {
      emit(state.copyWith(step: TripPlanningStep.stops));
    }
  }

  /// Go to insights step.
  void goToInsights() {
    if (state.hasTripCalculated) {
      emit(state.copyWith(step: TripPlanningStep.insights));
    }
  }

  /// Go to detail step.
  void goToDetail() {
    if (state.hasTripCalculated) {
      emit(state.copyWith(step: TripPlanningStep.detail));
    }
  }

  // ============================================================
  // TRIP MANAGEMENT
  // ============================================================

  /// Save current trip.
  Future<void> saveCurrentTrip({String? name}) async {
    if (state.currentTrip == null) {
      return;
    }

    emit(state.copyWith(isSaving: true, clearError: true));

    try {
      final tripToSave = name != null
          ? state.currentTrip!.copyWith(name: name)
          : state.currentTrip!;

      final savedTrip = await _repository.saveTrip(tripToSave);

      final savedTrips = List<TripModel>.from(state.savedTrips)..add(savedTrip);
      final recentTrips = [savedTrip, ...state.recentTrips].take(5).toList();

      emit(state.copyWith(
        isSaving: false,
        currentTrip: savedTrip,
        savedTrips: savedTrips,
        recentTrips: recentTrips,
        successMessage: 'Trip saved successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        isSaving: false,
        error: e.toString(),
      ));
    }
  }

  /// Load a saved trip.
  Future<void> loadTrip(String tripId) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final trip = await _repository.fetchTripById(tripId);

      if (trip != null) {
        emit(state.copyWith(
          isLoading: false,
          origin: trip.origin,
          destination: trip.destination,
          waypoints: trip.waypoints,
          selectedVehicle: trip.vehicle,
          preferences: trip.preferences,
          departureTime: trip.departureTime,
          currentTrip: trip,
          step: TripPlanningStep.summary,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: 'Trip not found',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  /// Delete a saved trip.
  Future<void> deleteTrip(String tripId) async {
    try {
      await _repository.deleteTrip(tripId);

      final savedTrips = state.savedTrips.where((t) => t.id != tripId).toList();
      final recentTrips = state.recentTrips.where((t) => t.id != tripId).toList();
      final favoriteTrips =
          state.favoriteTrips.where((t) => t.id != tripId).toList();

      emit(state.copyWith(
        savedTrips: savedTrips,
        recentTrips: recentTrips,
        favoriteTrips: favoriteTrips,
        successMessage: 'Trip deleted',
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// Toggle trip favorite status.
  Future<void> toggleTripFavorite(String tripId) async {
    try {
      await _repository.toggleTripFavorite(tripId);

      // Update local state
      final savedTrips = state.savedTrips.map((t) {
        if (t.id == tripId) {
          return t.copyWith(isFavorite: !t.isFavorite);
        }
        return t;
      }).toList();

      final favoriteTrips = savedTrips.where((t) => t.isFavorite).toList();

      var currentTrip = state.currentTrip;
      if (currentTrip?.id == tripId) {
        currentTrip = currentTrip!.copyWith(isFavorite: !currentTrip.isFavorite);
      }

      emit(state.copyWith(
        savedTrips: savedTrips,
        favoriteTrips: favoriteTrips,
        currentTrip: currentTrip,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  // ============================================================
  // VEHICLE MANAGEMENT
  // ============================================================

  /// Save a new vehicle profile.
  Future<void> saveVehicleProfile(VehicleProfileModel vehicle) async {
    try {
      final savedVehicle = await _repository.saveVehicleProfile(vehicle);
      final vehicles = List<VehicleProfileModel>.from(state.availableVehicles)
        ..add(savedVehicle);

      emit(state.copyWith(
        availableVehicles: vehicles,
        selectedVehicle: savedVehicle,
        successMessage: 'Vehicle saved',
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// Update a vehicle profile.
  Future<void> updateVehicleProfile(VehicleProfileModel vehicle) async {
    try {
      final updatedVehicle = await _repository.updateVehicleProfile(vehicle);
      final vehicles = state.availableVehicles.map((v) {
        if (v.id == vehicle.id) {
          return updatedVehicle;
        }
        return v;
      }).toList();

      var selectedVehicle = state.selectedVehicle;
      if (selectedVehicle?.id == vehicle.id) {
        selectedVehicle = updatedVehicle;
      }

      emit(state.copyWith(
        availableVehicles: vehicles,
        selectedVehicle: selectedVehicle,
        successMessage: 'Vehicle updated',
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// Delete a vehicle profile.
  Future<void> deleteVehicleProfile(String vehicleId) async {
    try {
      await _repository.deleteVehicleProfile(vehicleId);
      final vehicles =
          state.availableVehicles.where((v) => v.id != vehicleId).toList();

      var selectedVehicle = state.selectedVehicle;
      if (selectedVehicle?.id == vehicleId) {
        selectedVehicle = vehicles.isNotEmpty ? vehicles.first : null;
      }

      emit(state.copyWith(
        availableVehicles: vehicles,
        selectedVehicle: selectedVehicle,
        successMessage: 'Vehicle deleted',
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  // ============================================================
  // UTILITY
  // ============================================================

  /// Clear error message.
  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  /// Clear success message.
  void clearSuccessMessage() {
    emit(state.copyWith(clearSuccess: true));
  }

  /// Reset to initial input state.
  void reset() {
    emit(TripPlannerState(
      availableVehicles: state.availableVehicles,
      selectedVehicle: state.selectedVehicle,
      savedTrips: state.savedTrips,
      recentTrips: state.recentTrips,
      favoriteTrips: state.favoriteTrips,
    ));
  }

  /// Start new trip planning.
  void startNewTrip() {
    emit(state.copyWith(
      step: TripPlanningStep.input,
      clearOrigin: true,
      clearDestination: true,
      waypoints: const [],
      clearCurrentTrip: true,
    ));
  }
}

