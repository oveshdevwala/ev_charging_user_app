/// File: lib/features/main_shell/widgets/bottom_nav_bar.dart
/// Purpose: Bottom navigation bar widget with instant tab switching
/// Belongs To: main_shell feature
/// Customization Guide:
///    - Add/remove nav items by modifying _navItems list
///    - Customize styling via AppColors and ScreenUtil
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';

/// Bottom navigation bar widget with index-based tab switching.
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    required this.currentIndex,
    required this.onTabSelected,
    super.key,
  });

  /// Currently selected tab index
  final int currentIndex;

  /// Callback when a tab is selected
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Iconsax.home_2,
                activeIcon: Iconsax.home_25,
                label: AppStrings.home,
                isActive: currentIndex == 0,
                onTap: () => onTabSelected(0),
              ),
              _NavItem(
                icon: Iconsax.search_normal,
                activeIcon: Iconsax.search_normal_1,
                label: AppStrings.search,
                isActive: currentIndex == 1,
                onTap: () => onTabSelected(1),
              ),
              _NavItem(
                icon: Iconsax.heart,
                activeIcon: Iconsax.heart5,
                label: AppStrings.favorites,
                isActive: currentIndex == 2,
                onTap: () => onTabSelected(2),
              ),
              _NavItem(
                icon: Iconsax.calendar,
                activeIcon: Iconsax.calendar_tick,
                label: AppStrings.myBookings,
                isActive: currentIndex == 3,
                onTap: () => onTabSelected(3),
              ),
              _NavItem(
                icon: Iconsax.user,
                activeIcon: Iconsax.user,
                label: AppStrings.profile,
                isActive: currentIndex == 4,
                onTap: () => onTabSelected(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              size: 24.r,
              color: isActive ? AppColors.primary : AppColors.textSecondaryLight,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? AppColors.primary : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
