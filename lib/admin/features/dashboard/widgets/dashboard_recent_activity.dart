/// File: lib/admin/features/dashboard/widgets/dashboard_recent_activity.dart
/// Purpose: Dashboard recent activity widget
/// Belongs To: admin/features/dashboard/widgets
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/core.dart';

/// Dashboard recent activity list.
class DashboardRecentActivity extends StatelessWidget {
  const DashboardRecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return AdminCardWithHeader(
      title: AdminStrings.dashboardRecentActivity,
      actions: [
        TextButton(
          onPressed: () {},
          child: Text(AdminStrings.actionViewAll, style: TextStyle(fontSize: 12.sp)),
        ),
      ],
      contentPadding: EdgeInsets.zero,
      child: Column(
        children: [
          _ActivityItem(
            icon: Iconsax.gas_station,
            iconColor: colors.primary,
            title: 'New station registered',
            subtitle: 'Beach Boulevard Charging',
            time: '5 min ago',
          ),
          Divider(height: 1, color: colors.divider),
          _ActivityItem(
            icon: Iconsax.card,
            iconColor: colors.success,
            title: 'Payment received',
            subtitle: '\$28.50 from Alex Thompson',
            time: '15 min ago',
          ),
          Divider(height: 1, color: colors.divider),
          _ActivityItem(
            icon: Iconsax.user_add,
            iconColor: colors.info,
            title: 'New user signup',
            subtitle: 'emily.davis@email.com',
            time: '1 hour ago',
          ),
          Divider(height: 1, color: colors.divider),
          _ActivityItem(
            icon: Iconsax.star,
            iconColor: colors.warning,
            title: 'New review',
            subtitle: '5 stars for Downtown Hub',
            time: '2 hours ago',
          ),
          Divider(height: 1, color: colors.divider),
          _ActivityItem(
            icon: Iconsax.warning_2,
            iconColor: colors.error,
            title: 'Station offline',
            subtitle: 'Tech Campus Station',
            time: '3 hours ago',
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  const _ActivityItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 18.r, color: iconColor),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 11.sp,
              color: colors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

