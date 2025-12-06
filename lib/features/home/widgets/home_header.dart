/// File: lib/features/home/widgets/home_header.dart
/// Purpose: Home page header with greeting and profile
/// Belongs To: home feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/extensions/context_ext.dart';
import '../../../core/theme/app_colors.dart';

/// Home header widget with greeting and actions.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    required this.userName,
    required this.onNotificationTap,
    super.key,
  });

  final String userName;
  final VoidCallback onNotificationTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning! 👋',
              style: TextStyle(fontSize: 14.sp, color: colors.textSecondary),
            ),
            SizedBox(height: 4.h),
            Text(
              userName,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
        Row(
          children: [
            _IconButton(
              icon: Iconsax.notification,
              onTap: onNotificationTap,
              hasBadge: true,
            ),
            SizedBox(width: 12.w),
            _buildAvatar(context),
          ],
        ),
      ],
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final colors = context.appColors;
    final initials = userName.split(' ').take(2).map((n) => n[0]).join();

    return Container(
      width: 44.r,
      height: 44.r,
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.icon,
    required this.onTap,
    this.hasBadge = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool hasBadge;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.r,
        height: 44.r,
        decoration: BoxDecoration(
          color: colors.surfaceVariant,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(icon, size: 22.r, color: colors.textPrimary),
            ),
            if (hasBadge)
              Positioned(
                top: 10.h,
                right: 10.w,
                child: Container(
                  width: 8.r,
                  height: 8.r,
                  decoration: BoxDecoration(
                    color: colors.danger,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
