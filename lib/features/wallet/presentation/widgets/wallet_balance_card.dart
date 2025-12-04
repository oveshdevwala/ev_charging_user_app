/// File: lib/features/wallet/presentation/widgets/wallet_balance_card.dart
/// Purpose: Glassmorphism wallet balance card widget
/// Belongs To: wallet feature
/// Customization Guide:
///    - Modify gradient colors via AppColors
///    - Adjust blur intensity and border radius
library;

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/wallet_balance_model.dart';

/// Large glassmorphism wallet balance card.
/// 
/// Features:
/// - Glassmorphism effect with blur
/// - Gradient background
/// - Animated balance display
/// - Quick action buttons
class WalletBalanceCard extends StatelessWidget {
  const WalletBalanceCard({
    required this.balance, super.key,
    this.onRecharge,
    this.onViewHistory,
    this.showActions = true,
    this.isCompact = false,
  });

  final WalletBalanceModel balance;
  final VoidCallback? onRecharge;
  final VoidCallback? onViewHistory;
  final bool showActions;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF1A3A2F),
                  const Color(0xFF0D2818),
                ]
              : [
                  AppColors.primary,
                  AppColors.primaryDark,
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.all(isCompact ? 16.r : 24.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.15),
                  Colors.white.withValues(alpha: 0.05),
                ],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: isCompact ? 12.h : 20.h),
                _buildBalance(),
                if (!isCompact) ...[
                  SizedBox(height: 16.h),
                  _buildSubBalances(),
                ],
                if (showActions && !isCompact) ...[
                  SizedBox(height: 20.h),
                  _buildActions(context),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Iconsax.wallet_3,
                color: Colors.white,
                size: 20.r,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'Wallet Balance',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            children: [
              Icon(
                Icons.bolt,
                color: Colors.amber,
                size: 14.r,
              ),
              SizedBox(width: 4.w),
              Text(
                '${balance.rewardsBalance.toStringAsFixed(0)} credits',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBalance() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          balance.formattedTotalBalance,
          style: TextStyle(
            fontSize: isCompact ? 32.sp : 42.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -1,
          ),
        ),
        if (!isCompact)
          Text(
            'Available for use',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
      ],
    );
  }

  Widget _buildSubBalances() {
    return Row(
      children: [
        _buildSubBalanceItem(
          icon: Iconsax.clock,
          label: 'Pending',
          value: balance.formattedPendingBalance,
          color: Colors.amber,
        ),
        SizedBox(width: 24.w),
        _buildSubBalanceItem(
          icon: Iconsax.gift,
          label: 'Rewards',
          value: balance.formattedRewardsBalance,
          color: Colors.pinkAccent,
        ),
      ],
    );
  }

  Widget _buildSubBalanceItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6.r),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: color, size: 14.r),
        ),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Iconsax.add_circle,
            label: 'Recharge',
            onTap: onRecharge,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildActionButton(
            icon: Iconsax.document_text,
            label: 'History',
            onTap: onViewHistory,
            isOutlined: true,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    bool isOutlined = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isOutlined
              ? Colors.transparent
              : Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12.r),
          border: isOutlined
              ? Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1.5,
                )
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18.r),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

