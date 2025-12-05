/// File: lib/features/nearby_offers/data/models/partner_offer_model.dart
/// Purpose: Extended offer model for partner-specific offers with geo-location
/// Belongs To: nearby_offers feature
/// Customization Guide:
///    - Add new offer types to PartnerOfferType enum
///    - Update status logic as needed
library;

import 'package:equatable/equatable.dart';

import 'partner_category.dart';

/// Types of partner offers.
enum PartnerOfferType {
  discount,
  cashback,
  freeItem,
  bogo, // Buy one get one
  perk,
  voucher,
}

/// Offer status for tracking redemption.
enum OfferStatus { active, used, expired, pending }

/// Extension for PartnerOfferType with UI properties.
extension PartnerOfferTypeExt on PartnerOfferType {
  String get displayKey {
    switch (this) {
      case PartnerOfferType.discount:
        return 'offer_type_discount';
      case PartnerOfferType.cashback:
        return 'offer_type_cashback';
      case PartnerOfferType.freeItem:
        return 'offer_type_free_item';
      case PartnerOfferType.bogo:
        return 'offer_type_bogo';
      case PartnerOfferType.perk:
        return 'offer_type_perk';
      case PartnerOfferType.voucher:
        return 'offer_type_voucher';
    }
  }

  String get badgeText {
    switch (this) {
      case PartnerOfferType.discount:
        return 'DISCOUNT';
      case PartnerOfferType.cashback:
        return 'CASHBACK';
      case PartnerOfferType.freeItem:
        return 'FREE';
      case PartnerOfferType.bogo:
        return 'BOGO';
      case PartnerOfferType.perk:
        return 'PERK';
      case PartnerOfferType.voucher:
        return 'VOUCHER';
    }
  }
}

/// Partner offer model with geo-location and redemption tracking.
class PartnerOfferModel extends Equatable {
  const PartnerOfferModel({
    required this.id,
    required this.partnerId,
    required this.partnerName,
    required this.title,
    required this.description,
    required this.offerType,
    this.partnerCategory = PartnerCategory.services,
    this.imageUrl,
    this.partnerLogoUrl,
    this.discountPercent,
    this.discountAmount,
    this.cashbackPercent,
    this.minPurchaseAmount,
    this.maxDiscountAmount,
    this.latitude,
    this.longitude,
    this.distance,
    this.validFrom,
    this.validUntil,
    this.termsAndConditions,
    this.redemptionCode,
    this.status = OfferStatus.active,
    this.usageLimit,
    this.usedCount = 0,
    this.isTrending = false,
    this.isFeatured = false,
    this.viewCount = 0,
  });

  factory PartnerOfferModel.fromJson(Map<String, dynamic> json) {
    return PartnerOfferModel(
      id: json['id'] as String? ?? '',
      partnerId: json['partnerId'] as String? ?? '',
      partnerName: json['partnerName'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      offerType: PartnerOfferType.values.firstWhere(
        (t) => t.name == (json['offerType'] as String?),
        orElse: () => PartnerOfferType.discount,
      ),
      partnerCategory: PartnerCategory.values.firstWhere(
        (c) => c.name == (json['partnerCategory'] as String?),
        orElse: () => PartnerCategory.services,
      ),
      imageUrl: json['imageUrl'] as String?,
      partnerLogoUrl: json['partnerLogoUrl'] as String?,
      discountPercent: (json['discountPercent'] as num?)?.toDouble(),
      discountAmount: (json['discountAmount'] as num?)?.toDouble(),
      cashbackPercent: (json['cashbackPercent'] as num?)?.toDouble(),
      minPurchaseAmount: (json['minPurchaseAmount'] as num?)?.toDouble(),
      maxDiscountAmount: (json['maxDiscountAmount'] as num?)?.toDouble(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      distance: (json['distance'] as num?)?.toDouble(),
      validFrom: json['validFrom'] != null
          ? DateTime.tryParse(json['validFrom'] as String)
          : null,
      validUntil: json['validUntil'] != null
          ? DateTime.tryParse(json['validUntil'] as String)
          : null,
      termsAndConditions: json['termsAndConditions'] as String?,
      redemptionCode: json['redemptionCode'] as String?,
      status: OfferStatus.values.firstWhere(
        (s) => s.name == (json['status'] as String?),
        orElse: () => OfferStatus.active,
      ),
      usageLimit: json['usageLimit'] as int?,
      usedCount: json['usedCount'] as int? ?? 0,
      isTrending: json['isTrending'] as bool? ?? false,
      isFeatured: json['isFeatured'] as bool? ?? false,
      viewCount: json['viewCount'] as int? ?? 0,
    );
  }

  final String id;
  final String partnerId;
  final String partnerName;
  final String title;
  final String description;
  final PartnerOfferType offerType;
  final PartnerCategory partnerCategory;
  final String? imageUrl;
  final String? partnerLogoUrl;
  final double? discountPercent;
  final double? discountAmount;
  final double? cashbackPercent;
  final double? minPurchaseAmount;
  final double? maxDiscountAmount;
  final double? latitude;
  final double? longitude;
  final double? distance;
  final DateTime? validFrom;
  final DateTime? validUntil;
  final String? termsAndConditions;
  final String? redemptionCode;
  final OfferStatus status;
  final int? usageLimit;
  final int usedCount;
  final bool isTrending;
  final bool isFeatured;
  final int viewCount;

  /// Check if offer is valid.
  bool get isValid {
    if (status != OfferStatus.active) return false;
    if (validUntil != null && DateTime.now().isAfter(validUntil!)) return false;
    if (validFrom != null && DateTime.now().isBefore(validFrom!)) return false;
    if (usageLimit != null && usedCount >= usageLimit!) return false;
    return true;
  }

  /// Time remaining until expiry.
  Duration? get timeRemaining {
    if (validUntil == null) return null;
    final remaining = validUntil!.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Days remaining.
  int? get daysRemaining {
    final remaining = timeRemaining;
    if (remaining == null) return null;
    return remaining.inDays;
  }

  /// Hours remaining (for same-day expiry).
  int? get hoursRemaining {
    final remaining = timeRemaining;
    if (remaining == null) return null;
    return remaining.inHours;
  }

  /// Discount display text.
  String get discountText {
    if (discountPercent != null) {
      return '${discountPercent!.toInt()}% OFF';
    }
    if (discountAmount != null) {
      return '\$${discountAmount!.toStringAsFixed(0)} OFF';
    }
    if (cashbackPercent != null) {
      return '${cashbackPercent!.toInt()}% Cashback';
    }
    return offerType.badgeText;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'partnerId': partnerId,
      'partnerName': partnerName,
      'title': title,
      'description': description,
      'offerType': offerType.name,
      'partnerCategory': partnerCategory.name,
      'imageUrl': imageUrl,
      'partnerLogoUrl': partnerLogoUrl,
      'discountPercent': discountPercent,
      'discountAmount': discountAmount,
      'cashbackPercent': cashbackPercent,
      'minPurchaseAmount': minPurchaseAmount,
      'maxDiscountAmount': maxDiscountAmount,
      'latitude': latitude,
      'longitude': longitude,
      'distance': distance,
      'validFrom': validFrom?.toIso8601String(),
      'validUntil': validUntil?.toIso8601String(),
      'termsAndConditions': termsAndConditions,
      'redemptionCode': redemptionCode,
      'status': status.name,
      'usageLimit': usageLimit,
      'usedCount': usedCount,
      'isTrending': isTrending,
      'isFeatured': isFeatured,
      'viewCount': viewCount,
    };
  }

  PartnerOfferModel copyWith({
    String? id,
    String? partnerId,
    String? partnerName,
    String? title,
    String? description,
    PartnerOfferType? offerType,
    PartnerCategory? partnerCategory,
    String? imageUrl,
    String? partnerLogoUrl,
    double? discountPercent,
    double? discountAmount,
    double? cashbackPercent,
    double? minPurchaseAmount,
    double? maxDiscountAmount,
    double? latitude,
    double? longitude,
    double? distance,
    DateTime? validFrom,
    DateTime? validUntil,
    String? termsAndConditions,
    String? redemptionCode,
    OfferStatus? status,
    int? usageLimit,
    int? usedCount,
    bool? isTrending,
    bool? isFeatured,
    int? viewCount,
  }) {
    return PartnerOfferModel(
      id: id ?? this.id,
      partnerId: partnerId ?? this.partnerId,
      partnerName: partnerName ?? this.partnerName,
      title: title ?? this.title,
      description: description ?? this.description,
      offerType: offerType ?? this.offerType,
      partnerCategory: partnerCategory ?? this.partnerCategory,
      imageUrl: imageUrl ?? this.imageUrl,
      partnerLogoUrl: partnerLogoUrl ?? this.partnerLogoUrl,
      discountPercent: discountPercent ?? this.discountPercent,
      discountAmount: discountAmount ?? this.discountAmount,
      cashbackPercent: cashbackPercent ?? this.cashbackPercent,
      minPurchaseAmount: minPurchaseAmount ?? this.minPurchaseAmount,
      maxDiscountAmount: maxDiscountAmount ?? this.maxDiscountAmount,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distance: distance ?? this.distance,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
      termsAndConditions: termsAndConditions ?? this.termsAndConditions,
      redemptionCode: redemptionCode ?? this.redemptionCode,
      status: status ?? this.status,
      usageLimit: usageLimit ?? this.usageLimit,
      usedCount: usedCount ?? this.usedCount,
      isTrending: isTrending ?? this.isTrending,
      isFeatured: isFeatured ?? this.isFeatured,
      viewCount: viewCount ?? this.viewCount,
    );
  }

  @override
  List<Object?> get props => [
    id,
    partnerId,
    partnerName,
    title,
    description,
    offerType,
    partnerCategory,
    imageUrl,
    partnerLogoUrl,
    discountPercent,
    discountAmount,
    cashbackPercent,
    minPurchaseAmount,
    maxDiscountAmount,
    latitude,
    longitude,
    distance,
    validFrom,
    validUntil,
    termsAndConditions,
    redemptionCode,
    status,
    usageLimit,
    usedCount,
    isTrending,
    isFeatured,
    viewCount,
  ];
}
