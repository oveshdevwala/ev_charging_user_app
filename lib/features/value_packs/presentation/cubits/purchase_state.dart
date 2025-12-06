/// File: lib/features/value_packs/presentation/cubits/purchase_state.dart
/// Purpose: State for purchase flow
/// Belongs To: value_packs feature
library;

import 'package:equatable/equatable.dart';

import '../../domain/entities/purchase_receipt.dart';

/// State for purchase flow.
class PurchaseState extends Equatable {
  const PurchaseState({
    this.status = PurchaseStatus.idle,
    this.receipt,
    this.error,
  });

  /// Initial state.
  factory PurchaseState.initial() => const PurchaseState();

  final PurchaseStatus status;
  final PurchaseReceipt? receipt;
  final String? error;

  /// Check if processing.
  bool get isProcessing => status == PurchaseStatus.processing;

  /// Check if successful.
  bool get isSuccess => status == PurchaseStatus.success;

  /// Check if failed.
  bool get isFailed => status == PurchaseStatus.failure;

  /// Copy with new values.
  PurchaseState copyWith({
    PurchaseStatus? status,
    PurchaseReceipt? receipt,
    String? error,
  }) {
    return PurchaseState(
      status: status ?? this.status,
      receipt: receipt ?? this.receipt,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, receipt, error];
}

/// Purchase status enum.
enum PurchaseStatus {
  idle,
  processing,
  success,
  failure,
}

