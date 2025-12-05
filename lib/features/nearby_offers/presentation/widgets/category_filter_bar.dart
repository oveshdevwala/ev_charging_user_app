/// File: lib/features/nearby_offers/presentation/widgets/category_filter_bar.dart
/// Purpose: Horizontal scrollable category filter chips
/// Belongs To: nearby_offers feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/partner_category.dart';

class CategoryFilterBar extends StatelessWidget {
  const CategoryFilterBar({
    required this.selectedCategory,
    required this.onCategorySelected,
    super.key,
  });

  final PartnerCategory? selectedCategory;
  final ValueChanged<PartnerCategory?> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          _buildChip(
            context,
            label: 'All',
            isSelected:
                selectedCategory == null ||
                selectedCategory == PartnerCategory.all,
            onTap: () => onCategorySelected(null),
            icon: Icons.grid_view_rounded,
          ),
          SizedBox(width: 8.w),
          ...PartnerCategory.values.where((c) => c != PartnerCategory.all).map((
            category,
          ) {
            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: _buildChip(
                context,
                label:
                    category.name[0].toUpperCase() + category.name.substring(1),
                isSelected: selectedCategory == category,
                onTap: () => onCategorySelected(category),
                icon: category.iconData,
                color: category.color,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required IconData icon,
    Color? color,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return FilterChip(
      selected: isSelected,
      onSelected: (_) => onTap(),
      label: Text(label),
      avatar: Icon(
        icon,
        size: 18.sp,
        color: isSelected
            ? theme.colorScheme.onPrimary
            : (color ?? theme.colorScheme.onSurfaceVariant),
      ),
      backgroundColor: isDark
          ? theme.colorScheme.surfaceContainerHighest
          : Colors.white,
      selectedColor: theme.colorScheme.primary,
      labelStyle: theme.textTheme.labelLarge?.copyWith(
        color: isSelected
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected
            ? Colors.transparent
            : theme.colorScheme.outline.withOpacity(0.2),
      ),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
    );
  }
}
