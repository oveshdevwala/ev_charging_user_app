/// File: lib/features/wallet/presentation/widgets/credits_timeline.dart
/// Purpose: Credits history timeline widget
/// Belongs To: wallet feature
/// Customization Guide:
///    - Modify timeline styling
///    - Add animations for entries
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/credits_model.dart';

/// Credits timeline for displaying credit history.
/// 
/// Features:
/// - Visual timeline with connectors
/// - Source-based icons
/// - Expiry warnings
/// - Used/available indicators
class CreditsTimeline extends StatelessWidget {
  const CreditsTimeline({
    required this.entries, super.key,
    this.showExpiring = true,
  });

  final List<CreditEntryModel> entries;
  final bool showExpiring;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final isLast = index == entries.length - 1;

        return _CreditTimelineItem(
          entry: entry,
          isLast: isLast,
          showExpiring: showExpiring,
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(32.r),
      child: Column(
        children: [
          Icon(
            Iconsax.empty_wallet,
            size: 48.r,
            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
          ),
          SizedBox(height: 12.h),
          Text(
            'No credits yet',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Start charging to earn credits',
            style: TextStyle(
              fontSize: 12.sp,
              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _CreditTimelineItem extends StatelessWidget {
  const _CreditTimelineItem({
    required this.entry,
    required this.isLast,
    required this.showExpiring,
  });

  final CreditEntryModel entry;
  final bool isLast;
  final bool showExpiring;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          SizedBox(
            width: 40.w,
            child: Column(
              children: [
                _buildDot(),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isDark ? AppColors.outlineDark : AppColors.outlineLight,
                    ),
                  ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: 16.h),
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight,
                borderRadius: BorderRadius.circular(12.r),
                border: entry.isExpired
                    ? Border.all(color: AppColors.error.withValues(alpha: 0.3))
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(6.r),
                            decoration: BoxDecoration(
                              color: _getSourceColor().withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              _getSourceIcon(),
                              color: _getSourceColor(),
                              size: 14.r,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            entry.sourceDisplayName,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '+${entry.credits}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: entry.isExpired ? AppColors.textTertiaryLight : AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  if (entry.stationName != null || entry.description != null) ...[
                    SizedBox(height: 6.h),
                    Text(
                      entry.stationName ?? entry.description ?? '',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.formattedEarnedDate,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                        ),
                      ),
                      if (showExpiring && !entry.isExpired && entry.daysUntilExpiry <= 30)
                        _buildExpiryBadge(),
                      if (entry.isExpired) _buildExpiredBadge(),
                    ],
                  ),
                  if (entry.usedCredits > 0) ...[
                    SizedBox(height: 8.h),
                    _buildProgressBar(isDark),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      width: 12.r,
      height: 12.r,
      decoration: BoxDecoration(
        color: entry.isExpired ? AppColors.error : _getSourceColor(),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: (entry.isExpired ? AppColors.error : _getSourceColor())
                .withValues(alpha: 0.3),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  IconData _getSourceIcon() {
    switch (entry.source) {
      case CreditSource.charging:
        return Iconsax.flash_1;
      case CreditSource.referral:
        return Iconsax.people;
      case CreditSource.promotion:
        return Iconsax.ticket_discount;
      case CreditSource.bonus:
        return Iconsax.gift;
      case CreditSource.signup:
        return Iconsax.user_add;
      case CreditSource.anniversary:
        return Iconsax.cake;
      case CreditSource.loyalty:
        return Iconsax.crown;
      case CreditSource.feedback:
        return Iconsax.star;
    }
  }

  Color _getSourceColor() {
    switch (entry.source) {
      case CreditSource.charging:
        return AppColors.primary;
      case CreditSource.referral:
        return AppColors.secondary;
      case CreditSource.promotion:
        return AppColors.tertiary;
      case CreditSource.bonus:
        return Colors.amber;
      case CreditSource.signup:
        return AppColors.success;
      case CreditSource.anniversary:
        return Colors.pink;
      case CreditSource.loyalty:
        return Colors.orange;
      case CreditSource.feedback:
        return AppColors.info;
    }
  }

  Widget _buildExpiryBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.warningContainer,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Iconsax.clock, size: 10.r, color: AppColors.warningDark),
          SizedBox(width: 4.w),
          Text(
            'Expires in ${entry.daysUntilExpiry}d',
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.warningDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpiredBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.errorContainer,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        'Expired',
        style: TextStyle(
          fontSize: 9.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.error,
        ),
      ),
    );
  }

  Widget _buildProgressBar(bool isDark) {
    final progress = entry.usedCredits / entry.credits;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Used: ${entry.usedCredits} / ${entry.credits}',
              style: TextStyle(
                fontSize: 10.sp,
                color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
              ),
            ),
            Text(
              'Remaining: ${entry.remainingCredits}',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.success,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(2.r),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: isDark ? AppColors.outlineDark : AppColors.outlineLight,
            valueColor: AlwaysStoppedAnimation(
              progress == 1 ? AppColors.textTertiaryLight : AppColors.primary,
            ),
            minHeight: 4.h,
          ),
        ),
      ],
    );
  }
}

