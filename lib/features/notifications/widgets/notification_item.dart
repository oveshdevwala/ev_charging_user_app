/// File: lib/features/notifications/widgets/notification_item.dart
/// Purpose: Notification item widget
/// Belongs To: notifications feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/extensions/date_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/notification_model.dart';

/// Notification item widget.
class NotificationItem extends StatelessWidget {
  const NotificationItem({
    required this.notification,
    required this.onTap,
    super.key,
  });

  final NotificationModel notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: notification.isRead
              ? context.appColors.surface
              : colors.primaryContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: colors.outline),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIcon(),
            SizedBox(width: 12.w),
            Expanded(child: _buildContent(context)),
            if (!notification.isRead) _buildUnreadIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    final color = _getNotificationColor(notification.type);
    return Container(
      width: 44.r,
      height: 44.r,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(
        _getNotificationIcon(notification.type),
        size: 22.r,
        color: color,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          notification.title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w600,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          notification.message,
          style: TextStyle(
            fontSize: 13.sp,
            color: colors.textSecondary,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 8.h),
        Text(
          notification.createdAt?.relative ?? '',
          style: TextStyle(fontSize: 11.sp, color: colors.textTertiary),
        ),
      ],
    );
  }

  Widget _buildUnreadIndicator() {
    return Container(
      width: 8.r,
      height: 8.r,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return AppColors.info;
      case NotificationType.payment:
        return AppColors.success;
      case NotificationType.promotion:
        return AppColors.warning;
      case NotificationType.system:
        return AppColors.textSecondaryLight;
      case NotificationType.reminder:
        return AppColors.tertiary;
      case NotificationType.alert:
        return AppColors.error;
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return Iconsax.calendar_tick;
      case NotificationType.payment:
        return Iconsax.wallet_check;
      case NotificationType.promotion:
        return Iconsax.discount_shape;
      case NotificationType.system:
        return Iconsax.setting_2;
      case NotificationType.reminder:
        return Iconsax.clock;
      case NotificationType.alert:
        return Iconsax.danger;
    }
  }
}
