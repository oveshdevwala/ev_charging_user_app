/// File: lib/features/nearby_offers/presentation/blocs/nearby_offers/nearby_offers_event.dart
/// Purpose: Events for Nearby Offers BLoC
/// Belongs To: nearby_offers feature
library;

import 'package:equatable/equatable.dart';

import '../../../data/datasources/partner_remote_datasource.dart';
import '../../../data/models/partner_category.dart';
import '../../../data/models/partner_offer_model.dart';

abstract class NearbyOffersEvent extends Equatable {
  const NearbyOffersEvent();

  @override
  List<Object?> get props => [];
}

/// Fetch initial offers.
class FetchNearbyOffers extends NearbyOffersEvent {
  const FetchNearbyOffers({this.latitude, this.longitude, this.radiusKm = 5.0});

  final double? latitude;
  final double? longitude;
  final double radiusKm;

  @override
  List<Object?> get props => [latitude, longitude, radiusKm];
}

/// Refresh offers list.
class RefreshNearbyOffers extends NearbyOffersEvent {
  const RefreshNearbyOffers();
}

/// Load more offers (pagination).
class LoadMoreOffers extends NearbyOffersEvent {
  const LoadMoreOffers();
}

/// Apply filters.
class ApplyOfferFilters extends NearbyOffersEvent {
  const ApplyOfferFilters({
    this.category,
    this.offerType,
    this.radiusKm,
    this.sortBy,
  });

  final PartnerCategory? category;
  final PartnerOfferType? offerType;
  final double? radiusKm;
  final OfferSortType? sortBy;

  @override
  List<Object?> get props => [category, offerType, radiusKm, sortBy];
}

/// Clear all filters.
class ClearOfferFilters extends NearbyOffersEvent {
  const ClearOfferFilters();
}
