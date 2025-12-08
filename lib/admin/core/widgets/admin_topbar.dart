/// File: lib/admin/core/widgets/admin_topbar.dart
/// Purpose: Admin panel top navigation bar
/// Belongs To: admin/core/widgets
/// Customization Guide:
///    - Add actions via actions parameter
///    - Modify notification/profile dropdowns
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../config/admin_config.dart';
import '../extensions/admin_context_ext.dart';

/// Admin topbar widget.
class AdminTopbar extends StatelessWidget {
  const AdminTopbar({super.key, this.title, this.onMenuPressed, this.actions});

  final String? title;
  final VoidCallback? onMenuPressed;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Container(
      height: AdminConfig.topbarHeight,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.divider)),
      ),
      child: Row(
        children: [
          // Menu toggle button
          IconButton(
            onPressed: onMenuPressed,
            icon: Icon(Iconsax.menu_1, size: 20.r, color: colors.textSecondary),
          ),

          // Title
          if (title != null) ...[
            SizedBox(width: 8.w),
            Text(
              title!,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ],

          const Spacer(),

          // Custom actions
          if (actions != null) ...[...actions!, SizedBox(width: 8.w)],

          // Search button
          _TopbarIconButton(
            icon: Iconsax.search_normal_1,
            onPressed: () {
              // Open global search
            },
            tooltip: 'Search',
          ),

          SizedBox(width: 4.w),

          // Theme toggle
          _ThemeToggleButton(),

          SizedBox(width: 4.w),

          // Notifications
          _NotificationButton(),

          SizedBox(width: 8.w),

          // Profile dropdown
          _ProfileDropdown(),
        ],
      ),
    );
  }
}

class _TopbarIconButton extends StatelessWidget {
  const _TopbarIconButton({
    required this.icon,
    required this.onPressed,
    this.badge,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final int? badge;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Tooltip(
      message: tooltip ?? '',
      child: Stack(
        children: [
          IconButton(
            onPressed: onPressed,
            icon: Icon(icon, size: 20.r, color: colors.textSecondary),
            style: IconButton.styleFrom(
              backgroundColor: colors.surfaceVariant.withValues(alpha: 0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
          if (badge != null && badge! > 0)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: colors.error,
                  shape: BoxShape.circle,
                ),
                constraints: BoxConstraints(minWidth: 16.r, minHeight: 16.r),
                child: Text(
                  badge! > 99 ? '99+' : '$badge',
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.onError,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ThemeToggleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final colors = context.adminColors;

    return Tooltip(
      message: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
      child: IconButton(
        onPressed: () {
          // Toggle theme
          // This would typically be handled by a ThemeService
        },
        icon: Icon(
          isDark ? Iconsax.sun_1 : Iconsax.moon,
          size: 20.r,
          color: colors.textSecondary,
        ),
        style: IconButton.styleFrom(
          backgroundColor: colors.surfaceVariant.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return PopupMenuButton<String>(
      offset: Offset(0, 50.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: colors.surfaceVariant.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Iconsax.notification,
              size: 20.r,
              color: colors.textSecondary,
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              width: 8.r,
              height: 8.r,
              decoration: BoxDecoration(
                color: colors.error,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          child: SizedBox(
            width: 280.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Mark all read',
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ),
                  ],
                ),
                Divider(color: colors.divider),
              ],
            ),
          ),
        ),
        ..._buildNotificationItems(context),
        PopupMenuItem(
          child: Center(
            child: Text(
              'View all notifications',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: colors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<PopupMenuItem<String>> _buildNotificationItems(BuildContext context) {
    final colors = context.adminColors;
    final notifications = [
      ('New station registered', '5 min ago', Iconsax.gas_station),
      ('Payment received', '1 hour ago', Iconsax.card),
      ('New user signup', '3 hours ago', Iconsax.user_add),
    ];

    return notifications.map((n) {
      return PopupMenuItem<String>(
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(n.$3, size: 16.r, color: colors.primary),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    n.$1,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: colors.textPrimary,
                    ),
                  ),
                  Text(
                    n.$2,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: colors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

class _ProfileDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return PopupMenuButton<String>(
      offset: Offset(0, 50.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16.r,
            backgroundColor: colors.primary,
            child: Text(
              'AD',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: colors.onPrimary,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Admin User',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              Text(
                'Super Admin',
                style: TextStyle(fontSize: 11.sp, color: colors.textTertiary),
              ),
            ],
          ),
          SizedBox(width: 4.w),
          Icon(
            Icons.keyboard_arrow_down,
            size: 18.r,
            color: colors.textTertiary,
          ),
        ],
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Iconsax.user, size: 18.r, color: colors.textSecondary),
              SizedBox(width: 12.w),
              const Text('My Profile'),
            ],
          ),
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Iconsax.setting_2, size: 18.r, color: colors.textSecondary),
              SizedBox(width: 12.w),
              const Text('Settings'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Iconsax.logout, size: 18.r, color: colors.error),
              SizedBox(width: 12.w),
              Text('Logout', style: TextStyle(color: colors.error)),
            ],
          ),
        ),
      ],
    );
  }
}
