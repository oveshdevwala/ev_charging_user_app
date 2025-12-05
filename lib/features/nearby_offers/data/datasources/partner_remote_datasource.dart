/// File: lib/features/nearby_offers/data/datasources/partner_remote_datasource.dart
/// Purpose: Abstract interface for remote partner data operations
/// Belongs To: nearby_offers feature
/// Customization Guide:
///    - Implement with Firebase, REST API, or any backend
///    - Keep interface stable, swap implementations as needed
library;

import '../models/models.dart';

/// Sorting options for offers.
enum OfferSortType { distance, discount, trending, newest, expiringSoon }

/// Filter parameters for fetching offers.
class OfferFilterParams {
  const OfferFilterParams({
    this.latitude,
    this.longitude,
    this.radiusKm = 5.0,
    this.category,
    this.offerType,
    this.sortBy = OfferSortType.distance,
    this.page = 1,
    this.limit = 20,
  });

  final double? latitude;
  final double? longitude;
  final double radiusKm;
  final PartnerCategory? category;
  final PartnerOfferType? offerType;
  final OfferSortType sortBy;
  final int page;
  final int limit;

  OfferFilterParams copyWith({
    double? latitude,
    double? longitude,
    double? radiusKm,
    PartnerCategory? category,
    PartnerOfferType? offerType,
    OfferSortType? sortBy,
    int? page,
    int? limit,
  }) {
    return OfferFilterParams(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radiusKm: radiusKm ?? this.radiusKm,
      category: category ?? this.category,
      offerType: offerType ?? this.offerType,
      sortBy: sortBy ?? this.sortBy,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }
}

/// Abstract remote data source for partner operations.
///
/// Implement this interface with Firebase, REST API, or any backend.
/// The repository layer depends on this interface for data fetching.
abstract class PartnerRemoteDataSource {
  /// Fetch nearby offers based on filter parameters.
  Future<List<PartnerOfferModel>> fetchNearbyOffers(OfferFilterParams params);

  /// Fetch partners by category.
  Future<List<PartnerModel>> fetchPartners({
    PartnerCategory? category,
    double? latitude,
    double? longitude,
    int page = 1,
    int limit = 20,
  });

  /// Fetch single partner by ID.
  Future<PartnerModel?> fetchPartnerById(String partnerId);

  /// Fetch offers for a specific partner.
  Future<List<PartnerOfferModel>> fetchPartnerOffers(String partnerId);

  /// Check in at a partner location.
  Future<CheckInModel> checkInAtPartner({
    required String partnerId,
    required String userId,
    required double userLatitude,
    required double userLongitude,
  });

  /// Redeem an offer.
  Future<RedemptionModel> redeemOffer({
    required String offerId,
    required String userId,
  });

  /// Refresh QR code for a redemption.
  Future<RedemptionModel> refreshRedemptionQr(String redemptionId);

  /// Mark redemption as used (by partner scan).
  Future<RedemptionModel> markRedemptionUsed({
    required String redemptionId,
    String? transactionId,
    double? originalAmount,
    double? discountApplied,
    double? finalAmount,
  });

  /// Fetch user's check-in history.
  Future<List<CheckInModel>> fetchCheckInHistory({
    required String userId,
    int page = 1,
    int limit = 20,
  });

  /// Fetch user's redemption history.
  Future<List<RedemptionModel>> fetchRedemptionHistory({
    required String userId,
    OfferStatus? status,
    int page = 1,
    int limit = 20,
  });

  /// Search partners by name or keyword.
  Future<List<PartnerModel>> searchPartners(String query);

  /// Get category counts for filtering.
  Future<Map<PartnerCategory, int>> getCategoryCounts({
    double? latitude,
    double? longitude,
    double radiusKm = 5.0,
  });
}
