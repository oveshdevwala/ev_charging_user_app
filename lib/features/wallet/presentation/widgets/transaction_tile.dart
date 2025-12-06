/// File: lib/features/wallet/presentation/widgets/transaction_tile.dart
/// Purpose: Transaction list tile widget
/// Belongs To: wallet feature
/// Customization Guide:
///    - Modify icon mapping for transaction types
///    - Adjust colors based on transaction status
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/extensions/context_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/wallet_transaction_model.dart';

/// Transaction tile for displaying individual transactions.
///
/// Features:
/// - Icon based on transaction type
/// - Credit/debit color coding
/// - Status indicator
/// - Formatted date and time
class TransactionTile extends StatelessWidget {
  const TransactionTile({
    required this.transaction,
    super.key,
    this.onTap,
    this.showDivider = true,
  });

  final WalletTransactionModel transaction;
  final VoidCallback? onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
            child: Row(
              children: [
                _buildIcon(context),
                SizedBox(width: 12.w),
                Expanded(child: _buildDetails(context)),
                _buildAmount(context),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: colors.outline,
          ),
      ],
    );
  }

  Widget _buildIcon(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: _getIconBackgroundColor(context),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(
        _getIcon(),
        color: _getIconColor(context),
        size: 20.r,
      ),
    );
  }

  IconData _getIcon() {
    switch (transaction.type) {
      case WalletTransactionType.recharge:
        return Iconsax.add_circle;
      case WalletTransactionType.charging:
        return Iconsax.flash_1;
      case WalletTransactionType.cashback:
        return Iconsax.money_recive;
      case WalletTransactionType.refund:
        return Iconsax.refresh_left_square;
      case WalletTransactionType.promoCredit:
        return Iconsax.ticket_discount;
      case WalletTransactionType.referral:
        return Iconsax.people;
      case WalletTransactionType.reward:
        return Iconsax.gift;
      case WalletTransactionType.withdrawal:
        return Iconsax.money_send;
      case WalletTransactionType.transfer:
        return Iconsax.arrow_swap_horizontal;
      case WalletTransactionType.subscription:
        return Iconsax.crown;
    }
  }

  Color _getIconColor(BuildContext context) {
    final colors = context.appColors;

    if (transaction.isCredit) {
      return colors.success;
    }
    switch (transaction.type) {
      case WalletTransactionType.charging:
        return colors.primary;
      case WalletTransactionType.subscription:
        return colors.tertiary;
      default:
        return colors.danger;
    }
  }

  Color _getIconBackgroundColor(BuildContext context) {
    final baseColor = _getIconColor(context);
    return baseColor.withValues(alpha: 0.1);
  }

  Widget _buildDetails(BuildContext context) {
    final colors = context.appColors;
    return Column(
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
          _getSubtitle(),
          style: TextStyle(
            fontSize: 12.sp,
            color: colors.textSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Text(
              '${transaction.formattedDate} • ${transaction.formattedTime}',
              style: TextStyle(
                fontSize: 11.sp,
                color: colors.textTertiary,
              ),
            ),
            if (transaction.status != WalletTransactionStatus.completed) ...[
              SizedBox(width: 8.w),
              _buildStatusBadge(context),
            ],
          ],
        ),
      ],
    );
  }

  String _getSubtitle() {
    if (transaction.stationName != null) {
      return transaction.stationName!;
    }
    if (transaction.promoCode != null) {
      return 'Code: ${transaction.promoCode}';
    }
    return transaction.description ?? '';
  }

  Widget _buildStatusBadge(BuildContext context) {
    final colors = context.appColors;
    Color bgColor;
    Color textColor;

    switch (transaction.status) {
      case WalletTransactionStatus.pending:
        bgColor = colors.warningContainer;
        textColor = colors.warning;
        break;
      case WalletTransactionStatus.processing:
        bgColor = colors.infoContainer;
        textColor = colors.info;
        break;
      case WalletTransactionStatus.failed:
        bgColor = colors.dangerContainer;
        textColor = colors.danger;
        break;
      case WalletTransactionStatus.cancelled:
        bgColor = colors.surfaceVariant;
        textColor = colors.textSecondary;
        break;
      case WalletTransactionStatus.completed:
        bgColor = colors.successContainer;
        textColor = colors.success;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        transaction.statusDisplayName,
        style: TextStyle(
          fontSize: 9.sp,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildAmount(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          transaction.formattedAmount,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: transaction.isCredit ? colors.success : colors.textPrimary,
          ),
        ),
        if (transaction.cashbackPercentage != null)
          Container(
            margin: EdgeInsets.only(top: 4.h),
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: colors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              '${transaction.cashbackPercentage!.toStringAsFixed(0)}% back',
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.w600,
                color: colors.success,
              ),
            ),
          ),
      ],
    );
  }
}
