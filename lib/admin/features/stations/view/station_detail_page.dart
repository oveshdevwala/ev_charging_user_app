/// File: lib/admin/features/stations/view/station_detail_page.dart
/// Purpose: Station detail page for admin panel
/// Belongs To: admin/features/stations
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/core.dart';
import '../../../models/admin_station_model.dart';
import '../bloc/stations_bloc.dart';
import '../bloc/stations_event.dart';
import '../bloc/stations_state.dart';
import 'station_edit_page.dart';

/// Station detail page.
class StationDetailPage extends StatelessWidget {
  const StationDetailPage({required this.stationId, super.key});

  final String stationId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          StationsBloc()..add(StationDetailLoadRequested(stationId)),
      child: _StationDetailView(stationId: stationId),
    );
  }
}

class _StationDetailView extends StatelessWidget {
  const _StationDetailView({required this.stationId});

  final String stationId;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return BlocBuilder<StationsBloc, StationsState>(
      builder: (context, state) {
        if (state.isLoadingDetail) {
          return const AdminLoadingPage(message: 'Loading station details...');
        }

        final station = state.selectedStation;
        if (station == null) {
          return AdminEmptyState(
            icon: Iconsax.gas_station,
            title: 'Station not found',
            message: 'The station you are looking for does not exist.',
            actionLabel: 'Go back',
            onAction: () => context.pop(),
          );
        }

        return AdminPageContent(
          scrollable: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with breadcrumbs
              AdminPageHeader(
                title: station.name,
                subtitle: station.address,
                breadcrumbs: [AdminStrings.navStations, station.name],
                actions: [
                  AdminButton(
                    label: AdminStrings.actionEdit,
                    variant: AdminButtonVariant.outlined,
                    icon: Iconsax.edit_2,
                    onPressed: () {
                      context.pop(); // Close detail modal first
                      context.showAdminModal(
                        title: AdminStrings.stationsEditTitle,
                        maxWidth: 1000,
                        child: StationEditPage(stationId: station.id),
                      );
                    },
                  ),
                  AdminButton(
                    label: AdminStrings.actionDelete,
                    variant: AdminButtonVariant.outlined,
                    icon: Iconsax.trash,
                    backgroundColor: colors.error,
                    foregroundColor: colors.error,
                    onPressed: () async {
                      final confirm = await showAdminDeleteDialog(
                        context,
                        itemName: 'station',
                      );
                      if ((confirm ?? false) && context.mounted) {
                        context.read<StationsBloc>().add(
                          StationDeleteRequested(station.id),
                        );
                        context.pop();
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // Content
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 900;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Main info
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _StationOverviewCard(station: station),
                              SizedBox(height: 16.h),
                              _StationChargersCard(station: station),
                              SizedBox(height: 16.h),
                              _StationAmenitiesCard(station: station),
                            ],
                          ),
                        ),
                        SizedBox(width: 24.w),
                        // Side info
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _StationStatsCard(station: station),
                              SizedBox(height: 16.h),
                              _StationManagerCard(station: station),
                              SizedBox(height: 16.h),
                              _StationContactCard(station: station),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _StationOverviewCard(station: station),
                        SizedBox(height: 16.h),
                        _StationStatsCard(station: station),
                        SizedBox(height: 16.h),
                        _StationChargersCard(station: station),
                        SizedBox(height: 16.h),
                        _StationManagerCard(station: station),
                        SizedBox(height: 16.h),
                        _StationAmenitiesCard(station: station),
                        SizedBox(height: 16.h),
                        _StationContactCard(station: station),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StationOverviewCard extends StatelessWidget {
  const _StationOverviewCard({required this.station});

  final AdminStation station;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              station.imageUrl ?? AdminAssets.placeholderStation,
              height: 200.h,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 200.h,
                color: colors.surfaceVariant,
                child: Center(
                  child: Icon(
                    Iconsax.gas_station,
                    size: 48.r,
                    color: colors.textTertiary,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Status
          Row(
            children: [
              AdminStatusBadge.fromType(
                station.status == AdminStationStatus.active
                    ? AdminStatusType.active
                    : station.status == AdminStationStatus.maintenance
                    ? AdminStatusType.maintenance
                    : AdminStatusType.inactive,
              ),
              const Spacer(),
              Text(
                'ID: ${station.id}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: colors.textTertiary,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Description
          if (station.description != null) ...[
            Text(
              'Description',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              station.description!,
              style: TextStyle(fontSize: 14.sp, color: colors.textPrimary),
            ),
            SizedBox(height: 16.h),
          ],

          // Operating hours
          Text(
            'Operating Hours',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            station.operatingHours ?? '24/7',
            style: TextStyle(fontSize: 14.sp, color: colors.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _StationChargersCard extends StatelessWidget {
  const _StationChargersCard({required this.station});

  final AdminStation station;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return AdminCardWithHeader(
      title: AdminStrings.stationsChargerTypes,
      subtitle: '${station.totalChargers} chargers total',
      child: Column(
        children: station.chargers.map((charger) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Iconsax.flash_1,
                    size: 18.r,
                    color: colors.primary,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        charger.type.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                      Text(
                        '${charger.powerKw} kW • \$${charger.pricePerKwh?.toStringAsFixed(2) ?? "0.00"}/kWh',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                AdminStatusBadge(
                  label: charger.status.capitalize,
                  type: charger.status == 'available'
                      ? AdminStatusType.active
                      : charger.status == 'occupied'
                      ? AdminStatusType.warning
                      : AdminStatusType.maintenance,
                  size: AdminBadgeSize.small,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _StationAmenitiesCard extends StatelessWidget {
  const _StationAmenitiesCard({required this.station});

  final AdminStation station;

  @override
  Widget build(BuildContext context) {
    return AdminCardWithHeader(
      title: AdminStrings.stationsAmenities,
      child: Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: station.amenities.map((amenity) {
          return Chip(
            label: Text(amenity),
            labelStyle: TextStyle(fontSize: 12.sp),
          );
        }).toList(),
      ),
    );
  }
}

class _StationStatsCard extends StatelessWidget {
  const _StationStatsCard({required this.station});

  final AdminStation station;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return AdminCard(
      child: Column(
        children: [
          _StatRow(
            icon: Iconsax.star1,
            iconColor: colors.warning,
            label: 'Rating',
            value:
                '${station.rating?.toStringAsFixed(1) ?? "-"} (${station.totalReviews ?? 0} reviews)',
          ),
          Divider(height: 24.h, color: colors.divider),
          _StatRow(
            icon: Iconsax.flash_1,
            iconColor: colors.primary,
            label: 'Total Sessions',
            value: '${station.totalSessions ?? 0}',
          ),
          Divider(height: 24.h, color: colors.divider),
          _StatRow(
            icon: Iconsax.dollar_circle,
            iconColor: colors.success,
            label: 'Total Revenue',
            value: '\$${station.totalRevenue?.toStringAsFixed(2) ?? "0.00"}',
          ),
          Divider(height: 24.h, color: colors.divider),
          _StatRow(
            icon: Iconsax.electricity,
            iconColor: colors.info,
            label: 'Total Power',
            value: '${station.totalPowerKw.toStringAsFixed(0)} kW',
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Row(
      children: [
        Icon(icon, size: 18.r, color: iconColor),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 13.sp, color: colors.textSecondary),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _StationManagerCard extends StatelessWidget {
  const _StationManagerCard({required this.station});

  final AdminStation station;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return AdminCardWithHeader(
      title: 'Station Manager',
      actions: [
        TextButton(
          onPressed: () {
            // Assign/change manager
          },
          child: Text(
            station.hasManager ? 'Change' : 'Assign',
            style: TextStyle(fontSize: 12.sp),
          ),
        ),
      ],
      child: station.hasManager
          ? Row(
              children: [
                AdminAvatar(name: station.managerName),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        station.managerName!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                      Text(
                        'Manager ID: ${station.managerId}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Text(
              'No manager assigned',
              style: TextStyle(
                fontSize: 13.sp,
                color: colors.textTertiary,
                fontStyle: FontStyle.italic,
              ),
            ),
    );
  }
}

class _StationContactCard extends StatelessWidget {
  const _StationContactCard({required this.station});

  final AdminStation station;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return AdminCardWithHeader(
      title: AdminStrings.stationsContactInfo,
      child: Column(
        children: [
          if (station.phone != null) ...[
            Row(
              children: [
                Icon(Iconsax.call, size: 18.r, color: colors.textSecondary),
                SizedBox(width: 12.w),
                Text(
                  station.phone!,
                  style: TextStyle(fontSize: 13.sp, color: colors.textPrimary),
                ),
              ],
            ),
            SizedBox(height: 12.h),
          ],
          if (station.email != null)
            Row(
              children: [
                Icon(Iconsax.sms, size: 18.r, color: colors.textSecondary),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    station.email!,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: colors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
