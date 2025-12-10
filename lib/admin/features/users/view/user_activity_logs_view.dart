/// File: lib/admin/features/users/view/user_activity_logs_view.dart
/// Purpose: User activity logs page for admin panel
/// Belongs To: admin/features/users
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/core.dart';
import '../../../models/user_activity_log.dart';

/// User activity logs view.
class UserActivityLogsView extends StatelessWidget {
  const UserActivityLogsView({
    required this.userId,
    super.key,
  });

  final String userId;

  // TODO: Replace with actual data from repository
  List<UserActivityLog> _getMockLogs() {
    return [
      UserActivityLog(
        id: 'log_001',
        userId: userId,
        type: ActivityLogType.login,
        description: 'User logged in successfully',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ipAddress: '192.168.1.1',
        deviceInfo: 'iPhone 14 Pro',
      ),
      UserActivityLog(
        id: 'log_002',
        userId: userId,
        type: ActivityLogType.chargingSession,
        description: 'Started charging session at Station ST_001',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        metadata: const {'stationId': 'ST_001', 'duration': '45 minutes'},
      ),
      UserActivityLog(
        id: 'log_003',
        userId: userId,
        type: ActivityLogType.walletTopup,
        description: r'Wallet topped up with $50.00',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        metadata: const {'amount': 50.00, 'method': 'Credit Card'},
      ),
      UserActivityLog(
        id: 'log_004',
        userId: userId,
        type: ActivityLogType.offerRedeemed,
        description: 'Redeemed offer: 20% off charging',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        metadata: const {'offerId': 'OFF_001', 'discount': '20%'},
      ),
      UserActivityLog(
        id: 'log_005',
        userId: userId,
        type: ActivityLogType.profileUpdate,
        description: 'Updated profile information',
        timestamp: DateTime.now().subtract(const Duration(days: 5)),
      ),
      UserActivityLog(
        id: 'log_006',
        userId: userId,
        type: ActivityLogType.vehicleAdded,
        description: 'Added new vehicle: Tesla Model 3',
        timestamp: DateTime.now().subtract(const Duration(days: 7)),
        metadata: const {'vehicleId': 'VH_001', 'model': 'Tesla Model 3'},
      ),
    ];
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  IconData _getActivityIcon(ActivityLogType type) {
    switch (type) {
      case ActivityLogType.login:
        return Iconsax.login_1;
      case ActivityLogType.logout:
        return Iconsax.logout;
      case ActivityLogType.passwordReset:
        return Iconsax.lock;
      case ActivityLogType.walletTopup:
        return Iconsax.wallet_3;
      case ActivityLogType.chargingSession:
        return Iconsax.flash;
      case ActivityLogType.offerRedeemed:
        return Iconsax.ticket;
      case ActivityLogType.suspiciousActivity:
        return Iconsax.warning_2;
      case ActivityLogType.profileUpdate:
        return Iconsax.profile_circle;
      case ActivityLogType.vehicleAdded:
        return Iconsax.car;
      case ActivityLogType.vehicleRemoved:
        return Iconsax.trash;
      case ActivityLogType.other:
        return Iconsax.info_circle;
    }
  }

  Color _getActivityColor(ActivityLogType type, AdminAppColors colors) {
    switch (type) {
      case ActivityLogType.login:
      case ActivityLogType.logout:
        return colors.primary;
      case ActivityLogType.passwordReset:
        return colors.warning;
      case ActivityLogType.walletTopup:
        return colors.success;
      case ActivityLogType.chargingSession:
        return colors.info;
      case ActivityLogType.offerRedeemed:
        return colors.warning;
      case ActivityLogType.suspiciousActivity:
        return colors.error;
      case ActivityLogType.profileUpdate:
        return colors.primary;
      case ActivityLogType.vehicleAdded:
      case ActivityLogType.vehicleRemoved:
        return colors.info;
      case ActivityLogType.other:
        return colors.textSecondary;
    }
  }

  String _getActivityTypeLabel(ActivityLogType type) {
    switch (type) {
      case ActivityLogType.login:
        return 'Login';
      case ActivityLogType.logout:
        return 'Logout';
      case ActivityLogType.passwordReset:
        return 'Password Reset';
      case ActivityLogType.walletTopup:
        return 'Wallet Top-up';
      case ActivityLogType.chargingSession:
        return 'Charging Session';
      case ActivityLogType.offerRedeemed:
        return 'Offer Redeemed';
      case ActivityLogType.suspiciousActivity:
        return 'Suspicious Activity';
      case ActivityLogType.profileUpdate:
        return 'Profile Update';
      case ActivityLogType.vehicleAdded:
        return 'Vehicle Added';
      case ActivityLogType.vehicleRemoved:
        return 'Vehicle Removed';
      case ActivityLogType.other:
        return 'Other';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;
    final logs = _getMockLogs();

    return AdminPageContent(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Activity Logs',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              Text(
                '${logs.length} activities',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Logs List
          Expanded(
            child: logs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.document_text,
                          size: 64.r,
                          color: colors.textTertiary,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No activity logs found',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: logs.length,
                    separatorBuilder: (context, index) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      final icon = _getActivityIcon(log.type);
                      final color = _getActivityColor(log.type, colors);
                      final typeLabel = _getActivityTypeLabel(log.type);

                      return AdminCard(
                        padding: EdgeInsets.all(16.r),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icon
                            Container(
                              padding: EdgeInsets.all(10.r),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                icon,
                                size: 20.r,
                                color: color,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            // Content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          typeLabel,
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600,
                                            color: colors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        _formatDate(log.timestamp),
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: colors.textTertiary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    log.description,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                  if (log.metadata != null &&
                                      log.metadata!.isNotEmpty) ...[
                                    SizedBox(height: 8.h),
                                    Wrap(
                                      spacing: 8.w,
                                      runSpacing: 4.h,
                                      children: log.metadata!.entries.map((entry) {
                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 4.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: colors.surfaceVariant,
                                            borderRadius: BorderRadius.circular(4.r),
                                          ),
                                          child: Text(
                                            '${entry.key}: ${entry.value}',
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              color: colors.textSecondary,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                  if (log.ipAddress != null ||
                                      log.deviceInfo != null) ...[
                                    SizedBox(height: 8.h),
                                    Row(
                                      children: [
                                        if (log.ipAddress != null) ...[
                                          Icon(
                                            Iconsax.global,
                                            size: 12.r,
                                            color: colors.textTertiary,
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            log.ipAddress!,
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              color: colors.textTertiary,
                                            ),
                                          ),
                                        ],
                                        if (log.ipAddress != null &&
                                            log.deviceInfo != null)
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.w,
                                            ),
                                            child: Container(
                                              width: 4.r,
                                              height: 4.r,
                                              decoration: BoxDecoration(
                                                color: colors.textTertiary,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),
                                        if (log.deviceInfo != null) ...[
                                          Icon(
                                            Iconsax.mobile,
                                            size: 12.r,
                                            color: colors.textTertiary,
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            log.deviceInfo!,
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              color: colors.textTertiary,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

