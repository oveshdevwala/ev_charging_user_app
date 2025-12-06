/// File: lib/features/value_packs/domain/repositories/value_packs_repository.dart
/// Purpose: Abstract repository interface for value packs
/// Belongs To: value_packs feature
/// Customization Guide:
///    - Add new methods as needed
///    - Implement in data layer
library;

import '../entities/entities.dart';

/// Abstract repository for value packs operations.
/// Pure Dart interface - no Flutter dependencies.
abstract class ValuePacksRepository {
  /// Get all value packs with optional filters.
  Future<List<ValuePack>> getValuePacks({
    String? filter,
    String? sort,
    int page = 1,
    int limit = 20,
  });

  /// Get value pack by ID.
  Future<ValuePack?> getValuePackDetail(String id);

  /// Get reviews for a value pack.
  Future<List<Review>> getReviews(String packId, {int page = 1, int limit = 20});

  /// Submit a review for a value pack.
  Future<Review> submitReview({
    required String packId,
    required double rating,
    required String title,
    required String message,
    List<String>? images,
  });

  /// Purchase a value pack.
  Future<PurchaseReceipt> purchaseValuePack({
    required String packId,
    required String paymentToken,
    String? coupon,
  });

  /// Get user's purchase history.
  Future<List<PurchaseReceipt>> getUserPurchases({String? packId});

  /// Compare multiple value packs.
  Future<Map<String, dynamic>> comparePacks(List<String> packIds);

  /// Save/unsave a value pack to wishlist.
  Future<void> toggleSave(String packId);

  /// Get saved value packs.
  Future<List<ValuePack>> getSavedPacks();

  /// Get FAQ data.
  Future<List<Map<String, String>>> getFAQ();

  /// Get invoice PDF URL.
  Future<String> getInvoiceUrl(String receiptId);
}

