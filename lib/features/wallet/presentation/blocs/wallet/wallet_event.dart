/// File: lib/features/wallet/presentation/blocs/wallet/wallet_event.dart
/// Purpose: Wallet BLoC events
/// Belongs To: wallet feature
/// Customization Guide:
///    - Add new events for additional wallet operations
library;

import 'package:equatable/equatable.dart';

import 'wallet_state.dart';

/// Base wallet event class
abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

/// Load initial wallet data (balance + transactions + credits)
class LoadWalletData extends WalletEvent {
  const LoadWalletData();
}

/// Refresh wallet data via pull-to-refresh
class RefreshWalletData extends WalletEvent {
  const RefreshWalletData();
}

/// Load more transactions (pagination)
class LoadMoreTransactions extends WalletEvent {
  const LoadMoreTransactions();
}

/// Load more credits (pagination)
class LoadMoreCredits extends WalletEvent {
  const LoadMoreCredits();
}

/// Change selected tab
class ChangeWalletTab extends WalletEvent {
  const ChangeWalletTab(this.tab);

  final WalletTab tab;

  @override
  List<Object?> get props => [tab];
}

/// Change transaction filter
class ChangeTransactionFilter extends WalletEvent {
  const ChangeTransactionFilter(this.filter);

  final TransactionFilter filter;

  @override
  List<Object?> get props => [filter];
}

/// Clear error message
class ClearWalletError extends WalletEvent {
  const ClearWalletError();
}

/// Clear success message
class ClearWalletSuccess extends WalletEvent {
  const ClearWalletSuccess();
}

/// Update balance after recharge
class WalletBalanceUpdated extends WalletEvent {
  const WalletBalanceUpdated(this.newBalance);

  final double newBalance;

  @override
  List<Object?> get props => [newBalance];
}

