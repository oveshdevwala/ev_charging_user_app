/// File: lib/admin/features/offers/views/offers_list_page.dart
/// Purpose: Offers list screen with search, filters, pagination, and table
/// Belongs To: admin/features/offers
/// Route: AdminRoutes.offers
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/admin_strings.dart';
import '../../../core/widgets/widgets.dart';
import '../bloc/offer_detail_event.dart';
import '../bloc/offers_bloc.dart';
import '../bloc/offers_event.dart';
import '../bloc/offers_state.dart';
import '../offers_bindings.dart';
import '../repository/offers_local_mock.dart' as repo;
import 'offer_detail_page.dart';
import 'widgets/offer_actions_bar.dart';
import 'widgets/offer_filters.dart';
import 'widgets/offers_table.dart';

/// Entry widget wiring OffersBloc to the view.
class OffersListPage extends StatelessWidget {
  OffersListPage({super.key, OffersBindings? bindings})
    : _bindings = bindings ?? OffersBindings.instance;

  final OffersBindings _bindings;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _bindings.offersBloc()..add(const LoadOffers()),
      child: _OffersListBody(bindings: _bindings),
    );
  }
}

class _OffersListBody extends StatelessWidget {
  const _OffersListBody({required this.bindings});

  final OffersBindings bindings;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OffersBloc, OffersState>(
      listener: (context, state) {
        if (state.status == OffersStatus.error && state.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error ?? '')));
        }
        if (state.status == OffersStatus.actionSuccess &&
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
                  title: AdminStrings.offersTitle,
                  subtitle: AdminStrings.offersListTitle,
                  actions: [
                    AdminButton(
                      label: AdminStrings.actionCreate,
                      icon: Iconsax.add,
                      size: AdminButtonSize.small,
                      onPressed: () {
                        // TODO: Open create offer modal
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Create offer feature coming soon'),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 8.w),
                    AdminButton(
                      label: AdminStrings.offersRefresh,
                      icon: Iconsax.refresh,
                      size: AdminButtonSize.small,
                      onPressed: state.isLoading
                          ? null
                          : () => context.read<OffersBloc>().add(
                              const RefreshOffers(),
                            ),
                      isLoading: state.isLoading,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  height: 120.h,
                  child: OfferFilters(
                    status: state.filters?.status,
                    discountType: state.filters?.discountType,
                    searchQuery: state.searchQuery,
                    onSearchChanged: (query) {
                      context.read<OffersBloc>().add(SearchOffers(query));
                    },
                    onFilterChanged: (status, discountType, sortBy, order) {
                      context.read<OffersBloc>().add(
                        ApplyFilters(
                          repo.OfferFilters(
                            status: status,
                            discountType: discountType,
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
                      context.read<OffersBloc>().add(const ResetFilters());
                    },
                  ),
                ),
                SizedBox(height: 16.h),
                if (state.hasSelection)
                  OfferActionsBar(
                    selectedCount: state.selectedIds.length,
                    onBulkActivate: () {
                      context.read<OffersBloc>().add(
                        BulkAction(
                          action: BulkActionType.activate,
                          offerIds: state.selectedIds.toList(),
                        ),
                      );
                    },
                    onBulkDeactivate: () {
                      context.read<OffersBloc>().add(
                        BulkAction(
                          action: BulkActionType.deactivate,
                          offerIds: state.selectedIds.toList(),
                        ),
                      );
                    },
                    onBulkDelete: () {
                      context.read<OffersBloc>().add(
                        BulkAction(
                          action: BulkActionType.delete,
                          offerIds: state.selectedIds.toList(),
                        ),
                      );
                    },
                    onExport: () {
                      // TODO: Implement CSV export
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Export feature coming soon'),
                        ),
                      );
                    },
                    onClearSelection: () {
                      context.read<OffersBloc>().add(const ClearSelection());
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
                      : state.status == OffersStatus.error &&
                            state.items.isEmpty
                      ? AdminEmptyState(
                          title: AdminStrings.offersEmptyState,
                          message: state.error,
                          actionLabel: AdminStrings.actionRefresh,
                          onAction: () => context.read<OffersBloc>().add(
                            const LoadOffers(),
                          ),
                        )
                      : state.items.isEmpty
                      ? AdminEmptyState(
                          title: AdminStrings.offersEmptyState,
                          actionLabel: AdminStrings.actionRefresh,
                          onAction: () => context.read<OffersBloc>().add(
                            const RefreshOffers(),
                          ),
                        )
                      : OffersTable(
                          offers: state.items,
                          selectedIds: state.selectedIds,
                          onOfferTap: (offerId) =>
                              _openDetail(context, offerId),
                          onToggleSelect: (offerId) => context
                              .read<OffersBloc>()
                              .add(ToggleSelectOffer(offerId)),
                          onSelectAll: () => context.read<OffersBloc>().add(
                            const SelectAllOffers(),
                          ),
                          currentPage: state.page,
                          totalPages: state.totalPages,
                          perPage: state.perPage,
                          total: state.total,
                          onPageChanged: (page) =>
                              context.read<OffersBloc>().add(ChangePage(page)),
                          onPageSizeChanged: (perPage) => context
                              .read<OffersBloc>()
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

  Future<void> _openDetail(BuildContext context, String offerId) {
    return AdminModalSheet.show(
      context: context,
      maxWidth: 1200,
      child: BlocProvider(
        create: (_) =>
            bindings.offerDetailBloc()..add(LoadOfferDetail(offerId)),
        child: OfferDetailPage(offerId: offerId),
      ),
    );
  }
}
