/// File: lib/models/bundle_model.dart
/// Purpose: Value bundle/subscription pack model for upsells
/// Belongs To: shared
/// Customization Guide:
///    - Add new bundle types and pricing tiers
///    - Update copyWith and JSON methods accordingly
library;

import 'package:equatable/equatable.dart';

/// Bundle type enum for categorizing subscription packs.
enum BundleType {
  unlimited,
  monthly,
  homeCharging,
  business,
  starter,
}

/// Value bundle/subscription model.
class BundleModel extends Equatable {
  const BundleModel({
    required this.id,
    required this.titleKey,
    required this.benefitKey,
    required this.iconUrl,
    this.type = BundleType.monthly,
    this.price = 0.0,
    this.originalPrice,
    this.duration = 30,
    this.features = const [],
    this.isPopular = false,
    this.isBestValue = false,
    this.badgeKey,
    this.color,
  });

  /// Create from JSON map.
  factory BundleModel.fromJson(Map<String, dynamic> json) {
    return BundleModel(
      id: json['id'] as String? ?? '',
      titleKey: json['titleKey'] as String? ?? '',
      benefitKey: json['benefitKey'] as String? ?? '',
      iconUrl: json['iconUrl'] as String? ?? '',
      type: BundleType.values.firstWhere(
        (t) => t.name == (json['type'] as String?),
        orElse: () => BundleType.monthly,
      ),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
      duration: json['duration'] as int? ?? 30,
      features: (json['features'] as List<dynamic>?)?.cast<String>() ?? [],
      isPopular: json['isPopular'] as bool? ?? false,
      isBestValue: json['isBestValue'] as bool? ?? false,
      badgeKey: json['badgeKey'] as String?,
      color: json['color'] as String?,
    );
  }

  final String id;
  final String titleKey;
  final String benefitKey;
  final String iconUrl;
  final BundleType type;
  final double price;
  final double? originalPrice;
  final int duration;
  final List<String> features;
  final bool isPopular;
  final bool isBestValue;
  final String? badgeKey;
  final String? color;

  /// Check if bundle has discount.
  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  /// Calculate discount percentage.
  int get discountPercent {
    if (!hasDiscount) {
      return 0;
    }
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }

  /// Format duration as readable string.
  String get durationText {
    if (duration >= 365) {
      return '${duration ~/ 365} Year';
    }
    if (duration >= 30) {
      return '${duration ~/ 30} Month';
    }
    return '$duration Days';
  }

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titleKey': titleKey,
      'benefitKey': benefitKey,
      'iconUrl': iconUrl,
      'type': type.name,
      'price': price,
      'originalPrice': originalPrice,
      'duration': duration,
      'features': features,
      'isPopular': isPopular,
      'isBestValue': isBestValue,
      'badgeKey': badgeKey,
      'color': color,
    };
  }

  /// Copy with new values.
  BundleModel copyWith({
    String? id,
    String? titleKey,
    String? benefitKey,
    String? iconUrl,
    BundleType? type,
    double? price,
    double? originalPrice,
    int? duration,
    List<String>? features,
    bool? isPopular,
    bool? isBestValue,
    String? badgeKey,
    String? color,
  }) {
    return BundleModel(
      id: id ?? this.id,
      titleKey: titleKey ?? this.titleKey,
      benefitKey: benefitKey ?? this.benefitKey,
      iconUrl: iconUrl ?? this.iconUrl,
      type: type ?? this.type,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      duration: duration ?? this.duration,
      features: features ?? this.features,
      isPopular: isPopular ?? this.isPopular,
      isBestValue: isBestValue ?? this.isBestValue,
      badgeKey: badgeKey ?? this.badgeKey,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [
        id,
        titleKey,
        benefitKey,
        iconUrl,
        type,
        price,
        originalPrice,
        duration,
        features,
        isPopular,
        isBestValue,
        badgeKey,
        color,
      ];
}

