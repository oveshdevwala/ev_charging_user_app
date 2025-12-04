/// File: lib/models/transaction_model.dart
/// Purpose: Transaction/payment data model for activity tracking
/// Belongs To: shared
/// Customization Guide:
///    - Add new transaction types as needed
///    - Update copyWith and JSON methods accordingly
library;

import 'package:equatable/equatable.dart';

/// Transaction type enum.
enum TransactionType {
  charging,
  subscription,
  refund,
  topUp,
  withdrawal,
  reward,
  referral,
}

/// Transaction status enum.
enum TransactionStatus {
  completed,
  pending,
  failed,
  cancelled,
  refunded,
}

/// Payment method enum.
enum PaymentMethod {
  creditCard,
  debitCard,
  wallet,
  applePay,
  googlePay,
  paypal,
  bankTransfer,
}

/// Transaction model for payment history.
class TransactionModel extends Equatable {
  const TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.createdAt,
    this.status = TransactionStatus.completed,
    this.paymentMethod,
    this.description,
    this.referenceId,
    this.sessionId,
    this.stationName,
    this.energyKwh,
    this.currency = 'USD',
    this.fee = 0.0,
  });

  final String id;
  final TransactionType type;
  final double amount;
  final DateTime createdAt;
  final TransactionStatus status;
  final PaymentMethod? paymentMethod;
  final String? description;
  final String? referenceId;
  final String? sessionId;
  final String? stationName;
  final double? energyKwh;
  final String currency;
  final double fee;

  /// Net amount after fees.
  double get netAmount => amount - fee;

  /// Check if transaction is a credit (money in).
  bool get isCredit =>
      type == TransactionType.refund ||
      type == TransactionType.topUp ||
      type == TransactionType.reward ||
      type == TransactionType.referral;

  /// Get formatted amount with sign.
  String get formattedAmount {
    final sign = isCredit ? '+' : '-';
    return '$sign\$${amount.toStringAsFixed(2)}';
  }

  /// Get formatted date.
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

  /// Get formatted time.
  String get formattedTime {
    final hour = createdAt.hour.toString().padLeft(2, '0');
    final minute = createdAt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Get transaction type display name.
  String get typeDisplayName {
    switch (type) {
      case TransactionType.charging:
        return 'Charging';
      case TransactionType.subscription:
        return 'Subscription';
      case TransactionType.refund:
        return 'Refund';
      case TransactionType.topUp:
        return 'Wallet Top-up';
      case TransactionType.withdrawal:
        return 'Withdrawal';
      case TransactionType.reward:
        return 'Reward';
      case TransactionType.referral:
        return 'Referral Bonus';
    }
  }

  /// Get payment method display name.
  String get paymentMethodDisplayName {
    switch (paymentMethod) {
      case PaymentMethod.creditCard:
        return 'Credit Card';
      case PaymentMethod.debitCard:
        return 'Debit Card';
      case PaymentMethod.wallet:
        return 'Wallet';
      case PaymentMethod.applePay:
        return 'Apple Pay';
      case PaymentMethod.googlePay:
        return 'Google Pay';
      case PaymentMethod.paypal:
        return 'PayPal';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case null:
        return 'Unknown';
    }
  }

  /// Create from JSON map.
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String? ?? '',
      type: TransactionType.values.firstWhere(
        (t) => t.name == (json['type'] as String?),
        orElse: () => TransactionType.charging,
      ),
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      status: TransactionStatus.values.firstWhere(
        (s) => s.name == (json['status'] as String?),
        orElse: () => TransactionStatus.completed,
      ),
      paymentMethod: json['paymentMethod'] != null
          ? PaymentMethod.values.firstWhere(
              (p) => p.name == (json['paymentMethod'] as String),
              orElse: () => PaymentMethod.wallet,
            )
          : null,
      description: json['description'] as String?,
      referenceId: json['referenceId'] as String?,
      sessionId: json['sessionId'] as String?,
      stationName: json['stationName'] as String?,
      energyKwh: (json['energyKwh'] as num?)?.toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      fee: (json['fee'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'amount': amount,
      'createdAt': createdAt.toIso8601String(),
      'status': status.name,
      'paymentMethod': paymentMethod?.name,
      'description': description,
      'referenceId': referenceId,
      'sessionId': sessionId,
      'stationName': stationName,
      'energyKwh': energyKwh,
      'currency': currency,
      'fee': fee,
    };
  }

  /// Copy with new values.
  TransactionModel copyWith({
    String? id,
    TransactionType? type,
    double? amount,
    DateTime? createdAt,
    TransactionStatus? status,
    PaymentMethod? paymentMethod,
    String? description,
    String? referenceId,
    String? sessionId,
    String? stationName,
    double? energyKwh,
    String? currency,
    double? fee,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      description: description ?? this.description,
      referenceId: referenceId ?? this.referenceId,
      sessionId: sessionId ?? this.sessionId,
      stationName: stationName ?? this.stationName,
      energyKwh: energyKwh ?? this.energyKwh,
      currency: currency ?? this.currency,
      fee: fee ?? this.fee,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        amount,
        createdAt,
        status,
        paymentMethod,
        description,
        referenceId,
        sessionId,
        stationName,
        energyKwh,
        currency,
        fee,
      ];
}

