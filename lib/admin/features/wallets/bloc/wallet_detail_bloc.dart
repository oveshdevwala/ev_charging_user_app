/// File: lib/admin/features/wallets/bloc/wallet_detail_bloc.dart
/// Purpose: Wallet detail BLoC for single wallet actions
/// Belongs To: admin/features/wallets
library;

import 'package:bloc/bloc.dart';

import '../repository/wallets_repository.dart';
import 'wallet_detail_event.dart';
import 'wallet_detail_state.dart';

/// Handles wallet detail state and actions.
class WalletDetailBloc extends Bloc<WalletDetailEvent, WalletDetailState> {
  WalletDetailBloc({required this.repository})
    : super(const WalletDetailState()) {
    on<LoadWalletDetail>(_onLoadWalletDetail);
    on<AdjustBalance>(_onAdjustBalance);
    on<FreezeWallet>(_onFreezeWallet);
    on<UnfreezeWallet>(_onUnfreezeWallet);
    on<ProcessRefund>(_onProcessRefund);
    on<LoadTransactions>(_onLoadTransactions);
  }

  final WalletsRepository repository;

  Future<void> _onLoadWalletDetail(
    LoadWalletDetail event,
    Emitter<WalletDetailState> emit,
  ) async {
    emit(state.copyWith(status: WalletDetailStatus.loading));

    try {
      final wallet = await repository.fetchWalletById(event.walletId);
      emit(state.copyWith(status: WalletDetailStatus.loaded, wallet: wallet));

      // Load initial transactions
      add(LoadTransactions(walletId: event.walletId));
    } catch (e) {
      emit(
        state.copyWith(status: WalletDetailStatus.error, error: e.toString()),
      );
    }
  }

  Future<void> _onAdjustBalance(
    AdjustBalance event,
    Emitter<WalletDetailState> emit,
  ) async {
    emit(state.copyWith(status: WalletDetailStatus.processing));

    try {
      final updated = await repository.adjustBalance(
        walletId: event.walletId,
        amount: event.amount,
        memo: event.memo,
      );

      emit(
        state.copyWith(
          status: WalletDetailStatus.loaded,
          wallet: updated,
          successMessage: 'Balance adjusted successfully',
        ),
      );

      // Reload transactions to show new audit entry
      add(LoadTransactions(walletId: event.walletId));
    } catch (e) {
      emit(
        state.copyWith(status: WalletDetailStatus.error, error: e.toString()),
      );
    }
  }

  Future<void> _onFreezeWallet(
    FreezeWallet event,
    Emitter<WalletDetailState> emit,
  ) async {
    emit(state.copyWith(status: WalletDetailStatus.processing));

    try {
      final updated = await repository.freezeWallet(event.walletId);

      emit(
        state.copyWith(
          status: WalletDetailStatus.loaded,
          wallet: updated,
          successMessage: 'Wallet frozen successfully',
        ),
      );

      // Reload transactions
      add(LoadTransactions(walletId: event.walletId));
    } catch (e) {
      emit(
        state.copyWith(status: WalletDetailStatus.error, error: e.toString()),
      );
    }
  }

  Future<void> _onUnfreezeWallet(
    UnfreezeWallet event,
    Emitter<WalletDetailState> emit,
  ) async {
    emit(state.copyWith(status: WalletDetailStatus.processing));

    try {
      final updated = await repository.unfreezeWallet(event.walletId);

      emit(
        state.copyWith(
          status: WalletDetailStatus.loaded,
          wallet: updated,
          successMessage: 'Wallet unfrozen successfully',
        ),
      );

      // Reload transactions
      add(LoadTransactions(walletId: event.walletId));
    } catch (e) {
      emit(
        state.copyWith(status: WalletDetailStatus.error, error: e.toString()),
      );
    }
  }

  Future<void> _onProcessRefund(
    ProcessRefund event,
    Emitter<WalletDetailState> emit,
  ) async {
    emit(state.copyWith(status: WalletDetailStatus.processing));

    try {
      final updated = await repository.processRefund(
        walletId: event.walletId,
        amount: event.amount,
        memo: event.memo,
      );

      emit(
        state.copyWith(
          status: WalletDetailStatus.loaded,
          wallet: updated,
          successMessage: 'Refund processed successfully',
        ),
      );

      // Reload transactions
      add(LoadTransactions(walletId: event.walletId));
    } catch (e) {
      emit(
        state.copyWith(status: WalletDetailStatus.error, error: e.toString()),
      );
    }
  }

  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<WalletDetailState> emit,
  ) async {
    try {
      final response = await repository.fetchTransactions(
        walletId: event.walletId,
        page: event.page,
      );

      emit(
        state.copyWith(
          transactions: response.items,
          transactionsTotal: response.total,
          transactionsPage: response.page,
          transactionsPerPage: response.perPage,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: 'Failed to load transactions: $e'));
    }
  }
}
