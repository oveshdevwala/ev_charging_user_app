/// File: lib/features/value_packs/domain/entities/value_pack.dart
/// Purpose: Value pack domain entity
/// Belongs To: value_packs feature
/// Customization Guide:
///    - Add new fields as needed
///    - Update copyWith and props accordingly
library;

import 'package:equatable/equatable.dart';

/// Billing cycle enum for value packs.
enum BillingCycle {
  oneTime,
  monthly,
  yearly,
}

/// Value pack domain entity.
class ValuePack extends Equatable {
  const ValuePack({
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

  /// Check if pack has discount.
  bool get hasDiscount => oldPrice != null && oldPrice! > price;

  /// Calculate discount percentage.
  double get discountPercent {
    if (!hasDiscount) {
      return 0;
    }
    return ((oldPrice! - price) / oldPrice!) * 100;
  }

  /// Check if pack is available.
  bool get isAvailable => isActive && (stockLimit == null || stockLimit! > 0);

  /// Get billing cycle display text.
  String get billingCycleText {
    switch (billingCycle) {
      case BillingCycle.oneTime:
        return 'One-time';
      case BillingCycle.monthly:
        return 'Monthly';
      case BillingCycle.yearly:
        return 'Yearly';
    }
  }

  /// Copy with new values.
  ValuePack copyWith({
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
    return ValuePack(
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

