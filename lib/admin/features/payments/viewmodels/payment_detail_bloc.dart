/// File: lib/admin/features/payments/viewmodels/payment_detail_bloc.dart
/// Purpose: Payment detail BLoC (ViewModel) with refund flow
/// Belongs To: admin/features/payments
/// Customization Guide:
/// - Connect to backend refund endpoint and add error mapping
library;

import 'package:bloc/bloc.dart';

import '../datasource/payments_local_datasource.dart';
import 'payment_detail_event.dart';
import 'payment_detail_state.dart';

/// Handles payment detail lifecycle and refund requests.
class PaymentDetailBloc extends Bloc<PaymentDetailEvent, PaymentDetailState> {
  PaymentDetailBloc({required this.dataSource})
    : super(const PaymentDetailState()) {
    on<PaymentDetailRequested>(_onRequested);
    on<PaymentRefundRequested>(_onRefundRequested);
  }

  final PaymentsLocalDataSource dataSource;

  Future<void> _onRequested(
    PaymentDetailRequested event,
    Emitter<PaymentDetailState> emit,
  ) async {
    emit(state.copyWith(status: PaymentDetailStatus.loading));
    try {
      final payment = await dataSource.fetchPaymentById(event.paymentId);
      emit(
        state.copyWith(status: PaymentDetailStatus.loaded, payment: payment),
      );
    } catch (e) {
      emit(
        state.copyWith(status: PaymentDetailStatus.error, error: e.toString()),
      );
    }
  }

  Future<void> _onRefundRequested(
    PaymentRefundRequested event,
    Emitter<PaymentDetailState> emit,
  ) async {
    emit(state.copyWith(status: PaymentDetailStatus.refundProcessing));

    try {
      await dataSource.requestRefund(event.paymentId);
      final refreshed = await dataSource.fetchPaymentById(event.paymentId);
      emit(
        state.copyWith(
          status: PaymentDetailStatus.refundSuccess,
          payment: refreshed,
        ),
      );
      emit(
        state.copyWith(status: PaymentDetailStatus.loaded, payment: refreshed),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PaymentDetailStatus.refundFailure,
          error: e.toString(),
        ),
      );
    }
  }
}
