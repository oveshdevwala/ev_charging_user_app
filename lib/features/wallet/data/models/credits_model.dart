/// File: lib/features/wallet/data/models/credits_model.dart
/// Purpose: Charging credits model for rewards tracking
/// Belongs To: wallet feature
/// Customization Guide:
///    - Modify credit earning rules as needed
///    - Add new credit sources/types
library;

import 'package:equatable/equatable.dart';

/// Credit source type for tracking how credits were earned.
enum CreditSource {
  charging,
  referral,
  promotion,
  bonus,
  signup,
  anniversary,
  loyalty,
  feedback,
}

/// Credit status for ledger entries.
enum CreditStatus {
  active,
  used,
  expired,
  pending,
}

/// Single credit entry in the ledger.
/// 
/// ## Fields:
/// - [id]: Unique credit entry ID
/// - [credits]: Number of credits earned
/// - [source]: How credits were earned
/// - [earnedAt]: When credits were earned
/// - [expiresAt]: When credits expire
/// - [usedCredits]: Credits already used from this entry
/// - [sessionId]: Associated charging session (if applicable)
class CreditEntryModel extends Equatable {
  const CreditEntryModel({
    required this.id,
    required this.credits,
    required this.source,
    required this.earnedAt,
    required this.expiresAt,
    this.usedCredits = 0,
    this.sessionId,
    this.stationName,
    this.amountSpent,
    this.description,
    this.status = CreditStatus.active,
  });

  /// Create from JSON
  factory CreditEntryModel.fromJson(Map<String, dynamic> json) {
    return CreditEntryModel(
      id: json['id'] as String? ?? '',
      credits: json['credits'] as int? ?? 0,
      source: CreditSource.values.firstWhere(
        (s) => s.name == (json['source'] as String?),
        orElse: () => CreditSource.charging,
      ),
      earnedAt: json['earnedAt'] != null
          ? DateTime.parse(json['earnedAt'] as String)
          : DateTime.now(),
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : DateTime.now().add(const Duration(days: 365)),
      usedCredits: json['usedCredits'] as int? ?? 0,
      sessionId: json['sessionId'] as String?,
      stationName: json['stationName'] as String?,
      amountSpent: (json['amountSpent'] as num?)?.toDouble(),
      description: json['description'] as String?,
      status: CreditStatus.values.firstWhere(
        (s) => s.name == (json['status'] as String?),
        orElse: () => CreditStatus.active,
      ),
    );
  }

  final String id;
  final int credits;
  final CreditSource source;
  final DateTime earnedAt;
  final DateTime expiresAt;
  final int usedCredits;
  final String? sessionId;
  final String? stationName;
  final double? amountSpent;
  final String? description;
  final CreditStatus status;

  /// Remaining credits
  int get remainingCredits => credits - usedCredits;

  /// Check if entry is expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Check if entry has available credits
  bool get hasAvailableCredits => remainingCredits > 0 && !isExpired;

  /// Days until expiry
  int get daysUntilExpiry {
    final now = DateTime.now();
    return expiresAt.difference(now).inDays;
  }

  /// Get source display name
  String get sourceDisplayName {
    switch (source) {
      case CreditSource.charging:
        return 'Charging Session';
      case CreditSource.referral:
        return 'Referral Bonus';
      case CreditSource.promotion:
        return 'Promotional Offer';
      case CreditSource.bonus:
        return 'Bonus Credits';
      case CreditSource.signup:
        return 'Sign-up Bonus';
      case CreditSource.anniversary:
        return 'Anniversary Reward';
      case CreditSource.loyalty:
        return 'Loyalty Reward';
      case CreditSource.feedback:
        return 'Feedback Reward';
    }
  }

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
      'credits': credits,
      'source': source.name,
      'earnedAt': earnedAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'usedCredits': usedCredits,
      'sessionId': sessionId,
      'stationName': stationName,
      'amountSpent': amountSpent,
      'description': description,
      'status': status.name,
    };
  }

  /// Copy with
  CreditEntryModel copyWith({
    String? id,
    int? credits,
    CreditSource? source,
    DateTime? earnedAt,
    DateTime? expiresAt,
    int? usedCredits,
    String? sessionId,
    String? stationName,
    double? amountSpent,
    String? description,
    CreditStatus? status,
  }) {
    return CreditEntryModel(
      id: id ?? this.id,
      credits: credits ?? this.credits,
      source: source ?? this.source,
      earnedAt: earnedAt ?? this.earnedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      usedCredits: usedCredits ?? this.usedCredits,
      sessionId: sessionId ?? this.sessionId,
      stationName: stationName ?? this.stationName,
      amountSpent: amountSpent ?? this.amountSpent,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        id,
        credits,
        source,
        earnedAt,
        expiresAt,
        usedCredits,
        sessionId,
        stationName,
        amountSpent,
        description,
        status,
      ];
}

/// Credits summary model for displaying total credits info.
class CreditsSummaryModel extends Equatable {
  const CreditsSummaryModel({
    required this.totalCredits,
    required this.availableCredits,
    required this.usedCredits,
    required this.expiringCredits,
    required this.expiringInDays,
    required this.creditValue,
    this.currency = 'USD',
    this.creditsEarnedThisMonth = 0,
    this.totalCreditEntries = 0,
  });

  /// Create from JSON
  factory CreditsSummaryModel.fromJson(Map<String, dynamic> json) {
    return CreditsSummaryModel(
      totalCredits: json['totalCredits'] as int? ?? 0,
      availableCredits: json['availableCredits'] as int? ?? 0,
      usedCredits: json['usedCredits'] as int? ?? 0,
      expiringCredits: json['expiringCredits'] as int? ?? 0,
      expiringInDays: json['expiringInDays'] as int? ?? 0,
      creditValue: (json['creditValue'] as num?)?.toDouble() ?? 0.01,
      currency: json['currency'] as String? ?? 'USD',
      creditsEarnedThisMonth: json['creditsEarnedThisMonth'] as int? ?? 0,
      totalCreditEntries: json['totalCreditEntries'] as int? ?? 0,
    );
  }

  /// Empty summary
  factory CreditsSummaryModel.empty() => const CreditsSummaryModel(
        totalCredits: 0,
        availableCredits: 0,
        usedCredits: 0,
        expiringCredits: 0,
        expiringInDays: 0,
        creditValue: 0.01,
      );

  /// Total credits ever earned
  final int totalCredits;

  /// Currently available credits
  final int availableCredits;

  /// Credits already used
  final int usedCredits;

  /// Credits expiring soon
  final int expiringCredits;

  /// Days until next expiry
  final int expiringInDays;

  /// Value of 1 credit in currency
  final double creditValue;

  /// Currency code
  final String currency;

  /// Credits earned this month
  final int creditsEarnedThisMonth;

  /// Total credit entries
  final int totalCreditEntries;

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

  /// Monetary value of available credits
  double get availableValue => availableCredits * creditValue;

  /// Formatted monetary value
  String get formattedAvailableValue =>
      '$currencySymbol${availableValue.toStringAsFixed(2)}';

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'totalCredits': totalCredits,
      'availableCredits': availableCredits,
      'usedCredits': usedCredits,
      'expiringCredits': expiringCredits,
      'expiringInDays': expiringInDays,
      'creditValue': creditValue,
      'currency': currency,
      'creditsEarnedThisMonth': creditsEarnedThisMonth,
      'totalCreditEntries': totalCreditEntries,
    };
  }

  /// Copy with
  CreditsSummaryModel copyWith({
    int? totalCredits,
    int? availableCredits,
    int? usedCredits,
    int? expiringCredits,
    int? expiringInDays,
    double? creditValue,
    String? currency,
    int? creditsEarnedThisMonth,
    int? totalCreditEntries,
  }) {
    return CreditsSummaryModel(
      totalCredits: totalCredits ?? this.totalCredits,
      availableCredits: availableCredits ?? this.availableCredits,
      usedCredits: usedCredits ?? this.usedCredits,
      expiringCredits: expiringCredits ?? this.expiringCredits,
      expiringInDays: expiringInDays ?? this.expiringInDays,
      creditValue: creditValue ?? this.creditValue,
      currency: currency ?? this.currency,
      creditsEarnedThisMonth:
          creditsEarnedThisMonth ?? this.creditsEarnedThisMonth,
      totalCreditEntries: totalCreditEntries ?? this.totalCreditEntries,
    );
  }

  @override
  List<Object?> get props => [
        totalCredits,
        availableCredits,
        usedCredits,
        expiringCredits,
        expiringInDays,
        creditValue,
        currency,
        creditsEarnedThisMonth,
        totalCreditEntries,
      ];
}

