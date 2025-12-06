/// File: lib/features/wallet/presentation/widgets/credits_summary_card.dart
/// Purpose: Credits summary card with stats and graph placeholder
/// Belongs To: wallet feature
/// Customization Guide:
///    - Add actual chart using fl_chart
///    - Modify stats display
library;

import 'package:ev_charging_user_app/core/extensions/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/credits_model.dart';

/// Credits summary card displaying total credits and stats.
///
/// Features:
/// - Large credits display
/// - Stats row (earned, used, expiring)
/// - Chart placeholder
class CreditsSummaryCard extends StatelessWidget {
  const CreditsSummaryCard({
    required this.summary,
    super.key,
    this.onViewHistory,
  });

  final CreditsSummaryModel summary;
  final VoidCallback? onViewHistory;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [colors.tertiaryContainer, colors.surface]
              : [colors.tertiary, colors.tertiaryContainer],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: colors.tertiary.withValues(alpha: 0.3),
            blurRadius: 16.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: 20.h),
          _buildMainCredits(context),
          SizedBox(height: 16.h),
          _buildStatsRow(isDark, context),
          if (summary.expiringCredits > 0) ...[
            SizedBox(height: 12.h),
            _buildExpiryWarning(context, summary),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colors = context.appColors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: colors.textPrimary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Iconsax.star, color: colors.textPrimary, size: 18.r),
            ),
            SizedBox(width: 10.w),
            Text(
              'Charging Credits',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
        if (onViewHistory != null)
          GestureDetector(
            onTap: onViewHistory,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: colors.textPrimary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                'History',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMainCredits(BuildContext context) {
    final colors = context.appColors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          summary.availableCredits.toString(),
          style: TextStyle(
            fontSize: 48.sp,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
            height: 1,
          ),
        ),
        SizedBox(width: 8.w),
        Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Available',
                style: TextStyle(fontSize: 12.sp, color: colors.textSecondary),
              ),
              Text(
                'Worth ${summary.formattedAvailableValue}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.secondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(bool isDark, BuildContext context) {
    final colors = context.appColors;

    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            context: context,
            icon: Iconsax.arrow_up,
            label: 'Earned',
            value: summary.totalCredits.toString(),
            color: colors.success,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatItem(
            context: context,
            icon: Iconsax.arrow_down,
            label: 'Used',
            value: summary.usedCredits.toString(),
            color: colors.info,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatItem(
            context: context,
            icon: Iconsax.calendar,
            label: 'This Month',
            value: '+${summary.creditsEarnedThisMonth}',
            color: colors.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required BuildContext context,
  }) {
    final colors = context.appColors;
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: colors.textPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 16.r),
          SizedBox(height: 6.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 10.sp, color: colors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildExpiryWarning(
    BuildContext context,
    CreditsSummaryModel summary,
  ) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: colors.warning.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: colors.warning.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(Iconsax.warning_2, color: colors.warning, size: 18.r),
          SizedBox(width: 10.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 12.sp, color: colors.textPrimary),
                children: [
                  TextSpan(
                    text: '${summary.expiringCredits} credits ',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: 'expiring in ${summary.expiringInDays} days',
                    style: TextStyle(color: colors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact credits badge for display in other screens
class CreditsBadge extends StatelessWidget {
  const CreditsBadge({required this.credits, super.key, this.onTap});

  final int credits;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colors.tertiary, colors.tertiaryContainer],
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Iconsax.star, color: colors.textPrimary, size: 14.r),
            SizedBox(width: 4.w),
            Text(
              credits.toString(),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
