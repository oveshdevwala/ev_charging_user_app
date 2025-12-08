/// File: lib/admin/models/admin_transaction_model.dart
/// Purpose: Transaction model for admin panel
/// Belongs To: admin/models
library;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_transaction_model.g.dart';

/// Transaction type enum.
enum AdminTransactionType {
  @JsonValue('charge')
  charge,
  @JsonValue('recharge')
  recharge,
  @JsonValue('refund')
  refund,
  @JsonValue('withdrawal')
  withdrawal,
  @JsonValue('adjustment')
  adjustment,
}

/// Transaction status enum.
enum AdminTransactionStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('completed')
  completed,
  @JsonValue('failed')
  failed,
  @JsonValue('refunded')
  refunded,
}

/// Transaction model for admin panel.
@JsonSerializable()
class AdminTransaction extends Equatable {
  const AdminTransaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.userName,
    this.description,
    this.paymentMethod,
    this.sessionId,
    this.referenceId,
  });

  factory AdminTransaction.fromJson(Map<String, dynamic> json) =>
      _$AdminTransactionFromJson(json);

  final String id;
  final String userId;
  final AdminTransactionType type;
  final double amount;
  final AdminTransactionStatus status;
  final DateTime createdAt;
  final String? userName;
  final String? description;
  final String? paymentMethod;
  final String? sessionId;
  final String? referenceId;

  Map<String, dynamic> toJson() => _$AdminTransactionToJson(this);

  /// Check if amount is credit (positive).
  bool get isCredit => type == AdminTransactionType.recharge ||
      type == AdminTransactionType.refund;

  /// Check if amount is debit (negative).
  bool get isDebit => !isCredit;

  AdminTransaction copyWith({
    String? id,
    String? userId,
    AdminTransactionType? type,
    double? amount,
    AdminTransactionStatus? status,
    DateTime? createdAt,
    String? userName,
    String? description,
    String? paymentMethod,
    String? sessionId,
    String? referenceId,
  }) {
    return AdminTransaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      userName: userName ?? this.userName,
      description: description ?? this.description,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      sessionId: sessionId ?? this.sessionId,
      referenceId: referenceId ?? this.referenceId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        amount,
        status,
        createdAt,
        userName,
        description,
        paymentMethod,
        sessionId,
        referenceId,
      ];
}

