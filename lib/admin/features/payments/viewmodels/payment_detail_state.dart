/// File: lib/admin/features/payments/viewmodels/payment_detail_state.dart
/// Purpose: State definitions for payment detail BLoC
/// Belongs To: admin/features/payments
/// Customization Guide:
/// - Add additional flags when integrating backend workflows
library;

import 'package:equatable/equatable.dart';

import '../models/payment.dart';

/// Lifecycle status for payment detail view.
enum PaymentDetailStatus {
  initial,
  loading,
  loaded,
  error,
  refundProcessing,
  refundSuccess,
  refundFailure,
}

/// State for [PaymentDetailBloc].
class PaymentDetailState extends Equatable {
  const PaymentDetailState({
    this.status = PaymentDetailStatus.initial,
    this.payment,
    this.error,
  });

  final PaymentDetailStatus status;
  final AdminPayment? payment;
  final String? error;

  bool get isBusy =>
      status == PaymentDetailStatus.loading ||
      status == PaymentDetailStatus.refundProcessing;

  PaymentDetailState copyWith({
    PaymentDetailStatus? status,
    AdminPayment? payment,
    String? error,
  }) {
    return PaymentDetailState(
      status: status ?? this.status,
      payment: payment ?? this.payment,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, payment, error];
}
