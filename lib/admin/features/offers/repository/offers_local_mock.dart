/// File: lib/admin/features/offers/repository/offers_local_mock.dart
/// Purpose: Local mock data source for offers with delay/error simulation
/// Belongs To: admin/features/offers
/// Customization Guide:
/// - Replace with real API integration when backend is ready
library;

import 'dart:async';
import 'dart:math';

import '../../../core/constants/admin_assets.dart';
import '../../../core/utils/admin_helpers.dart';
import '../models/offer_model.dart';

/// Paginated response structure.
class PaginatedOffersResponse {
  const PaginatedOffersResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.perPage,
  });

  final List<OfferModel> items;
  final int total;
  final int page;
  final int perPage;
}

/// Filter parameters for offer queries.
class OfferFilters {
  const OfferFilters({
    this.status,
    this.discountType,
    this.search,
    this.sortBy,
    this.order = 'asc',
  });

  final OfferStatus? status;
  final DiscountType? discountType;
  final String? search;
  final String?
  sortBy; // 'created_at', 'valid_until', 'discount_value', 'current_uses'
  final String order; // 'asc', 'desc'
}

/// Local mock data source that loads offers from bundled JSON.
class OffersLocalMock {
  OffersLocalMock({
    this.simulateError = false,
    this.artificialDelay = const Duration(milliseconds: 600),
  });

  bool simulateError;
  final Duration artificialDelay;

  List<OfferModel> _cache = [];
  bool _isInitialized = false;
  final Random _random = Random();

  /// Load offers with pagination and filters.
  Future<PaginatedOffersResponse> fetchOffers({
    int page = 1,
    int perPage = 25,
    OfferFilters? filters,
    bool forceRefresh = false,
  }) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('offers_fetch_failed');

    if (!_isInitialized || forceRefresh) {
      try {
        const assetPath = AdminAssets.jsonOffers;
        print('Loading offers from: $assetPath');

        final data =
            await AdminHelpers.loadJsonAsset(assetPath) as List<dynamic>;
        _cache = data
            .map(
              (item) =>
                  OfferModel.fromJson(Map<String, dynamic>.from(item as Map)),
            )
            .toList();
        _isInitialized = true;
        print('Successfully loaded ${_cache.length} offers from JSON');
      } catch (e) {
        // Fallback: Generate dummy offers if asset loading fails
        print(
          'Warning: Failed to load offers.json from ${AdminAssets.jsonOffers}, using fallback data: $e',
        );
        _cache = _generateFallbackOffers();
        _isInitialized = true;
        print('Generated ${_cache.length} fallback offers');
      }
    }

    var filtered = List<OfferModel>.from(_cache);

    // Apply filters
    if (filters != null) {
      if (filters.status != null) {
        filtered = filtered.where((o) => o.status == filters.status).toList();
      }
      if (filters.discountType != null) {
        filtered = filtered
            .where((o) => o.discountType == filters.discountType)
            .toList();
      }
      if (filters.search != null && filters.search!.isNotEmpty) {
        final query = filters.search!.toLowerCase();
        filtered = filtered.where((o) {
          return o.id.toLowerCase().contains(query) ||
              o.title.toLowerCase().contains(query) ||
              (o.code?.toLowerCase().contains(query) ?? false) ||
              (o.description?.toLowerCase().contains(query) ?? false);
        }).toList();
      }

      // Apply sorting
      if (filters.sortBy != null) {
        filtered.sort((a, b) {
          var comparison = 0;
          switch (filters.sortBy) {
            case 'created_at':
              comparison = a.createdAt.compareTo(b.createdAt);
              break;
            case 'valid_until':
              comparison = a.validUntil.compareTo(b.validUntil);
              break;
            case 'discount_value':
              comparison = a.discountValue.compareTo(b.discountValue);
              break;
            case 'current_uses':
              comparison = a.currentUses.compareTo(b.currentUses);
              break;
            default:
              comparison = 0;
          }
          return filters.order == 'desc' ? -comparison : comparison;
        });
      }
    }

    // Pagination
    final total = filtered.length;
    final start = (page - 1) * perPage;
    final end = start + perPage;
    final paginated = filtered.sublist(
      start.clamp(0, total),
      end.clamp(0, total),
    );

    return PaginatedOffersResponse(
      items: paginated,
      total: total,
      page: page,
      perPage: perPage,
    );
  }

  /// Fetch single offer by id.
  Future<OfferModel> fetchOfferById(String id) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('offer_fetch_failed');

    if (!_isInitialized) {
      await fetchOffers();
    }

    final offer = _cache.firstWhere(
      (o) => o.id == id,
      orElse: () => throw Exception('Offer not found: $id'),
    );

    return offer;
  }

  /// Create new offer.
  Future<OfferModel> createOffer(OfferModel offer) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('offer_create_failed');

    if (!_isInitialized) {
      await fetchOffers();
    }

    final newOffer = offer.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
    );

    _cache.add(newOffer);
    return newOffer;
  }

  /// Update existing offer.
  Future<OfferModel> updateOffer(OfferModel offer) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('offer_update_failed');

    if (!_isInitialized) {
      await fetchOffers();
    }

    final index = _cache.indexWhere((o) => o.id == offer.id);
    if (index == -1) {
      throw Exception('Offer not found: ${offer.id}');
    }

    final updated = offer.copyWith(updatedAt: DateTime.now());
    _cache[index] = updated;
    return updated;
  }

  /// Delete offer.
  Future<void> deleteOffer(String id) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('offer_delete_failed');

    if (!_isInitialized) {
      await fetchOffers();
    }

    _cache.removeWhere((o) => o.id == id);
  }

  /// Activate offer.
  Future<OfferModel> activateOffer(String id) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('offer_activate_failed');

    final offer = await fetchOfferById(id);
    return updateOffer(offer.copyWith(status: OfferStatus.active));
  }

  /// Deactivate offer.
  Future<OfferModel> deactivateOffer(String id) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('offer_deactivate_failed');

    final offer = await fetchOfferById(id);
    return updateOffer(offer.copyWith(status: OfferStatus.inactive));
  }

  /// Generate fallback offers if JSON loading fails.
  List<OfferModel> _generateFallbackOffers() {
    final now = DateTime.now();
    return List.generate(
      50,
      (index) => OfferModel(
        id: 'offer_${index + 1}',
        title: 'Special Offer ${index + 1}',
        discountType: DiscountType.values[_random.nextInt(3)],
        discountValue: _random.nextDouble() * 50 + 5,
        status: OfferStatus.values[_random.nextInt(4)],
        validFrom: now.subtract(Duration(days: _random.nextInt(30))),
        validUntil: now.add(Duration(days: _random.nextInt(60) + 30)),
        createdAt: now.subtract(Duration(days: _random.nextInt(90))),
        description: 'Description for offer ${index + 1}',
        code: 'CODE${index + 1}',
        maxUses: _random.nextInt(1000) + 100,
        currentUses: _random.nextInt(500),
        minPurchaseAmount: _random.nextDouble() * 100,
      ),
    );
  }
}
