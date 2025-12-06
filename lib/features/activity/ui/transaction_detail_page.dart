/// File: lib/features/activity/ui/transaction_detail_page.dart
/// Purpose: Detailed view of a transaction
/// Belongs To: activity feature
/// Route: /transactionDetail/:id
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/core.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/transaction_model.dart';
import '../../../repositories/activity_repository.dart';

/// Transaction detail page showing full transaction information.
class TransactionDetailPage extends StatelessWidget {
  const TransactionDetailPage({required this.transactionId, super.key});

  final String transactionId;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final transaction = DummyActivityRepository().getTransactionById(
      transactionId,
    );

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Iconsax.arrow_left,
              size: 20.r,
              color: colors.textPrimary,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Transaction Details',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: transaction == null
          ? _buildNotFound(context)
          : _buildContent(context, transaction),
    );
  }

  Widget _buildNotFound(BuildContext context) {
    final colors = context.appColors;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.warning_2, size: 64.r, color: colors.textTertiary),
          SizedBox(height: 16.h),
          Text(
            'Transaction not found',
            style: TextStyle(fontSize: 16.sp, color: colors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, TransactionModel transaction) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Column(
        children: [
          // Amount Card
          _buildAmountCard(context, transaction),
          SizedBox(height: 20.h),

          // Transaction Info
          _buildInfoCard(context, transaction),
          SizedBox(height: 20.h),

          // Reference Card
          _buildReferenceCard(context, transaction),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }

  Widget _buildAmountCard(BuildContext context, TransactionModel transaction) {
    final colors = context.appColors;
    final isCredit = transaction.isCredit;

    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isCredit
              ? [colors.success, colors.successContainer]
              : [colors.primary, colors.primaryContainer],
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Container(
            width: 60.r,
            height: 60.r,
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIcon(transaction.type),
              size: 30.r,
              color: colors.surface,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            transaction.formattedAmount,
            style: TextStyle(
              fontSize: 36.sp,
              fontWeight: FontWeight.w800,
              color: colors.surface,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            transaction.typeDisplayName,
            style: TextStyle(
              fontSize: 14.sp,
              color: colors.surface.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, TransactionModel transaction) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transaction Information',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          _buildInfoRow(context, 'Date', transaction.formattedDate),
          SizedBox(height: 12.h),
          _buildInfoRow(context, 'Time', transaction.formattedTime),
          SizedBox(height: 12.h),
          _buildInfoRow(
            context,
            'Status',
            _getStatusDisplayName(transaction.status),
          ),
          if (transaction.stationName != null) ...[
            SizedBox(height: 12.h),
            _buildInfoRow(context, 'Station', transaction.stationName!),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final colors = context.appColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, color: colors.textSecondary),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildReferenceCard(
    BuildContext context,
    TransactionModel transaction,
  ) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reference',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  transaction.id,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: colors.textSecondary,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Iconsax.copy, size: 20.r, color: colors.primary),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: transaction.id));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Reference copied'),
                      backgroundColor: colors.surfaceVariant,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getStatusDisplayName(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return 'Completed';
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.failed:
        return 'Failed';
      case TransactionStatus.cancelled:
        return 'Cancelled';
      case TransactionStatus.refunded:
        return 'Refunded';
    }
  }

  IconData _getIcon(TransactionType type) {
    switch (type) {
      case TransactionType.charging:
        return Iconsax.flash_1;
      case TransactionType.topUp:
        return Iconsax.add_circle;
      case TransactionType.refund:
        return Iconsax.arrow_left;
      case TransactionType.reward:
        return Iconsax.gift;
      case TransactionType.subscription:
        return Iconsax.crown;
      case TransactionType.withdrawal:
        return Iconsax.money_send;
      case TransactionType.referral:
        return Iconsax.people;
    }
  }
}
