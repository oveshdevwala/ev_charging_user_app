/// File: lib/admin/features/wallets/models/wallet_transaction_model.dart
/// Purpose: Wallet transaction model for admin wallets module
/// Belongs To: admin/features/wallets
/// Customization Guide:
/// - Extend transaction types as needed
library;

import 'package:equatable/equatable.dart';

/// Transaction types.
enum TransactionType { credit, debit, refund, adjust }

/// Transaction model for wallet transaction history.
class WalletTransactionModel extends Equatable {
  const WalletTransactionModel({
    required this.id,
    required this.walletId,
    required this.type,
    required this.amount,
    required this.currency,
    required this.memo,
    required this.createdAt,
    required this.actor,
    this.status = 'completed',
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: json['id'] as String? ?? '',
      walletId: json['walletId'] as String? ?? '',
      type: _typeFromString(json['type'] as String?),
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'USD',
      memo: json['memo'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      actor: json['actor'] as String? ?? 'System',
      status: json['status'] as String? ?? 'completed',
    );
  }

  final String id;
  final String walletId;
  final TransactionType type;
  final double amount;
  final String currency;
  final String memo;
  final DateTime createdAt;
  final String actor;
  final String status;

  bool get isCredit =>
      type == TransactionType.credit || type == TransactionType.refund;
  bool get isDebit => type == TransactionType.debit;
  bool get isAdjust => type == TransactionType.adjust;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'walletId': walletId,
      'type': type.name,
      'amount': amount,
      'currency': currency,
      'memo': memo,
      'createdAt': createdAt.toIso8601String(),
      'actor': actor,
      'status': status,
    };
  }

  WalletTransactionModel copyWith({
    String? id,
    String? walletId,
    TransactionType? type,
    double? amount,
    String? currency,
    String? memo,
    DateTime? createdAt,
    String? actor,
    String? status,
  }) {
    return WalletTransactionModel(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      memo: memo ?? this.memo,
      createdAt: createdAt ?? this.createdAt,
      actor: actor ?? this.actor,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    id,
    walletId,
    type,
    amount,
    currency,
    memo,
    createdAt,
    actor,
    status,
  ];
}

TransactionType _typeFromString(String? value) {
  switch (value?.toLowerCase()) {
    case 'debit':
      return TransactionType.debit;
    case 'refund':
      return TransactionType.refund;
    case 'adjust':
      return TransactionType.adjust;
    case 'credit':
    default:
      return TransactionType.credit;
  }
}
