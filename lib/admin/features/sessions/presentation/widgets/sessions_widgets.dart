/// File: lib/admin/features/sessions/presentation/widgets/sessions_widgets.dart
/// Purpose: Reusable widgets for sessions monitoring UI
/// Belongs To: admin/features/sessions
/// Customization Guide:
///    - Replace placeholders with production charts/maps
///    - Keep sizing responsive via ScreenUtil
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../admin.dart';
import '../../sessions.dart';

/// KPI row for sessions dashboard.
class SessionsKpiRow extends StatelessWidget {
  const SessionsKpiRow({
    required this.active,
    required this.completed,
    required this.energy,
    required this.revenue,
    required this.duration,
    required this.faults,
    super.key,
  });

  final int active;
  final int completed;
  final double energy;
  final double revenue;
  final double duration;
  final int faults;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AdminMiniMetricCard(
            title: AdminStrings.sessionsKpiActive,
            value: '$active',
            icon: Iconsax.flash_1,
            iconColor: context.adminColors.primary,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: AdminMiniMetricCard(
            title: AdminStrings.sessionsKpiCompleted,
            value: '$completed',
            icon: Iconsax.tick_circle,
            iconColor: context.adminColors.success,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: AdminMiniMetricCard(
            title: AdminStrings.sessionsKpiEnergy,
            value: energy.toStringAsFixed(1),
            icon: Iconsax.battery_3full,
            iconColor: context.adminColors.info,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: AdminMiniMetricCard(
            title: AdminStrings.sessionsKpiRevenue,
            value: revenue.toStringAsFixed(2),
            icon: Iconsax.wallet_3,
            iconColor: context.adminColors.primary,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: AdminMiniMetricCard(
            title: AdminStrings.sessionsKpiDuration,
            value: '${duration.toStringAsFixed(1)}m',
            icon: Iconsax.clock_1,
            iconColor: context.adminColors.textSecondary,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: AdminMiniMetricCard(
            title: AdminStrings.sessionsKpiFaults,
            value: '$faults',
            icon: Iconsax.warning_2,
            iconColor: context.adminColors.warning,
          ),
        ),
      ],
    );
  }
}

/// Data table for sessions list.
class SessionsTable extends StatelessWidget {
  const SessionsTable({
    required this.sessions,
    required this.onViewDetail,
    required this.onToggleSelect,
    required this.selectedIds,
    super.key,
  });

  final List<AdminSessionSummaryDto> sessions;
  final Set<String> selectedIds;
  final void Function(AdminSessionSummaryDto session) onViewDetail;
  final void Function(String id) onToggleSelect;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    if (sessions.isEmpty) {
      return const AdminEmptyState(
        icon: Iconsax.flash_1,
        title: AdminStrings.sessionsEmptyState,
        message: AdminStrings.msgNoData,
      );
    }

    return AdminDataTable<AdminSessionSummaryDto>(
      columns: [
        AdminDataColumn(
          id: 'id',
          label: AdminStrings.labelId,
          width: 130.w,
          cellBuilder: (session) => Row(
            children: [
              Checkbox(
                value: selectedIds.contains(session.id),
                onChanged: (_) => onToggleSelect(session.id),
              ),
              Expanded(
                child: Text(
                  session.id,
                  style: TextStyle(fontSize: 12.sp, color: colors.textPrimary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        AdminDataColumn(
          id: 'status',
          label: AdminStrings.labelStatus,
          width: 120.w,
          cellBuilder: (session) {
            AdminStatusType statusType;
            switch (session.status) {
              case AdminSessionStatusDto.active:
                statusType = AdminStatusType.active;
                break;
              case AdminSessionStatusDto.completed:
                statusType = AdminStatusType.completed;
                break;
              case AdminSessionStatusDto.interrupted:
                statusType = AdminStatusType.warning;
                break;
              case AdminSessionStatusDto.cancelled:
                statusType = AdminStatusType.cancelled;
                break;
              case AdminSessionStatusDto.failed:
                statusType = AdminStatusType.error;
                break;
            }
            return AdminStatusBadge(
              label: session.status.name,
              type: statusType,
            );
          },
        ),
        AdminDataColumn(
          id: 'station',
          label: AdminStrings.navStations,
          width: 160.w,
          cellBuilder: (session) => Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  SessionsPexelsHelper.stationThumb,
                  width: 32.r,
                  height: 32.r,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  session.stationName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        AdminDataColumn(
          id: 'user',
          label: AdminStrings.navUsers,
          width: 140.w,
          cellBuilder: (session) => Row(
            children: [
              AdminAvatar(
                imageUrl: session.userAvatar ?? SessionsPexelsHelper.userAvatar,
                size: 28,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  session.userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.sp),
                ),
              ),
            ],
          ),
        ),
        AdminDataColumn(
          id: 'energy',
          label: AdminStrings.sessionsEnergyDelivered,
          width: 120.w,
          cellBuilder: (session) =>
              Text('${session.energyKwh?.toStringAsFixed(1) ?? 0} kWh'),
        ),
        AdminDataColumn(
          id: 'cost',
          label: AdminStrings.sessionsCost,
          width: 120.w,
          cellBuilder: (session) => Text(
            '${session.currency ?? 'USD'} ${session.cost?.toStringAsFixed(2) ?? '0.00'}',
          ),
        ),
        AdminDataColumn(
          id: 'duration',
          label: AdminStrings.labelDuration,
          width: 120.w,
          cellBuilder: (session) => Text(
            session.durationSec != null
                ? '${(session.durationSec! / 60).toStringAsFixed(1)}m'
                : '--',
          ),
        ),
        AdminDataColumn(
          id: 'actions',
          label: AdminStrings.labelActions,
          width: 100.w,
          cellBuilder: (session) => FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AdminIconButton(
                  icon: Iconsax.eye,
                  size: 28,
                  tooltip: AdminStrings.actionViewDetails,
                  onPressed: () => onViewDetail(session),
                ),
                SizedBox(width: 4.w),
                AdminIconButton(
                  icon: Iconsax.flag,
                  size: 28,
                  tooltip: AdminStrings.sessionsFlag,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ],
      items: sessions,
    );
  }
}

/// Simple telemetry chart placeholder.
class SessionsTelemetryChart extends StatelessWidget {
  const SessionsTelemetryChart({required this.telemetry, super.key});

  final List<AdminTelemetryPointDto> telemetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;
    return AdminCardWithHeader(
      title: AdminStrings.sessionsTelemetry,
      child: SizedBox(
        height: 200.h,
        child: telemetry.isEmpty
            ? Center(
                child: Text(
                  AdminStrings.msgNoData,
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 13.sp,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: telemetry.length,
                itemBuilder: (context, index) {
                  final point = telemetry[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 80.w,
                          child: Text(
                            '${point.timestamp.hour}:${point.timestamp.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: colors.textSecondary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: (point.powerKw ?? 0) / 100,
                            color: colors.primary,
                            backgroundColor: colors.surfaceVariant,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '${point.powerKw?.toStringAsFixed(1) ?? '0'} kW',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}

/// Timeline widget.
class SessionsTimeline extends StatelessWidget {
  const SessionsTimeline({required this.events, super.key});

  final List<AdminSessionEventDto> events;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;
    return AdminCardWithHeader(
      title: AdminStrings.sessionsTimeline,
      child: Column(
        children: events
            .map(
              (event) => ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 4.h,
                ),
                leading: Icon(
                  Iconsax.tick_circle,
                  color: colors.primary,
                  size: 20.r,
                ),
                title: Text(event.message, style: TextStyle(fontSize: 13.sp)),
                subtitle: Text(
                  event.timestamp.toIso8601String(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: colors.textSecondary,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

/// Live event feed widget.
class SessionsLiveFeed extends StatelessWidget {
  const SessionsLiveFeed({
    required this.events,
    required this.onPin,
    required this.pinnedId,
    super.key,
  });

  final List<AdminLiveSessionEventDto> events;
  final String? pinnedId;
  final void Function(String id) onPin;

  @override
  Widget build(BuildContext context) {
    return AdminCardWithHeader(
      title: AdminStrings.sessionsLiveMonitor,
      child: events.isEmpty
          ? SizedBox(
              height: 200.h,
              child: Center(
                child: Text(
                  AdminStrings.msgNoData,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: context.adminColors.textSecondary,
                  ),
                ),
              ),
            )
          : ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 260.h),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  final isPinned = pinnedId == event.sessionId;
                  return ListTile(
                    dense: true,
                    leading: Icon(
                      Iconsax.flash_1,
                      color: isPinned
                          ? context.adminColors.primary
                          : context.adminColors.textSecondary,
                      size: 18.r,
                    ),
                    title: Text(
                      '${event.sessionId} • ${event.type}',
                      style: TextStyle(fontSize: 13.sp),
                    ),
                    subtitle: Text(
                      event.timestamp.toIso8601String(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: context.adminColors.textSecondary,
                      ),
                    ),
                    trailing: AdminIconButton(
                      icon: isPinned ? Iconsax.tick_circle : Iconsax.bookmark,
                      tooltip: AdminStrings.sessionsPinned,
                      onPressed: () => onPin(event.sessionId),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

/// Filter sheet placeholder.
class SessionsFilterSheet extends StatelessWidget {
  const SessionsFilterSheet({
    required this.onApply,
    required this.onClear,
    super.key,
  });

  final void Function(Map<String, dynamic> filters) onApply;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    const statusOptions = AdminSessionStatusDto.values;
    AdminSessionStatusDto? selected;

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AdminStrings.sessionsFilters,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 12.h),
          DropdownButtonFormField<AdminSessionStatusDto>(
            initialValue: selected,
            decoration: const InputDecoration(
              labelText: AdminStrings.labelStatus,
            ),
            items: statusOptions
                .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
                .toList(),
            onChanged: (value) => selected = value,
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AdminButton(
                label: AdminStrings.filterClear,
                variant: AdminButtonVariant.text,
                onPressed: onClear,
              ),
              SizedBox(width: 8.w),
              AdminButton(
                label: AdminStrings.filterApply,
                onPressed: () => onApply({'status': selected?.name}),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
