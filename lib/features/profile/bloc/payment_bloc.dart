/// File: lib/features/profile/bloc/payment_bloc.dart
/// Purpose: Payment methods BLoC
/// Belongs To: profile feature
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/repositories.dart';
import 'payment_event.dart';
import 'payment_state.dart';

/// Payment BLoC for managing payment methods and wallet.
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc({required ProfileRepository repository})
      : _repository = repository,
        super(PaymentState.initial()) {
    on<LoadPaymentMethods>(_onLoadPaymentMethods);
    on<AddPaymentMethod>(_onAddPaymentMethod);
    on<SetDefaultPaymentMethod>(_onSetDefaultPaymentMethod);
    on<RemovePaymentMethod>(_onRemovePaymentMethod);
    on<LoadWallet>(_onLoadWallet);
    on<TopUpWallet>(_onTopUpWallet);
    on<LoadBillingHistory>(_onLoadBillingHistory);
    on<ClearPaymentError>(_onClearPaymentError);
  }

  final ProfileRepository _repository;

  Future<void> _onLoadPaymentMethods(
    LoadPaymentMethods event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final methods = await _repository.getPaymentMethods();
      emit(state.copyWith(
        isLoading: false,
        paymentMethods: methods,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onAddPaymentMethod(
    AddPaymentMethod event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(isAdding: true, error: null));
    try {
      final method = await _repository.addPaymentMethod(
        gatewayToken: event.gatewayToken,
        brand: event.brand,
        last4: event.last4,
        expMonth: event.expMonth,
        expYear: event.expYear,
      );
      final updatedMethods = [...state.paymentMethods, method];
      emit(state.copyWith(
        isAdding: false,
        paymentMethods: updatedMethods,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isAdding: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onSetDefaultPaymentMethod(
    SetDefaultPaymentMethod event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _repository.setDefaultPaymentMethod(event.id);
      final updatedMethods = state.paymentMethods.map((method) {
        return method.copyWith(isDefault: method.id == event.id);
      }).toList();
      emit(state.copyWith(
        isLoading: false,
        paymentMethods: updatedMethods,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onRemovePaymentMethod(
    RemovePaymentMethod event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _repository.removePaymentMethod(event.id);
      final updatedMethods = state.paymentMethods
          .where((method) => method.id != event.id)
          .toList();
      emit(state.copyWith(
        isLoading: false,
        paymentMethods: updatedMethods,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadWallet(
    LoadWallet event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(isLoadingWallet: true, error: null));
    try {
      final wallet = await _repository.getWallet();
      emit(state.copyWith(
        isLoadingWallet: false,
        wallet: wallet,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingWallet: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onTopUpWallet(
    TopUpWallet event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(isToppingUp: true, error: null));
    try {
      final transaction = await _repository.topUpWallet(
        amount: event.amount,
        paymentMethodId: event.paymentMethodId,
      );
      final updatedWallet = state.wallet?.copyWith(
        balance: (state.wallet?.balance ?? 0) + event.amount,
        transactions: [
          transaction,
          ...(state.wallet?.transactions ?? []),
        ],
      );
      emit(state.copyWith(
        isToppingUp: false,
        wallet: updatedWallet,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isToppingUp: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadBillingHistory(
    LoadBillingHistory event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(isLoadingBilling: true, error: null));
    try {
      final history = await _repository.getBillingHistory();
      emit(state.copyWith(
        isLoadingBilling: false,
        billingHistory: history,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingBilling: false,
        error: e.toString(),
      ));
    }
  }

  void _onClearPaymentError(
    ClearPaymentError event,
    Emitter<PaymentState> emit,
  ) {
    emit(state.copyWith(error: null));
  }
}

