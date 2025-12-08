/// File: lib/core/services/analytics_service.dart
/// Purpose: Abstract analytics service interface
/// Belongs To: shared
/// Customization Guide:
///    - Implement with Firebase Analytics, Mixpanel, or Segment
///    - Add new event methods as needed
library;

/// Abstract analytics service.
abstract class AnalyticsService {
  /// Log when an offer is viewed.
  Future<void> logOfferViewed({
    required String offerId,
    required String partnerId,
    required String offerType,
  });

  /// Log when an offer is redeemed.
  Future<void> logOfferRedeemed({
    required String offerId,
    required String partnerId,
    required double discountAmount,
  });

  /// Log when a user checks in at a partner.
  Future<void> logPartnerCheckIn({
    required String partnerId,
    required String partnerName,
    required int creditsEarned,
  });

  /// Log when the marketplace is opened.
  Future<void> logMarketplaceOpened({required String source});

  /// Log generic event.
  Future<void> logEvent(
    String name,
    Map<String, String> map, {
    Map<String, dynamic>? parameters,
  });
}

/// Dummy analytics implementation.
class DummyAnalyticsService implements AnalyticsService {
  @override
  Future<void> logOfferViewed({
    required String offerId,
    required String partnerId,
    required String offerType,
  }) async {
    // print('Analytics: Offer Viewed - $offerId ($offerType)');
  }

  @override
  Future<void> logOfferRedeemed({
    required String offerId,
    required String partnerId,
    required double discountAmount,
  }) async {
    // print('Analytics: Offer Redeemed - $offerId (Saved $discountAmount)');
  }

  @override
  Future<void> logPartnerCheckIn({
    required String partnerId,
    required String partnerName,
    required int creditsEarned,
  }) async {
    // print('Analytics: Check-in - $partnerName (+$creditsEarned credits)');
  }

  @override
  Future<void> logMarketplaceOpened({required String source}) async {
    // print('Analytics: Marketplace Opened from $source');
  }

  @override
  Future<void> logEvent(
    String name,
    Map<String, String> map, {
    Map<String, dynamic>? parameters,
  }) async {
    // print('Analytics: Event $name - $parameters');
  }
}
