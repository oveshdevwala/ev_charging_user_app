/// File: lib/admin/core/widgets/admin_modal_sheet.dart
/// Purpose: Adaptive modal sheet widget for sub-screens (full-screen on mobile, centered modal on desktop)
/// Belongs To: admin/core/widgets
/// Customization Guide:
///    - Adjust breakpoints in AdminResponsive
///    - Customize modal width/height via parameters
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../extensions/admin_context_ext.dart';

/// Adaptive modal sheet that shows full-screen on mobile/tablet and centered modal on desktop.
class AdminModalSheet extends StatelessWidget {
  const AdminModalSheet({
    required this.child,
    super.key,
    this.title,
    this.showCloseButton = true,
    this.onClose,
    this.width,
    this.height,
    this.maxWidth = 800,
    this.maxHeight = 900,
    this.isDismissible = true,
    this.enableDrag = true,
  });

  final Widget child;
  final String? title;
  final bool showCloseButton;
  final VoidCallback? onClose;
  final double? width;
  final double? height;
  final double maxWidth;
  final double maxHeight;
  final bool isDismissible;
  final bool enableDrag;

  /// Show modal sheet with adaptive behavior.
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    bool showCloseButton = true,
    VoidCallback? onClose,
    double? width,
    double? height,
    double maxWidth = 800,
    double maxHeight = 900,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: isDismissible,
      builder: (context) => AdminModalSheet(
        title: title,
        showCloseButton: showCloseButton,
        onClose: onClose,
        width: width,
        height: height,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;
    final isMobile = context.isMobile;
    final isTablet = context.isTablet;

    // Full-screen on mobile/tablet, centered modal on desktop
    if (isMobile || isTablet) {
      return _FullScreenModal(
        title: title,
        showCloseButton: showCloseButton,
        onClose: onClose ?? () => context.pop(),
        child: child,
      );
    }

    // Centered modal on desktop
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(24.w),
      child: Material(
        type: MaterialType.card,
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          width: width ?? maxWidth.w,
          height: height ?? maxHeight.h,
          constraints: BoxConstraints(
            maxWidth: maxWidth.w,
            maxHeight: maxHeight.h,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withOpacity(0.1),
                blurRadius: 24.r,
                offset: Offset(0, 8.h),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              if (title != null || showCloseButton)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: colors.divider,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (title != null) ...[
                        Expanded(
                          child: Text(
                            title!,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                      if (showCloseButton)
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            size: 24.r,
                            color: colors.textSecondary,
                          ),
                          onPressed: onClose ?? () => context.pop(),
                        ),
                    ],
                  ),
                ),

              // Content with Material wrapper and padding
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: child,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Full-screen modal for mobile/tablet.
class _FullScreenModal extends StatelessWidget {
  const _FullScreenModal({
    required this.child,
    this.title,
    this.showCloseButton = true,
    this.onClose,
  });

  final Widget child;
  final String? title;
  final bool showCloseButton;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: showCloseButton
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: colors.textPrimary,
                ),
                onPressed: onClose ?? () => context.pop(),
              )
            : null,
        title: title != null
            ? Text(
                title!,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              )
            : null,
        centerTitle: false,
      ),
      body: Material(
        color: colors.surface,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: child,
        ),
      ),
    );
  }
}

