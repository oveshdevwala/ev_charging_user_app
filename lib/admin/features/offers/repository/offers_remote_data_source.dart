/// File: lib/admin/features/offers/repository/offers_remote_data_source.dart
/// Purpose: Remote data source interface for offers API
/// Belongs To: admin/features/offers
/// Customization Guide:
/// - Implement API calls when backend is ready
library;

import '../models/offer_model.dart';
import 'offers_local_mock.dart';

/// Remote data source for offers (to be implemented with API).
class OffersRemoteDataSource {
  Future<PaginatedOffersResponse> fetchOffers({
    int page = 1,
    int perPage = 25,
    OfferFilters? filters,
  }) async {
    // TODO: Implement API call
    throw UnimplementedError('API integration pending');
  }

  Future<OfferModel> fetchOfferById(String id) async {
    // TODO: Implement API call
    throw UnimplementedError('API integration pending');
  }

  Future<OfferModel> createOffer(OfferModel offer) async {
    // TODO: Implement API call
    throw UnimplementedError('API integration pending');
  }

  Future<OfferModel> updateOffer(OfferModel offer) async {
    // TODO: Implement API call
    throw UnimplementedError('API integration pending');
  }

  Future<void> deleteOffer(String id) async {
    // TODO: Implement API call
    throw UnimplementedError('API integration pending');
  }

  Future<OfferModel> activateOffer(String id) async {
    // TODO: Implement API call
    throw UnimplementedError('API integration pending');
  }

  Future<OfferModel> deactivateOffer(String id) async {
    // TODO: Implement API call
    throw UnimplementedError('API integration pending');
  }
}
