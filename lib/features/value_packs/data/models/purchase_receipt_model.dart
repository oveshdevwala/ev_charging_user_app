/// File: lib/features/value_packs/data/models/purchase_receipt_model.dart
/// Purpose: Purchase receipt data model with JSON serialization
/// Belongs To: value_packs feature
library;

import 'package:equatable/equatable.dart';

import '../../domain/entities/purchase_receipt.dart';

/// Purchase receipt data model.
class PurchaseReceiptModel extends Equatable {
  const PurchaseReceiptModel({
    required this.id,
    required this.packId,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.status,
    this.createdAt,
    this.invoiceUrl,
    this.transactionId,
    this.paymentMethod,
  });

  /// Create from JSON map.
  factory PurchaseReceiptModel.fromJson(Map<String, dynamic> json) {
    return PurchaseReceiptModel(
      id: json['id'] as String? ?? '',
      packId: json['packId'] as String? ?? json['pack_id'] as String? ?? '',
      userId: json['userId'] as String? ?? json['user_id'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'USD',
      status: _parseStatus(json['status'] as String?),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : json['created_at'] != null
              ? DateTime.tryParse(json['created_at'] as String)
              : null,
      invoiceUrl: json['invoiceUrl'] as String? ?? json['invoice_url'] as String?,
      transactionId: json['transactionId'] as String? ?? json['transaction_id'] as String?,
      paymentMethod: json['paymentMethod'] as String? ?? json['payment_method'] as String?,
    );
  }

  /// Parse status from string.
  static PurchaseStatus _parseStatus(String? value) {
    if (value == null) {
      return PurchaseStatus.pending;
    }
    switch (value.toLowerCase()) {
      case 'completed':
        return PurchaseStatus.completed;
      case 'processing':
        return PurchaseStatus.processing;
      case 'failed':
        return PurchaseStatus.failed;
      case 'cancelled':
        return PurchaseStatus.cancelled;
      case 'refunded':
        return PurchaseStatus.refunded;
      default:
        return PurchaseStatus.pending;
    }
  }

  final String id;
  final String packId;
  final String userId;
  final double amount;
  final String currency;
  final PurchaseStatus status;
  final DateTime? createdAt;
  final String? invoiceUrl;
  final String? transactionId;
  final String? paymentMethod;

  /// Convert to domain entity.
  PurchaseReceipt toEntity() {
    return PurchaseReceipt(
      id: id,
      packId: packId,
      userId: userId,
      amount: amount,
      currency: currency,
      status: status,
      createdAt: createdAt,
      invoiceUrl: invoiceUrl,
      transactionId: transactionId,
      paymentMethod: paymentMethod,
    );
  }

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'packId': packId,
      'userId': userId,
      'amount': amount,
      'currency': currency,
      'status': status.name,
      'createdAt': createdAt?.toIso8601String(),
      'invoiceUrl': invoiceUrl,
      'transactionId': transactionId,
      'paymentMethod': paymentMethod,
    };
  }

  /// Copy with new values.
  PurchaseReceiptModel copyWith({
    String? id,
    String? packId,
    String? userId,
    double? amount,
    String? currency,
    PurchaseStatus? status,
    DateTime? createdAt,
    String? invoiceUrl,
    String? transactionId,
    String? paymentMethod,
  }) {
    return PurchaseReceiptModel(
      id: id ?? this.id,
      packId: packId ?? this.packId,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      invoiceUrl: invoiceUrl ?? this.invoiceUrl,
      transactionId: transactionId ?? this.transactionId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  @override
  List<Object?> get props => [
        id,
        packId,
        userId,
        amount,
        currency,
        status,
        createdAt,
        invoiceUrl,
        transactionId,
        paymentMethod,
      ];
}

