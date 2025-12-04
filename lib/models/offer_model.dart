/// File: lib/models/offer_model.dart
/// Purpose: Offer/promotion data model for home screen carousel
/// Belongs To: shared
/// Customization Guide:
///    - Add new fields for additional offer attributes
///    - Update copyWith and JSON methods accordingly

import 'package:equatable/equatable.dart';

/// Offer type enum for categorizing promotions.
enum OfferType {
  dailyDeal,
  cashback,
  partner,
  seasonal,
  referral,
}

/// Promotional offer model.
class OfferModel extends Equatable {
  const OfferModel({
    required this.id,
    required this.titleKey,
    required this.descKey,
    required this.bannerUrl,
    this.type = OfferType.dailyDeal,
    this.discountPercent,
    this.validUntil,
    this.termsKey,
    this.actionUrl,
    this.isActive = true,
  });

  final String id;
  final String titleKey;
  final String descKey;
  final String bannerUrl;
  final OfferType type;
  final double? discountPercent;
  final DateTime? validUntil;
  final String? termsKey;
  final String? actionUrl;
  final bool isActive;

  /// Check if offer is still valid.
  bool get isValid {
    if (validUntil == null) return isActive;
    return isActive && DateTime.now().isBefore(validUntil!);
  }

  /// Days remaining for the offer.
  int? get daysRemaining {
    if (validUntil == null) return null;
    return validUntil!.difference(DateTime.now()).inDays;
  }

  /// Create from JSON map.
  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'] as String? ?? '',
      titleKey: json['titleKey'] as String? ?? '',
      descKey: json['descKey'] as String? ?? '',
      bannerUrl: json['bannerUrl'] as String? ?? '',
      type: OfferType.values.firstWhere(
        (t) => t.name == (json['type'] as String?),
        orElse: () => OfferType.dailyDeal,
      ),
      discountPercent: (json['discountPercent'] as num?)?.toDouble(),
      validUntil: json['validUntil'] != null
          ? DateTime.tryParse(json['validUntil'] as String)
          : null,
      termsKey: json['termsKey'] as String?,
      actionUrl: json['actionUrl'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titleKey': titleKey,
      'descKey': descKey,
      'bannerUrl': bannerUrl,
      'type': type.name,
      'discountPercent': discountPercent,
      'validUntil': validUntil?.toIso8601String(),
      'termsKey': termsKey,
      'actionUrl': actionUrl,
      'isActive': isActive,
    };
  }

  /// Copy with new values.
  OfferModel copyWith({
    String? id,
    String? titleKey,
    String? descKey,
    String? bannerUrl,
    OfferType? type,
    double? discountPercent,
    DateTime? validUntil,
    String? termsKey,
    String? actionUrl,
    bool? isActive,
  }) {
    return OfferModel(
      id: id ?? this.id,
      titleKey: titleKey ?? this.titleKey,
      descKey: descKey ?? this.descKey,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      type: type ?? this.type,
      discountPercent: discountPercent ?? this.discountPercent,
      validUntil: validUntil ?? this.validUntil,
      termsKey: termsKey ?? this.termsKey,
      actionUrl: actionUrl ?? this.actionUrl,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        id,
        titleKey,
        descKey,
        bannerUrl,
        type,
        discountPercent,
        validUntil,
        termsKey,
        actionUrl,
        isActive,
      ];
}

