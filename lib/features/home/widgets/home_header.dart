/// File: lib/features/home/widgets/home_header.dart
/// Purpose: Home page header with greeting and profile
/// Belongs To: home feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/theme/app_colors.dart';

/// Home header widget with greeting and actions.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    required this.userName, required this.onNotificationTap, super.key,
  });

  final String userName;
  final VoidCallback onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning! 👋',
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondaryLight),
            ),
            SizedBox(height: 4.h),
            Text(
              userName,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimaryLight,
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
            _buildAvatar(),
          ],
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    final initials = userName.split(' ').take(2).map((n) => n[0]).join();
    return Container(
      width: 44.r,
      height: 44.r,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.r,
        height: 44.r,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariantLight,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Stack(
          children: [
            Center(child: Icon(icon, size: 22.r, color: AppColors.textPrimaryLight)),
            if (hasBadge)
              Positioned(
                top: 10.h,
                right: 10.w,
                child: Container(
                  width: 8.r,
                  height: 8.r,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
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

