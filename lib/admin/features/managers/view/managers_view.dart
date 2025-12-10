/// File: lib/admin/features/managers/view/managers_view.dart
/// Purpose: Managers list page for admin panel
/// Belongs To: admin/features/managers
library;

import 'package:ev_charging_user_app/admin/features/managers/blocs/managers/managers_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/core.dart';
import '../../../core/utils/csv_exporter.dart';
import '../../../models/manager.dart';
import '../../../viewmodels/managers_view_model.dart';
import '../blocs/managers/managers_bloc.dart';
import '../blocs/managers/managers_event.dart';
import 'manager_assign_modal.dart';
import 'manager_detail_view.dart';
import 'manager_form_view.dart';

/// Managers list page.
class ManagersView extends StatelessWidget {
  const ManagersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManagersBloc()..add(const LoadManagers()),
      child: const _ManagersListView(),
    );
  }
}

class _ManagersListView extends StatelessWidget {
  const _ManagersListView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManagersBloc, ManagersState>(
      builder: (context, state) {
        final viewModel = ManagersViewModel(context.read<ManagersBloc>());

        return AdminPageContent(
          scrollable: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              AdminPageHeader(
                title: AdminStrings.managersListTitle,
                subtitle: '${state.totalManagers} managers total',
                actions: [
                  AdminButton(
                    label: AdminStrings.actionExport,
                    variant: AdminButtonVariant.outlined,
                    icon: Iconsax.document_download,
                    onPressed: () {
                      final allManagers = state.managers;
                      if (allManagers.isEmpty) {
                        context.showWarningSnackBar('No managers to export');
                        return;
                      }
                      try {
                        CsvExporter.exportManagersToCsv(allManagers);
                        context.showSuccessSnackBar(
                          AdminStrings.msgExportSuccess,
                        );
                      } catch (e) {
                        context.showErrorSnackBar('Export failed: $e');
                      }
                    },
                  ),
                  AdminButton(
                    label: AdminStrings.managersAddTitle,
                    icon: Iconsax.add,
                    onPressed: () => context.showAdminModal(
                      title: AdminStrings.managersAddTitle,
                      maxWidth: 600,
                      child: ManagerFormView(
                        onSaved: (manager) {
                          viewModel.create(manager);
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // Filters and search
              _ManagersFilters(state: state, viewModel: viewModel),
              SizedBox(height: 16.h),

              // Table
              Expanded(
                child: AdminCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      Expanded(
                        child: _ManagersTable(
                          state: state,
                          viewModel: viewModel,
                        ),
                      ),
                      // Pagination
                      AdminTablePagination(
                        currentPage: state.currentPage,
                        totalPages: state.totalPages,
                        totalItems: state.totalManagers,
                        pageSize: state.pageSize,
                        onPageChanged: viewModel.changePage,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ManagersFilters extends StatelessWidget {
  const _ManagersFilters({required this.state, required this.viewModel});

  final ManagersState state;
  final ManagersViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return AdminResponsiveFilterBar(
      searchHint: 'Search managers...',
      onSearchChanged: viewModel.search,
      filterCount: state.filters != null ? 1 : 0,
      filterItems: [
        AdminFilterItem<String?>(
          id: 'status',
          label: AdminStrings.labelStatus,
          value: state.filters?['status'] as String?,
          width: 150.w,
          items: const [
            DropdownMenuItem<String?>(child: Text('All')),
            DropdownMenuItem<String?>(value: 'active', child: Text('Active')),
            DropdownMenuItem<String?>(
              value: 'inactive',
              child: Text('Inactive'),
            ),
          ],
          onChanged: (status) {
            viewModel.filter(status != null ? {'status': status} : null);
          },
        ),
      ],
      onReset: () {
        viewModel.filter(null);
      },
    );
  }
}

class _ManagersTable extends StatelessWidget {
  const _ManagersTable({required this.state, required this.viewModel});

  final ManagersState state;
  final ManagersViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.managers.isEmpty) {
      return AdminEmptyState(
        icon: Iconsax.profile_2user,
        title: AdminStrings.managersEmptyState,
        message: 'No managers match your search criteria.',
        actionLabel: 'Add Manager',
        onAction: () => context.showAdminModal(
          title: AdminStrings.managersAddTitle,
          maxWidth: 600,
          child: ManagerFormView(
            onSaved: (manager) {
              viewModel.create(manager);
              Navigator.of(context).pop();
            },
          ),
        ),
      );
    }

    return AdminDataTable<Manager>(
      columns: [
        AdminDataColumn(
          id: 'name',
          label: AdminStrings.labelName,
          sortable: true,
          flex: 2,
          cellBuilder: (manager) => Row(
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.profile_2user,
                  size: 20.r,
                  color: colors.primary,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      manager.name,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      manager.email,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: colors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        AdminDataColumn(
          id: 'phone',
          label: AdminStrings.labelPhone,
          width: 140.w,
          cellBuilder: (manager) => Text(
            manager.phone ?? '-',
            style: TextStyle(fontSize: 13.sp, color: colors.textPrimary),
          ),
        ),
        AdminDataColumn(
          id: 'stations',
          label: 'Assigned Stations',
          width: 120.w,
          cellBuilder: (manager) => Text(
            '${manager.assignedStationIds.length}',
            style: TextStyle(fontSize: 13.sp, color: colors.textPrimary),
          ),
        ),
        AdminDataColumn(
          id: 'roles',
          label: 'Roles',
          width: 140.w,
          cellBuilder: (manager) => Wrap(
            spacing: 4.w,
            children: manager.roles.map((role) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  role,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: colors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        AdminDataColumn(
          id: 'status',
          label: AdminStrings.labelStatus,
          width: 100.w,
          cellBuilder: (manager) => AdminStatusBadge(
            label: manager.status,
            type: manager.status == 'active'
                ? AdminStatusType.active
                : AdminStatusType.inactive,
          ),
        ),
        AdminDataColumn(
          id: 'actions',
          label: '',
          width: 180.w,
          alignment: Alignment.centerRight,
          cellBuilder: (manager) => FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AdminIconButton(
                  icon: Iconsax.eye,
                  size: 28,
                  tooltip: 'View',
                  onPressed: () => context.showAdminModal(
                    title: AdminStrings.managersDetailTitle,
                    maxWidth: 1200,
                    child: ManagerDetailView(
                      manager: manager,
                      viewModel: viewModel,
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                AdminIconButton(
                  icon: Iconsax.edit_2,
                  size: 28,
                  tooltip: 'Edit',
                  onPressed: () => context.showAdminModal(
                    title: AdminStrings.managersEditTitle,
                    maxWidth: 600,
                    child: ManagerFormView(
                      manager: manager,
                      onSaved: (updated) {
                        viewModel.update(updated);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                AdminIconButton(
                  icon: Iconsax.location,
                  size: 28,
                  tooltip: 'Assign Stations',
                  onPressed: () => context.showAdminModal(
                    title: 'Assign Stations',
                    maxWidth: 600,
                    child: ManagerAssignModal(
                      managerId: manager.id,
                      currentStationIds: manager.assignedStationIds,
                      viewModel: viewModel,
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                AdminIconButton(
                  icon: manager.status == 'active'
                      ? Iconsax.close_circle
                      : Iconsax.tick_circle,
                  size: 28,
                  tooltip: manager.status == 'active'
                      ? 'Deactivate'
                      : 'Activate',
                  onPressed: () {
                    final newStatus = manager.status == 'active'
                        ? 'inactive'
                        : 'active';
                    viewModel.toggleStatus(manager.id, newStatus);
                  },
                ),
                SizedBox(width: 2.w),
                AdminIconButton(
                  icon: Iconsax.trash,
                  size: 28,
                  tooltip: 'Delete',
                  onPressed: () async {
                    final confirmed = await showAdminConfirmDialog(
                      context,
                      title: AdminStrings.actionDelete,
                      message: AdminStrings.msgConfirmDelete,
                      isDanger: true,
                    );
                    if (confirmed ?? false) {
                      viewModel.delete(manager.id);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
      items: state.managers,
      onRowTap: (manager) => context.showAdminModal(
        title: AdminStrings.managersDetailTitle,
        maxWidth: 900,
        child: ManagerDetailView(manager: manager, viewModel: viewModel),
      ),
      isLoading: state.isLoading,
    );
  }
}
