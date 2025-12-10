/// File: lib/admin/features/wallets/views/widgets/wallet_actions_bar.dart
/// Purpose: Bulk actions bar for selected wallets
/// Belongs To: admin/features/wallets
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/admin_strings.dart';
import '../../../../core/extensions/admin_context_ext.dart';
import '../../../../core/widgets/widgets.dart';

/// Bulk actions bar widget.
class WalletActionsBar extends StatelessWidget {
  const WalletActionsBar({
    required this.selectedCount,
    required this.onBulkFreeze,
    required this.onBulkUnfreeze,
    required this.onExport,
    required this.onClearSelection,
    super.key,
  });

  final int selectedCount;
  final VoidCallback onBulkFreeze;
  final VoidCallback onBulkUnfreeze;
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
            icon: Iconsax.lock,
            label: AdminStrings.walletsFreeze,
            onPressed: onBulkFreeze,
          ),
          SizedBox(width: 8.w),
          AdminButton(
            size: AdminButtonSize.small,
            variant: AdminButtonVariant.outlined,
            icon: Iconsax.unlock,
            label: AdminStrings.walletsUnfreeze,
            onPressed: onBulkUnfreeze,
          ),
          SizedBox(width: 8.w),
          AdminButton(
            size: AdminButtonSize.small,
            variant: AdminButtonVariant.outlined,
            icon: Iconsax.export,
            label: AdminStrings.walletsExportCsv,
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
