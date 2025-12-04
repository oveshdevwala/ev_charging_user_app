/// File: lib/features/wallet/presentation/widgets/cashback_tag.dart
/// Purpose: Cashback tag/badge widget for partner stations
/// Belongs To: wallet feature
/// Customization Guide:
///    - Modify tier colors and icons
///    - Add animation effects
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/cashback_model.dart';

/// Cashback tag for displaying cashback percentage.
/// 
/// Features:
/// - Partner tier badges
/// - Percentage display
/// - Compact and expanded variants
class CashbackTag extends StatelessWidget {
  const CashbackTag({
    required this.percentage, super.key,
    this.partnerBadge,
    this.isCompact = false,
    this.showIcon = true,
  });

  final double percentage;
  final String? partnerBadge;
  final bool isCompact;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return _buildCompact();
    }
    return _buildExpanded();
  }

  Widget _buildCompact() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.success,
            AppColors.successDark,
          ],
        ),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              Iconsax.money_recive,
              color: Colors.white,
              size: 10.r,
            ),
            SizedBox(width: 3.w),
          ],
          Text(
            '${percentage.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpanded() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getGradientColors(),
        ),
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: _getGradientColors().first.withValues(alpha: 0.3),
            blurRadius: 4.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getBadgeIcon(),
            color: Colors.white,
            size: 14.r,
          ),
          SizedBox(width: 6.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${percentage.toStringAsFixed(0)}% Cashback',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              if (partnerBadge != null)
                Text(
                  partnerBadge!,
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  List<Color> _getGradientColors() {
    if (partnerBadge?.toLowerCase().contains('platinum') ?? false) {
      return [const Color(0xFF6B5B95), const Color(0xFF4A4063)];
    }
    if (partnerBadge?.toLowerCase().contains('gold') ?? false) {
      return [const Color(0xFFFFB400), const Color(0xFFCC9000)];
    }
    if (partnerBadge?.toLowerCase().contains('silver') ?? false) {
      return [const Color(0xFF9E9E9E), const Color(0xFF757575)];
    }
    return [AppColors.success, AppColors.successDark];
  }

  IconData _getBadgeIcon() {
    if (partnerBadge?.toLowerCase().contains('platinum') ?? false) {
      return Iconsax.crown;
    }
    if (partnerBadge?.toLowerCase().contains('gold') ?? false) {
      return Iconsax.medal_star;
    }
    if (partnerBadge?.toLowerCase().contains('silver') ?? false) {
      return Iconsax.medal;
    }
    return Iconsax.money_recive;
  }
}

/// Cashback detail card for transaction details.
class CashbackDetailCard extends StatelessWidget {
  const CashbackDetailCard({
    required this.cashback, super.key,
    this.onTap,
  });

  final CashbackModel cashback;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.success.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Iconsax.money_recive,
                    color: AppColors.success,
                    size: 20.r,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cashback.stationName,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        cashback.typeDisplayName,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      cashback.formattedCashbackAmount,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.success,
                      ),
                    ),
                    if (cashback.isPartnerStation && cashback.partnerBadge != null)
                      CashbackTag(
                        percentage: cashback.cashbackPercentage,
                        isCompact: true,
                        showIcon: false,
                      ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: (isDark ? AppColors.backgroundDark : AppColors.backgroundLight),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoItem(
                    label: 'Original Amount',
                    value: cashback.formattedOriginalAmount,
                    isDark: isDark,
                  ),
                  _buildInfoItem(
                    label: 'Cashback',
                    value: cashback.formattedPercentage,
                    isDark: isDark,
                  ),
                  _buildInfoItem(
                    label: 'Status',
                    value: cashback.statusDisplayName,
                    isDark: isDark,
                    valueColor: cashback.isCredited ? AppColors.success : AppColors.warning,
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              cashback.formattedEarnedDate,
              style: TextStyle(
                fontSize: 11.sp,
                color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required String label,
    required String value,
    required bool isDark,
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: valueColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
          ),
        ),
      ],
    );
  }
}

