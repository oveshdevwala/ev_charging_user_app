/// File: lib/features/profile/widgets/profile_menu_section.dart
/// Purpose: Profile menu section widget
/// Belongs To: profile feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/context_ext.dart';
import 'profile_menu_item.dart';

/// Profile menu section container.
class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({
    required this.title,
    required this.items,
    super.key,
  });

  final String title;
  final List<ProfileMenuItem> items;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
          ),
        ),
        SizedBox(height: 12.h),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: colors.outline),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  _buildMenuItem(context, item),
                  if (index < items.length - 1)
                    Divider(height: 1, indent: 56.w, color: colors.outline),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, ProfileMenuItem item) {
    final colors = context.appColors;

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
                color: colors.surfaceVariant,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(item.icon, size: 20.r, color: colors.textPrimary),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                item.title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: colors.textPrimary,
                ),
              ),
            ),
            if (item.trailing != null)
              Text(
                item.trailing!,
                style: TextStyle(fontSize: 14.sp, color: colors.textSecondary),
              ),
            SizedBox(width: 8.w),
            Icon(
              Icons.chevron_right_rounded,
              size: 20.r,
              color: colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
