/// File: lib/features/main_shell/widgets/bottom_nav_bar.dart
/// Purpose: Bottom navigation bar widget
/// Belongs To: main_shell feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../routes/app_routes.dart';

/// Bottom navigation bar widget.
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key, required this.currentPath});

  final String currentPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [BoxShadow(color: AppColors.shadowLight, blurRadius: 20, offset: const Offset(0, -5))],
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
                isActive: currentPath == AppRoutes.userHome.path,
                onTap: () => context.go(AppRoutes.userHome.path),
              ),
              _NavItem(
                icon: Iconsax.search_normal,
                activeIcon: Iconsax.search_normal_1,
                label: AppStrings.search,
                isActive: currentPath == AppRoutes.userSearch.path,
                onTap: () => context.go(AppRoutes.userSearch.path),
              ),
              _NavItem(
                icon: Iconsax.heart,
                activeIcon: Iconsax.heart5,
                label: AppStrings.favorites,
                isActive: currentPath == AppRoutes.userFavorites.path,
                onTap: () => context.go(AppRoutes.userFavorites.path),
              ),
              _NavItem(
                icon: Iconsax.calendar,
                activeIcon: Iconsax.calendar_tick,
                label: AppStrings.myBookings,
                isActive: currentPath == AppRoutes.userBookings.path,
                onTap: () => context.go(AppRoutes.userBookings.path),
              ),
              _NavItem(
                icon: Iconsax.user,
                activeIcon: Iconsax.user,
                label: AppStrings.profile,
                isActive: currentPath == AppRoutes.userProfile.path,
                onTap: () => context.go(AppRoutes.userProfile.path),
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

