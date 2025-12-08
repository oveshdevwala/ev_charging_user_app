/// File: lib/core/data/models/pexels/pexels_src.dart
/// Purpose: Pexels image source URLs model
/// Belongs To: shared
/// Customization Guide:
///    - All image size URLs are available
///    - Use appropriate size for your use case
library;

/// Pexels image source URLs for different sizes.
class PexelsSrc {
  const PexelsSrc({
    required this.original,
    required this.large2x,
    required this.large,
    required this.medium,
    required this.small,
    required this.portrait,
    required this.landscape,
    required this.tiny,
  });

  /// Create from JSON
  factory PexelsSrc.fromJson(Map<String, dynamic> json) {
    return PexelsSrc(
      original: json['original'] as String? ?? '',
      large2x: json['large2x'] as String? ?? '',
      large: json['large'] as String? ?? '',
      medium: json['medium'] as String? ?? '',
      small: json['small'] as String? ?? '',
      portrait: json['portrait'] as String? ?? '',
      landscape: json['landscape'] as String? ?? '',
      tiny: json['tiny'] as String? ?? '',
    );
  }

  /// Original image URL
  final String original;

  /// Large 2x image URL (high resolution)
  final String large2x;

  /// Large image URL
  final String large;

  /// Medium image URL
  final String medium;

  /// Small image URL
  final String small;

  /// Portrait orientation image URL
  final String portrait;

  /// Landscape orientation image URL
  final String landscape;

  /// Tiny thumbnail image URL
  final String tiny;

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'original': original,
      'large2x': large2x,
      'large': large,
      'medium': medium,
      'small': small,
      'portrait': portrait,
      'landscape': landscape,
      'tiny': tiny,
    };
  }

  /// Create a copy with modified fields
  PexelsSrc copyWith({
    String? original,
    String? large2x,
    String? large,
    String? medium,
    String? small,
    String? portrait,
    String? landscape,
    String? tiny,
  }) {
    return PexelsSrc(
      original: original ?? this.original,
      large2x: large2x ?? this.large2x,
      large: large ?? this.large,
      medium: medium ?? this.medium,
      small: small ?? this.small,
      portrait: portrait ?? this.portrait,
      landscape: landscape ?? this.landscape,
      tiny: tiny ?? this.tiny,
    );
  }

  @override
  String toString() {
    return 'PexelsSrc(original: $original, large: $large, medium: $medium)';
  }
}

