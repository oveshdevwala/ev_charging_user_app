/// File: lib/admin/features/payments/viewmodels/payment_detail_event.dart
/// Purpose: Event definitions for payment detail BLoC
/// Belongs To: admin/features/payments
/// Customization Guide:
/// - Add audit/log events when backend integration arrives
library;

import 'package:equatable/equatable.dart';

/// Base payment detail event.
abstract class PaymentDetailEvent extends Equatable {
  const PaymentDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Load payment detail by id.
class PaymentDetailRequested extends PaymentDetailEvent {
  const PaymentDetailRequested(this.paymentId);

  final String paymentId;

  @override
  List<Object?> get props => [paymentId];
}

/// Request a refund for the payment.
class PaymentRefundRequested extends PaymentDetailEvent {
  const PaymentRefundRequested(this.paymentId);

  final String paymentId;

  @override
  List<Object?> get props => [paymentId];
}
