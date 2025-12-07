/// File: lib/core/repositories/pexels_repository.dart
/// Purpose: Pexels repository for image fetching
/// Belongs To: shared
/// Customization Guide:
///    - Add caching logic if needed
///    - Implement offline support
library;

import '../data/models/pexels/pexels.dart';
import '../services/pexels_api_service.dart';

/// Pexels repository interface.
abstract class PexelsRepository {
  /// Get default/curated images
  Future<List<PexelsPhoto>> getDefaultImages({
    int page = 1,
    int perPage = 15,
  });

  /// Search images by query
  Future<List<PexelsPhoto>> searchImages(
    String query, {
    int page = 1,
    int perPage = 15,
  });
}

/// Pexels repository implementation.
class PexelsRepositoryImpl implements PexelsRepository {
  PexelsRepositoryImpl({
    required PexelsApiService apiService,
  }) : _apiService = apiService;

  final PexelsApiService _apiService;

  // Simple in-memory cache
  List<PexelsPhoto>? _cachedCuratedPhotos;
  DateTime? _cacheTimestamp;
  static const Duration _cacheExpiry = Duration(hours: 1);

  @override
  Future<List<PexelsPhoto>> getDefaultImages({
    int page = 1,
    int perPage = 15,
  }) async {
    // Return cached results if available and fresh
    if (page == 1 &&
        _cachedCuratedPhotos != null &&
        _cacheTimestamp != null &&
        DateTime.now().difference(_cacheTimestamp!) < _cacheExpiry) {
      return _cachedCuratedPhotos!;
    }

    try {
      final photos = await _apiService.curatedPhotos(
        page: page,
        perPage: perPage,
      );

      // Cache first page results
      if (page == 1) {
        _cachedCuratedPhotos = photos;
        _cacheTimestamp = DateTime.now();
      }

      return photos;
    } catch (e) {
      // If API fails and we have cached data, return cached data
      if (_cachedCuratedPhotos != null) {
        return _cachedCuratedPhotos!;
      }
      rethrow;
    }
  }

  @override
  Future<List<PexelsPhoto>> searchImages(
    String query, {
    int page = 1,
    int perPage = 15,
  }) async {
    if (query.isEmpty) {
      // If query is empty, return curated photos
      return getDefaultImages(page: page, perPage: perPage);
    }

    try {
      return await _apiService.searchPhotos(
        query,
        page: page,
        perPage: perPage,
      );
    } catch (e) {
      // If search fails, fallback to curated photos
      return getDefaultImages(page: page, perPage: perPage);
    }
  }
}

