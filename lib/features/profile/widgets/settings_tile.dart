/// File: lib/features/profile/widgets/settings_tile.dart
/// Purpose: Settings tile widget
/// Belongs To: profile feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';

/// Settings navigation tile.
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.titleColor,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final Color? titleColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariantLight,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, size: 20.r, color: titleColor),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500, color: titleColor),
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 20.r, color: AppColors.textSecondaryLight),
          ],
        ),
      ),
    );
  }
}

