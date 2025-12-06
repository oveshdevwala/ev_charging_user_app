/// File: lib/features/value_packs/domain/entities/purchase_receipt.dart
/// Purpose: Purchase receipt domain entity
/// Belongs To: value_packs feature
/// Customization Guide:
///    - Add new fields as needed
///    - Update copyWith and props accordingly
library;

import 'package:equatable/equatable.dart';

/// Purchase status enum.
enum PurchaseStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
  refunded,
}

/// Purchase receipt domain entity.
class PurchaseReceipt extends Equatable {
  const PurchaseReceipt({
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

  /// Check if purchase is successful.
  bool get isSuccessful => status == PurchaseStatus.completed;

  /// Check if purchase is pending.
  bool get isPending => status == PurchaseStatus.pending || status == PurchaseStatus.processing;

  /// Copy with new values.
  PurchaseReceipt copyWith({
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
    return PurchaseReceipt(
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

