/// File: lib/features/nearby_offers/data/repositories/partner_repository.dart
/// Purpose: Repository implementation for partner data
/// Belongs To: nearby_offers feature
/// Customization Guide:
///    - Replace DummyPartnerRepository with RealPartnerRepository when backend is ready
///    - Add caching logic in the real implementation
library;


import '../datasources/datasources.dart';
import '../models/models.dart';

/// Repository interface for partner operations.
abstract class PartnerRepository {
  Future<List<PartnerOfferModel>> fetchNearbyOffers(OfferFilterParams params);

  Future<List<PartnerModel>> fetchPartners({
    PartnerCategory? category,
    double? latitude,
    double? longitude,
    int page = 1,
    int limit = 20,
  });

  Future<PartnerModel?> fetchPartnerById(String partnerId);

  Future<List<PartnerOfferModel>> fetchPartnerOffers(String partnerId);

  Future<CheckInModel> checkInAtPartner({
    required String partnerId,
    required String userId,
    required double userLatitude,
    required double userLongitude,
  });

  Future<RedemptionModel> redeemOffer({
    required String offerId,
    required String userId,
  });

  Future<List<CheckInModel>> fetchCheckInHistory({
    required String userId,
    int page = 1,
    int limit = 20,
  });

  Future<List<RedemptionModel>> fetchRedemptionHistory({
    required String userId,
    OfferStatus? status,
    int page = 1,
    int limit = 20,
  });
}

/// Dummy implementation with mock data.
class DummyPartnerRepository implements PartnerRepository {
  @override
  Future<List<PartnerOfferModel>> fetchNearbyOffers(
    OfferFilterParams params,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));

    // Mock data generation
    return List.generate(10, (index) {
      final type =
          PartnerOfferType.values[index % PartnerOfferType.values.length];
      final category =
          PartnerCategory.values[index % PartnerCategory.values.length];

      return PartnerOfferModel(
        id: 'offer_$index',
        partnerId: 'partner_$index',
        partnerName: 'Partner Name $index',
        title: 'Special Offer $index',
        description:
            'Get amazing discounts on your favorite items. Limited time only!',
        offerType: type,
        partnerCategory: category,
        imageUrl: 'https://picsum.photos/seed/$index/400/200',
        partnerLogoUrl: 'https://picsum.photos/seed/logo_$index/100/100',
        discountPercent: type == PartnerOfferType.discount
            ? (index + 1) * 5.0
            : null,
        cashbackPercent: type == PartnerOfferType.cashback ? 5.0 : null,
        distance: 0.5 + (index * 0.2),
        validUntil: DateTime.now().add(Duration(days: index + 1)),
        latitude: 37.7749 + (index * 0.001),
        longitude: -122.4194 + (index * 0.001),
      );
    });
  }

  @override
  Future<List<PartnerModel>> fetchPartners({
    PartnerCategory? category,
    double? latitude,
    double? longitude,
    int page = 1,
    int limit = 20,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    return List.generate(10, (index) {
      final cat =
          category ??
          PartnerCategory.values[index % PartnerCategory.values.length];

      return PartnerModel(
        id: 'partner_$index',
        name: 'Partner Business $index',
        category: cat,
        address: '123 Partner St, City, State',
        latitude: 37.7749 + (index * 0.002),
        longitude: -122.4194 + (index * 0.002),
        description:
            'A great place for ${cat.name}. Visit us while you charge!',
        imageUrl: 'https://picsum.photos/seed/partner_$index/400/300',
        logoUrl: 'https://picsum.photos/seed/logo_$index/100/100',
        rating: 4.0 + (index % 10) / 10,
        reviewCount: 50 + index * 10,
        distance: 0.2 + (index * 0.3),
        openTime: '09:00',
        closeTime: '22:00',
        activeOfferCount: 2,
        checkInCredits: 10 + index,
      );
    });
  }

  @override
  Future<PartnerModel?> fetchPartnerById(String partnerId) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    return PartnerModel(
      id: partnerId,
      name: 'Partner Business Details',
      category: PartnerCategory.food,
      address: '123 Partner St, City, State',
      latitude: 37.7749,
      longitude: -122.4194,
      description:
          'Detailed description of the partner business. We offer great services and products.',
      imageUrl: 'https://picsum.photos/seed/detail/400/300',
      logoUrl: 'https://picsum.photos/seed/logo/100/100',
      rating: 4.5,
      reviewCount: 120,
      distance: 0.5,
      openTime: '08:00',
      closeTime: '23:00',
      activeOfferCount: 3,
      photos: List.generate(
        5,
        (i) => 'https://picsum.photos/seed/photo_$i/300/300',
      ),
      isVerified: true,
    );
  }

  @override
  Future<List<PartnerOfferModel>> fetchPartnerOffers(String partnerId) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    return List.generate(3, (index) {
      return PartnerOfferModel(
        id: 'partner_offer_$index',
        partnerId: partnerId,
        partnerName: 'Partner Business',
        title: 'Partner Offer $index',
        description: 'Exclusive offer for EV drivers.',
        offerType: PartnerOfferType.discount,
        partnerCategory: PartnerCategory.food,
        discountPercent: 15,
        validUntil: DateTime.now().add(const Duration(days: 7)),
      );
    });
  }

  @override
  Future<CheckInModel> checkInAtPartner({
    required String partnerId,
    required String userId,
    required double userLatitude,
    required double userLongitude,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 1000));

    // Simulate geo-fence check (always success for dummy)
    return CheckInModel(
      id: 'checkin_${DateTime.now().millisecondsSinceEpoch}',
      partnerId: partnerId,
      partnerName: 'Partner Business',
      userId: userId,
      checkInTime: DateTime.now(),
      status: CheckInStatus.success,
      creditsEarned: 20,
      validationMessage: 'Successfully checked in!',
      distanceMeters: 50,
    );
  }

  @override
  Future<RedemptionModel> redeemOffer({
    required String offerId,
    required String userId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 1000));

    return RedemptionModel(
      id: 'redeem_${DateTime.now().millisecondsSinceEpoch}',
      offerId: offerId,
      offerTitle: 'Special Offer',
      partnerId: 'partner_1',
      partnerName: 'Partner Business',
      userId: userId,
      status: OfferStatus.active,
      createdAt: DateTime.now(),
      qrCode: 'EV_OFFER_${offerId}_$userId',
      qrExpiresAt: DateTime.now().add(const Duration(minutes: 15)),
    );
  }

  @override
  Future<List<CheckInModel>> fetchCheckInHistory({
    required String userId,
    int page = 1,
    int limit = 20,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    return List.generate(5, (index) {
      return CheckInModel(
        id: 'history_checkin_$index',
        partnerId: 'partner_$index',
        partnerName: 'Partner $index',
        userId: userId,
        checkInTime: DateTime.now().subtract(Duration(days: index)),
        status: CheckInStatus.success,
        creditsEarned: 10,
      );
    });
  }

  @override
  Future<List<RedemptionModel>> fetchRedemptionHistory({
    required String userId,
    OfferStatus? status,
    int page = 1,
    int limit = 20,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    return List.generate(5, (index) {
      return RedemptionModel(
        id: 'history_redeem_$index',
        offerId: 'offer_$index',
        offerTitle: 'Offer Title $index',
        partnerId: 'partner_$index',
        partnerName: 'Partner $index',
        userId: userId,
        status: index == 0 ? OfferStatus.active : OfferStatus.used,
        createdAt: DateTime.now().subtract(Duration(days: index)),
        redeemedAt: index == 0
            ? null
            : DateTime.now().subtract(Duration(days: index)),
      );
    });
  }
}
