/// File: lib/admin/features/wallets/bloc/wallet_detail_state.dart
/// Purpose: State definitions for wallet detail BLoC
/// Belongs To: admin/features/wallets
library;

import 'package:equatable/equatable.dart';

import '../models/wallet_model.dart';
import '../models/wallet_transaction_model.dart';

/// Lifecycle status for wallet detail.
enum WalletDetailStatus { initial, loading, loaded, processing, error }

/// State for [WalletDetailBloc].
class WalletDetailState extends Equatable {
  const WalletDetailState({
    this.status = WalletDetailStatus.initial,
    this.wallet,
    this.transactions = const [],
    this.transactionsTotal = 0,
    this.transactionsPage = 1,
    this.transactionsPerPage = 25,
    this.error,
    this.successMessage,
  });

  final WalletDetailStatus status;
  final WalletModel? wallet;
  final List<WalletTransactionModel> transactions;
  final int transactionsTotal;
  final int transactionsPage;
  final int transactionsPerPage;
  final String? error;
  final String? successMessage;

  bool get isLoading => status == WalletDetailStatus.loading;
  bool get isProcessing => status == WalletDetailStatus.processing;

  WalletDetailState copyWith({
    WalletDetailStatus? status,
    WalletModel? wallet,
    List<WalletTransactionModel>? transactions,
    int? transactionsTotal,
    int? transactionsPage,
    int? transactionsPerPage,
    String? error,
    String? successMessage,
  }) {
    return WalletDetailState(
      status: status ?? this.status,
      wallet: wallet ?? this.wallet,
      transactions: transactions ?? this.transactions,
      transactionsTotal: transactionsTotal ?? this.transactionsTotal,
      transactionsPage: transactionsPage ?? this.transactionsPage,
      transactionsPerPage: transactionsPerPage ?? this.transactionsPerPage,
      error: error,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    wallet,
    transactions,
    transactionsTotal,
    transactionsPage,
    transactionsPerPage,
    error,
    successMessage,
  ];
}
