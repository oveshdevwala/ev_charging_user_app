/// File: lib/features/profile/widgets/profile_menu_section.dart
/// Purpose: Profile menu section widget
/// Belongs To: profile feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import 'profile_menu_item.dart';

/// Profile menu section container.
class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({
    super.key,
    required this.title,
    required this.items,
  });

  final String title;
  final List<ProfileMenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondaryLight,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.outlineLight),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  _buildMenuItem(item),
                  if (index < items.length - 1)
                    Divider(height: 1, indent: 56.w, color: AppColors.outlineLight),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(ProfileMenuItem item) {
    return GestureDetector(
      onTap: item.onTap,
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
              child: Icon(item.icon, size: 20.r, color: AppColors.textPrimaryLight),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                item.title,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: AppColors.textPrimaryLight),
              ),
            ),
            if (item.trailing != null)
              Text(
                item.trailing!,
                style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondaryLight),
              ),
            SizedBox(width: 8.w),
            Icon(Icons.chevron_right_rounded, size: 20.r, color: AppColors.textSecondaryLight),
          ],
        ),
      ),
    );
  }
}

