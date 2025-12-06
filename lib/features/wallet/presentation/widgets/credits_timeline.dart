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

import '../../../../core/extensions/context_ext.dart';
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
    required this.entries,
    super.key,
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
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(32.r),
      child: Column(
        children: [
          Icon(
            Iconsax.empty_wallet,
            size: 48.r,
            color: colors.textTertiary,
          ),
          SizedBox(height: 12.h),
          Text(
            'No credits yet',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Start charging to earn credits',
            style: TextStyle(
              fontSize: 12.sp,
              color: colors.textTertiary,
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
    final colors = context.appColors;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          SizedBox(
            width: 40.w,
            child: Column(
              children: [
                _buildDot(context),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: colors.outline,
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
                color: colors.surfaceVariant,
                borderRadius: BorderRadius.circular(12.r),
                border: entry.isExpired
                    ? Border.all(color: colors.danger.withValues(alpha: 0.3))
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
                              color: _getSourceColor(context).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              _getSourceIcon(),
                              color: _getSourceColor(context),
                              size: 14.r,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            entry.sourceDisplayName,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '+${entry.credits}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: entry.isExpired ? colors.textTertiary : colors.success,
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
                        color: colors.textSecondary,
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
                          color: colors.textTertiary,
                        ),
                      ),
                      if (showExpiring && !entry.isExpired && entry.daysUntilExpiry <= 30)
                        _buildExpiryBadge(context),
                      if (entry.isExpired) _buildExpiredBadge(context),
                    ],
                  ),
                  if (entry.usedCredits > 0) ...[
                    SizedBox(height: 8.h),
                    _buildProgressBar(context),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(BuildContext context) {
    final colors = context.appColors;
    final color = entry.isExpired ? colors.danger : _getSourceColor(context);

    return Container(
      width: 12.r,
      height: 12.r,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
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

  Color _getSourceColor(BuildContext context) {
    final colors = context.appColors;

    switch (entry.source) {
      case CreditSource.charging:
        return colors.primary;
      case CreditSource.referral:
        return colors.secondary;
      case CreditSource.promotion:
        return colors.tertiary;
      case CreditSource.bonus:
        return colors.warning;
      case CreditSource.signup:
        return colors.success;
      case CreditSource.anniversary:
        return colors.danger;
      case CreditSource.loyalty:
        return colors.info;
      case CreditSource.feedback:
        return colors.info;
    }
  }

  Widget _buildExpiryBadge(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colors.warningContainer,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Iconsax.clock, size: 10.r, color: colors.warning),
          SizedBox(width: 4.w),
          Text(
            'Expires in ${entry.daysUntilExpiry}d',
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              color: colors.warning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpiredBadge(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colors.dangerContainer,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        'Expired',
        style: TextStyle(
          fontSize: 9.sp,
          fontWeight: FontWeight.w600,
          color: colors.danger,
        ),
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    final colors = context.appColors;
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
                color: colors.textTertiary,
              ),
            ),
            Text(
              'Remaining: ${entry.remainingCredits}',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: colors.success,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(2.r),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: colors.outline,
            valueColor: AlwaysStoppedAnimation(
              progress == 1 ? colors.textTertiary : colors.primary,
            ),
            minHeight: 4.h,
          ),
        ),
      ],
    );
  }
}
