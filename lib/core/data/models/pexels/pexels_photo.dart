/// File: lib/core/data/models/pexels/pexels_photo.dart
/// Purpose: Pexels photo model
/// Belongs To: shared
/// Customization Guide:
///    - Use src property to get different image sizes
///    - photographer field contains attribution info
library;

import 'pexels_src.dart';

/// Pexels photo model.
class PexelsPhoto {
  const PexelsPhoto({
    required this.id,
    required this.photographer,
    required this.url,
    required this.src,
  });

  /// Create from JSON
  factory PexelsPhoto.fromJson(Map<String, dynamic> json) {
    return PexelsPhoto(
      id: json['id'] as int? ?? 0,
      photographer: json['photographer'] as String? ?? '',
      url: json['url'] as String? ?? '',
      src: PexelsSrc.fromJson(
        json['src'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  /// Photo ID
  final int id;

  /// Photographer name (for attribution)
  final String photographer;

  /// Photo page URL on Pexels
  final String url;

  /// Image source URLs for different sizes
  final PexelsSrc src;

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'photographer': photographer,
      'url': url,
      'src': src.toJson(),
    };
  }

  /// Create a copy with modified fields
  PexelsPhoto copyWith({
    int? id,
    String? photographer,
    String? url,
    PexelsSrc? src,
  }) {
    return PexelsPhoto(
      id: id ?? this.id,
      photographer: photographer ?? this.photographer,
      url: url ?? this.url,
      src: src ?? this.src,
    );
  }

  @override
  String toString() {
    return 'PexelsPhoto(id: $id, photographer: $photographer)';
  }
}

