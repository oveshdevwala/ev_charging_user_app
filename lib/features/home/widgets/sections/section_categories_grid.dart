/// File: lib/features/home/widgets/sections/section_categories_grid.dart
/// Purpose: Compact non-scrollable quick action grid section (3 columns × 2 rows)
/// Belongs To: home feature
/// Customization Guide:
///    - Add/remove categories by modifying _categories list
///    - Customize grid layout via crossAxisCount
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../bloc/home_state.dart';

/// Category item configuration.
class _CategoryItem {
  const _CategoryItem({
    required this.category,
    required this.icon,
    required this.label,
    this.color,
  });

  final HomeCategory category;
  final IconData icon;
  final String label;
  final Color? color;
}

/// Compact non-scrollable grid for quick actions (3 per row).
class SectionCategoriesGrid extends StatelessWidget {
  SectionCategoriesGrid({required this.onCategoryTap, super.key});

  /// Callback when a category is tapped.
  final void Function(HomeCategory category) onCategoryTap;

  final List<_CategoryItem> _categories = [
    const _CategoryItem(
      category: HomeCategory.findCharger,
      icon: Iconsax.search_normal,
      label: AppStrings.categoryFind,
      color: AppColors.primary,
    ),
    const _CategoryItem(
      category: HomeCategory.bookSlot,
      icon: Iconsax.calendar_add,
      label: AppStrings.categoryBook,
      color: AppColors.secondary,
    ),
    const _CategoryItem(
      category: HomeCategory.myBookings,
      icon: Iconsax.calendar_tick,
      label: AppStrings.categoryBookings,
      color: AppColors.tertiary,
    ),
    const _CategoryItem(
      category: HomeCategory.myVehicles,
      icon: Iconsax.car,
      label: AppStrings.categoryVehicles,
      color: AppColors.info,
    ),
    const _CategoryItem(
      category: HomeCategory.chargingHistory,
      icon: Iconsax.clock,
      label: AppStrings.categoryHistory,
      color: AppColors.warning,
    ),
    const _CategoryItem(
      category: HomeCategory.tripPlanner,
      icon: Iconsax.routing_2,
      label: AppStrings.categoryTrip,
      color: AppColors.success,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          // Row 1: 3 items
          Row(
            children: [
              _buildItem(context, _categories[0]),
              SizedBox(width: 8.w),
              _buildItem(context, _categories[1]),
              SizedBox(width: 8.w),
              _buildItem(context, _categories[2]),
            ],
          ),
          SizedBox(height: 8.h),
          // Row 2: 3 items
          Row(
            children: [
              _buildItem(context, _categories[3]),
              SizedBox(width: 8.w),
              _buildItem(context, _categories[4]),
              SizedBox(width: 8.w),
              _buildItem(context, _categories[5]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, _CategoryItem item) {
    return Expanded(
      child: _CompactGridButton(
        icon: item.icon,
        label: item.label,
        iconColor: item.color,
        onTap: () => onCategoryTap(item.category),
      ),
    );
  }
}

/// Compact grid button widget for quick actions.
class _CompactGridButton extends StatelessWidget {
  const _CompactGridButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: colors.outline,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: (iconColor ?? colors.primary).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  icon,
                  size: 18.r,
                  color: iconColor ?? colors.primary,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
