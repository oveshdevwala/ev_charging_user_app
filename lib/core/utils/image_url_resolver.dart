/// File: lib/core/utils/image_url_resolver.dart
/// Purpose: Utility to resolve image URLs from Pexels photos
/// Belongs To: shared
/// Customization Guide:
///    - Add more size options if needed
///    - Implement fallback logic
library;

import '../data/models/pexels/pexels.dart';

/// Image size options for Pexels photos
enum ImageSize {
  /// Tiny thumbnail (100px)
  tiny,

  /// Small (400px)
  small,

  /// Medium (600px)
  medium,

  /// Large (1200px)
  large,

  /// Large 2x (high resolution)
  large2x,

  /// Original size
  original,

  /// Portrait orientation
  portrait,

  /// Landscape orientation
  landscape,
}

/// Utility class for resolving image URLs from Pexels photos.
class ImageUrlResolver {
  ImageUrlResolver._();

  /// Get image URL from Pexels photo based on size preference.
  /// 
  /// [photo] - Pexels photo model
  /// [size] - Desired image size (default: medium)
  /// 
  /// Returns image URL string.
  static String getImageUrl(
    PexelsPhoto photo, {
    ImageSize size = ImageSize.medium,
  }) {
    switch (size) {
      case ImageSize.tiny:
        return photo.src.tiny;
      case ImageSize.small:
        return photo.src.small;
      case ImageSize.medium:
        return photo.src.medium;
      case ImageSize.large:
        return photo.src.large;
      case ImageSize.large2x:
        return photo.src.large2x;
      case ImageSize.original:
        return photo.src.original;
      case ImageSize.portrait:
        return photo.src.portrait;
      case ImageSize.landscape:
        return photo.src.landscape;
    }
  }

  /// Get best image URL for a specific use case.
  /// 
  /// [photo] - Pexels photo model
  /// [width] - Desired width in pixels
  /// [height] - Desired height in pixels
  /// 
  /// Returns best matching image URL.
  static String getBestImageUrl(
    PexelsPhoto photo, {
    double? width,
    double? height,
  }) {
    // If portrait orientation needed
    if (height != null && width != null && height > width) {
      return photo.src.portrait;
    }

    // If landscape orientation needed
    if (width != null && height != null && width > height) {
      return photo.src.landscape;
    }

    // Choose based on width
    if (width != null) {
      if (width <= 200) {
        return photo.src.small;
      } else if (width <= 600) {
        return photo.src.medium;
      } else if (width <= 1200) {
        return photo.src.large;
      } else {
        return photo.src.large2x;
      }
    }

    // Default to medium
    return photo.src.medium;
  }
}

