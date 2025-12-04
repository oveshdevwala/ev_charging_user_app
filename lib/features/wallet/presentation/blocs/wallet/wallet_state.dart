/// File: lib/features/wallet/presentation/blocs/wallet/wallet_state.dart
/// Purpose: Wallet BLoC state with single-state pattern
/// Belongs To: wallet feature
/// Customization Guide:
///    - Add new fields for additional wallet features
///    - All fields must be in copyWith and props
library;

import 'package:equatable/equatable.dart';

import '../../../data/models/models.dart';

/// Tab options for wallet screen
enum WalletTab {
  transactions,
  credits,
}

/// Filter options for transactions
enum TransactionFilter {
  all,
  credits,
  debits,
  cashback,
  recharge,
}

/// Wallet state containing all wallet-related data.
/// 
/// ## Fields:
/// - [isLoading]: Initial loading state
/// - [isRefreshing]: Pull-to-refresh state
/// - [balance]: Current wallet balance
/// - [transactions]: Transaction history
/// - [creditsSummary]: Credits summary
/// - [creditsHistory]: Credits ledger entries
/// - [cashbackHistory]: Cashback history
/// - [selectedTab]: Currently selected tab
/// - [transactionFilter]: Active transaction filter
/// - [error]: Error message if any
class WalletState extends Equatable {
  const WalletState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.balance,
    this.transactions = const [],
    this.creditsSummary,
    this.creditsHistory = const [],
    this.cashbackHistory = const [],
    this.selectedTab = WalletTab.transactions,
    this.transactionFilter = TransactionFilter.all,
    this.hasMoreTransactions = true,
    this.hasMoreCredits = true,
    this.currentTransactionPage = 1,
    this.currentCreditsPage = 1,
    this.error,
    this.successMessage,
  });

  /// Initial state factory
  factory WalletState.initial() => const WalletState(isLoading: true);

  /// Initial loading state
  final bool isLoading;

  /// Pull-to-refresh state
  final bool isRefreshing;

  /// Loading more items (pagination)
  final bool isLoadingMore;

  /// Current wallet balance
  final WalletBalanceModel? balance;

  /// Transaction history
  final List<WalletTransactionModel> transactions;

  /// Credits summary
  final CreditsSummaryModel? creditsSummary;

  /// Credits history
  final List<CreditEntryModel> creditsHistory;

  /// Cashback history
  final List<CashbackModel> cashbackHistory;

  /// Currently selected tab
  final WalletTab selectedTab;

  /// Active transaction filter
  final TransactionFilter transactionFilter;

  /// Has more transactions to load
  final bool hasMoreTransactions;

  /// Has more credits to load
  final bool hasMoreCredits;

  /// Current transaction page
  final int currentTransactionPage;

  /// Current credits page
  final int currentCreditsPage;

  /// Error message
  final String? error;

  /// Success message for snackbar
  final String? successMessage;

  /// Check if wallet data is loaded
  bool get hasData => balance != null;

  /// Check if there's an error
  bool get hasError => error != null && error!.isNotEmpty;

  /// Filtered transactions based on current filter
  List<WalletTransactionModel> get filteredTransactions {
    switch (transactionFilter) {
      case TransactionFilter.all:
        return transactions;
      case TransactionFilter.credits:
        return transactions.where((t) => t.isCredit).toList();
      case TransactionFilter.debits:
        return transactions.where((t) => !t.isCredit).toList();
      case TransactionFilter.cashback:
        return transactions
            .where((t) => t.type == WalletTransactionType.cashback)
            .toList();
      case TransactionFilter.recharge:
        return transactions
            .where((t) => t.type == WalletTransactionType.recharge)
            .toList();
    }
  }

  /// Copy with new values
  WalletState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    bool? isLoadingMore,
    WalletBalanceModel? balance,
    List<WalletTransactionModel>? transactions,
    CreditsSummaryModel? creditsSummary,
    List<CreditEntryModel>? creditsHistory,
    List<CashbackModel>? cashbackHistory,
    WalletTab? selectedTab,
    TransactionFilter? transactionFilter,
    bool? hasMoreTransactions,
    bool? hasMoreCredits,
    int? currentTransactionPage,
    int? currentCreditsPage,
    String? error,
    String? successMessage,
  }) {
    return WalletState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
      creditsSummary: creditsSummary ?? this.creditsSummary,
      creditsHistory: creditsHistory ?? this.creditsHistory,
      cashbackHistory: cashbackHistory ?? this.cashbackHistory,
      selectedTab: selectedTab ?? this.selectedTab,
      transactionFilter: transactionFilter ?? this.transactionFilter,
      hasMoreTransactions: hasMoreTransactions ?? this.hasMoreTransactions,
      hasMoreCredits: hasMoreCredits ?? this.hasMoreCredits,
      currentTransactionPage:
          currentTransactionPage ?? this.currentTransactionPage,
      currentCreditsPage: currentCreditsPage ?? this.currentCreditsPage,
      error: error,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isRefreshing,
        isLoadingMore,
        balance,
        transactions,
        creditsSummary,
        creditsHistory,
        cashbackHistory,
        selectedTab,
        transactionFilter,
        hasMoreTransactions,
        hasMoreCredits,
        currentTransactionPage,
        currentCreditsPage,
        error,
        successMessage,
      ];
}

