/// File: lib/admin/features/offers/views/widgets/offer_actions_bar.dart
/// Purpose: Bulk actions bar for selected offers
/// Belongs To: admin/features/offers
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/admin_strings.dart';
import '../../../../core/extensions/admin_context_ext.dart';
import '../../../../core/widgets/widgets.dart';

/// Bulk actions bar widget.
class OfferActionsBar extends StatelessWidget {
  const OfferActionsBar({
    required this.selectedCount,
    required this.onBulkActivate,
    required this.onBulkDeactivate,
    required this.onBulkDelete,
    required this.onExport,
    required this.onClearSelection,
    super.key,
  });

  final int selectedCount;
  final VoidCallback onBulkActivate;
  final VoidCallback onBulkDeactivate;
  final VoidCallback onBulkDelete;
  final VoidCallback onExport;
  final VoidCallback onClearSelection;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return AdminCard(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              '$selectedCount ${AdminStrings.tableSelected.replaceAll('{count}', selectedCount.toString())}',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: colors.primary,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          AdminButton(
            size: AdminButtonSize.small,
            variant: AdminButtonVariant.outlined,
            icon: Iconsax.tick_circle,
            label: AdminStrings.actionActivate,
            onPressed: onBulkActivate,
          ),
          SizedBox(width: 8.w),
          AdminButton(
            size: AdminButtonSize.small,
            variant: AdminButtonVariant.outlined,
            icon: Iconsax.close_circle,
            label: AdminStrings.actionDeactivate,
            onPressed: onBulkDeactivate,
          ),
          SizedBox(width: 8.w),
          AdminButton(
            size: AdminButtonSize.small,
            variant: AdminButtonVariant.outlined,
            icon: Iconsax.trash,
            label: AdminStrings.actionDelete,
            onPressed: onBulkDelete,
          ),
          SizedBox(width: 8.w),
          AdminButton(
            size: AdminButtonSize.small,
            variant: AdminButtonVariant.outlined,
            icon: Iconsax.export,
            label: AdminStrings.actionExport,
            onPressed: onExport,
          ),
          const Spacer(),
          TextButton(
            onPressed: onClearSelection,
            child: Text('Clear', style: TextStyle(fontSize: 12.sp)),
          ),
        ],
      ),
    );
  }
}
