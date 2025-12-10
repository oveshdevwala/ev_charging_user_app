/// File: lib/admin/features/wallets/bloc/wallets_bloc.dart
/// Purpose: Wallets list BLoC handling load/search/pagination/filter/bulk actions
/// Belongs To: admin/features/wallets
library;

import 'package:bloc/bloc.dart';
import 'package:ev_charging_user_app/admin/features/wallets/repository/wallets_local_mock.dart';

import '../repository/wallets_repository.dart';
import 'wallets_event.dart';
import 'wallets_state.dart';

/// Handles wallets list state with pagination, search, filters, and bulk actions.
class WalletsBloc extends Bloc<WalletsEvent, WalletsState> {
  WalletsBloc({required this.repository}) : super(const WalletsState()) {
    on<LoadWallets>(_onLoadWallets);
    on<SearchWallets>(_onSearchWallets);
    on<ChangePage>(_onChangePage);
    on<ChangePageSize>(_onChangePageSize);
    on<ToggleSelectWallet>(_onToggleSelectWallet);
    on<SelectAllWallets>(_onSelectAllWallets);
    on<ClearSelection>(_onClearSelection);
    on<ApplyFilters>(_onApplyFilters);
    on<ResetFilters>(_onResetFilters);
    on<BulkAction>(_onBulkAction);
    on<RefreshWallets>(_onRefreshWallets);
  }

  final WalletsRepository repository;

  Future<void> _onLoadWallets(
    LoadWallets event,
    Emitter<WalletsState> emit,
  ) async {
    emit(state.copyWith(status: WalletsStatus.loading));

    try {
      // Build filters from state and event
      final filters =
          event.filters ??
          WalletFilters(
            status: state.filters?.status,
            currency: state.filters?.currency,
            search: state.searchQuery.isNotEmpty ? state.searchQuery : null,
            sortBy: state.filters?.sortBy,
            order: state.filters?.order ?? 'asc',
          );

      final response = await repository.fetchWallets(
        page: event.page,
        perPage: event.perPage,
        filters: filters,
        forceRefresh: event.forceRefresh,
      );

      emit(
        state.copyWith(
          status: WalletsStatus.loaded,
          items: response.items,
          total: response.total,
          page: response.page,
          perPage: response.perPage,
          filters: filters,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: WalletsStatus.error, error: e.toString()));
    }
  }

  void _onSearchWallets(SearchWallets event, Emitter<WalletsState> emit) {
    final filters = WalletFilters(
      status: state.filters?.status,
      currency: state.filters?.currency,
      search: event.query.isNotEmpty ? event.query : null,
      sortBy: state.filters?.sortBy,
      order: state.filters?.order ?? 'asc',
    );

    add(LoadWallets(perPage: state.perPage, filters: filters));
  }

  void _onChangePage(ChangePage event, Emitter<WalletsState> emit) {
    add(
      LoadWallets(
        page: event.page,
        perPage: state.perPage,
        filters: state.filters,
      ),
    );
  }

  void _onChangePageSize(ChangePageSize event, Emitter<WalletsState> emit) {
    add(LoadWallets(perPage: event.perPage, filters: state.filters));
  }

  void _onToggleSelectWallet(
    ToggleSelectWallet event,
    Emitter<WalletsState> emit,
  ) {
    final newSelection = Set<String>.from(state.selectedIds);
    if (newSelection.contains(event.walletId)) {
      newSelection.remove(event.walletId);
    } else {
      newSelection.add(event.walletId);
    }

    emit(state.copyWith(selectedIds: newSelection));
  }

  void _onSelectAllWallets(SelectAllWallets event, Emitter<WalletsState> emit) {
    final allIds = state.items.map((w) => w.id).toSet();
    emit(state.copyWith(selectedIds: allIds));
  }

  void _onClearSelection(ClearSelection event, Emitter<WalletsState> emit) {
    emit(state.copyWith(selectedIds: {}));
  }

  void _onApplyFilters(ApplyFilters event, Emitter<WalletsState> emit) {
    add(LoadWallets(perPage: state.perPage, filters: event.filters));
  }

  void _onResetFilters(ResetFilters event, Emitter<WalletsState> emit) {
    add(LoadWallets(perPage: state.perPage));
  }

  Future<void> _onBulkAction(
    BulkAction event,
    Emitter<WalletsState> emit,
  ) async {
    emit(state.copyWith(status: WalletsStatus.loading));

    try {
      for (final walletId in event.walletIds) {
        switch (event.action) {
          case BulkActionType.freeze:
            await repository.freezeWallet(walletId);
            break;
          case BulkActionType.unfreeze:
            await repository.unfreezeWallet(walletId);
            break;
          case BulkActionType.export:
            // Export handled separately
            break;
        }
      }

      emit(
        state.copyWith(
          status: WalletsStatus.actionSuccess,
          successMessage: 'Bulk action completed',
          selectedIds: {},
        ),
      );

      // Reload wallets
      add(
        LoadWallets(
          page: state.page,
          perPage: state.perPage,
          filters: state.filters,
          forceRefresh: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: WalletsStatus.error, error: e.toString()));
    }
  }

  Future<void> _onRefreshWallets(
    RefreshWallets event,
    Emitter<WalletsState> emit,
  ) async {
    add(
      LoadWallets(
        page: state.page,
        perPage: state.perPage,
        filters: state.filters,
        forceRefresh: true,
      ),
    );
  }
}
