/// File: lib/features/home/widgets/home_search_bar.dart
/// Purpose: Search bar widget for home page
/// Belongs To: home feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_ext.dart';

/// Search bar widget that navigates to search page.
class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: colors.surfaceVariant,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(
              Iconsax.search_normal,
              size: 20.r,
              color: colors.textSecondary,
            ),
            SizedBox(width: 12.w),
            Text(
              AppStrings.searchForStations,
              style: TextStyle(fontSize: 14.sp, color: colors.textTertiary),
            ),
            const Spacer(),
            Icon(Iconsax.setting_4, size: 20.r, color: colors.textSecondary),
          ],
        ),
      ),
    );
  }
}
