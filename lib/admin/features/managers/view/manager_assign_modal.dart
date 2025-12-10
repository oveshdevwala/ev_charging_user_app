/// File: lib/admin/features/managers/view/manager_assign_modal.dart
/// Purpose: Modal for assigning/unassigning stations to managers
/// Belongs To: admin/features/managers
/// Customization Guide:
///    - Modify station ID input method if station repository is available
///    - Add multi-select UI if station list is provided
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/core.dart';
import '../../../viewmodels/managers_view_model.dart';

/// Modal for assigning stations to a manager.
class ManagerAssignModal extends StatefulWidget {
  const ManagerAssignModal({
    required this.managerId,
    required this.currentStationIds,
    required this.viewModel,
    super.key,
  });

  final String managerId;
  final List<String> currentStationIds;
  final ManagersViewModel viewModel;

  @override
  State<ManagerAssignModal> createState() => _ManagerAssignModalState();
}

class _ManagerAssignModalState extends State<ManagerAssignModal> {
  final _stationIdsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _stationIdsController.text = widget.currentStationIds.join(', ');
  }

  @override
  void dispose() {
    _stationIdsController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final stationIds = _stationIdsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    widget.viewModel.assignStations(widget.managerId, stationIds);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;
    final currentCount = widget.currentStationIds.length;

    return AdminPageContent(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colors.primary.withValues(alpha: 0.1),
                  colors.primary.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Iconsax.gas_station,
                    size: 24.r,
                    color: colors.primary,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assign Stations',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        currentCount > 0
                            ? '$currentCount station${currentCount > 1 ? 's' : ''} currently assigned'
                            : 'No stations assigned yet',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (currentCount > 0)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      '$currentCount',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // Input Section
          AdminCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Iconsax.location,
                      size: 20.r,
                      color: colors.primary,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Station Assignment',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                const Divider(),
                SizedBox(height: 20.h),
                // Station IDs input
                AdminTextField(
                  controller: _stationIdsController,
                  label: 'Station IDs',
                  hint: 'e.g., st_1001, st_1002, st_1003',
                  prefixIcon: Iconsax.gas_station,
                  maxLines: 5,
                  helperText: 'Enter station IDs separated by commas',
                ),
                SizedBox(height: 20.h),
                // Example chips
                Text(
                  'Format Example:',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.textSecondary,
                  ),
                ),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: ['st_1001', 'st_1002', 'st_1003'].map((example) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surfaceVariant,
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: colors.outline.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        example,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'monospace',
                          color: colors.textSecondary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Info Banner
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: colors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: colors.info.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Iconsax.info_circle,
                  size: 20.r,
                  color: colors.info,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Tips',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.info,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '• Separate multiple station IDs with commas\n'
                        '• Changes will be saved immediately upon confirmation\n'
                        '• Leave empty to unassign all stations',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: colors.info,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: AdminButton(
                  label: AdminStrings.actionCancel,
                  variant: AdminButtonVariant.outlined,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                flex: 2,
                child: AdminButton(
                  label: AdminStrings.actionSave,
                  icon: Iconsax.tick_circle,
                  onPressed: _handleSave,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

