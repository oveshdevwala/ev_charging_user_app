/// File: lib/features/wallet/data/models/wallet_transaction_model.dart
/// Purpose: Wallet transaction model for credits/debits history
/// Belongs To: wallet feature
/// Customization Guide:
///    - Add new transaction types for different operations
///    - Modify categorization logic as needed
library;

import 'package:equatable/equatable.dart';

/// Transaction type enum for wallet operations.
enum WalletTransactionType {
  recharge,
  charging,
  cashback,
  refund,
  promoCredit,
  referral,
  reward,
  withdrawal,
  transfer,
  subscription,
}

/// Transaction status enum.
enum WalletTransactionStatus {
  completed,
  pending,
  failed,
  cancelled,
  processing,
}

/// Wallet transaction model for tracking all wallet operations.
/// 
/// ## Fields:
/// - [id]: Unique transaction identifier
/// - [type]: Type of transaction
/// - [amount]: Transaction amount
/// - [status]: Current status
/// - [createdAt]: Transaction timestamp
/// - [description]: Human-readable description
/// - [referenceId]: External reference ID (e.g., payment gateway ID)
/// - [metadata]: Additional transaction metadata
class WalletTransactionModel extends Equatable {
  const WalletTransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.description,
    this.referenceId,
    this.stationName,
    this.sessionId,
    this.promoCode,
    this.cashbackPercentage,
    this.balanceAfter,
    this.currency = 'USD',
    this.metadata = const {},
  });

  /// Create from JSON
  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: json['id'] as String? ?? '',
      type: WalletTransactionType.values.firstWhere(
        (t) => t.name == (json['type'] as String?),
        orElse: () => WalletTransactionType.charging,
      ),
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      status: WalletTransactionStatus.values.firstWhere(
        (s) => s.name == (json['status'] as String?),
        orElse: () => WalletTransactionStatus.completed,
      ),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      description: json['description'] as String?,
      referenceId: json['referenceId'] as String?,
      stationName: json['stationName'] as String?,
      sessionId: json['sessionId'] as String?,
      promoCode: json['promoCode'] as String?,
      cashbackPercentage: (json['cashbackPercentage'] as num?)?.toDouble(),
      balanceAfter: (json['balanceAfter'] as num?)?.toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );
  }

  final String id;
  final WalletTransactionType type;
  final double amount;
  final WalletTransactionStatus status;
  final DateTime createdAt;
  final String? description;
  final String? referenceId;
  final String? stationName;
  final String? sessionId;
  final String? promoCode;
  final double? cashbackPercentage;
  final double? balanceAfter;
  final String currency;
  final Map<String, dynamic> metadata;

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

  /// Check if transaction is a credit (money in)
  bool get isCredit {
    switch (type) {
      case WalletTransactionType.recharge:
      case WalletTransactionType.cashback:
      case WalletTransactionType.refund:
      case WalletTransactionType.promoCredit:
      case WalletTransactionType.referral:
      case WalletTransactionType.reward:
        return true;
      case WalletTransactionType.charging:
      case WalletTransactionType.withdrawal:
      case WalletTransactionType.transfer:
      case WalletTransactionType.subscription:
        return false;
    }
  }

  /// Formatted amount with sign and currency
  String get formattedAmount {
    final sign = isCredit ? '+' : '-';
    return '$sign$currencySymbol${amount.toStringAsFixed(2)}';
  }

  /// Get transaction type display name
  String get typeDisplayName {
    switch (type) {
      case WalletTransactionType.recharge:
        return 'Wallet Recharge';
      case WalletTransactionType.charging:
        return 'Charging Session';
      case WalletTransactionType.cashback:
        return 'Cashback';
      case WalletTransactionType.refund:
        return 'Refund';
      case WalletTransactionType.promoCredit:
        return 'Promo Credit';
      case WalletTransactionType.referral:
        return 'Referral Bonus';
      case WalletTransactionType.reward:
        return 'Reward';
      case WalletTransactionType.withdrawal:
        return 'Withdrawal';
      case WalletTransactionType.transfer:
        return 'Transfer';
      case WalletTransactionType.subscription:
        return 'Subscription';
    }
  }

  /// Get status display name
  String get statusDisplayName {
    switch (status) {
      case WalletTransactionStatus.completed:
        return 'Completed';
      case WalletTransactionStatus.pending:
        return 'Pending';
      case WalletTransactionStatus.failed:
        return 'Failed';
      case WalletTransactionStatus.cancelled:
        return 'Cancelled';
      case WalletTransactionStatus.processing:
        return 'Processing';
    }
  }

  /// Formatted date
  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final txDate = DateTime(createdAt.year, createdAt.month, createdAt.day);

    if (txDate == today) {
      return 'Today';
    } else if (txDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    }
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  /// Formatted time
  String get formattedTime {
    final hour = createdAt.hour.toString().padLeft(2, '0');
    final minute = createdAt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'amount': amount,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'description': description,
      'referenceId': referenceId,
      'stationName': stationName,
      'sessionId': sessionId,
      'promoCode': promoCode,
      'cashbackPercentage': cashbackPercentage,
      'balanceAfter': balanceAfter,
      'currency': currency,
      'metadata': metadata,
    };
  }

  /// Copy with
  WalletTransactionModel copyWith({
    String? id,
    WalletTransactionType? type,
    double? amount,
    WalletTransactionStatus? status,
    DateTime? createdAt,
    String? description,
    String? referenceId,
    String? stationName,
    String? sessionId,
    String? promoCode,
    double? cashbackPercentage,
    double? balanceAfter,
    String? currency,
    Map<String, dynamic>? metadata,
  }) {
    return WalletTransactionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      referenceId: referenceId ?? this.referenceId,
      stationName: stationName ?? this.stationName,
      sessionId: sessionId ?? this.sessionId,
      promoCode: promoCode ?? this.promoCode,
      cashbackPercentage: cashbackPercentage ?? this.cashbackPercentage,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      currency: currency ?? this.currency,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        amount,
        status,
        createdAt,
        description,
        referenceId,
        stationName,
        sessionId,
        promoCode,
        cashbackPercentage,
        balanceAfter,
        currency,
        metadata,
      ];
}

