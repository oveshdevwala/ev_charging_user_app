/// File: lib/features/wallet/data/models/promo_code_model.dart
/// Purpose: Promo code data model with validation and discount logic
/// Belongs To: wallet feature
/// Customization Guide:
///    - Add new discount types (BOGO, tiered, etc.)
///    - Modify validation rules as needed
library;

import 'package:equatable/equatable.dart';

/// Promo code discount type.
enum PromoDiscountType { percentage, fixed, cashback, credits }

/// Promo code status.
enum PromoCodeStatus { active, expired, used, invalid, limitReached }

/// Promo code applicability.
enum PromoApplicability { recharge, charging, subscription, all }

/// Promo code model for discounts and rewards.
///
/// ## Fields:
/// - [code]: The promo code string
/// - [discountType]: Type of discount (percentage, fixed, etc.)
/// - [discountValue]: Value of the discount
/// - [minSpend]: Minimum spend required
/// - [maxDiscount]: Maximum discount cap
/// - [validFrom]: Start date
/// - [validUntil]: End date
/// - [usageLimit]: Maximum times code can be used
/// - [usedCount]: Current usage count
/// - [applicability]: Where the promo can be applied
class PromoCodeModel extends Equatable {
  const PromoCodeModel({
    required this.id,
    required this.code,
    required this.discountType,
    required this.discountValue,
    required this.validFrom,
    required this.validUntil,
    this.title,
    this.description,
    this.minSpend = 0.0,
    this.maxDiscount,
    this.usageLimit = 1,
    this.usedCount = 0,
    this.applicability = PromoApplicability.all,
    this.terms = const [],
    this.isActive = true,
    this.currency = 'USD',
  });

  /// Create from JSON
  factory PromoCodeModel.fromJson(Map<String, dynamic> json) {
    return PromoCodeModel(
      id: json['id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      discountType: PromoDiscountType.values.firstWhere(
        (t) => t.name == (json['discountType'] as String?),
        orElse: () => PromoDiscountType.percentage,
      ),
      discountValue: (json['discountValue'] as num?)?.toDouble() ?? 0.0,
      validFrom: json['validFrom'] != null
          ? DateTime.parse(json['validFrom'] as String)
          : DateTime.now(),
      validUntil: json['validUntil'] != null
          ? DateTime.parse(json['validUntil'] as String)
          : DateTime.now().add(const Duration(days: 30)),
      title: json['title'] as String?,
      description: json['description'] as String?,
      minSpend: (json['minSpend'] as num?)?.toDouble() ?? 0.0,
      maxDiscount: (json['maxDiscount'] as num?)?.toDouble(),
      usageLimit: json['usageLimit'] as int? ?? 1,
      usedCount: json['usedCount'] as int? ?? 0,
      applicability: PromoApplicability.values.firstWhere(
        (a) => a.name == (json['applicability'] as String?),
        orElse: () => PromoApplicability.all,
      ),
      terms:
          (json['terms'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      isActive: json['isActive'] as bool? ?? true,
      currency: json['currency'] as String? ?? 'USD',
    );
  }

  final String id;
  final String code;
  final PromoDiscountType discountType;
  final double discountValue;
  final DateTime validFrom;
  final DateTime validUntil;
  final String? title;
  final String? description;
  final double minSpend;
  final double? maxDiscount;
  final int usageLimit;
  final int usedCount;
  final PromoApplicability applicability;
  final List<String> terms;
  final bool isActive;
  final String currency;

  /// Currency symbol
  String get currencySymbol {
    switch (currency) {
      case 'INR':
        return '₹';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'USD':
      default:
        return r'$';
    }
  }

  /// Check if promo is valid
  bool get isValid {
    final now = DateTime.now();
    return isActive &&
        now.isAfter(validFrom) &&
        now.isBefore(validUntil) &&
        usedCount < usageLimit;
  }

  /// Get promo code status
  PromoCodeStatus get status {
    final now = DateTime.now();
    if (!isActive) {
      return PromoCodeStatus.invalid;
    }
    if (now.isBefore(validFrom)) {
      return PromoCodeStatus.invalid;
    }
    if (now.isAfter(validUntil)) {
      return PromoCodeStatus.expired;
    }
    if (usedCount >= usageLimit) {
      return PromoCodeStatus.limitReached;
    }
    return PromoCodeStatus.active;
  }

  /// Days remaining for validity
  int get daysRemaining {
    final now = DateTime.now();
    return validUntil.difference(now).inDays;
  }

  /// Formatted discount value
  String get formattedDiscount {
    switch (discountType) {
      case PromoDiscountType.percentage:
        return '${discountValue.toStringAsFixed(0)}% OFF';
      case PromoDiscountType.fixed:
        return '$currencySymbol${discountValue.toStringAsFixed(0)} OFF';
      case PromoDiscountType.cashback:
        return '${discountValue.toStringAsFixed(0)}% Cashback';
      case PromoDiscountType.credits:
        return '${discountValue.toStringAsFixed(0)} Credits';
    }
  }

  /// Calculate discount for a given amount
  double calculateDiscount(double amount) {
    if (!isValid) {
      return 0;
    }
    if (amount < minSpend) {
      return 0;
    }

    var discount = 0;
    switch (discountType) {
      case PromoDiscountType.percentage:
      case PromoDiscountType.cashback:
        discount = (amount * (discountValue / 100)).toInt();
        break;
      case PromoDiscountType.fixed:
      case PromoDiscountType.credits:
        discount = discountValue.toInt();
        break;
    }

    // Apply max discount cap if set
    if (maxDiscount != null && discount > maxDiscount!) {
      discount = maxDiscount!.toInt();
    }

    // Don't allow discount more than the amount
    if (discount > amount) {
      discount = amount.toInt();
    }

    return discount.toDouble();
  }

  /// Validate promo for an amount and get error if any
  String? validateForAmount(double amount) {
    if (!isActive) {
      return 'This promo code is no longer active';
    }

    final now = DateTime.now();
    if (now.isBefore(validFrom)) {
      return 'This promo code is not yet active';
    }
    if (now.isAfter(validUntil)) {
      return 'This promo code has expired';
    }
    if (usedCount >= usageLimit) {
      return 'This promo code has reached its usage limit';
    }
    if (amount < minSpend) {
      return 'Minimum spend of $currencySymbol${minSpend.toStringAsFixed(0)} required';
    }
    return null;
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'discountType': discountType.name,
      'discountValue': discountValue,
      'validFrom': validFrom.toIso8601String(),
      'validUntil': validUntil.toIso8601String(),
      'title': title,
      'description': description,
      'minSpend': minSpend,
      'maxDiscount': maxDiscount,
      'usageLimit': usageLimit,
      'usedCount': usedCount,
      'applicability': applicability.name,
      'terms': terms,
      'isActive': isActive,
      'currency': currency,
    };
  }

  /// Copy with
  PromoCodeModel copyWith({
    String? id,
    String? code,
    PromoDiscountType? discountType,
    double? discountValue,
    DateTime? validFrom,
    DateTime? validUntil,
    String? title,
    String? description,
    double? minSpend,
    double? maxDiscount,
    int? usageLimit,
    int? usedCount,
    PromoApplicability? applicability,
    List<String>? terms,
    bool? isActive,
    String? currency,
  }) {
    return PromoCodeModel(
      id: id ?? this.id,
      code: code ?? this.code,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
      title: title ?? this.title,
      description: description ?? this.description,
      minSpend: minSpend ?? this.minSpend,
      maxDiscount: maxDiscount ?? this.maxDiscount,
      usageLimit: usageLimit ?? this.usageLimit,
      usedCount: usedCount ?? this.usedCount,
      applicability: applicability ?? this.applicability,
      terms: terms ?? this.terms,
      isActive: isActive ?? this.isActive,
      currency: currency ?? this.currency,
    );
  }

  @override
  List<Object?> get props => [
    id,
    code,
    discountType,
    discountValue,
    validFrom,
    validUntil,
    title,
    description,
    minSpend,
    maxDiscount,
    usageLimit,
    usedCount,
    applicability,
    terms,
    isActive,
    currency,
  ];
}

/// Result of applying a promo code
class PromoCodeResult extends Equatable {
  const PromoCodeResult({
    required this.isValid,
    this.promo,
    this.discountAmount = 0.0,
    this.errorMessage,
  });

  factory PromoCodeResult.success({
    required PromoCodeModel promo,
    required double discountAmount,
  }) => PromoCodeResult(
    isValid: true,
    promo: promo,
    discountAmount: discountAmount,
  );

  factory PromoCodeResult.failure(String errorMessage) =>
      PromoCodeResult(isValid: false, errorMessage: errorMessage);

  final bool isValid;
  final PromoCodeModel? promo;
  final double discountAmount;
  final String? errorMessage;

  @override
  List<Object?> get props => [isValid, promo, discountAmount, errorMessage];
}



