/// File: lib/admin/features/users/view/user_detail_view.dart
/// Purpose: User detail page for admin panel
/// Belongs To: admin/features/users
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/core.dart';
import '../../../models/admin_user.dart';
import '../../../viewmodels/users_view_model.dart';
import 'user_activity_logs_view.dart';
import 'user_edit_view.dart';

/// User detail view.
class UserDetailView extends StatelessWidget {
  const UserDetailView({
    required this.user,
    required this.viewModel,
    super.key,
  });

  final AdminUser user;
  final UsersViewModel viewModel;

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;
    final isActive = user.status == 'active';

    return AdminPageContent(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Header Section
            AdminCard(
              padding: EdgeInsets.all(24.r),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Profile Avatar
                      AdminAvatar(
                        imageUrl: user.avatarUrl,
                        name: user.name,
                        size: 96,
                      ),
                      SizedBox(width: 24.w),
                      // Name and Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    user.name,
                                    style: TextStyle(
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.w700,
                                      color: colors.textPrimary,
                                    ),
                                  ),
                                ),
                                if (user.role == 'vip')
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colors.warning.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Iconsax.star,
                                          size: 14.r,
                                          color: colors.warning,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          'VIP',
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w700,
                                            color: colors.warning,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Icon(
                                  Iconsax.sms,
                                  size: 16.r,
                                  color: colors.textSecondary,
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    user.email,
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: colors.textSecondary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            if (user.phone != null) ...[
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.call,
                                    size: 16.r,
                                    color: colors.textSecondary,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    user.phone!,
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Icon(
                                  Iconsax.calendar_1,
                                  size: 14.r,
                                  color: colors.textTertiary,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  'Joined ${_formatDate(user.createdAt)}',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: colors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Status Badge
                      AdminStatusBadge(
                        label: user.status.toUpperCase(),
                        type: _getStatusType(user.status),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: AdminButton(
                          label: AdminStrings.actionEdit,
                          variant: AdminButtonVariant.outlined,
                          icon: Iconsax.edit_2,
                          onPressed: () => context.showAdminModal<void>(
                            title: AdminStrings.usersEditTitle,
                            maxWidth: 800,
                            child: UserEditView(
                              user: user,
                              onSaved: (updated) {
                                viewModel.update(updated);
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: AdminButton(
                          label: 'View Activity Logs',
                          variant: AdminButtonVariant.outlined,
                          icon: Iconsax.document_text,
                          onPressed: () => context.showAdminModal<void>(
                            title: 'Activity Logs',
                            maxWidth: 1200,
                            child: UserActivityLogsView(userId: user.id),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: AdminButton(
                          label: isActive
                              ? AdminStrings.actionDeactivate
                              : AdminStrings.actionActivate,
                          variant: AdminButtonVariant.outlined,
                          icon: isActive
                              ? Iconsax.close_circle
                              : Iconsax.tick_circle,
                          backgroundColor: isActive
                              ? colors.error.withValues(alpha: 0.1)
                              : colors.success.withValues(alpha: 0.1),
                          foregroundColor: isActive
                              ? colors.error
                              : colors.success,
                          onPressed: () {
                            final newStatus = isActive ? 'inactive' : 'active';
                            viewModel.updateStatus(user.id, newStatus);
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Stats Cards Row
            Row(
              children: [
                Expanded(
                  child: AdminMetricCard(
                    title: 'Wallet Balance',
                    value: _formatCurrency(user.walletBalance),
                    icon: Iconsax.wallet_3,
                    iconColor: colors.success,
                    iconBackgroundColor: colors.success.withValues(alpha: 0.1),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: AdminMetricCard(
                    title: 'Total Sessions',
                    value: '${user.totalSessions}',
                    icon: Iconsax.flash,
                    iconColor: colors.primary,
                    iconBackgroundColor: colors.primary.withValues(alpha: 0.1),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: AdminMetricCard(
                    title: 'Total Spent',
                    value: _formatCurrency(user.totalSpent),
                    icon: Iconsax.money_send,
                    iconColor: colors.warning,
                    iconBackgroundColor: colors.warning.withValues(alpha: 0.1),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: AdminMetricCard(
                    title: 'Vehicles',
                    value: '${user.vehicleCount}',
                    icon: Iconsax.car,
                    iconColor: colors.info,
                    iconBackgroundColor: colors.info.withValues(alpha: 0.1),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Details Section - Two Column Layout
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column - User Details
                Expanded(
                  flex: 2,
                  child: AdminCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Iconsax.profile_circle,
                              size: 24.r,
                              color: colors.primary,
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              'User Information',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: colors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        const Divider(),
                        SizedBox(height: 24.h),
                        _DetailGrid(user: user, formatDate: _formatDate),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                // Right Column - Account Info
                Expanded(
                  child: Column(
                    children: [
                      AdminCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Iconsax.shield_tick,
                                  size: 24.r,
                                  color: colors.primary,
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  'Account Details',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: colors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24.h),
                            const Divider(),
                            SizedBox(height: 24.h),
                            _AccountInfoCard(user: user, formatDate: _formatDate),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      if (user.tags != null && user.tags!.isNotEmpty)
                        AdminCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.tag,
                                    size: 24.r,
                                    color: colors.primary,
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    'Tags',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color: colors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24.h),
                              Wrap(
                                spacing: 8.w,
                                runSpacing: 8.h,
                                children: user.tags!.map((tag) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 8.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colors.primary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                        color: colors.primary.withValues(alpha: 0.3),
                                      ),
                                    ),
                                    child: Text(
                                      tag,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                        color: colors.primary,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Last Activity Section
            AdminCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Iconsax.clock,
                            size: 24.r,
                            color: colors.primary,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Recent Activity',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      AdminButton(
                        label: 'View All Logs',
                        variant: AdminButtonVariant.text,
                        icon: Iconsax.arrow_right_3,
                        onPressed: () => context.showAdminModal<void>(
                          title: 'Activity Logs',
                          maxWidth: 1200,
                          child: UserActivityLogsView(userId: user.id),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  const Divider(),
                  SizedBox(height: 24.h),
                  _ActivitySummary(user: user, formatDate: _formatDate),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AdminStatusType _getStatusType(String status) {
    switch (status) {
      case 'active':
        return AdminStatusType.active;
      case 'inactive':
        return AdminStatusType.inactive;
      case 'suspended':
        return AdminStatusType.warning;
      case 'blocked':
        return AdminStatusType.error;
      default:
        return AdminStatusType.inactive;
    }
  }
}

class _DetailGrid extends StatelessWidget {
  const _DetailGrid({
    required this.user,
    required this.formatDate,
  });

  final AdminUser user;
  final String Function(DateTime) formatDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _DetailRow(
          label: AdminStrings.labelId,
          value: user.id,
          icon: Iconsax.tag,
        ),
        _DetailRow(
          label: AdminStrings.labelName,
          value: user.name,
          icon: Iconsax.user,
        ),
        _DetailRow(
          label: AdminStrings.labelEmail,
          value: user.email,
          icon: Iconsax.sms,
        ),
        if (user.phone != null)
          _DetailRow(
            label: AdminStrings.labelPhone,
            value: user.phone!,
            icon: Iconsax.call,
          ),
        _DetailRow(
          label: 'Role',
          value: user.role.toUpperCase(),
          icon: Iconsax.crown,
        ),
        if (user.accountType != null)
          _DetailRow(
            label: 'Account Type',
            value: user.accountType!.toUpperCase(),
            icon: Iconsax.briefcase,
          ),
        if (user.signupSource != null)
          _DetailRow(
            label: 'Signup Source',
            value: user.signupSource!.toUpperCase(),
            icon: Iconsax.login,
          ),
        if (user.kycStatus != null)
          _DetailRow(
            label: 'KYC Status',
            value: user.kycStatus!.toUpperCase(),
            icon: Iconsax.shield_tick,
          ),
        _DetailRow(
          label: 'Last Login',
          value: formatDate(user.lastLoginAt),
          icon: Iconsax.clock,
        ),
        if (user.lastChargeSessionAt != null)
          _DetailRow(
            label: 'Last Charge',
            value: formatDate(user.lastChargeSessionAt!),
            icon: Iconsax.flash,
          ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.icon,
  });

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 20.r,
              color: colors.textSecondary,
            ),
            SizedBox(width: 12.w),
          ],
          SizedBox(
            width: 140.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: colors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountInfoCard extends StatelessWidget {
  const _AccountInfoCard({
    required this.user,
    required this.formatDate,
  });

  final AdminUser user;
  final String Function(DateTime) formatDate;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Column(
      children: [
        _InfoItem(
          icon: Iconsax.calendar,
          label: 'Created',
          value: formatDate(user.createdAt),
        ),
        SizedBox(height: 16.h),
        _InfoItem(
          icon: Iconsax.clock,
          label: 'Last Updated',
          value: formatDate(user.updatedAt),
        ),
        SizedBox(height: 16.h),
        _InfoItem(
          icon: Iconsax.profile_2user,
          label: 'Status',
          value: user.status.toUpperCase(),
          valueColor: _getStatusColor(user.status, colors),
        ),
      ],
    );
  }

  Color _getStatusColor(String status, AdminAppColors colors) {
    switch (status) {
      case 'active':
        return colors.success;
      case 'inactive':
        return colors.textSecondary;
      case 'suspended':
        return colors.warning;
      case 'blocked':
        return colors.error;
      default:
        return colors.textPrimary;
    }
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16.r,
            color: colors.textSecondary,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: colors.textTertiary,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: valueColor ?? colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivitySummary extends StatelessWidget {
  const _ActivitySummary({
    required this.user,
    required this.formatDate,
  });

  final AdminUser user;
  final String Function(DateTime) formatDate;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Column(
      children: [
        _ActivityItem(
          icon: Iconsax.login_1,
          label: 'Last Login',
          value: formatDate(user.lastLoginAt),
          color: colors.primary,
        ),
        if (user.lastChargeSessionAt != null) ...[
          SizedBox(height: 12.h),
          _ActivityItem(
            icon: Iconsax.flash,
            label: 'Last Charge Session',
            value: formatDate(user.lastChargeSessionAt!),
            color: colors.success,
          ),
        ],
        SizedBox(height: 12.h),
        _ActivityItem(
          icon: Iconsax.wallet_3,
          label: 'Wallet Balance',
          value: '\$${user.walletBalance.toStringAsFixed(2)}',
          color: colors.warning,
        ),
      ],
    );
  }
}

class _ActivityItem extends StatelessWidget {
  const _ActivityItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
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
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: colors.textSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

