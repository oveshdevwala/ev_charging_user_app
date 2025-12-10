/// File: lib/admin/features/offers/repository/offers_repository.dart
/// Purpose: Repository abstraction for offers data source
/// Belongs To: admin/features/offers
/// Customization Guide:
/// - Toggle between mock and remote via [useMock] flag
/// - Replace with dependency injection when DI framework is added
library;

import '../models/offer_model.dart';
import 'offers_local_mock.dart';
import 'offers_remote_data_source.dart';

/// Repository that abstracts between mock and remote data sources.
class OffersRepository {
  OffersRepository({
    bool useMock = true,
    OffersLocalMock? mockDataSource,
    OffersRemoteDataSource? remoteDataSource,
  }) : _useMock = useMock,
       _mockDataSource = mockDataSource ?? OffersLocalMock(),
       _remoteDataSource = remoteDataSource ?? OffersRemoteDataSource();

  final bool _useMock;
  final OffersLocalMock _mockDataSource;
  final OffersRemoteDataSource _remoteDataSource;

  /// Fetch offers with pagination and filters.
  Future<PaginatedOffersResponse> fetchOffers({
    int page = 1,
    int perPage = 25,
    OfferFilters? filters,
    bool forceRefresh = false,
  }) async {
    if (_useMock) {
      return _mockDataSource.fetchOffers(
        page: page,
        perPage: perPage,
        filters: filters,
        forceRefresh: forceRefresh,
      );
    } else {
      return _remoteDataSource.fetchOffers(
        page: page,
        perPage: perPage,
        filters: filters,
      );
    }
  }

  /// Fetch single offer by id.
  Future<OfferModel> fetchOfferById(String id) async {
    if (_useMock) {
      return _mockDataSource.fetchOfferById(id);
    } else {
      return _remoteDataSource.fetchOfferById(id);
    }
  }

  /// Create new offer.
  Future<OfferModel> createOffer(OfferModel offer) async {
    if (_useMock) {
      return _mockDataSource.createOffer(offer);
    } else {
      return _remoteDataSource.createOffer(offer);
    }
  }

  /// Update existing offer.
  Future<OfferModel> updateOffer(OfferModel offer) async {
    if (_useMock) {
      return _mockDataSource.updateOffer(offer);
    } else {
      return _remoteDataSource.updateOffer(offer);
    }
  }

  /// Delete offer.
  Future<void> deleteOffer(String id) async {
    if (_useMock) {
      return _mockDataSource.deleteOffer(id);
    } else {
      return _remoteDataSource.deleteOffer(id);
    }
  }

  /// Activate offer.
  Future<OfferModel> activateOffer(String id) async {
    if (_useMock) {
      return _mockDataSource.activateOffer(id);
    } else {
      return _remoteDataSource.activateOffer(id);
    }
  }

  /// Deactivate offer.
  Future<OfferModel> deactivateOffer(String id) async {
    if (_useMock) {
      return _mockDataSource.deactivateOffer(id);
    } else {
      return _remoteDataSource.deactivateOffer(id);
    }
  }
}
