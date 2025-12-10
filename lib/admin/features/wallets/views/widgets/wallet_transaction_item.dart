/// File: lib/admin/features/wallets/views/widgets/wallet_transaction_item.dart
/// Purpose: Transaction item widget for wallet detail page
/// Belongs To: admin/features/wallets
library;

import 'package:ev_charging_user_app/admin/core/widgets/admin_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/admin_strings.dart';
import '../../../../core/extensions/admin_context_ext.dart';
import '../../models/wallet_transaction_model.dart';

/// Transaction item widget.
class WalletTransactionItem extends StatelessWidget {
  const WalletTransactionItem({required this.transaction, super.key});

  final WalletTransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;
    final isCredit = transaction.isCredit;
    final isDebit = transaction.isDebit;
    final isAdjust = transaction.isAdjust;

    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.divider),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: (isCredit ? colors.success : colors.error).withValues(
                alpha: 0.1,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCredit ? Iconsax.arrow_down_2 : Iconsax.arrow_up_2,
              size: 20.r,
              color: isCredit ? colors.success : colors.error,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _getTypeLabel(transaction.type),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    AdminStatusBadge(
                      label: transaction.status,
                      type: AdminStatusType.success,
                      size: AdminBadgeSize.small,
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  transaction.memo,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: colors.textSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'By ${transaction.actor} • ${DateFormat.yMMMd().add_jm().format(transaction.createdAt)}',
                  style: TextStyle(fontSize: 11.sp, color: colors.textTertiary),
                ),
              ],
            ),
          ),
          Text(
            '${isCredit ? '+' : '-'}${transaction.currency} ${transaction.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: isCredit ? colors.success : colors.error,
            ),
          ),
        ],
      ),
    );
  }

  String _getTypeLabel(TransactionType type) {
    switch (type) {
      case TransactionType.credit:
        return AdminStrings.walletsTypeCredit;
      case TransactionType.debit:
        return AdminStrings.walletsTypeDebit;
      case TransactionType.refund:
        return AdminStrings.walletsTypeRefund;
      case TransactionType.adjust:
        return AdminStrings.walletsTypeAdjust;
    }
  }
}
