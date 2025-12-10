/// File: lib/admin/features/wallets/bloc/wallet_detail_event.dart
/// Purpose: Events for wallet detail BLoC
/// Belongs To: admin/features/wallets
library;

import 'package:equatable/equatable.dart';

/// Base class for wallet detail events.
abstract class WalletDetailEvent extends Equatable {
  const WalletDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Load wallet detail.
class LoadWalletDetail extends WalletDetailEvent {
  const LoadWalletDetail(this.walletId);

  final String walletId;

  @override
  List<Object?> get props => [walletId];
}

/// Adjust wallet balance.
class AdjustBalance extends WalletDetailEvent {
  const AdjustBalance({
    required this.walletId,
    required this.amount,
    required this.memo,
  });

  final String walletId;
  final double amount;
  final String memo;

  @override
  List<Object?> get props => [walletId, amount, memo];
}

/// Freeze wallet.
class FreezeWallet extends WalletDetailEvent {
  const FreezeWallet(this.walletId);

  final String walletId;

  @override
  List<Object?> get props => [walletId];
}

/// Unfreeze wallet.
class UnfreezeWallet extends WalletDetailEvent {
  const UnfreezeWallet(this.walletId);

  final String walletId;

  @override
  List<Object?> get props => [walletId];
}

/// Process refund.
class ProcessRefund extends WalletDetailEvent {
  const ProcessRefund({
    required this.walletId,
    required this.amount,
    required this.memo,
  });

  final String walletId;
  final double amount;
  final String memo;

  @override
  List<Object?> get props => [walletId, amount, memo];
}

/// Load transactions.
class LoadTransactions extends WalletDetailEvent {
  const LoadTransactions({required this.walletId, this.page = 1});

  final String walletId;
  final int page;

  @override
  List<Object?> get props => [walletId, page];
}
