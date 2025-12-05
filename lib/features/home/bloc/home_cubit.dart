/// File: lib/features/home/bloc/home_cubit.dart
/// Purpose: Home page Cubit for managing all home screen data
/// Belongs To: home feature
/// Customization Guide:
///    - Add new methods for additional section interactions
///    - All async operations should handle errors properly
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../features/nearby_offers/data/datasources/partner_remote_datasource.dart';
import '../../../features/nearby_offers/data/models/partner_offer_model.dart';
import '../../../features/nearby_offers/domain/usecases/get_nearby_offers_usecase.dart';
import '../../../repositories/home_repository.dart';
import '../../../repositories/station_repository.dart';
import 'home_state.dart';

/// Home page Cubit managing all section data.
class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required HomeRepository homeRepository,
    required StationRepository stationRepository,
  })  : _homeRepository = homeRepository,
        _stationRepository = stationRepository,
        super(HomeState.initial());

  final HomeRepository _homeRepository;
  final StationRepository _stationRepository;

  /// Load all home data.
  Future<void> loadHomeData({
    double latitude = 37.7749,
    double longitude = -122.4194,
  }) async {
    emit(state.copyWith(isLoading: true));

    try {
      // Fetch all data in parallel
      final stationsFuture = _homeRepository.fetchNearbyStations(
        latitude: latitude,
        longitude: longitude,
      );
      final routesFuture = _homeRepository.fetchSavedRoutes();
      final offersFuture = _homeRepository.fetchOffers();
      final bundlesFuture = _homeRepository.fetchBundles();
      final summaryFuture = _homeRepository.fetchActivitySummary();
      
      // Fetch nearby offers
      final nearbyOffersFuture = _fetchNearbyOffers(
        latitude: latitude,
        longitude: longitude,
      );

      final stations = await stationsFuture;
      final routes = await routesFuture;
      final offers = await offersFuture;
      final bundles = await bundlesFuture;
      final summary = await summaryFuture;
      final nearbyOffers = await nearbyOffersFuture;

      emit(state.copyWith(
        isLoading: false,
        nearbyStations: stations,
        savedRoutes: routes,
        offers: offers,
        bundles: bundles,
        nearbyOffers: nearbyOffers,
        activitySummary: summary,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  /// Refresh all home data.
  Future<void> refreshHomeData({
    double latitude = 37.7749,
    double longitude = -122.4194,
  }) async {
    emit(state.copyWith(isRefreshing: true));

    try {
      final stationsFuture = _homeRepository.fetchNearbyStations(
        latitude: latitude,
        longitude: longitude,
      );
      final routesFuture = _homeRepository.fetchSavedRoutes();
      final offersFuture = _homeRepository.fetchOffers();
      final bundlesFuture = _homeRepository.fetchBundles();
      final summaryFuture = _homeRepository.fetchActivitySummary();
      
      // Fetch nearby offers
      final nearbyOffersFuture = _fetchNearbyOffers(
        latitude: latitude,
        longitude: longitude,
      );

      final stations = await stationsFuture;
      final routes = await routesFuture;
      final offers = await offersFuture;
      final bundles = await bundlesFuture;
      final summary = await summaryFuture;
      final nearbyOffers = await nearbyOffersFuture;

      emit(state.copyWith(
        isRefreshing: false,
        nearbyStations: stations,
        savedRoutes: routes,
        offers: offers,
        bundles: bundles,
        nearbyOffers: nearbyOffers,
        activitySummary: summary,
      ));
    } catch (e) {
      emit(state.copyWith(
        isRefreshing: false,
        error: e.toString(),
      ));
    }
  }

  /// Fetch nearby offers using the use case.
  Future<List<PartnerOfferModel>> _fetchNearbyOffers({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final getNearbyOffers = sl<GetNearbyOffersUseCase>();
      final params = OfferFilterParams(
        latitude: latitude,
        longitude: longitude,
        radiusKm: 10.0, // 10km radius for home page
        limit: 10, // Limit to 10 offers for home page
      );
      return await getNearbyOffers(params);
    } catch (e) {
      // Return empty list on error to not break home page
      return [];
    }
  }

  /// Select an offer.
  void selectOffer(String offerId) {
    emit(state.copyWith(selectedOfferId: offerId));
  }

  /// Select a station.
  void selectStation(String stationId) {
    emit(state.copyWith(selectedStationId: stationId));
  }

  /// Toggle favorite for a station.
  Future<void> toggleFavorite(String stationId) async {
    await _stationRepository.toggleFavorite(stationId);

    final updatedStations = state.nearbyStations.map((station) {
      if (station.id == stationId) {
        return station.copyWith(isFavorite: !station.isFavorite);
      }
      return station;
    }).toList();

    emit(state.copyWith(nearbyStations: updatedStations));
  }

  /// Clear selection.
  void clearSelection() {
    emit(state.copyWith(
      
    ));
  }

  /// Clear error.
  void clearError() {
    emit(state.copyWith());
  }
}
