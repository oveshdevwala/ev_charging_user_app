/// File: lib/features/nearby_offers/presentation/blocs/nearby_offers/nearby_offers_state.dart
/// Purpose: State for Nearby Offers BLoC
/// Belongs To: nearby_offers feature
library;

import 'package:equatable/equatable.dart';

import '../../../data/datasources/partner_remote_datasource.dart';
import '../../../data/models/partner_offer_model.dart';

enum NearbyOffersStatus { initial, loading, loaded, error }

class NearbyOffersState extends Equatable {
  const NearbyOffersState({
    this.status = NearbyOffersStatus.initial,
    this.offers = const [],
    this.filterParams = const OfferFilterParams(),
    this.hasReachedMax = false,
    this.errorMessage,
    this.isRefreshing = false,
    this.isLoadingMore = false,
  });

  final NearbyOffersStatus status;
  final List<PartnerOfferModel> offers;
  final OfferFilterParams filterParams;
  final bool hasReachedMax;
  final String? errorMessage;
  final bool isRefreshing;
  final bool isLoadingMore;

  NearbyOffersState copyWith({
    NearbyOffersStatus? status,
    List<PartnerOfferModel>? offers,
    OfferFilterParams? filterParams,
    bool? hasReachedMax,
    String? errorMessage,
    bool? isRefreshing,
    bool? isLoadingMore,
  }) {
    return NearbyOffersState(
      status: status ?? this.status,
      offers: offers ?? this.offers,
      filterParams: filterParams ?? this.filterParams,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    status,
    offers,
    filterParams,
    hasReachedMax,
    errorMessage,
    isRefreshing,
    isLoadingMore,
  ];
}
