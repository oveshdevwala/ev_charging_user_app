/// File: lib/admin/features/stations/view/stations_list_page.dart
/// Purpose: Stations list page for admin panel
/// Belongs To: admin/features/stations
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/core.dart';
import '../../../models/admin_station_model.dart';
import '../stations.dart';

/// Stations list page.
class StationsListPage extends StatelessWidget {
  const StationsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StationsBloc()..add(const StationsLoadRequested()),
      child: const _StationsListView(),
    );
  }
}

class _StationsListView extends StatelessWidget {
  const _StationsListView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StationsBloc, StationsState>(
      builder: (context, state) {
        return AdminPageContent(
          scrollable: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              AdminPageHeader(
                title: AdminStrings.stationsListTitle,
                subtitle: '${state.totalStations} stations total',
                actions: [
                  AdminButton(
                    label: AdminStrings.actionExport,
                    variant: AdminButtonVariant.outlined,
                    icon: Iconsax.document_download,
                    onPressed: () {
                      context.showSuccessSnackBar(
                        'Exporting stations to CSV...',
                      );
                    },
                  ),
                  AdminButton(
                    label: AdminStrings.actionCreate,
                    icon: Iconsax.add,
                    onPressed: () => context.showAdminModal(
                      title: AdminStrings.stationsAddTitle,
                      maxWidth: 1000,
                      child: const StationEditPage(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // Stats cards
              if (state.stats != null) ...[
                _StationStats(stats: state.stats!),
                SizedBox(height: 24.h),
              ],

              // Filters and search
              _StationsFilters(state: state),
              SizedBox(height: 16.h),

              // Table with constrained height
              Expanded(
                child: AdminCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      Expanded(child: _StationsTable(state: state)),
                      // Pagination
                      AdminTablePagination(
                        currentPage: state.currentPage,
                        totalPages: state.totalPages,
                        totalItems: state.totalStations,
                        pageSize: state.pageSize,
                        onPageChanged: (page) {
                          context.read<StationsBloc>().add(
                            StationsPageChanged(page),
                          );
                        },
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

class _StationStats extends StatelessWidget {
  const _StationStats({required this.stats});

  final StationStats stats;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Row(
      children: [
        Expanded(
          child: AdminMiniMetricCard(
            title: 'Active',
            value: '${stats.active}',
            icon: Iconsax.tick_circle,
            iconColor: colors.success,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: AdminMiniMetricCard(
            title: 'Inactive',
            value: '${stats.inactive}',
            icon: Iconsax.close_circle,
            iconColor: colors.textTertiary,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: AdminMiniMetricCard(
            title: 'Maintenance',
            value: '${stats.maintenance}',
            icon: Iconsax.setting_3,
            iconColor: colors.warning,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: AdminMiniMetricCard(
            title: 'Total Chargers',
            value: '${stats.totalChargers}',
            icon: Iconsax.flash_1,
            iconColor: colors.primary,
          ),
        ),
      ],
    );
  }
}

class _StationsFilters extends StatelessWidget {
  const _StationsFilters({required this.state});

  final StationsState state;

  @override
  Widget build(BuildContext context) {
    return AdminResponsiveFilterBar(
      searchHint: 'Search stations...',
      onSearchChanged: (query) {
        context.read<StationsBloc>().add(StationsSearchChanged(query));
      },
      filterCount: state.filterStatus != null ? 1 : 0,
      filterItems: [
        AdminFilterItem<AdminStationStatus?>(
          id: 'status',
          label: 'Status',
          value: state.filterStatus,
          width: 150.w,
          items: [
            const DropdownMenuItem<AdminStationStatus?>(child: Text('All')),
            ...AdminStationStatus.values.map(
              (status) => DropdownMenuItem<AdminStationStatus?>(
                value: status,
                child: Text(status.name.capitalize),
              ),
            ),
          ],
          onChanged: (status) {
            context.read<StationsBloc>().add(StationsFilterChanged(status));
          },
        ),
      ],
      onReset: () {
        context.read<StationsBloc>().add(const StationsFilterChanged(null));
      },
    );
  }
}

class _StationsTable extends StatelessWidget {
  const _StationsTable({required this.state});

  final StationsState state;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.stations.isEmpty) {
      return AdminEmptyState(
        icon: Iconsax.gas_station,
        title: AdminStrings.stationsEmptyState,
        message: 'No stations match your search criteria.',
        actionLabel: 'Add Station',
        onAction: () => context.showAdminModal(
          title: AdminStrings.stationsAddTitle,
          maxWidth: 1000,
          child: const StationEditPage(),
        ),
      );
    }

    return AdminDataTable<AdminStation>(
      columns: [
        AdminDataColumn(
          id: 'name',
          label: 'Station',
          sortable: true,
          flex: 2,
          cellBuilder: (station) => Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  station.imageUrl ?? AdminAssets.placeholderStation,
                  width: 40.r,
                  height: 40.r,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 40.r,
                    height: 40.r,
                    color: colors.surfaceVariant,
                    child: Icon(Iconsax.gas_station, size: 20.r),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      station.name,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      station.address,
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
          id: 'status',
          label: 'Status',
          width: 100.w,
          cellBuilder: (station) => AdminStatusBadge(
            label: station.status.name.capitalize,
            type: _getStatusType(station.status),
          ),
        ),
        AdminDataColumn(
          id: 'chargers',
          label: 'Chargers',
          width: 100.w,
          cellBuilder: (station) => Text(
            '${station.availableChargers}/${station.totalChargers}',
            style: TextStyle(fontSize: 13.sp, color: colors.textPrimary),
          ),
        ),
        AdminDataColumn(
          id: 'rating',
          label: 'Rating',
          sortable: true,
          width: 80.w,
          cellBuilder: (station) => Row(
            children: [
              Icon(Iconsax.star1, size: 14.r, color: colors.warning),
              SizedBox(width: 4.w),
              Text(
                station.rating?.toStringAsFixed(1) ?? '-',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        AdminDataColumn(
          id: 'manager',
          label: 'Manager',
          width: 120.w,
          cellBuilder: (station) => station.hasManager
              ? Text(
                  station.managerName ?? '',
                  style: TextStyle(fontSize: 13.sp, color: colors.textPrimary),
                  overflow: TextOverflow.ellipsis,
                )
              : Text(
                  'Unassigned',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: colors.textTertiary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
        ),
        AdminDataColumn(
          id: 'actions',
          label: '',
          width: 90.w,
          alignment: Alignment.centerRight,
          cellBuilder: (station) => FittedBox(
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
                  onPressed: () => context.showAdminModal(
                    title: AdminStrings.stationsDetailTitle,
                    maxWidth: 1200,
                    child: StationDetailPage(stationId: station.id),
                  ),
                ),
                SizedBox(width: 4.w),
                AdminIconButton(
                  icon: Iconsax.edit_2,
                  size: 32,
                  tooltip: 'Edit',
                  onPressed: () => context.showAdminModal(
                    title: AdminStrings.stationsEditTitle,
                    maxWidth: 1000,
                    child: StationEditPage(stationId: station.id),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      items: state.paginatedStations,
      onRowTap: (station) => context.showAdminModal(
        title: AdminStrings.stationsDetailTitle,
        maxWidth: 1200,
        child: StationDetailPage(stationId: station.id),
      ),
      isLoading: state.isLoading,
    );
  }

  AdminStatusType _getStatusType(AdminStationStatus status) {
    switch (status) {
      case AdminStationStatus.active:
        return AdminStatusType.active;
      case AdminStationStatus.inactive:
        return AdminStatusType.inactive;
      case AdminStationStatus.maintenance:
        return AdminStatusType.maintenance;
      case AdminStationStatus.pending:
        return AdminStatusType.pending;
    }
  }
}
