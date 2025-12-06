/// File: lib/features/home/bloc/home_state.dart
/// Purpose: Home page state for BLoC with all advanced section data
/// Belongs To: home feature
/// Customization Guide:
///    - Add new fields for additional sections
///    - All fields must be in copyWith and props
library;

import 'package:equatable/equatable.dart';

import '../../../features/nearby_offers/data/models/partner_offer_model.dart';
import '../../../models/bundle_model.dart';
import '../../../models/offer_model.dart';
import '../../../models/station_model.dart';
import '../../../models/trip_route_model.dart';
import '../../../models/user_activity_model.dart';

/// Home category enum for quick actions grid.
enum HomeCategory {
  findCharger,
  bookSlot,
  myBookings,
  myVehicles,
  chargingHistory,
  tripPlanner,
}

/// Home page state with all section data.
class HomeState extends Equatable {
  const HomeState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.nearbyStations = const [],
    this.savedRoutes = const [],
    this.offers = const [],
    this.bundles = const [],
    this.nearbyOffers = const [],
    this.activitySummary,
    this.error,
    this.selectedOfferId,
    this.selectedStationId,
  });

  /// Initial loading state.
  factory HomeState.initial() => const HomeState(isLoading: true);

  /// Loading state for initial load.
  final bool isLoading;

  /// Refreshing state for pull-to-refresh.
  final bool isRefreshing;

  /// Nearby stations with smart ranking.
  final List<StationModel> nearbyStations;

  /// Saved trip routes.
  final List<TripRouteModel> savedRoutes;

  /// Promotional offers.
  final List<OfferModel> offers;

  /// Recommended bundles/subscriptions.
  final List<BundleModel> bundles;

  /// Nearby partner offers.
  final List<PartnerOfferModel> nearbyOffers;

  /// User activity summary.
  final UserActivitySummary? activitySummary;

  /// Error message if any.
  final String? error;

  /// Currently selected offer ID.
  final String? selectedOfferId;

  /// Currently selected station ID.
  final String? selectedStationId;

  /// Check if data is loaded.
  bool get hasData =>
      nearbyStations.isNotEmpty ||
      offers.isNotEmpty ||
      bundles.isNotEmpty ||
      nearbyOffers.isNotEmpty ||
      activitySummary != null;

  /// Check if there's an error.
  bool get hasError => error != null && error!.isNotEmpty;

  /// Copy with new values.
  HomeState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    List<StationModel>? nearbyStations,
    List<TripRouteModel>? savedRoutes,
    List<OfferModel>? offers,
    List<BundleModel>? bundles,
    List<PartnerOfferModel>? nearbyOffers,
    UserActivitySummary? activitySummary,
    String? error,
    String? selectedOfferId,
    String? selectedStationId,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      nearbyStations: nearbyStations ?? this.nearbyStations,
      savedRoutes: savedRoutes ?? this.savedRoutes,
      offers: offers ?? this.offers,
      bundles: bundles ?? this.bundles,
      nearbyOffers: nearbyOffers ?? this.nearbyOffers,
      activitySummary: activitySummary ?? this.activitySummary,
      error: error,
      selectedOfferId: selectedOfferId ?? this.selectedOfferId,
      selectedStationId: selectedStationId ?? this.selectedStationId,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isRefreshing,
        nearbyStations,
        savedRoutes,
        offers,
        bundles,
        nearbyOffers,
        activitySummary,
        error,
        selectedOfferId,
        selectedStationId,
      ];
}
