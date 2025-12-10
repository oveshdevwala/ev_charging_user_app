/// File: lib/admin/features/managers/view/manager_detail_view.dart
/// Purpose: Manager detail page for admin panel
/// Belongs To: admin/features/managers
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/core.dart';
import '../../../models/manager.dart';
import '../../../viewmodels/managers_view_model.dart';
import '../../stations/view/station_detail_page.dart';
import 'manager_assign_modal.dart';
import 'manager_form_view.dart';

/// Manager detail view.
class ManagerDetailView extends StatelessWidget {
  const ManagerDetailView({
    required this.manager,
    required this.viewModel,
    super.key,
  });

  final Manager manager;
  final ManagersViewModel viewModel;

  String _formatDateForDisplay(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;
    final isActive = manager.status == 'active';

    return AdminPageContent(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Header Section
            AdminCard(
              padding: EdgeInsets.all(24.r),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Profile Avatar
                      Container(
                        width: 96.r,
                        height: 96.r,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colors.primary.withValues(alpha: 0.2),
                              colors.primary.withValues(alpha: 0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colors.primary.withValues(alpha: 0.3),
                            width: 3.r,
                          ),
                        ),
                        child: Icon(
                          Iconsax.profile_2user,
                          size: 48.r,
                          color: colors.primary,
                        ),
                      ),
                      SizedBox(width: 24.w),
                      // Name and Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              manager.name,
                              style: TextStyle(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w700,
                                color: colors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Icon(
                                  Iconsax.sms,
                                  size: 16.r,
                                  color: colors.textSecondary,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  manager.email,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            if (manager.phone != null) ...[
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.call,
                                    size: 16.r,
                                    color: colors.textSecondary,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    manager.phone!,
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Status Badge
                      AdminStatusBadge(
                        label: manager.status.toUpperCase(),
                        type: isActive
                            ? AdminStatusType.active
                            : AdminStatusType.inactive,
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: AdminButton(
                          label: AdminStrings.actionEdit,
                          variant: AdminButtonVariant.outlined,
                          icon: Iconsax.edit_2,
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
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: AdminButton(
                          label: isActive
                              ? AdminStrings.actionDeactivate
                              : AdminStrings.actionActivate,
                          variant: AdminButtonVariant.outlined,
                          icon: isActive
                              ? Iconsax.close_circle
                              : Iconsax.tick_circle,
                          backgroundColor: isActive
                              ? colors.error.withValues(alpha: 0.1)
                              : colors.success.withValues(alpha: 0.1),
                          foregroundColor: isActive
                              ? colors.error
                              : colors.success,
                          onPressed: () {
                            final newStatus = isActive ? 'inactive' : 'active';
                            viewModel.toggleStatus(manager.id, newStatus);
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Details Section - Two Column Layout
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column - Manager Details
                Expanded(
                  flex: 2,
                  child: AdminCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Iconsax.profile_circle,
                              size: 24.r,
                              color: colors.primary,
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              'Manager Information',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: colors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        const Divider(),
                        SizedBox(height: 24.h),
                        _DetailGrid(manager: manager),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                // Right Column - Roles Card
                Expanded(
                  child: AdminCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Iconsax.shield_tick,
                              size: 24.r,
                              color: colors.primary,
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              'Roles & Permissions',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: colors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        const Divider(),
                        SizedBox(height: 24.h),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: manager.roles.map((role) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: colors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: colors.primary.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Iconsax.shield_tick,
                                    size: 16.r,
                                    color: colors.primary,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    role.replaceAll('_', ' ').toTitleCase(),
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: colors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 24.h),
                        // Created At Info
                        Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            color: colors.surfaceVariant,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Iconsax.calendar,
                                size: 16.r,
                                color: colors.textSecondary,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Created',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: colors.textTertiary,
                                      ),
                                    ),
                                    Text(
                                      _formatDateForDisplay(manager.createdAt),
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                        color: colors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Assigned Stations Section
            AdminCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Iconsax.gas_station,
                            size: 24.r,
                            color: colors.primary,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            AdminStrings.managersAssignedStations,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              '${manager.assignedStationIds.length}',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: colors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      AdminButton(
                        label: AdminStrings.actionAssign,
                        variant: AdminButtonVariant.outlined,
                        icon: Iconsax.add,
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
                    ],
                  ),
                  SizedBox(height: 24.h),
                  const Divider(),
                  SizedBox(height: 24.h),
                  if (manager.assignedStationIds.isEmpty)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 48.h),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(24.r),
                              decoration: BoxDecoration(
                                color: colors.surfaceVariant,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Iconsax.location,
                                size: 48.r,
                                color: colors.textTertiary,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'No stations assigned',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: colors.textSecondary,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Assign stations to this manager',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: colors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 12.w,
                      runSpacing: 12.h,
                      children: manager.assignedStationIds.map((
                        String stationId,
                      ) {
                        return _StationCard(
                          stationId: stationId,
                          onTap: () {
                            context.showAdminModal(
                              title: AdminStrings.stationsDetailTitle,
                              maxWidth: 1200,
                              child: StationDetailPage(stationId: stationId),
                            );
                          },
                          onUnassign: () {
                            final updatedIds = List<String>.from(
                              manager.assignedStationIds,
                            )..remove(stationId);
                            viewModel.assignStations(manager.id, updatedIds);
                          },
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailGrid extends StatelessWidget {
  const _DetailGrid({required this.manager});

  final Manager manager;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _DetailRow(
          label: AdminStrings.labelId,
          value: manager.id,
          icon: Iconsax.tag,
        ),
        _DetailRow(
          label: AdminStrings.labelName,
          value: manager.name,
          icon: Iconsax.user,
        ),
        _DetailRow(
          label: AdminStrings.labelEmail,
          value: manager.email,
          icon: Iconsax.sms,
        ),
        if (manager.phone != null)
          _DetailRow(
            label: AdminStrings.labelPhone,
            value: manager.phone!,
            icon: Iconsax.call,
          ),
      ],
    );
  }

}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.icon,
  });

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 20.r,
              color: colors.textSecondary,
            ),
            SizedBox(width: 12.w),
          ],
          SizedBox(
            width: 140.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: colors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Station card widget for assigned stations list.
class _StationCard extends StatelessWidget {
  const _StationCard({
    required this.stationId,
    required this.onTap,
    required this.onUnassign,
  });

  final String stationId;
  final VoidCallback onTap;
  final VoidCallback onUnassign;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Container(
      width: 280.w,
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: colors.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Iconsax.gas_station,
                    size: 24.r,
                    color: colors.primary,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stationId,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Tap to view details',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Iconsax.more,
                    size: 20.r,
                    color: colors.textSecondary,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'view',
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.eye,
                            size: 18.r,
                            color: colors.textPrimary,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'View Details',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'unassign',
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.trash,
                            size: 18.r,
                            color: colors.error,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Unassign',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: colors.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'view') {
                      onTap();
                    } else if (value == 'unassign') {
                      onUnassign();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Extension to convert string to title case.
extension StringExtension on String {
  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}
