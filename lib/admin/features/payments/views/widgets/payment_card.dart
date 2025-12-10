/// File: lib/admin/features/payments/views/widgets/payment_card.dart
/// Purpose: Reusable payment card for list/grid views
/// Belongs To: admin/features/payments
/// Route: AdminRoutes.payments
/// Customization Guide:
/// - Add extra metadata (fees, coupon) to the summary row when available
library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/admin_strings.dart';
import '../../../../core/extensions/admin_context_ext.dart';
import '../../../../core/widgets/admin_card.dart';
import '../../../../core/widgets/admin_status_badge.dart';
import '../../models/payment.dart';

/// Card showing payment summary.
class PaymentCard extends StatelessWidget {
  const PaymentCard({required this.payment, super.key, this.onTap});

  final AdminPayment payment;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;
    final currencyFormatter = NumberFormat.simpleCurrency(
      name: payment.currency,
    );

    return AdminCard(
      padding: EdgeInsets.all(16.r),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: SizedBox(
              width: 64.w,
              height: 64.w,
              child: payment.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: payment.imageUrl!,
                      fit: BoxFit.cover,
                    )
                  : ColoredBox(
                      color: colors.surfaceVariant,
                      child: Icon(
                        Iconsax.card,
                        color: colors.textSecondary,
                        size: 28.r,
                      ),
                    ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        payment.stationName,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    AdminStatusBadge(
                      label: _statusLabel(payment.status),
                      type: _statusType(payment.status),
                      size: AdminBadgeSize.small,
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  '${AdminStrings.paymentsAmountLabel}: ${currencyFormatter.format(payment.amount)}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: 6.h),
                Wrap(
                  spacing: 12.w,
                  runSpacing: 6.h,
                  children: [
                    _chip(
                      context,
                      icon: Iconsax.card_pos,
                      label:
                          '${AdminStrings.paymentsMethodLabel}: ${_methodLabel(payment.method)}',
                    ),
                    _chip(
                      context,
                      icon: Iconsax.user,
                      label:
                          '${AdminStrings.paymentsUserLabel}: ${payment.userName}',
                    ),
                    _chip(
                      context,
                      icon: Iconsax.ticket,
                      label:
                          '${AdminStrings.paymentsReferenceLabel}: ${payment.referenceId}',
                    ),
                    _chip(
                      context,
                      icon: Iconsax.calendar_1,
                      label: DateFormat.yMMMd().add_jm().format(
                        payment.createdAt.toLocal(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    final colors = context.adminColors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.r, color: colors.textSecondary),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, color: colors.textSecondary),
          ),
        ],
      ),
    );
  }

  AdminStatusType _statusType(AdminPaymentStatus status) {
    switch (status) {
      case AdminPaymentStatus.pending:
        return AdminStatusType.pending;
      case AdminPaymentStatus.completed:
        return AdminStatusType.completed;
      case AdminPaymentStatus.failed:
        return AdminStatusType.error;
      case AdminPaymentStatus.refunded:
        return AdminStatusType.success;
    }
  }

  String _statusLabel(AdminPaymentStatus status) {
    switch (status) {
      case AdminPaymentStatus.pending:
        return AdminStrings.statusPending;
      case AdminPaymentStatus.completed:
        return AdminStrings.statusCompleted;
      case AdminPaymentStatus.failed:
        return AdminStrings.statusFailed;
      case AdminPaymentStatus.refunded:
        return AdminStrings.statusRefunded;
    }
  }

  String _methodLabel(AdminPaymentMethod method) {
    switch (method) {
      case AdminPaymentMethod.card:
        return AdminStrings.paymentsMethodCard;
      case AdminPaymentMethod.wallet:
        return AdminStrings.paymentsMethodWallet;
      case AdminPaymentMethod.upi:
        return AdminStrings.paymentsMethodUpi;
    }
  }
}
