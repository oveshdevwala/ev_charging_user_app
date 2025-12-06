/// File: lib/features/value_packs/data/datasources/value_packs_remote_datasource.dart
/// Purpose: Remote data source interface for value packs API
/// Belongs To: value_packs feature
/// Customization Guide:
///    - Implement actual API calls when backend is ready
library;

import '../models/models.dart';

/// Abstract remote data source for value packs.
abstract class ValuePacksRemoteDataSource {
  /// Get all value packs from API.
  Future<List<ValuePackModel>> getValuePacks({
    String? filter,
    String? sort,
    int page = 1,
    int limit = 20,
  });

  /// Get value pack detail from API.
  Future<ValuePackModel> getValuePackDetail(String id);

  /// Get reviews from API.
  Future<List<ReviewModel>> getReviews(String packId, {int page = 1, int limit = 20});

  /// Submit review to API.
  Future<ReviewModel> submitReview({
    required String packId,
    required double rating,
    required String title,
    required String message,
    List<String>? images,
  });

  /// Purchase value pack via API.
  Future<PurchaseReceiptModel> purchaseValuePack({
    required String packId,
    required String paymentToken,
    String? coupon,
  });

  /// Get user purchases from API.
  Future<List<PurchaseReceiptModel>> getUserPurchases({String? packId});

  /// Compare packs via API.
  Future<Map<String, dynamic>> comparePacks(List<String> packIds);

  /// Toggle save pack via API.
  Future<void> toggleSave(String packId);

  /// Get saved packs from API.
  Future<List<ValuePackModel>> getSavedPacks();

  /// Get FAQ from API.
  Future<List<Map<String, String>>> getFAQ();

  /// Get invoice URL from API.
  Future<String> getInvoiceUrl(String receiptId);
}

