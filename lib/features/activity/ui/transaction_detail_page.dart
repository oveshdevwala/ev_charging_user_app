/// File: lib/features/activity/ui/transaction_detail_page.dart
/// Purpose: Detailed view of a transaction
/// Belongs To: activity feature
/// Route: /transactionDetail/:id
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/transaction_model.dart';
import '../../../repositories/activity_repository.dart';

/// Transaction detail page showing full transaction information.
class TransactionDetailPage extends StatelessWidget {
  const TransactionDetailPage({required this.transactionId, super.key});

  final String transactionId;

  @override
  Widget build(BuildContext context) {
    final transaction = DummyActivityRepository().getTransactionById(transactionId);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Iconsax.arrow_left, size: 20.r, color: AppColors.textPrimaryLight),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Transaction Details',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryLight,
          ),
        ),
        centerTitle: false,
      ),
      body: transaction == null
          ? _buildNotFound()
          : _buildContent(context, transaction),
    );
  }

  Widget _buildNotFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.warning_2, size: 64.r, color: AppColors.textTertiaryLight),
          SizedBox(height: 16.h),
          Text(
            'Transaction not found',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textSecondaryLight,
            ),
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
          _buildAmountCard(transaction),
          SizedBox(height: 20.h),

          // Transaction Info
          _buildInfoCard(transaction),
          SizedBox(height: 20.h),

          // Reference Card
          _buildReferenceCard(context, transaction),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }

  Widget _buildAmountCard(TransactionModel transaction) {
    final isCredit = transaction.isCredit;

    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isCredit
              ? [AppColors.success, AppColors.successDark]
              : [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Container(
            width: 60.r,
            height: 60.r,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIcon(transaction.type),
              size: 30.r,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            transaction.formattedAmount,
            style: TextStyle(
              fontSize: 36.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            transaction.typeDisplayName,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              transaction.status == TransactionStatus.completed
                  ? 'Completed'
                  : transaction.status == TransactionStatus.pending
                      ? 'Pending'
                      : 'Failed',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(TransactionType type) {
    switch (type) {
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

  Widget _buildInfoCard(TransactionModel transaction) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.outlineLight),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Iconsax.calendar,
            label: 'Date',
            value: transaction.formattedDate,
          ),
          Divider(height: 24.h, color: AppColors.outlineLight),
          _buildInfoRow(
            icon: Iconsax.clock,
            label: 'Time',
            value: transaction.formattedTime,
          ),
          if (transaction.stationName != null) ...[
            Divider(height: 24.h, color: AppColors.outlineLight),
            _buildInfoRow(
              icon: Iconsax.gas_station,
              label: 'Station',
              value: transaction.stationName!,
            ),
          ],
          if (transaction.energyKwh != null) ...[
            Divider(height: 24.h, color: AppColors.outlineLight),
            _buildInfoRow(
              icon: Iconsax.flash_1,
              label: 'Energy',
              value: '${transaction.energyKwh!.toStringAsFixed(1)} kWh',
            ),
          ],
          if (transaction.description != null) ...[
            Divider(height: 24.h, color: AppColors.outlineLight),
            _buildInfoRow(
              icon: Iconsax.document_text,
              label: 'Description',
              value: transaction.description!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariantLight,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 20.r, color: AppColors.textSecondaryLight),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textTertiaryLight,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReferenceCard(BuildContext context, TransactionModel transaction) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.outlineLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reference',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryLight,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariantLight,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    transaction.id,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: 'monospace',
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Material(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
                child: InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: transaction.id));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Transaction ID copied'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(10.r),
                  child: Container(
                    padding: EdgeInsets.all(12.r),
                    child: Icon(
                      Iconsax.copy,
                      size: 20.r,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Icon(Iconsax.info_circle, size: 16.r, color: AppColors.textTertiaryLight),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Keep this reference for your records.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textTertiaryLight,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

