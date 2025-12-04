/// File: lib/features/trip_planner/bloc/trip_planner_state.dart
/// Purpose: Trip planner state for BLoC with all trip planning data
/// Belongs To: trip_planner feature
/// Customization Guide:
///    - Add new fields for additional trip planning features
///    - All fields must be in copyWith and props
library;

import 'package:equatable/equatable.dart';

import '../models/models.dart';

/// Trip planning step enum.
enum TripPlanningStep {
  /// Home page with saved trips.
  home,

  /// Entering origin and destination.
  input,

  /// Calculating route and stops.
  calculating,

  /// Showing trip summary.
  summary,

  /// Viewing charging stops.
  stops,

  /// Viewing trip insights.
  insights,

  /// Viewing detailed itinerary.
  detail,
}

/// Trip planner state with all planning data.
class TripPlannerState extends Equatable {
  const TripPlannerState({
    this.step = TripPlanningStep.home,
    this.isLoading = false,
    this.isCalculating = false,
    this.isSaving = false,
    this.origin,
    this.destination,
    this.waypoints = const [],
    this.selectedVehicle,
    this.availableVehicles = const [],
    this.preferences = const TripPreferences(),
    this.departureTime,
    this.currentTrip,
    this.savedTrips = const [],
    this.recentTrips = const [],
    this.favoriteTrips = const [],
    this.locationSearchResults = const [],
    this.isSearching = false,
    this.searchQuery,
    this.error,
    this.successMessage,
  });

  /// Initial loading state.
  factory TripPlannerState.initial() => const TripPlannerState(isLoading: true);

  /// Current planning step.
  final TripPlanningStep step;

  /// Loading state for initial data fetch.
  final bool isLoading;

  /// Calculating state for trip calculation.
  final bool isCalculating;

  /// Saving state for save operations.
  final bool isSaving;

  /// Selected origin location.
  final LocationModel? origin;

  /// Selected destination location.
  final LocationModel? destination;

  /// Optional waypoints.
  final List<LocationModel> waypoints;

  /// Selected vehicle for the trip.
  final VehicleProfileModel? selectedVehicle;

  /// Available vehicle profiles.
  final List<VehicleProfileModel> availableVehicles;

  /// Trip preferences.
  final TripPreferences preferences;

  /// Planned departure time.
  final DateTime? departureTime;

  /// Current calculated trip.
  final TripModel? currentTrip;

  /// All saved trips.
  final List<TripModel> savedTrips;

  /// Recent trips.
  final List<TripModel> recentTrips;

  /// Favorite trips.
  final List<TripModel> favoriteTrips;

  /// Location search results.
  final List<LocationModel> locationSearchResults;

  /// Whether location search is in progress.
  final bool isSearching;

  /// Current search query.
  final String? searchQuery;

  /// Error message if any.
  final String? error;

  /// Success message for user feedback.
  final String? successMessage;

  /// Check if ready to calculate trip.
  bool get canCalculate =>
      origin != null && destination != null && selectedVehicle != null;

  /// Check if trip has been calculated.
  bool get hasTripCalculated => currentTrip != null;

  /// Check if there's an error.
  bool get hasError => error != null && error!.isNotEmpty;

  /// Get total charging stops count.
  int get chargingStopsCount => currentTrip?.chargingStops.length ?? 0;

  /// Get total trip cost.
  double get totalCost => currentTrip?.estimates?.estimatedCost ?? 0;

  /// Get total trip distance.
  double get totalDistanceKm => currentTrip?.estimates?.totalDistanceKm ?? 0;

  /// Copy with new values.
  TripPlannerState copyWith({
    TripPlanningStep? step,
    bool? isLoading,
    bool? isCalculating,
    bool? isSaving,
    LocationModel? origin,
    LocationModel? destination,
    List<LocationModel>? waypoints,
    VehicleProfileModel? selectedVehicle,
    List<VehicleProfileModel>? availableVehicles,
    TripPreferences? preferences,
    DateTime? departureTime,
    TripModel? currentTrip,
    List<TripModel>? savedTrips,
    List<TripModel>? recentTrips,
    List<TripModel>? favoriteTrips,
    List<LocationModel>? locationSearchResults,
    bool? isSearching,
    String? searchQuery,
    String? error,
    String? successMessage,
    bool clearOrigin = false,
    bool clearDestination = false,
    bool clearCurrentTrip = false,
    bool clearError = false,
    bool clearSuccess = false,
    bool clearSearchResults = false,
  }) {
    return TripPlannerState(
      step: step ?? this.step,
      isLoading: isLoading ?? this.isLoading,
      isCalculating: isCalculating ?? this.isCalculating,
      isSaving: isSaving ?? this.isSaving,
      origin: clearOrigin ? null : (origin ?? this.origin),
      destination: clearDestination ? null : (destination ?? this.destination),
      waypoints: waypoints ?? this.waypoints,
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,
      availableVehicles: availableVehicles ?? this.availableVehicles,
      preferences: preferences ?? this.preferences,
      departureTime: departureTime ?? this.departureTime,
      currentTrip: clearCurrentTrip ? null : (currentTrip ?? this.currentTrip),
      savedTrips: savedTrips ?? this.savedTrips,
      recentTrips: recentTrips ?? this.recentTrips,
      favoriteTrips: favoriteTrips ?? this.favoriteTrips,
      locationSearchResults:
          clearSearchResults ? const [] : (locationSearchResults ?? this.locationSearchResults),
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
      error: clearError ? null : error,
      successMessage: clearSuccess ? null : successMessage,
    );
  }

  @override
  List<Object?> get props => [
        step,
        isLoading,
        isCalculating,
        isSaving,
        origin,
        destination,
        waypoints,
        selectedVehicle,
        availableVehicles,
        preferences,
        departureTime,
        currentTrip,
        savedTrips,
        recentTrips,
        favoriteTrips,
        locationSearchResults,
        isSearching,
        searchQuery,
        error,
        successMessage,
      ];
}

