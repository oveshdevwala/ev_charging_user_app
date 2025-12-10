/// File: lib/admin/features/wallets/bloc/wallets_event.dart
/// Purpose: Events for wallets list BLoC
/// Belongs To: admin/features/wallets
library;

import 'package:equatable/equatable.dart';

import '../repository/wallets_local_mock.dart';

/// Base class for wallets events.
abstract class WalletsEvent extends Equatable {
  const WalletsEvent();

  @override
  List<Object?> get props => [];
}

/// Load wallets with pagination and filters.
class LoadWallets extends WalletsEvent {
  const LoadWallets({
    this.page = 1,
    this.perPage = 25,
    this.filters,
    this.forceRefresh = false,
  });

  final int page;
  final int perPage;
  final WalletFilters? filters;
  final bool forceRefresh;

  @override
  List<Object?> get props => [page, perPage, filters, forceRefresh];
}

/// Search wallets by query.
class SearchWallets extends WalletsEvent {
  const SearchWallets(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Change current page.
class ChangePage extends WalletsEvent {
  const ChangePage(this.page);

  final int page;

  @override
  List<Object?> get props => [page];
}

/// Change page size.
class ChangePageSize extends WalletsEvent {
  const ChangePageSize(this.perPage);

  final int perPage;

  @override
  List<Object?> get props => [perPage];
}

/// Toggle wallet selection.
class ToggleSelectWallet extends WalletsEvent {
  const ToggleSelectWallet(this.walletId);

  final String walletId;

  @override
  List<Object?> get props => [walletId];
}

/// Select all wallets.
class SelectAllWallets extends WalletsEvent {
  const SelectAllWallets();
}

/// Clear wallet selection.
class ClearSelection extends WalletsEvent {
  const ClearSelection();
}

/// Apply filters.
class ApplyFilters extends WalletsEvent {
  const ApplyFilters(this.filters);

  final WalletFilters filters;

  @override
  List<Object?> get props => [filters];
}

/// Reset filters.
class ResetFilters extends WalletsEvent {
  const ResetFilters();
}

/// Bulk action on selected wallets.
class BulkAction extends WalletsEvent {
  const BulkAction({required this.action, required this.walletIds});

  final BulkActionType action;
  final List<String> walletIds;

  @override
  List<Object?> get props => [action, walletIds];
}

/// Bulk action types.
enum BulkActionType { freeze, unfreeze, export }

/// Refresh wallets list.
class RefreshWallets extends WalletsEvent {
  const RefreshWallets();
}
