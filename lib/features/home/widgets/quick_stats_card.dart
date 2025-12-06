/// File: lib/features/home/widgets/quick_stats_card.dart
/// Purpose: Quick stats card for home page
/// Belongs To: home feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/theme/app_colors.dart';

/// Quick stats card showing user's charging stats.
class QuickStatsCard extends StatelessWidget {
  const QuickStatsCard({
    required this.sessions,
    required this.energy,
    required this.spent,
    super.key,
  });

  final int sessions;
  final String energy;
  final String spent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: Iconsax.flash_1,
              value: '$sessions',
              label: 'Sessions',
            ),
          ),
          _buildDivider(context   ),
          Expanded(
            child: _StatItem(
              icon: Iconsax.battery_charging,
              value: energy,
              label: 'Energy',
            ),
          ),
          _buildDivider(context),
          Expanded(
            child: _StatItem(
              icon: Iconsax.wallet,
              value: spent,
              label: 'Spent',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      width: 1,
      height: 48.h,
      color: context.appColors.surface.withValues(alpha: 0.3),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 24.r, color: context.appColors.surface),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: context.appColors.surface,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: context.appColors.surface.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}
