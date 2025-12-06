/// File: lib/features/activity/widgets/transaction_card.dart
/// Purpose: Transaction card for payment history
/// Belongs To: activity feature
/// Customization Guide:
///    - Customize card appearance via params
///    - Used in transactions list
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/transaction_model.dart';

/// Transaction card widget.
class TransactionCard extends StatelessWidget {
  const TransactionCard({required this.transaction, super.key, this.onTap});

  /// Transaction data.
  final TransactionModel transaction;

  /// Tap callback.
  final VoidCallback? onTap;

  IconData get _icon {
    switch (transaction.type) {
      case TransactionType.charging:
        return Iconsax.flash_1;
      case TransactionType.subscription:
        return Iconsax.calendar_tick;
      case TransactionType.refund:
        return Iconsax.money_recive;
      case TransactionType.topUp:
        return Iconsax.wallet_add;
      case TransactionType.withdrawal:
        return Iconsax.money_send;
      case TransactionType.reward:
        return Iconsax.gift;
      case TransactionType.referral:
        return Iconsax.people;
    }
  }

  Color _iconColor(BuildContext context) {
    final colors = context.appColors;

    if (transaction.isCredit) {
      return colors.success;
    }
    switch (transaction.type) {
      case TransactionType.charging:
        return colors.primary;
      case TransactionType.subscription:
        return AppColors.tertiary;
      default:
        return colors.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final iconColor = _iconColor(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: colors.outline),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(_icon, size: 22.r, color: iconColor),
            ),
            SizedBox(width: 14.w),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.typeDisplayName,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    transaction.description ?? transaction.stationName ?? '',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: colors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${transaction.formattedDate} · ${transaction.formattedTime}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: colors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),

            // Amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  transaction.formattedAmount,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: transaction.isCredit
                        ? colors.success
                        : colors.textPrimary,
                  ),
                ),
                if (transaction.energyKwh != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    '${transaction.energyKwh!.toStringAsFixed(1)} kWh',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Grouped transactions by date.
class TransactionGroup extends StatelessWidget {
  const TransactionGroup({
    required this.date,
    required this.transactions,
    super.key,
    this.onTransactionTap,
  });

  /// Group date.
  final String date;

  /// Transactions in this group.
  final List<TransactionModel> transactions;

  /// Transaction tap callback.
  final void Function(TransactionModel)? onTransactionTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
          child: Text(
            date,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
        ),
        ...transactions.map(
          (tx) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: TransactionCard(
              transaction: tx,
              onTap: onTransactionTap != null
                  ? () => onTransactionTap!(tx)
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
