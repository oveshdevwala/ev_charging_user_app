/// File: lib/features/value_packs/data/repositories/value_packs_repository_impl.dart
/// Purpose: Repository implementation for value packs
/// Belongs To: value_packs feature
/// Customization Guide:
///    - Add offline fallback logic when local datasource is ready
library;

import '../../domain/entities/entities.dart';
import '../../domain/repositories/value_packs_repository.dart';
import '../datasources/datasources.dart';

/// Repository implementation for value packs.
class ValuePacksRepositoryImpl implements ValuePacksRepository {
  ValuePacksRepositoryImpl({
    required ValuePacksRemoteDataSource remoteDataSource,
    ValuePacksLocalDataSource? localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final ValuePacksRemoteDataSource _remoteDataSource;
  final ValuePacksLocalDataSource? _localDataSource;

  @override
  Future<List<ValuePack>> getValuePacks({
    String? filter,
    String? sort,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      // Try to get from cache first
      if (_localDataSource != null) {
        final cached = await _localDataSource.getCachedValuePacks();
        if (cached != null && cached.isNotEmpty) {
          // Return cached data immediately, then refresh in background
          _refreshValuePacksInBackground(filter, sort, page, limit);
          return cached.map((model) => model.toEntity()).toList();
        }
      }

      // Fetch from remote
      final models = await _remoteDataSource.getValuePacks(
        filter: filter,
        sort: sort,
        page: page,
        limit: limit,
      );

      // Cache the results
      if (_localDataSource != null) {
        await _localDataSource.cacheValuePacks(models);
      }

      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      // Fallback to cache on error
      if (_localDataSource != null) {
        final cached = await _localDataSource.getCachedValuePacks();
        if (cached != null && cached.isNotEmpty) {
          return cached.map((model) => model.toEntity()).toList();
        }
      }
      rethrow;
    }
  }

  /// Refresh value packs in background.
  void _refreshValuePacksInBackground(String? filter, String? sort, int page, int limit) {
    _remoteDataSource.getValuePacks(
      filter: filter,
      sort: sort,
      page: page,
      limit: limit,
    ).then((models) {
      if (_localDataSource != null) {
        _localDataSource.cacheValuePacks(models);
      }
    }).catchError((_) {
      // Silently fail background refresh
    });
  }

  @override
  Future<ValuePack?> getValuePackDetail(String id) async {
    try {
      // Try cache first
      if (_localDataSource != null) {
        final cached = await _localDataSource.getCachedValuePackDetail(id);
        if (cached != null) {
          _refreshPackDetailInBackground(id);
          return cached.toEntity();
        }
      }

      // Fetch from remote
      final model = await _remoteDataSource.getValuePackDetail(id);

      // Cache the result
      if (_localDataSource != null) {
        await _localDataSource.cacheValuePackDetail(model);
      }

      return model.toEntity();
    } catch (e) {
      // Fallback to cache
      if (_localDataSource != null) {
        final cached = await _localDataSource.getCachedValuePackDetail(id);
        if (cached != null) {
          return cached.toEntity();
        }
      }
      rethrow;
    }
  }

  /// Refresh pack detail in background.
  void _refreshPackDetailInBackground(String id) {
    _remoteDataSource.getValuePackDetail(id).then((model) {
      if (_localDataSource != null) {
        _localDataSource.cacheValuePackDetail(model);
      }
    }).catchError((_) {
      // Silently fail background refresh
    });
  }

  @override
  Future<List<Review>> getReviews(String packId, {int page = 1, int limit = 20}) async {
    try {
      // Try cache first
      if (_localDataSource != null) {
        final cached = await _localDataSource.getCachedReviews(packId);
        if (cached != null && cached.isNotEmpty) {
          return cached.map((model) => model.toEntity()).toList();
        }
      }

      // Fetch from remote
      final models = await _remoteDataSource.getReviews(packId, page: page, limit: limit);

      // Cache the results
      if (_localDataSource != null) {
        await _localDataSource.cacheReviews(packId, models);
      }

      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      // Fallback to cache
      if (_localDataSource != null) {
        final cached = await _localDataSource.getCachedReviews(packId);
        if (cached != null && cached.isNotEmpty) {
          return cached.map((model) => model.toEntity()).toList();
        }
      }
      rethrow;
    }
  }

  @override
  Future<Review> submitReview({
    required String packId,
    required double rating,
    required String title,
    required String message,
    List<String>? images,
  }) async {
    final model = await _remoteDataSource.submitReview(
      packId: packId,
      rating: rating,
      title: title,
      message: message,
      images: images,
    );

    // Invalidate cache for this pack's reviews
    if (_localDataSource != null) {
      await _localDataSource.cacheReviews(packId, []);
    }

    return model.toEntity();
  }

  @override
  Future<PurchaseReceipt> purchaseValuePack({
    required String packId,
    required String paymentToken,
    String? coupon,
  }) async {
    final model = await _remoteDataSource.purchaseValuePack(
      packId: packId,
      paymentToken: paymentToken,
      coupon: coupon,
    );

    return model.toEntity();
  }

  @override
  Future<List<PurchaseReceipt>> getUserPurchases({String? packId}) async {
    final models = await _remoteDataSource.getUserPurchases(packId: packId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Map<String, dynamic>> comparePacks(List<String> packIds) async {
    return _remoteDataSource.comparePacks(packIds);
  }

  @override
  Future<void> toggleSave(String packId) async {
    await _remoteDataSource.toggleSave(packId);
  }

  @override
  Future<List<ValuePack>> getSavedPacks() async {
    final models = await _remoteDataSource.getSavedPacks();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<Map<String, String>>> getFAQ() async {
    return _remoteDataSource.getFAQ();
  }

  @override
  Future<String> getInvoiceUrl(String receiptId) async {
    return _remoteDataSource.getInvoiceUrl(receiptId);
  }
}

