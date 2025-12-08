/// File: lib/admin/models/admin_offer_model.dart
/// Purpose: Offer/promotion model for admin panel
/// Belongs To: admin/models
library;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_offer_model.g.dart';

/// Offer status enum.
enum AdminOfferStatus {
  @JsonValue('active')
  active,
  @JsonValue('inactive')
  inactive,
  @JsonValue('scheduled')
  scheduled,
  @JsonValue('expired')
  expired,
}

/// Discount type enum.
enum AdminDiscountType {
  @JsonValue('percentage')
  percentage,
  @JsonValue('fixed')
  fixed,
  @JsonValue('freeEnergy')
  freeEnergy,
}

/// Offer model for admin panel.
@JsonSerializable()
class AdminOffer extends Equatable {
  const AdminOffer({
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
  });

  factory AdminOffer.fromJson(Map<String, dynamic> json) =>
      _$AdminOfferFromJson(json);

  final String id;
  final String title;
  final AdminDiscountType discountType;
  final double discountValue;
  final AdminOfferStatus status;
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

  Map<String, dynamic> toJson() => _$AdminOfferToJson(this);

  /// Check if offer is currently valid.
  bool get isValid {
    final now = DateTime.now();
    return status == AdminOfferStatus.active &&
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
      case AdminDiscountType.percentage:
        return '${discountValue.toStringAsFixed(0)}%';
      case AdminDiscountType.fixed:
        return '\$${discountValue.toStringAsFixed(2)}';
      case AdminDiscountType.freeEnergy:
        return '${discountValue.toStringAsFixed(1)} kWh Free';
    }
  }

  AdminOffer copyWith({
    String? id,
    String? title,
    AdminDiscountType? discountType,
    double? discountValue,
    AdminOfferStatus? status,
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
  }) {
    return AdminOffer(
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
      ];
}

