/// File: lib/features/value_packs/data/models/value_pack_model.dart
/// Purpose: Value pack data model with JSON serialization
/// Belongs To: value_packs feature
/// Customization Guide:
///    - Add new fields as needed
///    - Update fromJson/toJson accordingly
library;

import 'package:equatable/equatable.dart';

import '../../domain/entities/value_pack.dart';

/// Value pack data model.
class ValuePackModel extends Equatable {
  const ValuePackModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.price,
    required this.priceCurrency,
    this.oldPrice,
    this.billingCycle = BillingCycle.oneTime,
    this.features = const [],
    this.tags = const [],
    this.badge,
    this.iconUrl,
    this.heroImageUrl,
    this.savingsPercent,
    this.isActive = true,
    this.stockLimit,
    this.purchaseLimitPerUser,
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.includedKwh,
    this.benefits = const {},
    this.createdAt,
    this.updatedAt,
  });

  /// Create from JSON map.
  factory ValuePackModel.fromJson(Map<String, dynamic> json) {
    return ValuePackModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      priceCurrency: json['priceCurrency'] as String? ?? json['price_currency'] as String? ?? 'USD',
      oldPrice: (json['oldPrice'] as num?)?.toDouble() ?? (json['old_price'] as num?)?.toDouble(),
      billingCycle: _parseBillingCycle(json['billingCycle'] as String? ?? json['billing_cycle'] as String?),
      features: (json['features'] as List<dynamic>?)?.cast<String>() ?? [],
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      badge: json['badge'] as String?,
      iconUrl: json['iconUrl'] as String? ?? json['icon_url'] as String?,
      heroImageUrl: json['heroImageUrl'] as String? ?? json['hero_image_url'] as String?,
      savingsPercent: (json['savingsPercent'] as num?)?.toDouble() ?? (json['savings_percent'] as num?)?.toDouble(),
      isActive: json['isActive'] as bool? ?? json['is_active'] as bool? ?? true,
      stockLimit: json['stockLimit'] as int? ?? json['stock_limit'] as int?,
      purchaseLimitPerUser: json['purchaseLimitPerUser'] as int? ?? json['purchase_limit_per_user'] as int?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: json['reviewsCount'] as int? ?? json['reviews_count'] as int? ?? 0,
      includedKwh: (json['includedKwh'] as num?)?.toDouble() ?? (json['included_kwh'] as num?)?.toDouble(),
      benefits: json['benefits'] != null
          ? Map<String, String>.from(json['benefits'] as Map)
          : const {},
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : json['created_at'] != null
              ? DateTime.tryParse(json['created_at'] as String)
              : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : json['updated_at'] != null
              ? DateTime.tryParse(json['updated_at'] as String)
              : null,
    );
  }

  /// Parse billing cycle from string.
  static BillingCycle _parseBillingCycle(String? value) {
    if (value == null) {
      return BillingCycle.oneTime;
    }
    switch (value.toLowerCase()) {
      case 'monthly':
        return BillingCycle.monthly;
      case 'yearly':
        return BillingCycle.yearly;
      default:
        return BillingCycle.oneTime;
    }
  }

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final double price;
  final String priceCurrency;
  final double? oldPrice;
  final BillingCycle billingCycle;
  final List<String> features;
  final List<String> tags;
  final String? badge;
  final String? iconUrl;
  final String? heroImageUrl;
  final double? savingsPercent;
  final bool isActive;
  final int? stockLimit;
  final int? purchaseLimitPerUser;
  final double rating;
  final int reviewsCount;
  final double? includedKwh;
  final Map<String, String> benefits;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Convert to domain entity.
  ValuePack toEntity() {
    return ValuePack(
      id: id,
      title: title,
      subtitle: subtitle,
      description: description,
      price: price,
      priceCurrency: priceCurrency,
      oldPrice: oldPrice,
      billingCycle: billingCycle,
      features: features,
      tags: tags,
      badge: badge,
      iconUrl: iconUrl,
      heroImageUrl: heroImageUrl,
      savingsPercent: savingsPercent,
      isActive: isActive,
      stockLimit: stockLimit,
      purchaseLimitPerUser: purchaseLimitPerUser,
      rating: rating,
      reviewsCount: reviewsCount,
      includedKwh: includedKwh,
      benefits: benefits,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'price': price,
      'priceCurrency': priceCurrency,
      'oldPrice': oldPrice,
      'billingCycle': billingCycle.name,
      'features': features,
      'tags': tags,
      'badge': badge,
      'iconUrl': iconUrl,
      'heroImageUrl': heroImageUrl,
      'savingsPercent': savingsPercent,
      'isActive': isActive,
      'stockLimit': stockLimit,
      'purchaseLimitPerUser': purchaseLimitPerUser,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'includedKwh': includedKwh,
      'benefits': benefits,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Copy with new values.
  ValuePackModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    double? price,
    String? priceCurrency,
    double? oldPrice,
    BillingCycle? billingCycle,
    List<String>? features,
    List<String>? tags,
    String? badge,
    String? iconUrl,
    String? heroImageUrl,
    double? savingsPercent,
    bool? isActive,
    int? stockLimit,
    int? purchaseLimitPerUser,
    double? rating,
    int? reviewsCount,
    double? includedKwh,
    Map<String, String>? benefits,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ValuePackModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      price: price ?? this.price,
      priceCurrency: priceCurrency ?? this.priceCurrency,
      oldPrice: oldPrice ?? this.oldPrice,
      billingCycle: billingCycle ?? this.billingCycle,
      features: features ?? this.features,
      tags: tags ?? this.tags,
      badge: badge ?? this.badge,
      iconUrl: iconUrl ?? this.iconUrl,
      heroImageUrl: heroImageUrl ?? this.heroImageUrl,
      savingsPercent: savingsPercent ?? this.savingsPercent,
      isActive: isActive ?? this.isActive,
      stockLimit: stockLimit ?? this.stockLimit,
      purchaseLimitPerUser: purchaseLimitPerUser ?? this.purchaseLimitPerUser,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      includedKwh: includedKwh ?? this.includedKwh,
      benefits: benefits ?? this.benefits,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        description,
        price,
        priceCurrency,
        oldPrice,
        billingCycle,
        features,
        tags,
        badge,
        iconUrl,
        heroImageUrl,
        savingsPercent,
        isActive,
        stockLimit,
        purchaseLimitPerUser,
        rating,
        reviewsCount,
        includedKwh,
        benefits,
        createdAt,
        updatedAt,
      ];
}

