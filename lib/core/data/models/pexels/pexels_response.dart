/// File: lib/core/data/models/pexels/pexels_response.dart
/// Purpose: Pexels API response wrapper
/// Belongs To: shared
library;

import 'pexels_photo.dart';

/// Pexels API response wrapper.
class PexelsResponse {
  const PexelsResponse({
    required this.photos,
    required this.page,
    required this.perPage,
    required this.totalResults,
    this.nextPage,
  });

  /// Create from JSON
  factory PexelsResponse.fromJson(Map<String, dynamic> json) {
    final photosList = json['photos'] as List<dynamic>? ?? [];
    return PexelsResponse(
      photos: photosList
          .map((photo) => PexelsPhoto.fromJson(photo as Map<String, dynamic>))
          .toList(),
      page: json['page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 15,
      totalResults: json['total_results'] as int? ?? 0,
      nextPage: json['next_page'] as String?,
    );
  }

  /// List of photos
  final List<PexelsPhoto> photos;

  /// Current page number
  final int page;

  /// Results per page
  final int perPage;

  /// Total number of results
  final int totalResults;

  /// Next page URL (if available)
  final String? nextPage;

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'photos': photos.map((photo) => photo.toJson()).toList(),
      'page': page,
      'per_page': perPage,
      'total_results': totalResults,
      'next_page': nextPage,
    };
  }
}

