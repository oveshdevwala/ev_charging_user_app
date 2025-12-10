/// File: lib/admin/features/offers/models/offer_model.dart
/// Purpose: Offer domain model for admin offers module
/// Belongs To: admin/features/offers
/// Customization Guide:
/// - Extend enums when adding new offer statuses/discount types
/// - Add additional fields as backend evolves
library;

import 'package:equatable/equatable.dart';

/// Supported offer statuses.
enum OfferStatus { active, inactive, scheduled, expired }

/// Supported discount types.
enum DiscountType { percentage, fixed, freeEnergy }

/// Offer model used across list and detail surfaces.
class OfferModel extends Equatable {
  const OfferModel({
    required this.id,
    required this.title,
    required this.discountType,
    required this.discountValue,
    required this.status,
    required this.validFrom,
    required this.validUntil,
    required this.createdAt,
    this.description,
    this.code,
    this.imageUrl,
    this.maxUses,
    this.currentUses = 0,
    this.minPurchaseAmount,
    this.applicableStations = const [],
    this.termsAndConditions,
    this.createdBy,
    this.updatedAt,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      discountType: _discountTypeFromString(json['discountType'] as String?),
      discountValue: (json['discountValue'] as num?)?.toDouble() ?? 0.0,
      status: _statusFromString(json['status'] as String?),
      validFrom: DateTime.tryParse(json['validFrom'] as String? ?? '') ??
          DateTime.now(),
      validUntil: DateTime.tryParse(json['validUntil'] as String? ?? '') ??
          DateTime.now(),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      description: json['description'] as String?,
      code: json['code'] as String?,
      imageUrl: json['imageUrl'] as String?,
      maxUses: json['maxUses'] as int?,
      currentUses: json['currentUses'] as int? ?? 0,
      minPurchaseAmount: (json['minPurchaseAmount'] as num?)?.toDouble(),
      applicableStations: (json['applicableStations'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      termsAndConditions: json['termsAndConditions'] as String?,
      createdBy: json['createdBy'] as String?,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  final String id;
  final String title;
  final DiscountType discountType;
  final double discountValue;
  final OfferStatus status;
  final DateTime validFrom;
  final DateTime validUntil;
  final DateTime createdAt;
  final String? description;
  final String? code;
  final String? imageUrl;
  final int? maxUses;
  final int currentUses;
  final double? minPurchaseAmount;
  final List<String> applicableStations;
  final String? termsAndConditions;
  final String? createdBy;
  final DateTime? updatedAt;

  /// Check if offer is currently valid.
  bool get isValid {
    final now = DateTime.now();
    return status == OfferStatus.active &&
        now.isAfter(validFrom) &&
        now.isBefore(validUntil);
  }

  /// Check if offer has remaining uses.
  bool get hasRemainingUses => maxUses == null || currentUses < maxUses!;

  /// Remaining uses count.
  int? get remainingUses => maxUses != null ? maxUses! - currentUses : null;

  /// Formatted discount value.
  String get formattedDiscount {
    switch (discountType) {
      case DiscountType.percentage:
        return '${discountValue.toStringAsFixed(0)}%';
      case DiscountType.fixed:
        return '\$${discountValue.toStringAsFixed(2)}';
      case DiscountType.freeEnergy:
        return '${discountValue.toStringAsFixed(1)} kWh Free';
    }
  }

  /// Days until expiry.
  int get daysUntilExpiry {
    final now = DateTime.now();
    if (validUntil.isBefore(now)) return 0;
    return validUntil.difference(now).inDays;
  }

  /// Check if offer is expired.
  bool get isExpired => DateTime.now().isAfter(validUntil);

  /// Check if offer is scheduled (not yet active).
  bool get isScheduled => DateTime.now().isBefore(validFrom);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'discountType': discountType.name,
      'discountValue': discountValue,
      'status': status.name,
      'validFrom': validFrom.toIso8601String(),
      'validUntil': validUntil.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'description': description,
      'code': code,
      'imageUrl': imageUrl,
      'maxUses': maxUses,
      'currentUses': currentUses,
      'minPurchaseAmount': minPurchaseAmount,
      'applicableStations': applicableStations,
      'termsAndConditions': termsAndConditions,
      'createdBy': createdBy,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  OfferModel copyWith({
    String? id,
    String? title,
    DiscountType? discountType,
    double? discountValue,
    OfferStatus? status,
    DateTime? validFrom,
    DateTime? validUntil,
    DateTime? createdAt,
    String? description,
    String? code,
    String? imageUrl,
    int? maxUses,
    int? currentUses,
    double? minPurchaseAmount,
    List<String>? applicableStations,
    String? termsAndConditions,
    String? createdBy,
    DateTime? updatedAt,
  }) {
    return OfferModel(
      id: id ?? this.id,
      title: title ?? this.title,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      status: status ?? this.status,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      code: code ?? this.code,
      imageUrl: imageUrl ?? this.imageUrl,
      maxUses: maxUses ?? this.maxUses,
      currentUses: currentUses ?? this.currentUses,
      minPurchaseAmount: minPurchaseAmount ?? this.minPurchaseAmount,
      applicableStations: applicableStations ?? this.applicableStations,
      termsAndConditions: termsAndConditions ?? this.termsAndConditions,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        discountType,
        discountValue,
        status,
        validFrom,
        validUntil,
        createdAt,
        description,
        code,
        imageUrl,
        maxUses,
        currentUses,
        minPurchaseAmount,
        applicableStations,
        termsAndConditions,
        createdBy,
        updatedAt,
      ];
}

OfferStatus _statusFromString(String? value) {
  switch (value?.toLowerCase()) {
    case 'inactive':
      return OfferStatus.inactive;
    case 'scheduled':
      return OfferStatus.scheduled;
    case 'expired':
      return OfferStatus.expired;
    case 'active':
    default:
      return OfferStatus.active;
  }
}

DiscountType _discountTypeFromString(String? value) {
  switch (value?.toLowerCase()) {
    case 'fixed':
      return DiscountType.fixed;
    case 'freeenergy':
    case 'free_energy':
      return DiscountType.freeEnergy;
    case 'percentage':
    default:
      return DiscountType.percentage;
  }
}
