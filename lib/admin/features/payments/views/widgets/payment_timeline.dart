/// File: lib/admin/features/payments/views/widgets/payment_timeline.dart
/// Purpose: Timeline widget for payment history
/// Belongs To: admin/features/payments
/// Route: AdminRoutes.paymentDetail
/// Customization Guide:
/// - Append additional metadata (actor, channel) per timeline entry
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/admin_context_ext.dart';
import '../../../../core/theme/admin_colors.dart';
import '../../models/payment.dart';

/// Vertical timeline showing payment events.
class PaymentTimeline extends StatelessWidget {
  const PaymentTimeline({required this.entries, super.key});

  final List<AdminPaymentTimelineEntry> entries;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;
    final formatter = DateFormat.yMMMd().add_jm();

    return Column(
      children: [
        for (var i = 0; i < entries.length; i++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 12.r,
                    height: 12.r,
                    decoration: BoxDecoration(
                      color: _statusColor(entries[i].status),
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (i != entries.length - 1)
                    Container(width: 2.w, height: 40.h, color: colors.divider),
                ],
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entries[i].title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      entries[i].description,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: colors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      formatter.format(entries[i].timestamp.toLocal()),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: colors.textTertiary,
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Color _statusColor(AdminPaymentStatus status) {
    switch (status) {
      case AdminPaymentStatus.pending:
        return AdminColors.infoDark;
      case AdminPaymentStatus.completed:
        return AdminColors.successDark;
      case AdminPaymentStatus.failed:
        return AdminColors.errorDark;
      case AdminPaymentStatus.refunded:
        return AdminColors.warningDark;
    }
  }
}
