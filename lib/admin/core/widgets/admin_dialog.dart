/// File: lib/admin/core/widgets/admin_dialog.dart
/// Purpose: Dialog and modal widgets for admin panel
/// Belongs To: admin/core/widgets
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../extensions/admin_context_ext.dart';
import 'admin_button.dart';

/// Admin dialog widget.
class AdminDialog extends StatelessWidget {
  const AdminDialog({
    required this.title,
    super.key,
    this.content,
    this.actions,
    this.icon,
    this.iconColor,
    this.width,
  });

  final String title;
  final Widget? content;
  final List<Widget>? actions;
  final IconData? icon;
  final Color? iconColor;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        width: width ?? 400.w,
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: (iconColor ?? colors.primary).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 28.r,
                  color: iconColor ?? colors.primary,
                ),
              ),
              SizedBox(height: 16.h),
            ],
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            if (content != null) ...[
              SizedBox(height: 12.h),
              content!,
            ],
            if (actions != null && actions!.isNotEmpty) ...[
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions!
                    .map((action) => Padding(
                          padding: EdgeInsets.only(left: 8.w),
                          child: action,
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Confirmation dialog helper.
Future<bool?> showAdminConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmText = 'Confirm',
  String cancelText = 'Cancel',
  bool isDanger = false,
  IconData? icon,
}) {
  final colors = context.adminColors;
  
  return showDialog<bool>(
    context: context,
    builder: (context) => AdminDialog(
      title: title,
      icon: icon ?? (isDanger ? Iconsax.warning_2 : Iconsax.info_circle),
      iconColor: isDanger ? colors.error : null,
      content: Text(
        message,
        style: TextStyle(
          fontSize: 14.sp,
          color: colors.textSecondary,
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        AdminButton(
          label: cancelText,
          variant: AdminButtonVariant.outlined,
          onPressed: () => Navigator.of(context).pop(false),
        ),
        AdminButton(
          label: confirmText,
          backgroundColor: isDanger ? colors.error : null,
          foregroundColor: isDanger ? colors.onError : null,
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );
}

/// Delete confirmation dialog.
Future<bool?> showAdminDeleteDialog(
  BuildContext context, {
  required String itemName,
}) {
  return showAdminConfirmDialog(
    context,
    title: 'Delete $itemName?',
    message: 'This action cannot be undone. Are you sure you want to delete this $itemName?',
    confirmText: 'Delete',
    isDanger: true,
    icon: Iconsax.trash,
  );
}

/// Admin modal/drawer.
class AdminModal extends StatelessWidget {
  const AdminModal({
    required this.title,
    required this.child,
    super.key,
    this.actions,
    this.width,
    this.showCloseButton = true,
  });

  final String title;
  final Widget child;
  final List<Widget>? actions;
  final double? width;
  final bool showCloseButton;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: colors.surface,
        elevation: 8,
        child: SizedBox(
          width: width ?? 400.w,
          height: double.infinity,
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: colors.divider),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    if (showCloseButton)
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close,
                          size: 20.r,
                          color: colors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.r),
                  child: child,
                ),
              ),

              // Actions
              if (actions != null && actions!.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: colors.divider),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: actions!
                        .map((action) => Padding(
                              padding: EdgeInsets.only(left: 8.w),
                              child: action,
                            ))
                        .toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show modal from right side.
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required Widget child,
    List<Widget>? actions,
    double? width,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black54,
      pageBuilder: (context, animation, secondaryAnimation) {
        return AdminModal(
          title: title,
          actions: actions,
          width: width,
          child: child,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }
}

