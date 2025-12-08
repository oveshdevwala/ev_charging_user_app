/// File: lib/admin/core/widgets/admin_empty_state.dart
/// Purpose: Empty state widget for admin panel
/// Belongs To: admin/core/widgets
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../extensions/admin_context_ext.dart';
import 'admin_button.dart';

/// Admin empty state widget.
class AdminEmptyState extends StatelessWidget {
  const AdminEmptyState({
    super.key,
    this.icon,
    this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.size = AdminEmptyStateSize.medium,
  });

  final IconData? icon;
  final String? title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final AdminEmptyStateSize size;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    final double iconSize;
    final double titleSize;
    final double messageSize;

    switch (size) {
      case AdminEmptyStateSize.small:
        iconSize = 40.r;
        titleSize = 14.sp;
        messageSize = 12.sp;
        break;
      case AdminEmptyStateSize.medium:
        iconSize = 56.r;
        titleSize = 16.sp;
        messageSize = 14.sp;
        break;
      case AdminEmptyStateSize.large:
        iconSize = 72.r;
        titleSize = 20.sp;
        messageSize = 15.sp;
        break;
    }

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: colors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Iconsax.document,
                size: iconSize,
                color: colors.textTertiary,
              ),
            ),
            if (title != null) ...[
              SizedBox(height: 16.h),
              Text(
                title!,
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (message != null) ...[
              SizedBox(height: 8.h),
              Text(
                message!,
                style: TextStyle(
                  fontSize: messageSize,
                  color: colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: 24.h),
              AdminButton(
                label: actionLabel!,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty state size.
enum AdminEmptyStateSize { small, medium, large }

