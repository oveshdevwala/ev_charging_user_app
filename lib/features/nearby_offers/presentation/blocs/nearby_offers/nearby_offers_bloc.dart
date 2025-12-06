/// File: lib/features/nearby_offers/presentation/blocs/nearby_offers/nearby_offers_bloc.dart
/// Purpose: BLoC for managing nearby offers
/// Belongs To: nearby_offers feature
library;

import 'package:ev_charging_user_app/core/utils/offer_sort_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/partner_remote_datasource.dart';
import '../../../domain/usecases/get_nearby_offers_usecase.dart';
import 'nearby_offers_event.dart';
import 'nearby_offers_state.dart';

class NearbyOffersBloc extends Bloc<NearbyOffersEvent, NearbyOffersState> {
  NearbyOffersBloc({required GetNearbyOffersUseCase getNearbyOffers})
    : _getNearbyOffers = getNearbyOffers,
      super(const NearbyOffersState()) {
    on<FetchNearbyOffers>(_onFetchNearbyOffers);
    on<RefreshNearbyOffers>(_onRefreshNearbyOffers);
    on<LoadMoreOffers>(_onLoadMoreOffers);
    on<ApplyOfferFilters>(_onApplyFilters);
    on<ClearOfferFilters>(_onClearFilters);
  }

  final GetNearbyOffersUseCase _getNearbyOffers;

  Future<void> _onFetchNearbyOffers(
    FetchNearbyOffers event,
    Emitter<NearbyOffersState> emit,
  ) async {
    emit(state.copyWith(status: NearbyOffersStatus.loading));

    try {
      final params = state.filterParams.copyWith(
        latitude: event.latitude,
        longitude: event.longitude,
        radiusKm: event.radiusKm,
        page: 1,
      );

      final offers = await _getNearbyOffers(params);

      emit(
        state.copyWith(
          status: NearbyOffersStatus.loaded,
          offers: offers,
          filterParams: params,
          hasReachedMax: offers.length < params.limit,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NearbyOffersStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRefreshNearbyOffers(
    RefreshNearbyOffers event,
    Emitter<NearbyOffersState> emit,
  ) async {
    if (state.isRefreshing) return;

    emit(state.copyWith(isRefreshing: true));

    try {
      final params = state.filterParams.copyWith(page: 1);
      final offers = await _getNearbyOffers(params);

      emit(
        state.copyWith(
          status: NearbyOffersStatus.loaded,
          offers: offers,
          filterParams: params,
          hasReachedMax: offers.length < params.limit,
          isRefreshing: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isRefreshing: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadMoreOffers(
    LoadMoreOffers event,
    Emitter<NearbyOffersState> emit,
  ) async {
    if (state.hasReachedMax || state.isLoadingMore) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final nextPage = state.filterParams.page + 1;
      final params = state.filterParams.copyWith(page: nextPage);

      final newOffers = await _getNearbyOffers(params);

      emit(
        state.copyWith(
          isLoadingMore: false,
          offers: [...state.offers, ...newOffers],
          filterParams: params,
          hasReachedMax: newOffers.length < params.limit,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onApplyFilters(
    ApplyOfferFilters event,
    Emitter<NearbyOffersState> emit,
  ) async {
    emit(state.copyWith(status: NearbyOffersStatus.loading));

    try {
      final params = state.filterParams.copyWith(
        category: event.category,
        offerType: event.offerType,
        radiusKm: event.radiusKm,
        sortBy: event.sortBy,
        page: 1,
      );

      final offers = await _getNearbyOffers(params);

      // Apply client-side sorting if needed (though repo should handle it)
      final sortedOffers = OfferSortUtils.sortOffers(offers, params.sortBy);

      emit(
        state.copyWith(
          status: NearbyOffersStatus.loaded,
          offers: sortedOffers,
          filterParams: params,
          hasReachedMax: offers.length < params.limit,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NearbyOffersStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onClearFilters(
    ClearOfferFilters event,
    Emitter<NearbyOffersState> emit,
  ) async {
    emit(state.copyWith(status: NearbyOffersStatus.loading));

    try {
      // Keep location but reset other filters
      final params = OfferFilterParams(
        latitude: state.filterParams.latitude,
        longitude: state.filterParams.longitude,
      );

      final offers = await _getNearbyOffers(params);

      emit(
        state.copyWith(
          status: NearbyOffersStatus.loaded,
          offers: offers,
          filterParams: params,
          hasReachedMax: offers.length < params.limit,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NearbyOffersStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
