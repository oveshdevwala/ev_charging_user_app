/// File: lib/admin/features/users/view/users_view.dart
/// Purpose: Users list page for admin panel with enhanced features
/// Belongs To: admin/features/users
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/core.dart';
import '../../../core/utils/csv_exporter.dart';
import '../../../models/admin_user.dart';
import '../../../viewmodels/users_view_model.dart';
import '../blocs/users/users_bloc.dart';
import '../blocs/users/users_event.dart';
import '../blocs/users/users_state.dart';
import 'user_detail_view.dart';
import 'user_edit_view.dart';

/// Users list page.
class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UsersBloc()..add(const LoadUsers()),
      child: const _UsersListView(),
    );
  }
}

class _UsersListView extends StatefulWidget {
  const _UsersListView();

  @override
  State<_UsersListView> createState() => _UsersListViewState();
}

class _UsersListViewState extends State<_UsersListView> {
  bool _showAdvancedFilters = false;
  DateTimeRange? _dateRange;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        final viewModel = UsersViewModel(context.read<UsersBloc>());

        return AdminPageContent(
          scrollable: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              AdminPageHeader(
                title: AdminStrings.usersListTitle,
                subtitle:
                    '${state.totalUsers} users total${state.selectedUserIds != null && state.selectedUserIds!.isNotEmpty ? ' • ${state.selectedUserIds!.length} selected' : ''}',
                actions: [
                  if (state.selectedUserIds != null &&
                      state.selectedUserIds!.isNotEmpty)
                    AdminButton(
                      label: 'Clear Selection',
                      variant: AdminButtonVariant.text,
                      icon: Iconsax.close_circle,
                      onPressed: () {
                        context.read<UsersBloc>().add(
                          const ClearSelectionEvent(),
                        );
                      },
                    ),
                  AdminButton(
                    label: AdminStrings.actionExport,
                    variant: AdminButtonVariant.outlined,
                    icon: Iconsax.document_download,
                    onPressed: () {
                      final allUsers = state.users;
                      if (allUsers.isEmpty) {
                        context.showWarningSnackBar('No users to export');
                        return;
                      }
                      try {
                        CsvExporter.exportUsersToCsv(allUsers);
                        context.showSuccessSnackBar(
                          AdminStrings.msgExportSuccess,
                        );
                      } catch (e) {
                        context.showErrorSnackBar('Export failed: $e');
                      }
                    },
                  ),
                  if (state.selectedUserIds != null &&
                      state.selectedUserIds!.isNotEmpty)
                    AdminButton(
                      label: 'Bulk Actions (${state.selectedUserIds!.length})',
                      icon: Iconsax.more,
                      onPressed: () =>
                          _showBulkActions(context, viewModel, state),
                    ),
                ],
              ),
              SizedBox(height: 24.h),

              // Filters and search
              _UsersFilters(
                state: state,
                viewModel: viewModel,
                showAdvancedFilters: _showAdvancedFilters,
                dateRange: _dateRange,
                onAdvancedFiltersToggle: () {
                  setState(() {
                    _showAdvancedFilters = !_showAdvancedFilters;
                  });
                },
                onDateRangeChanged: (range) {
                  setState(() {
                    _dateRange = range;
                  });
                  final filters = Map<String, dynamic>.from(
                    state.filters ?? {},
                  );
                  if (range != null) {
                    filters['dateFrom'] = range.start.toIso8601String();
                    filters['dateTo'] = range.end.toIso8601String();
                  } else {
                    filters.remove('dateFrom');
                    filters.remove('dateTo');
                  }
                  viewModel.applyFilters(filters.isEmpty ? null : filters);
                },
              ),
              SizedBox(height: 16.h),

              // Advanced Filters Panel
              if (_showAdvancedFilters)
                _AdvancedFiltersPanel(
                  state: state,
                  viewModel: viewModel,
                  onClose: () {
                    setState(() {
                      _showAdvancedFilters = false;
                    });
                  },
                ),
              if (_showAdvancedFilters) SizedBox(height: 16.h),

              // Sorting and View Options
              _SortingBar(state: state, viewModel: viewModel),
              SizedBox(height: 16.h),

              // Table
              Expanded(
                child: AdminCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      Expanded(
                        child: _UsersTable(state: state, viewModel: viewModel),
                      ),
                      // Pagination
                      AdminTablePagination(
                        currentPage: state.currentPage,
                        totalPages: state.totalPages,
                        totalItems: state.totalUsers,
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

  void _showBulkActions(
    BuildContext context,
    UsersViewModel viewModel,
    UsersState state,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Bulk Actions (${state.selectedUserIds?.length ?? 0} selected)',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 24.h),
            ListTile(
              leading: const Icon(Iconsax.tick_circle),
              title: const Text('Activate'),
              onTap: () {
                final ids = state.selectedUserIds?.toList() ?? [];
                if (ids.isNotEmpty) {
                  viewModel.bulkUpdateStatus(ids, 'active');
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.close_circle),
              title: const Text('Deactivate'),
              onTap: () {
                final ids = state.selectedUserIds?.toList() ?? [];
                if (ids.isNotEmpty) {
                  viewModel.bulkUpdateStatus(ids, 'inactive');
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.trash),
              title: const Text('Delete'),
              textColor: context.adminColors.error,
              onTap: () async {
                final ids = state.selectedUserIds?.toList() ?? [];
                if (ids.isEmpty) {
                  Navigator.pop(context);
                  return;
                }
                Navigator.pop(context);
                final confirmed = await showAdminConfirmDialog(
                  context,
                  title: AdminStrings.actionDelete,
                  message: 'Delete ${ids.length} users?',
                  isDanger: true,
                );
                if (confirmed ?? false) {
                  viewModel.bulkDelete(ids);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _UsersFilters extends StatelessWidget {
  const _UsersFilters({
    required this.state,
    required this.viewModel,
    required this.showAdvancedFilters,
    required this.dateRange,
    required this.onAdvancedFiltersToggle,
    required this.onDateRangeChanged,
  });

  final UsersState state;
  final UsersViewModel viewModel;
  final bool showAdvancedFilters;
  final DateTimeRange? dateRange;
  final VoidCallback onAdvancedFiltersToggle;
  final void Function(DateTimeRange?) onDateRangeChanged;

  @override
  Widget build(BuildContext context) {
    return AdminResponsiveFilterBar(
      searchHint: 'Search users by name, email, phone, or ID...',
      onSearchChanged: viewModel.search,
      filterCount: state.filters != null ? state.filters!.length : 0,
      showResetButton: false,
      filterItems: [
        AdminFilterItem<String?>(
          id: 'status',
          label: AdminStrings.filterStatus,
          value: state.filters?['status'] as String?,
          width: 150.w,
          items: const [
            DropdownMenuItem<String?>(child: Text('All Status')),
            DropdownMenuItem<String?>(value: 'active', child: Text('Active')),
            DropdownMenuItem<String?>(
              value: 'inactive',
              child: Text('Inactive'),
            ),
            DropdownMenuItem<String?>(
              value: 'suspended',
              child: Text('Suspended'),
            ),
            DropdownMenuItem<String?>(value: 'blocked', child: Text('Blocked')),
          ],
          onChanged: (value) {
            final filters = Map<String, dynamic>.from(state.filters ?? {});
            if (value == null) {
              filters.remove('status');
            } else {
              filters['status'] = value;
            }
            viewModel.applyFilters(filters.isEmpty ? null : filters);
          },
        ),
        AdminFilterItem<String?>(
          id: 'role',
          label: 'Role',
          value: state.filters?['role'] as String?,
          width: 140.w,
          items: const [
            DropdownMenuItem<String?>(child: Text('All Roles')),
            DropdownMenuItem<String?>(value: 'user', child: Text('User')),
            DropdownMenuItem<String?>(value: 'premium', child: Text('Premium')),
            DropdownMenuItem<String?>(value: 'vip', child: Text('VIP')),
          ],
          onChanged: (value) {
            final filters = Map<String, dynamic>.from(state.filters ?? {});
            if (value == null) {
              filters.remove('role');
            } else {
              filters['role'] = value;
            }
            viewModel.applyFilters(filters.isEmpty ? null : filters);
          },
        ),
      ],
      actions: [
        AdminButton(
          label: showAdvancedFilters ? 'Hide Filters' : 'More Filters',
          variant: AdminButtonVariant.outlined,
          icon: showAdvancedFilters ? Iconsax.arrow_up_2 : Iconsax.filter,
          onPressed: onAdvancedFiltersToggle,
        ),
      ],
    );
  }
}

class _AdvancedFiltersPanel extends StatelessWidget {
  const _AdvancedFiltersPanel({
    required this.state,
    required this.viewModel,
    required this.onClose,
  });

  final UsersState state;
  final UsersViewModel viewModel;
  final VoidCallback onClose;

  String _formatDateRange(DateTimeRange? range) {
    if (range == null) return 'Select date range';
    return '${range.start.day}/${range.start.month}/${range.start.year} - ${range.end.day}/${range.end.month}/${range.end.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;
    DateTimeRange? dateRange;
    if (state.filters?['dateFrom'] != null &&
        state.filters?['dateTo'] != null) {
      try {
        dateRange = DateTimeRange(
          start: DateTime.parse(state.filters!['dateFrom'] as String),
          end: DateTime.parse(state.filters!['dateTo'] as String),
        );
      } catch (e) {
        // Invalid date range
      }
    }

    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Advanced Filters',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              IconButton(
                icon: const Icon(Iconsax.close_circle),
                onPressed: onClose,
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              // Account Type
              Expanded(
                child: DropdownButtonFormField<String?>(
                  initialValue: state.filters?['accountType'] as String?,
                  decoration: InputDecoration(
                    labelText: 'Account Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(child: Text('All Types')),
                    DropdownMenuItem(
                      value: 'personal',
                      child: Text('Personal'),
                    ),
                    DropdownMenuItem(
                      value: 'business',
                      child: Text('Business'),
                    ),
                  ],
                  onChanged: (value) {
                    final filters = Map<String, dynamic>.from(
                      state.filters ?? {},
                    );
                    if (value == null) {
                      filters.remove('accountType');
                    } else {
                      filters['accountType'] = value;
                    }
                    viewModel.applyFilters(filters.isEmpty ? null : filters);
                  },
                ),
              ),
              SizedBox(width: 16.w),
              // Signup Source
              Expanded(
                child: DropdownButtonFormField<String?>(
                  initialValue: state.filters?['signupSource'] as String?,
                  decoration: InputDecoration(
                    labelText: 'Signup Source',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(child: Text('All Sources')),
                    DropdownMenuItem(value: 'email', child: Text('Email')),
                    DropdownMenuItem(value: 'google', child: Text('Google')),
                    DropdownMenuItem(value: 'apple', child: Text('Apple')),
                    DropdownMenuItem(
                      value: 'facebook',
                      child: Text('Facebook'),
                    ),
                  ],
                  onChanged: (value) {
                    final filters = Map<String, dynamic>.from(
                      state.filters ?? {},
                    );
                    if (value == null) {
                      filters.remove('signupSource');
                    } else {
                      filters['signupSource'] = value;
                    }
                    viewModel.applyFilters(filters.isEmpty ? null : filters);
                  },
                ),
              ),
              SizedBox(width: 16.w),
              // Date Range Picker
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final range = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      initialDateRange: dateRange,
                    );
                    if (range != null) {
                      final filters = Map<String, dynamic>.from(
                        state.filters ?? {},
                      );
                      filters['dateFrom'] = range.start.toIso8601String();
                      filters['dateTo'] = range.end.toIso8601String();
                      viewModel.applyFilters(filters);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: colors.outline),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.calendar_1,
                          size: 20.r,
                          color: colors.textSecondary,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            _formatDateRange(dateRange),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: dateRange != null
                                  ? colors.textPrimary
                                  : colors.textTertiary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              // Clear Filters
              AdminButton(
                label: 'Clear All',
                variant: AdminButtonVariant.outlined,
                icon: Iconsax.close_circle,
                onPressed: () {
                  viewModel.applyFilters(null);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SortingBar extends StatelessWidget {
  const _SortingBar({required this.state, required this.viewModel});

  final UsersState state;
  final UsersViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Row(
      children: [
        Text(
          'Sort by:',
          style: TextStyle(fontSize: 13.sp, color: colors.textSecondary),
        ),
        SizedBox(width: 12.w),
        DropdownButton<String>(
          value: state.sortBy ?? 'createdAt',
          underline: const SizedBox.shrink(),
          items: const [
            DropdownMenuItem(value: 'name', child: Text('Name')),
            DropdownMenuItem(value: 'email', child: Text('Email')),
            DropdownMenuItem(value: 'status', child: Text('Status')),
            DropdownMenuItem(value: 'createdAt', child: Text('Created Date')),
            DropdownMenuItem(value: 'lastLoginAt', child: Text('Last Login')),
            DropdownMenuItem(
              value: 'walletBalance',
              child: Text('Wallet Balance'),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              viewModel.sort(value, state.sortDesc);
            }
          },
        ),
        SizedBox(width: 12.w),
        IconButton(
          icon: Icon(
            state.sortDesc ? Iconsax.arrow_down_2 : Iconsax.arrow_up_2,
            size: 20.r,
          ),
          onPressed: () {
            viewModel.sort(state.sortBy ?? 'createdAt', !state.sortDesc);
          },
          tooltip: state.sortDesc ? 'Ascending' : 'Descending',
        ),
      ],
    );
  }
}

class _UsersTable extends StatelessWidget {
  const _UsersTable({required this.state, required this.viewModel});

  final UsersState state;
  final UsersViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;
    final selectedIds = state.selectedUserIds ?? {};

    // Responsive column visibility
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;
    final isMobile = context.isMobile;

    // Build columns list based on screen size
    final columns = <AdminDataColumn<AdminUser>>[
      // Name column - always visible
      AdminDataColumn(
        id: 'name',
        label: AdminStrings.labelName,
        sortable: true,
        flex: isDesktop ? 2 : (isTablet ? 3 : 4),
        cellBuilder: (user) => Row(
          children: [
            AdminAvatar(imageUrl: user.avatarUrl, name: user.name),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user.name,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!isMobile) // Hide email on mobile
                    Text(
                      user.email,
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
      // Phone - hide on mobile
      if (!isMobile)
        AdminDataColumn(
          id: 'phone',
          label: AdminStrings.labelPhone,
          width: 140.w,
          cellBuilder: (user) => Text(
            user.phone ?? '-',
            style: TextStyle(fontSize: 13.sp, color: colors.textPrimary),
          ),
        ),
      // Wallet Balance - hide on mobile/tablet
      if (isDesktop)
        AdminDataColumn(
          id: 'walletBalance',
          label: 'Wallet Balance',
          width: 120.w,
          sortable: true,
          cellBuilder: (user) => Text(
            '\$${user.walletBalance.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 13.sp,
              color: colors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      // Sessions - hide on mobile
      if (!isMobile)
        AdminDataColumn(
          id: 'totalSessions',
          label: 'Sessions',
          width: 100.w,
          cellBuilder: (user) => Text(
            '${user.totalSessions}',
            style: TextStyle(fontSize: 13.sp, color: colors.textPrimary),
          ),
        ),
      // Last Charge - hide on mobile/tablet
      if (isDesktop)
        AdminDataColumn(
          id: 'lastChargeSessionAt',
          label: 'Last Charge',
          width: 140.w,
          cellBuilder: (user) => Text(
            user.lastChargeSessionAt != null
                ? _formatDate(user.lastChargeSessionAt!)
                : 'Never',
            style: TextStyle(fontSize: 12.sp, color: colors.textSecondary),
          ),
        ),
      // Status - always visible
      AdminDataColumn(
        id: 'status',
        label: AdminStrings.labelStatus,
        width: 100.w,
        sortable: true,
        cellBuilder: (user) => AdminStatusBadge(
          label: user.status,
          type: _getStatusType(user.status),
        ),
      ),
      // Role - hide on mobile
      if (!isMobile)
        AdminDataColumn(
          id: 'role',
          label: 'Role',
          width: 100.w,
          cellBuilder: (user) => Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: _getRoleColor(user.role, colors).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              user.role.toUpperCase(),
              style: TextStyle(
                fontSize: 11.sp,
                color: _getRoleColor(user.role, colors),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      // Created At - hide on mobile/tablet
      if (isDesktop)
        AdminDataColumn(
          id: 'createdAt',
          label: AdminStrings.labelCreatedAt,
          width: 120.w,
          sortable: true,
          cellBuilder: (user) => Text(
            _formatDate(user.createdAt),
            style: TextStyle(fontSize: 12.sp, color: colors.textSecondary),
          ),
        ),
      // Actions - only View and Edit buttons
      AdminDataColumn(
        id: 'actions',
        label: '',
        width: 90.w,
        alignment: Alignment.centerRight,
        cellBuilder: (user) => FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AdminIconButton(
                icon: Iconsax.eye,
                size: 32,
                tooltip: 'View',
                onPressed: () => context.showAdminModal<void>(
                  title: AdminStrings.usersDetailTitle,
                  maxWidth: 1200,
                  child: UserDetailView(user: user, viewModel: viewModel),
                ),
              ),
              SizedBox(width: 4.w),
              AdminIconButton(
                icon: Iconsax.edit_2,
                size: 32,
                tooltip: 'Edit',
                onPressed: () => context.showAdminModal<void>(
                  title: AdminStrings.usersEditTitle,
                  child: UserEditView(
                    user: user,
                    onSaved: (updated) {
                      viewModel.update(updated);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ];

    return AdminDataTable<AdminUser>(
      columns: columns,
      items: state.users,
      onRowTap: (user) => context.showAdminModal<void>(
        title: AdminStrings.usersDetailTitle,
        maxWidth: 1200,
        child: UserDetailView(user: user, viewModel: viewModel),
      ),
      isLoading: state.isLoading,
      selectedItems: selectedIds
          .map((id) => state.users.firstWhere((u) => u.id == id))
          .toSet(),
      onSelectionChanged: (selected) {
        final selectedIds = selected.map((u) => u.id).toSet();
        context.read<UsersBloc>().add(
          selectedIds.length == state.users.length
              ? const SelectAllUsersEvent()
              : const ClearSelectionEvent(),
        );
        // Toggle individual selections
        for (final user in state.users) {
          final isSelected = selected.contains(user);
          final currentlySelected = selectedIds.contains(user.id);
          if (isSelected != currentlySelected) {
            context.read<UsersBloc>().add(ToggleUserSelectionEvent(user.id));
          }
        }
      },
    );
  }

  AdminStatusType _getStatusType(String status) {
    switch (status) {
      case 'active':
        return AdminStatusType.active;
      case 'inactive':
        return AdminStatusType.inactive;
      case 'suspended':
        return AdminStatusType.warning;
      case 'blocked':
        return AdminStatusType.error;
      default:
        return AdminStatusType.inactive;
    }
  }

  Color _getRoleColor(String role, AdminAppColors colors) {
    switch (role) {
      case 'vip':
        return colors.warning;
      case 'premium':
        return colors.primary;
      default:
        return colors.textSecondary;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else {
      return '${(difference.inDays / 365).floor()}y ago';
    }
  }
}
