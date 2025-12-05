/// File: lib/features/profile/bloc/payment_state.dart
/// Purpose: Payment BLoC state
/// Belongs To: profile feature
library;

import 'package:equatable/equatable.dart';

import '../models/models.dart';

/// Payment state.
class PaymentState extends Equatable {
  const PaymentState({
    this.isLoading = false,
    this.isAdding = false,
    this.isLoadingWallet = false,
    this.isToppingUp = false,
    this.isLoadingBilling = false,
    this.paymentMethods = const [],
    this.wallet,
    this.billingHistory = const [],
    this.error,
  });

  /// Initial state.
  factory PaymentState.initial() => const PaymentState();

  final bool isLoading;
  final bool isAdding;
  final bool isLoadingWallet;
  final bool isToppingUp;
  final bool isLoadingBilling;
  final List<PaymentMethodModel> paymentMethods;
  final WalletModel? wallet;
  final List<Map<String, dynamic>> billingHistory;
  final String? error;

  /// Copy with new values.
  PaymentState copyWith({
    bool? isLoading,
    bool? isAdding,
    bool? isLoadingWallet,
    bool? isToppingUp,
    bool? isLoadingBilling,
    List<PaymentMethodModel>? paymentMethods,
    WalletModel? wallet,
    List<Map<String, dynamic>>? billingHistory,
    String? error,
  }) {
    return PaymentState(
      isLoading: isLoading ?? this.isLoading,
      isAdding: isAdding ?? this.isAdding,
      isLoadingWallet: isLoadingWallet ?? this.isLoadingWallet,
      isToppingUp: isToppingUp ?? this.isToppingUp,
      isLoadingBilling: isLoadingBilling ?? this.isLoadingBilling,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      wallet: wallet ?? this.wallet,
      billingHistory: billingHistory ?? this.billingHistory,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isAdding,
        isLoadingWallet,
        isToppingUp,
        isLoadingBilling,
        paymentMethods,
        wallet,
        billingHistory,
        error,
      ];
}

