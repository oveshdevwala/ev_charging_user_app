/// File: lib/core/services/station_image_service.dart
/// Purpose: Service to fetch Pexels images for stations
/// Belongs To: shared
/// Customization Guide:
///    - Adjust search queries for better image matching
///    - Modify cache duration as needed
library;

import '../data/models/pexels/pexels.dart';
import '../repositories/pexels_repository.dart';
import '../utils/image_url_resolver.dart';

/// Service for managing station images from Pexels.
class StationImageService {
  StationImageService({
    required PexelsRepository pexelsRepository,
  }) : _pexelsRepository = pexelsRepository;

  final PexelsRepository _pexelsRepository;

  // Cache for station images (stationId -> imageUrl)
  final Map<String, String> _imageCache = {};

  // Cache for Pexels photos (to avoid repeated API calls)
  List<PexelsPhoto>? _cachedPhotos;
  DateTime? _cacheTimestamp;
  static const Duration _cacheExpiry = Duration(hours: 24);

  /// Get image URL for a station.
  /// 
  /// Uses Pexels API to fetch relevant images for EV charging stations.
  /// Caches results to avoid repeated API calls.
  Future<String?> getStationImageUrl(String stationId, {
    String? stationName,
    String? stationDescription,
  }) async {
    // Return cached image if available
    if (_imageCache.containsKey(stationId)) {
      return _imageCache[stationId];
    }

    try {
      // Try to get cached Pexels photos first
      var photos = _cachedPhotos ?? [];

      // If cache expired or empty, fetch new photos
      if (photos.isEmpty ||
          _cacheTimestamp == null ||
          DateTime.now().difference(_cacheTimestamp!) > _cacheExpiry) {
        // Search for relevant images
        final searchQueries = _buildSearchQueries(stationName, stationDescription);
        
        for (final query in searchQueries) {
          try {
            photos = await _pexelsRepository.searchImages(query, perPage: 20);
            if (photos.isNotEmpty) {
              break; // Use first successful search
            }
          } catch (e) {
            // Continue to next query or fallback
            continue;
          }
        }

        // If search failed, use curated photos as fallback
        if (photos.isEmpty) {
          photos = await _pexelsRepository.getDefaultImages(perPage: 20);
        }

        // Cache the photos
        _cachedPhotos = photos;
        _cacheTimestamp = DateTime.now();
      }

      // Select image based on station ID (deterministic selection)
      if (photos.isNotEmpty) {
        final index = stationId.hashCode.abs() % photos.length;
        final selectedPhoto = photos[index];
        final imageUrl = ImageUrlResolver.getImageUrl(
          selectedPhoto,
          size: ImageSize.large,
        );

        // Cache the result
        _imageCache[stationId] = imageUrl;
        return imageUrl;
      }
    } catch (e) {
      // If all fails, return null (will show placeholder)
      return null;
    }

    return null;
  }

  /// Get multiple station image URLs in batch.
  Future<Map<String, String>> getStationImageUrls(
    List<String> stationIds, {
    Map<String, String>? stationNames,
    Map<String, String>? stationDescriptions,
  }) async {
    final results = <String, String>{};

    // Fetch all images in parallel
    final futures = stationIds.map((id) async {
      final imageUrl = await getStationImageUrl(
        id,
        stationName: stationNames?[id],
        stationDescription: stationDescriptions?[id],
      );
      if (imageUrl != null) {
        results[id] = imageUrl;
      }
    });

    await Future.wait(futures);
    return results;
  }

  /// Build search queries based on station info.
  List<String> _buildSearchQueries(String? name, String? description) {
    final queries = <String>[];

    // Primary queries for EV charging stations
    queries.add('electric car charging station');
    queries.add('EV charging point');
    queries.add('electric vehicle station');

    // If station name contains specific keywords, add more targeted queries
    if (name != null) {
      final lowerName = name.toLowerCase();
      if (lowerName.contains('supercharger') || lowerName.contains('tesla')) {
        queries.insert(0, 'tesla supercharger');
        queries.insert(1, 'tesla charging');
      }
      if (lowerName.contains('hub') || lowerName.contains('center')) {
        queries.insert(0, 'EV charging hub');
      }
      if (lowerName.contains('park') || lowerName.contains('green')) {
        queries.insert(0, 'green energy charging');
      }
    }

    // If description contains keywords, add related queries
    if (description != null) {
      final lowerDesc = description.toLowerCase();
      if (lowerDesc.contains('solar')) {
        queries.insert(0, 'solar powered charging');
      }
      if (lowerDesc.contains('fast') || lowerDesc.contains('rapid')) {
        queries.insert(0, 'fast EV charging');
      }
    }

    return queries;
  }

  /// Clear image cache.
  void clearCache() {
    _imageCache.clear();
    _cachedPhotos = null;
    _cacheTimestamp = null;
  }

  /// Clear cache for a specific station.
  void clearStationCache(String stationId) {
    _imageCache.remove(stationId);
  }
}

