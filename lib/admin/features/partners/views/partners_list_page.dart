/// File: lib/admin/features/partners/views/partners_list_page.dart
/// Purpose: Partners list screen with search, filters, pagination, and table
/// Belongs To: admin/features/partners
/// Route: AdminRoutes.partners
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/admin_strings.dart';
import '../../../core/extensions/admin_context_ext.dart';
import '../../../core/widgets/widgets.dart';
import '../bloc/bloc.dart';
import '../partners_bindings.dart';
import '../repository/partners_requests.dart' as repository;
import 'partner_detail_page.dart';
import 'widgets/partners_actions_bar.dart';
import 'widgets/partners_filters.dart';
import 'widgets/partners_table.dart';

/// Entry widget wiring PartnersBloc to the view.
class PartnersListPage extends StatelessWidget {
  PartnersListPage({super.key, PartnersBindings? bindings})
    : _bindings = bindings ?? PartnersBindings.instance;

  final PartnersBindings _bindings;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _bindings.partnersBloc()..add(const LoadPartners()),
      child: _PartnersListBody(bindings: _bindings),
    );
  }
}

class _PartnersListBody extends StatelessWidget {
  const _PartnersListBody({required this.bindings});

  final PartnersBindings bindings;

  void _openDetail(BuildContext context, String partnerId) {
    context.showAdminModal(
      title: AdminStrings.partnersDetailTitle,
      maxWidth: 1200,
      child: BlocProvider(
        create: (_) =>
            bindings.partnerDetailBloc()..add(LoadPartnerDetail(partnerId)),
        child: PartnerDetailPage(partnerId: partnerId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PartnersBloc, PartnersState>(
      listener: (context, state) {
        if (state.status == PartnersStatus.error && state.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error ?? '')));
        }
        if (state.status == PartnersStatus.actionSuccess &&
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
                  title: AdminStrings.partnersTitle,
                  subtitle: AdminStrings.partnersListTitle,
                  actions: [
                    AdminButton(
                      label: AdminStrings.actionCreate,
                      icon: Iconsax.add,
                      size: AdminButtonSize.small,
                      onPressed: () {
                        // TODO: Open create modal
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Create partner feature coming soon'),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 8.w),
                    AdminButton(
                      label: AdminStrings.partnersRefresh,
                      icon: Iconsax.refresh,
                      size: AdminButtonSize.small,
                      onPressed: state.isLoading
                          ? null
                          : () => context.read<PartnersBloc>().add(
                              const RefreshPartners(),
                            ),
                      isLoading: state.isLoading,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                PartnersFilters(
                  status: state.filters?.status,
                  type: state.filters?.type,
                  country: state.filters?.country,
                  searchQuery: state.searchQuery,
                  onSearchChanged: (query) {
                    context.read<PartnersBloc>().add(SearchPartners(query));
                  },
                  onFilterChanged: (status, type, country) {
                    context.read<PartnersBloc>().add(
                      FilterPartners(
                        repository.PartnersFilters(
                          status: status,
                          type: type,
                          country: country,
                          search: state.searchQuery.isNotEmpty
                              ? state.searchQuery
                              : null,
                        ),
                      ),
                    );
                  },
                  onReset: () {
                    context.read<PartnersBloc>().add(const LoadPartners());
                  },
                ),
                SizedBox(height: 16.h),
                if (state.hasSelection)
                  PartnersActionsBar(
                    selectedCount: state.selectedPartnerIds.length,
                    onBulkApprove: () {
                      // TODO: Show confirmation dialog
                      context.read<PartnersBloc>().add(
                        BulkApprovePartners(state.selectedPartnerIds.toList()),
                      );
                    },
                    onBulkReject: () {
                      // TODO: Show reason dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Bulk reject feature coming soon'),
                        ),
                      );
                    },
                    onExport: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Export feature coming soon'),
                        ),
                      );
                    },
                    onClearSelection: () {
                      context.read<PartnersBloc>().add(const ClearSelection());
                    },
                  ),
                SizedBox(height: 16.h),
                Expanded(
                  child: state.isLoading && state.partners.isEmpty
                      ? SizedBox(
                          height: 400.h,
                          child: const AdminListSkeleton(
                            itemCount: 8,
                            padding: EdgeInsets.zero,
                          ),
                        )
                      : state.status == PartnersStatus.error &&
                            state.partners.isEmpty
                      ? AdminEmptyState(
                          title: AdminStrings.partnersEmptyState,
                          message: state.error,
                          actionLabel: AdminStrings.actionRefresh,
                          onAction: () => context.read<PartnersBloc>().add(
                            const LoadPartners(),
                          ),
                        )
                      : state.partners.isEmpty
                      ? AdminEmptyState(
                          title: AdminStrings.partnersEmptyState,
                          actionLabel: AdminStrings.actionRefresh,
                          onAction: () => context.read<PartnersBloc>().add(
                            const RefreshPartners(),
                          ),
                        )
                      : PartnersTable(
                          partners: state.partners,
                          selectedIds: state.selectedPartnerIds,
                          sortState: state.sortState,
                          onPartnerTap: (partnerId) =>
                              _openDetail(context, partnerId),
                          onToggleSelect: (partnerId) => context
                              .read<PartnersBloc>()
                              .add(ToggleSelectPartner(partnerId)),
                          onSelectAll: () => context.read<PartnersBloc>().add(
                            const SelectAllPartners(),
                          ),
                          onSort: (columnId, ascending) =>
                              context.read<PartnersBloc>().add(
                                SortPartners(
                                  columnId: columnId,
                                  ascending: ascending,
                                ),
                              ),
                          currentPage: state.page,
                          totalPages: state.totalPages,
                          perPage: state.perPage,
                          total: state.total,
                          onPageChanged: (page) => context
                              .read<PartnersBloc>()
                              .add(ChangePage(page)),
                          onPageSizeChanged: (perPage) => context
                              .read<PartnersBloc>()
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
}
