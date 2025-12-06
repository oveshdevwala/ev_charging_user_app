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
    required this.percentage,
    super.key,
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
      return _buildCompact(context);
    }
    return _buildExpanded(context);
  }

  Widget _buildCompact(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.success, colors.successContainer],
        ),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              Iconsax.money_recive,
              color: colors.textPrimary,
              size: 10.r,
            ),
            SizedBox(width: 3.w),
          ],
          Text(
            '${percentage.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpanded(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: _getGradientColors(context)),
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: _getGradientColors(context).first.withValues(alpha: 0.3),
            blurRadius: 4.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getBadgeIcon(), color: colors.textPrimary, size: 14.r),
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
                  color: colors.textPrimary,
                ),
              ),
              if (partnerBadge != null)
                Text(
                  partnerBadge!,
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: colors.textSecondary,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  List<Color> _getGradientColors(BuildContext context) {
    final colors = context.appColors;
    if (partnerBadge?.toLowerCase().contains('platinum') ?? false) {
      return [colors.tertiary, colors.tertiaryContainer];
    }
    if (partnerBadge?.toLowerCase().contains('gold') ?? false) {
      return [colors.secondary, colors.secondaryContainer];
    }
    if (partnerBadge?.toLowerCase().contains('silver') ?? false) {
      return [colors.textTertiary, colors.textTertiary];
    }
    return [AppColors.success, colors.successContainer];
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
  const CashbackDetailCard({required this.cashback, super.key, this.onTap});

  final CashbackModel cashback;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: colors.surfaceVariant,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: colors.success.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: colors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Iconsax.money_recive,
                    color: colors.success,
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
                          color: colors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        cashback.typeDisplayName,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: colors.textSecondary,
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
                        color: colors.success,
                      ),
                    ),
                    if (cashback.isPartnerStation &&
                        cashback.partnerBadge != null)
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
                color: colors.background,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoItem(
                    context: context,
                    label: 'Original Amount',
                    value: cashback.formattedOriginalAmount,
                  ),
                  _buildInfoItem(
                    context: context,
                    label: 'Cashback',
                    value: cashback.formattedPercentage,
                  ),
                  _buildInfoItem(
                    context: context,
                    label: 'Status',
                    value: cashback.statusDisplayName,
                    valueColor: cashback.isCredited
                        ? colors.success
                        : colors.warning,
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              cashback.formattedEarnedDate,
              style: TextStyle(fontSize: 11.sp, color: colors.textTertiary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required BuildContext context,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10.sp, color: colors.textTertiary),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: valueColor ?? colors.textPrimary,
          ),
        ),
      ],
    );
  }
}
