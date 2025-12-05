/// File: lib/features/nearby_offers/data/datasources/partner_local_datasource.dart
/// Purpose: Local caching layer for partner data
/// Belongs To: nearby_offers feature
/// Customization Guide:
///    - Swap SharedPreferences with Hive for better performance
///    - Adjust cache TTL as needed
library;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';

/// Cache keys for local storage.
abstract class PartnerCacheKeys {
  static const String partnersPrefix = 'partners_cache_';
  static const String offersPrefix = 'offers_cache_';
  static const String checkInsPrefix = 'checkins_cache_';
  static const String redemptionsPrefix = 'redemptions_cache_';
  static const String lastSyncKey = 'partners_last_sync';
}

/// Local data source for caching partner data.
///
/// Uses SharedPreferences for simple caching.
/// Can be swapped with Hive for better performance.
class PartnerLocalDataSource {
  PartnerLocalDataSource({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  /// Cache TTL in minutes.
  static const int cacheTtlMinutes = 30;

  /// Check if cache is still valid.
  bool isCacheValid() {
    final lastSync = _prefs.getInt(PartnerCacheKeys.lastSyncKey);
    if (lastSync == null) return false;

    final lastSyncTime = DateTime.fromMillisecondsSinceEpoch(lastSync);
    final now = DateTime.now();
    return now.difference(lastSyncTime).inMinutes < cacheTtlMinutes;
  }

  /// Update last sync timestamp.
  Future<void> updateSyncTimestamp() async {
    await _prefs.setInt(
      PartnerCacheKeys.lastSyncKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  // ============ Partners ============

  /// Cache partners list.
  Future<void> cachePartners(
    List<PartnerModel> partners, {
    PartnerCategory? category,
  }) async {
    final key = '${PartnerCacheKeys.partnersPrefix}${category?.name ?? 'all'}';
    final jsonList = partners.map((p) => p.toJson()).toList();
    await _prefs.setString(key, jsonEncode(jsonList));
    await updateSyncTimestamp();
  }

  /// Get cached partners.
  List<PartnerModel>? getCachedPartners({PartnerCategory? category}) {
    if (!isCacheValid()) return null;

    final key = '${PartnerCacheKeys.partnersPrefix}${category?.name ?? 'all'}';
    final jsonString = _prefs.getString(key);
    if (jsonString == null) return null;

    try {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((e) => PartnerModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  /// Cache single partner.
  Future<void> cachePartner(PartnerModel partner) async {
    final key = '${PartnerCacheKeys.partnersPrefix}id_${partner.id}';
    await _prefs.setString(key, jsonEncode(partner.toJson()));
  }

  /// Get cached partner by ID.
  PartnerModel? getCachedPartner(String partnerId) {
    final key = '${PartnerCacheKeys.partnersPrefix}id_$partnerId';
    final jsonString = _prefs.getString(key);
    if (jsonString == null) return null;

    try {
      return PartnerModel.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }

  // ============ Offers ============

  /// Cache offers list.
  Future<void> cacheOffers(
    List<PartnerOfferModel> offers, {
    String? cacheKey,
  }) async {
    final key = '${PartnerCacheKeys.offersPrefix}${cacheKey ?? 'all'}';
    final jsonList = offers.map((o) => o.toJson()).toList();
    await _prefs.setString(key, jsonEncode(jsonList));
  }

  /// Get cached offers.
  List<PartnerOfferModel>? getCachedOffers({String? cacheKey}) {
    if (!isCacheValid()) return null;

    final key = '${PartnerCacheKeys.offersPrefix}${cacheKey ?? 'all'}';
    final jsonString = _prefs.getString(key);
    if (jsonString == null) return null;

    try {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((e) => PartnerOfferModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  // ============ Check-ins ============

  /// Cache check-in history.
  Future<void> cacheCheckIns(List<CheckInModel> checkIns, String userId) async {
    final key = '${PartnerCacheKeys.checkInsPrefix}$userId';
    final jsonList = checkIns.map((c) => c.toJson()).toList();
    await _prefs.setString(key, jsonEncode(jsonList));
  }

  /// Get cached check-ins.
  List<CheckInModel>? getCachedCheckIns(String userId) {
    final key = '${PartnerCacheKeys.checkInsPrefix}$userId';
    final jsonString = _prefs.getString(key);
    if (jsonString == null) return null;

    try {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((e) => CheckInModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  // ============ Redemptions ============

  /// Cache redemption history.
  Future<void> cacheRedemptions(
    List<RedemptionModel> redemptions,
    String userId,
  ) async {
    final key = '${PartnerCacheKeys.redemptionsPrefix}$userId';
    final jsonList = redemptions.map((r) => r.toJson()).toList();
    await _prefs.setString(key, jsonEncode(jsonList));
  }

  /// Get cached redemptions.
  List<RedemptionModel>? getCachedRedemptions(String userId) {
    final key = '${PartnerCacheKeys.redemptionsPrefix}$userId';
    final jsonString = _prefs.getString(key);
    if (jsonString == null) return null;

    try {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((e) => RedemptionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  // ============ Clear Cache ============

  /// Clear all partner-related cache.
  Future<void> clearCache() async {
    final keys = _prefs.getKeys().where(
      (key) =>
          key.startsWith(PartnerCacheKeys.partnersPrefix) ||
          key.startsWith(PartnerCacheKeys.offersPrefix) ||
          key.startsWith(PartnerCacheKeys.checkInsPrefix) ||
          key.startsWith(PartnerCacheKeys.redemptionsPrefix),
    );

    for (final key in keys) {
      await _prefs.remove(key);
    }
    await _prefs.remove(PartnerCacheKeys.lastSyncKey);
  }
}
