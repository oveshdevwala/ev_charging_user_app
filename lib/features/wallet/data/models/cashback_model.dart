/// File: lib/features/wallet/data/models/cashback_model.dart
/// Purpose: Cashback data model for partner stations rewards
/// Belongs To: wallet feature
/// Customization Guide:
///    - Add new cashback tiers/rules
///    - Modify partner station logic as needed
library;

import 'package:equatable/equatable.dart';

/// Cashback status enum.
enum CashbackStatus {
  pending,
  credited,
  expired,
  cancelled,
}

/// Cashback type enum.
enum CashbackType {
  partnerStation,
  promotion,
  loyalty,
  firstTime,
  referral,
}

/// Cashback model for tracking cashback rewards.
/// 
/// ## Fields:
/// - [id]: Unique cashback ID
/// - [sessionId]: Associated charging session
/// - [stationId]: Station where charging occurred
/// - [stationName]: Display name of station
/// - [originalAmount]: Amount spent on charging
/// - [cashbackPercentage]: Cashback percentage applied
/// - [cashbackAmount]: Actual cashback amount earned
/// - [status]: Current cashback status
/// - [earnedAt]: When cashback was earned
/// - [creditedAt]: When cashback was credited to wallet
class CashbackModel extends Equatable {
  const CashbackModel({
    required this.id,
    required this.sessionId,
    required this.stationId,
    required this.stationName,
    required this.originalAmount,
    required this.cashbackPercentage,
    required this.cashbackAmount,
    required this.earnedAt,
    this.status = CashbackStatus.pending,
    this.type = CashbackType.partnerStation,
    this.creditedAt,
    this.isPartnerStation = false,
    this.partnerBadge,
    this.description,
    this.transactionId,
    this.currency = 'USD',
  });

  /// Create from JSON
  factory CashbackModel.fromJson(Map<String, dynamic> json) {
    return CashbackModel(
      id: json['id'] as String? ?? '',
      sessionId: json['sessionId'] as String? ?? '',
      stationId: json['stationId'] as String? ?? '',
      stationName: json['stationName'] as String? ?? '',
      originalAmount: (json['originalAmount'] as num?)?.toDouble() ?? 0.0,
      cashbackPercentage:
          (json['cashbackPercentage'] as num?)?.toDouble() ?? 0.0,
      cashbackAmount: (json['cashbackAmount'] as num?)?.toDouble() ?? 0.0,
      earnedAt: json['earnedAt'] != null
          ? DateTime.parse(json['earnedAt'] as String)
          : DateTime.now(),
      status: CashbackStatus.values.firstWhere(
        (s) => s.name == (json['status'] as String?),
        orElse: () => CashbackStatus.pending,
      ),
      type: CashbackType.values.firstWhere(
        (t) => t.name == (json['type'] as String?),
        orElse: () => CashbackType.partnerStation,
      ),
      creditedAt: json['creditedAt'] != null
          ? DateTime.parse(json['creditedAt'] as String)
          : null,
      isPartnerStation: json['isPartnerStation'] as bool? ?? false,
      partnerBadge: json['partnerBadge'] as String?,
      description: json['description'] as String?,
      transactionId: json['transactionId'] as String?,
      currency: json['currency'] as String? ?? 'USD',
    );
  }

  final String id;
  final String sessionId;
  final String stationId;
  final String stationName;
  final double originalAmount;
  final double cashbackPercentage;
  final double cashbackAmount;
  final DateTime earnedAt;
  final CashbackStatus status;
  final CashbackType type;
  final DateTime? creditedAt;
  final bool isPartnerStation;
  final String? partnerBadge;
  final String? description;
  final String? transactionId;
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

  /// Formatted cashback amount
  String get formattedCashbackAmount =>
      '+$currencySymbol${cashbackAmount.toStringAsFixed(2)}';

  /// Formatted original amount
  String get formattedOriginalAmount =>
      '$currencySymbol${originalAmount.toStringAsFixed(2)}';

  /// Formatted percentage
  String get formattedPercentage => '${cashbackPercentage.toStringAsFixed(0)}%';

  /// Get status display name
  String get statusDisplayName {
    switch (status) {
      case CashbackStatus.pending:
        return 'Pending';
      case CashbackStatus.credited:
        return 'Credited';
      case CashbackStatus.expired:
        return 'Expired';
      case CashbackStatus.cancelled:
        return 'Cancelled';
    }
  }

  /// Get type display name
  String get typeDisplayName {
    switch (type) {
      case CashbackType.partnerStation:
        return 'Partner Station';
      case CashbackType.promotion:
        return 'Promotional';
      case CashbackType.loyalty:
        return 'Loyalty Reward';
      case CashbackType.firstTime:
        return 'First Time User';
      case CashbackType.referral:
        return 'Referral';
    }
  }

  /// Check if cashback is credited
  bool get isCredited => status == CashbackStatus.credited;

  /// Formatted earned date
  String get formattedEarnedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final entryDate = DateTime(earnedAt.year, earnedAt.month, earnedAt.day);

    if (entryDate == today) {
      return 'Today';
    } else if (entryDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    }
    return '${earnedAt.day}/${earnedAt.month}/${earnedAt.year}';
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionId': sessionId,
      'stationId': stationId,
      'stationName': stationName,
      'originalAmount': originalAmount,
      'cashbackPercentage': cashbackPercentage,
      'cashbackAmount': cashbackAmount,
      'earnedAt': earnedAt.toIso8601String(),
      'status': status.name,
      'type': type.name,
      'creditedAt': creditedAt?.toIso8601String(),
      'isPartnerStation': isPartnerStation,
      'partnerBadge': partnerBadge,
      'description': description,
      'transactionId': transactionId,
      'currency': currency,
    };
  }

  /// Copy with
  CashbackModel copyWith({
    String? id,
    String? sessionId,
    String? stationId,
    String? stationName,
    double? originalAmount,
    double? cashbackPercentage,
    double? cashbackAmount,
    DateTime? earnedAt,
    CashbackStatus? status,
    CashbackType? type,
    DateTime? creditedAt,
    bool? isPartnerStation,
    String? partnerBadge,
    String? description,
    String? transactionId,
    String? currency,
  }) {
    return CashbackModel(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      stationId: stationId ?? this.stationId,
      stationName: stationName ?? this.stationName,
      originalAmount: originalAmount ?? this.originalAmount,
      cashbackPercentage: cashbackPercentage ?? this.cashbackPercentage,
      cashbackAmount: cashbackAmount ?? this.cashbackAmount,
      earnedAt: earnedAt ?? this.earnedAt,
      status: status ?? this.status,
      type: type ?? this.type,
      creditedAt: creditedAt ?? this.creditedAt,
      isPartnerStation: isPartnerStation ?? this.isPartnerStation,
      partnerBadge: partnerBadge ?? this.partnerBadge,
      description: description ?? this.description,
      transactionId: transactionId ?? this.transactionId,
      currency: currency ?? this.currency,
    );
  }

  @override
  List<Object?> get props => [
        id,
        sessionId,
        stationId,
        stationName,
        originalAmount,
        cashbackPercentage,
        cashbackAmount,
        earnedAt,
        status,
        type,
        creditedAt,
        isPartnerStation,
        partnerBadge,
        description,
        transactionId,
        currency,
      ];
}

/// Partner station info for cashback eligibility.
class PartnerStationModel extends Equatable {
  const PartnerStationModel({
    required this.stationId,
    required this.stationName,
    required this.cashbackPercentage,
    this.partnerBadge,
    this.partnerTier,
    this.validUntil,
    this.terms = const [],
  });

  /// Create from JSON
  factory PartnerStationModel.fromJson(Map<String, dynamic> json) {
    return PartnerStationModel(
      stationId: json['stationId'] as String? ?? '',
      stationName: json['stationName'] as String? ?? '',
      cashbackPercentage:
          (json['cashbackPercentage'] as num?)?.toDouble() ?? 0.0,
      partnerBadge: json['partnerBadge'] as String?,
      partnerTier: json['partnerTier'] as String?,
      validUntil: json['validUntil'] != null
          ? DateTime.parse(json['validUntil'] as String)
          : null,
      terms: (json['terms'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }

  final String stationId;
  final String stationName;
  final double cashbackPercentage;
  final String? partnerBadge;
  final String? partnerTier;
  final DateTime? validUntil;
  final List<String> terms;

  /// Formatted percentage
  String get formattedPercentage =>
      '${cashbackPercentage.toStringAsFixed(0)}% Cashback';

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'stationId': stationId,
      'stationName': stationName,
      'cashbackPercentage': cashbackPercentage,
      'partnerBadge': partnerBadge,
      'partnerTier': partnerTier,
      'validUntil': validUntil?.toIso8601String(),
      'terms': terms,
    };
  }

  @override
  List<Object?> get props => [
        stationId,
        stationName,
        cashbackPercentage,
        partnerBadge,
        partnerTier,
        validUntil,
        terms,
      ];
}

