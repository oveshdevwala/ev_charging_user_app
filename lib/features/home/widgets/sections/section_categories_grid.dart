/// File: lib/features/home/widgets/sections/section_categories_grid.dart
/// Purpose: Quick action categories grid section
/// Belongs To: home feature
/// Customization Guide:
///    - Add/remove categories by modifying _categories list
///    - Customize buttons via CategoryButton component
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../bloc/home_state.dart';
import '../section_header.dart';
import '../components/category_button.dart';

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

/// Categories grid section with quick actions.
class SectionCategoriesGrid extends StatelessWidget {
  SectionCategoriesGrid({
    super.key,
    required this.onCategoryTap,
  });

  /// Callback when a category is tapped.
  final void Function(HomeCategory category) onCategoryTap;

  final List<_CategoryItem> _categories = [
    _CategoryItem(
      category: HomeCategory.findCharger,
      icon: Iconsax.search_normal,
      label: AppStrings.categoryFind,
      color: AppColors.primary,
    ),
    _CategoryItem(
      category: HomeCategory.bookSlot,
      icon: Iconsax.calendar_add,
      label: AppStrings.categoryBook,
      color: AppColors.secondary,
    ),
    _CategoryItem(
      category: HomeCategory.myBookings,
      icon: Iconsax.calendar_tick,
      label: AppStrings.categoryBookings,
      color: AppColors.tertiary,
    ),
    _CategoryItem(
      category: HomeCategory.myVehicles,
      icon: Iconsax.car,
      label: AppStrings.categoryVehicles,
      color: AppColors.info,
    ),
    _CategoryItem(
      category: HomeCategory.chargingHistory,
      icon: Iconsax.clock,
      label: AppStrings.categoryHistory,
      color: AppColors.warning,
    ),
    _CategoryItem(
      category: HomeCategory.support,
      icon: Iconsax.message_question,
      label: AppStrings.categorySupport,
      color: AppColors.success,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: AppStrings.categoriesTitle,
          showAction: false,
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final item = _categories[index];
              return CategoryButton(
                icon: item.icon,
                label: item.label,
                iconColor: item.color,
                isCompact: true,
                onTap: () => onCategoryTap(item.category),
              );
            },
          ),
        ),
      ],
    );
  }
}

