/// File: lib/features/wallet/presentation/blocs/wallet/wallet_bloc.dart
/// Purpose: Main Wallet BLoC for managing wallet state
/// Belongs To: wallet feature
/// Customization Guide:
///    - Add new event handlers for additional operations
///    - Inject additional repositories as needed
/// 
/// ## Flow Diagram:
/// ```
/// UI Event -> WalletBloc -> Repository -> Update State -> Rebuild UI
/// ```
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/wallet_repository.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

/// Wallet BLoC managing all wallet operations.
/// 
/// ## Responsibilities:
/// - Load wallet balance
/// - Fetch and paginate transactions
/// - Manage credits summary and history
/// - Handle tab switching and filtering
class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc({
    required WalletRepository walletRepository,
  })  : _walletRepository = walletRepository,
        super(WalletState.initial()) {
    on<LoadWalletData>(_onLoadWalletData);
    on<RefreshWalletData>(_onRefreshWalletData);
    on<LoadMoreTransactions>(_onLoadMoreTransactions);
    on<LoadMoreCredits>(_onLoadMoreCredits);
    on<ChangeWalletTab>(_onChangeTab);
    on<ChangeTransactionFilter>(_onChangeFilter);
    on<ClearWalletError>(_onClearError);
    on<ClearWalletSuccess>(_onClearSuccess);
    on<WalletBalanceUpdated>(_onBalanceUpdated);
  }

  final WalletRepository _walletRepository;

  /// Load initial wallet data
  Future<void> _onLoadWalletData(
    LoadWalletData event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      // Fetch all data in parallel
      final balanceFuture = _walletRepository.getWalletBalance();
      final transactionsFuture = _walletRepository.getTransactions(
        
      );
      final creditsSummaryFuture = _walletRepository.getCreditsSummary();
      final creditsHistoryFuture = _walletRepository.getCreditsHistory(
        
      );
      final cashbackFuture = _walletRepository.getCashbackHistory(
        limit: 10,
      );

      final balance = await balanceFuture;
      final transactions = await transactionsFuture;
      final creditsSummary = await creditsSummaryFuture;
      final creditsHistory = await creditsHistoryFuture;
      final cashback = await cashbackFuture;

      emit(state.copyWith(
        isLoading: false,
        balance: balance,
        transactions: transactions,
        creditsSummary: creditsSummary,
        creditsHistory: creditsHistory,
        cashbackHistory: cashback,
        hasMoreTransactions: transactions.length >= 20,
        hasMoreCredits: creditsHistory.length >= 20,
        currentTransactionPage: 1,
        currentCreditsPage: 1,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  /// Refresh wallet data via pull-to-refresh
  Future<void> _onRefreshWalletData(
    RefreshWalletData event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(isRefreshing: true));

    try {
      final balanceFuture = _walletRepository.getWalletBalance();
      final transactionsFuture = _walletRepository.getTransactions(
        
      );
      final creditsSummaryFuture = _walletRepository.getCreditsSummary();
      final creditsHistoryFuture = _walletRepository.getCreditsHistory(
        
      );

      final balance = await balanceFuture;
      final transactions = await transactionsFuture;
      final creditsSummary = await creditsSummaryFuture;
      final creditsHistory = await creditsHistoryFuture;

      emit(state.copyWith(
        isRefreshing: false,
        balance: balance,
        transactions: transactions,
        creditsSummary: creditsSummary,
        creditsHistory: creditsHistory,
        hasMoreTransactions: transactions.length >= 20,
        hasMoreCredits: creditsHistory.length >= 20,
        currentTransactionPage: 1,
        currentCreditsPage: 1,
      ));
    } catch (e) {
      emit(state.copyWith(
        isRefreshing: false,
        error: e.toString(),
      ));
    }
  }

  /// Load more transactions (pagination)
  Future<void> _onLoadMoreTransactions(
    LoadMoreTransactions event,
    Emitter<WalletState> emit,
  ) async {
    if (state.isLoadingMore || !state.hasMoreTransactions) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    try {
      final nextPage = state.currentTransactionPage + 1;
      final newTransactions = await _walletRepository.getTransactions(
        page: nextPage,
      );

      emit(state.copyWith(
        isLoadingMore: false,
        transactions: [...state.transactions, ...newTransactions],
        hasMoreTransactions: newTransactions.length >= 20,
        currentTransactionPage: nextPage,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        error: e.toString(),
      ));
    }
  }

  /// Load more credits (pagination)
  Future<void> _onLoadMoreCredits(
    LoadMoreCredits event,
    Emitter<WalletState> emit,
  ) async {
    if (state.isLoadingMore || !state.hasMoreCredits) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    try {
      final nextPage = state.currentCreditsPage + 1;
      final newCredits = await _walletRepository.getCreditsHistory(
        page: nextPage,
      );

      emit(state.copyWith(
        isLoadingMore: false,
        creditsHistory: [...state.creditsHistory, ...newCredits],
        hasMoreCredits: newCredits.length >= 20,
        currentCreditsPage: nextPage,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        error: e.toString(),
      ));
    }
  }

  /// Change selected tab
  void _onChangeTab(
    ChangeWalletTab event,
    Emitter<WalletState> emit,
  ) {
    emit(state.copyWith(selectedTab: event.tab));
  }

  /// Change transaction filter
  void _onChangeFilter(
    ChangeTransactionFilter event,
    Emitter<WalletState> emit,
  ) {
    emit(state.copyWith(transactionFilter: event.filter));
  }

  /// Clear error
  void _onClearError(
    ClearWalletError event,
    Emitter<WalletState> emit,
  ) {
    emit(state.copyWith());
  }

  /// Clear success message
  void _onClearSuccess(
    ClearWalletSuccess event,
    Emitter<WalletState> emit,
  ) {
    emit(state.copyWith());
  }

  /// Handle balance update after recharge
  void _onBalanceUpdated(
    WalletBalanceUpdated event,
    Emitter<WalletState> emit,
  ) {
    if (state.balance != null) {
      emit(state.copyWith(
        balance: state.balance!.copyWith(
          totalBalance: event.newBalance,
          availableBalance: event.newBalance,
          lastUpdated: DateTime.now(),
        ),
      ));
    }
  }
}

