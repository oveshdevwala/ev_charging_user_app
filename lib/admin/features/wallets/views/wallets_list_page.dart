/// File: lib/admin/features/wallets/views/wallets_list_page.dart
/// Purpose: Wallets list screen with search, filters, pagination, and table
/// Belongs To: admin/features/wallets
/// Route: AdminRoutes.wallets
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/admin_strings.dart';
import '../../../core/widgets/widgets.dart';
import '../bloc/wallet_detail_event.dart';
import '../bloc/wallets_bloc.dart';
import '../bloc/wallets_event.dart';
import '../bloc/wallets_state.dart';
import '../repository/wallets_local_mock.dart' as repo;
import '../wallets_bindings.dart';
import 'wallet_detail_page.dart';
import 'widgets/wallet_actions_bar.dart';
import 'widgets/wallet_filters.dart';
import 'widgets/wallets_table.dart';

/// Entry widget wiring WalletsBloc to the view.
class WalletsListPage extends StatelessWidget {
  WalletsListPage({super.key, WalletsBindings? bindings})
    : _bindings = bindings ?? WalletsBindings.instance;

  final WalletsBindings _bindings;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _bindings.walletsBloc()..add(const LoadWallets()),
      child: _WalletsListBody(bindings: _bindings),
    );
  }
}

class _WalletsListBody extends StatelessWidget {
  const _WalletsListBody({required this.bindings});

  final WalletsBindings bindings;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletsBloc, WalletsState>(
      listener: (context, state) {
        if (state.status == WalletsStatus.error && state.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error ?? '')));
        }
        if (state.status == WalletsStatus.actionSuccess &&
            state.successMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.successMessage ?? '')));
        }
      },
      builder: (context, state) {
        return AdminPageContent(
          scrollable: false,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AdminPageHeader(
                  title: AdminStrings.walletsTitle,
                  subtitle: AdminStrings.walletsListTitle,
                  actions: [
                    AdminButton(
                      label: AdminStrings.walletsRefresh,
                      icon: Iconsax.refresh,
                      size: AdminButtonSize.small,
                      onPressed: state.isLoading
                          ? null
                          : () => context.read<WalletsBloc>().add(
                              const RefreshWallets(),
                            ),
                      isLoading: state.isLoading,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                WalletFilters(
                  status: state.filters?.status,
                  currency: state.filters?.currency,
                  searchQuery: state.searchQuery,
                  onSearchChanged: (query) {
                    context.read<WalletsBloc>().add(SearchWallets(query));
                  },
                  onFilterChanged: (status, currency, sortBy, order) {
                    context.read<WalletsBloc>().add(
                      ApplyFilters(
                        repo.WalletFilters(
                          status: status,
                          currency: currency,
                          search: state.searchQuery.isNotEmpty
                              ? state.searchQuery
                              : null,
                          sortBy: sortBy,
                          order: order ?? 'asc',
                        ),
                      ),
                    );
                  },
                  onReset: () {
                    context.read<WalletsBloc>().add(const ResetFilters());
                  },
                ),
                SizedBox(height: 16.h),
                if (state.hasSelection)
                  WalletActionsBar(
                    selectedCount: state.selectedIds.length,
                    onBulkFreeze: () {
                      context.read<WalletsBloc>().add(
                        BulkAction(
                          action: BulkActionType.freeze,
                          walletIds: state.selectedIds.toList(),
                        ),
                      );
                    },
                    onBulkUnfreeze: () {
                      context.read<WalletsBloc>().add(
                        BulkAction(
                          action: BulkActionType.unfreeze,
                          walletIds: state.selectedIds.toList(),
                        ),
                      );
                    },
                    onExport: () {
                      // TODO(admin): Implement CSV export
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Export feature coming soon'),
                        ),
                      );
                    },
                    onClearSelection: () {
                      context.read<WalletsBloc>().add(const ClearSelection());
                    },
                  ),
                SizedBox(height: 16.h),
                Expanded(
                  child: state.isLoading && state.items.isEmpty
                      ? SizedBox(
                          height: 400.h,
                          child: const AdminListSkeleton(
                            itemCount: 8,
                            padding: EdgeInsets.zero,
                          ),
                        )
                      : state.status == WalletsStatus.error &&
                            state.items.isEmpty
                      ? AdminEmptyState(
                          title: AdminStrings.walletsEmptyState,
                          message: state.error,
                          actionLabel: AdminStrings.actionRefresh,
                          onAction: () => context.read<WalletsBloc>().add(
                            const LoadWallets(),
                          ),
                        )
                      : state.items.isEmpty
                      ? AdminEmptyState(
                          title: AdminStrings.walletsEmptyState,
                          actionLabel: AdminStrings.actionRefresh,
                          onAction: () => context.read<WalletsBloc>().add(
                            const RefreshWallets(),
                          ),
                        )
                      : WalletsTable(
                          wallets: state.items,
                          selectedIds: state.selectedIds,
                          onWalletTap: (walletId) =>
                              _openDetail(context, walletId),
                          onToggleSelect: (walletId) => context
                              .read<WalletsBloc>()
                              .add(ToggleSelectWallet(walletId)),
                          onSelectAll: () => context.read<WalletsBloc>().add(
                            const SelectAllWallets(),
                          ),
                          currentPage: state.page,
                          totalPages: state.totalPages,
                          perPage: state.perPage,
                          total: state.total,
                          onPageChanged: (page) =>
                              context.read<WalletsBloc>().add(ChangePage(page)),
                          onPageSizeChanged: (perPage) => context
                              .read<WalletsBloc>()
                              .add(ChangePageSize(perPage)),
                          isLoading: state.isLoading,
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openDetail(BuildContext context, String walletId) {
    return AdminModalSheet.show(
      context: context,
      maxWidth: 1200,
      child: BlocProvider(
        create: (_) =>
            bindings.walletDetailBloc()..add(LoadWalletDetail(walletId)),
        child: WalletDetailPage(walletId: walletId),
      ),
    );
  }
}
