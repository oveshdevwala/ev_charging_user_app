/// File: lib/features/profile/widgets/settings_section.dart
/// Purpose: Settings section container
/// Belongs To: profile feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';

/// Settings section container widget.
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

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
            children: children.asMap().entries.map((e) {
              return Column(
                children: [
                  e.value,
                  if (e.key < children.length - 1)
                    Divider(height: 1, indent: 56.w, color: AppColors.outlineLight),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

