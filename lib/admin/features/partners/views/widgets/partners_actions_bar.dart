/// File: lib/admin/features/partners/views/widgets/partners_actions_bar.dart
/// Purpose: Bulk actions bar for selected partners
/// Belongs To: admin/features/partners
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/admin_strings.dart';
import '../../../../core/extensions/admin_context_ext.dart';
import '../../../../core/widgets/widgets.dart';

/// Partners bulk actions bar.
class PartnersActionsBar extends StatelessWidget {
  const PartnersActionsBar({
    required this.selectedCount,
    required this.onBulkApprove,
    required this.onBulkReject,
    required this.onExport,
    required this.onClearSelection,
    super.key,
  });

  final int selectedCount;
  final VoidCallback onBulkApprove;
  final VoidCallback onBulkReject;
  final VoidCallback onExport;
  final VoidCallback onClearSelection;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return AdminCard(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Text(
            '$selectedCount selected',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(width: 16.w),
          AdminButton(
            label: AdminStrings.partnersBulkApprove,
            icon: Iconsax.tick_circle,
            size: AdminButtonSize.small,
            onPressed: onBulkApprove,
          ),
          SizedBox(width: 8.w),
          AdminButton(
            label: AdminStrings.partnersBulkReject,
            icon: Iconsax.close_circle,
            size: AdminButtonSize.small,
            variant: AdminButtonVariant.outlined,
            onPressed: onBulkReject,
          ),
          SizedBox(width: 8.w),
          AdminButton(
            label: AdminStrings.partnersExportCsv,
            icon: Iconsax.export,
            size: AdminButtonSize.small,
            variant: AdminButtonVariant.outlined,
            onPressed: onExport,
          ),
          const Spacer(),
          AdminButton(
            label: AdminStrings.actionClose,
            icon: Iconsax.close_circle,
            size: AdminButtonSize.small,
            variant: AdminButtonVariant.text,
            onPressed: onClearSelection,
          ),
        ],
      ),
    );
  }
}
