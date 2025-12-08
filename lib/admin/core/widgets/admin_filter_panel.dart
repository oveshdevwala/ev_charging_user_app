/// File: lib/admin/core/widgets/admin_filter_panel.dart
/// Purpose: Filter panel widget for admin lists
/// Belongs To: admin/core/widgets
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../constants/admin_strings.dart';
import '../extensions/admin_context_ext.dart';
import 'admin_button.dart';

/// Admin filter panel widget.
class AdminFilterPanel extends StatelessWidget {
  const AdminFilterPanel({
    required this.children,
    super.key,
    this.onApply,
    this.onClear,
    this.title,
    this.isExpanded = true,
  });

  final List<Widget> children;
  final VoidCallback? onApply;
  final VoidCallback? onClear;
  final String? title;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Iconsax.filter,
                size: 18.r,
                color: colors.textSecondary,
              ),
              SizedBox(width: 8.w),
              Text(
                title ?? AdminStrings.filterTitle,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              const Spacer(),
              if (onClear != null)
                TextButton(
                  onPressed: onClear,
                  child: Text(
                    AdminStrings.filterClear,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: colors.textSecondary,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.h),

          // Filter fields
          ...children,

          // Actions
          if (onApply != null) ...[
            SizedBox(height: 16.h),
            AdminButton(
              label: AdminStrings.filterApply,
              onPressed: onApply,
              isFullWidth: true,
            ),
          ],
        ],
      ),
    );
  }
}

/// Filter chip group.
class AdminFilterChipGroup extends StatelessWidget {
  const AdminFilterChipGroup({
    required this.label,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    super.key,
    this.multiSelect = true,
  });

  final String label;
  final List<String> options;
  final Set<String> selectedValues;
  final void Function(Set<String>) onChanged;
  final bool multiSelect;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: colors.textSecondary,
          ),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: options.map((option) {
            final isSelected = selectedValues.contains(option);
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                final newValues = Set<String>.from(selectedValues);
                if (multiSelect) {
                  if (selected) {
                    newValues.add(option);
                  } else {
                    newValues.remove(option);
                  }
                } else {
                  newValues.clear();
                  if (selected) {
                    newValues.add(option);
                  }
                }
                onChanged(newValues);
              },
              selectedColor: colors.primaryContainer,
              checkmarkColor: colors.primary,
              labelStyle: TextStyle(
                fontSize: 12.sp,
                color: isSelected ? colors.primary : colors.textPrimary,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Date range filter.
class AdminDateRangeFilter extends StatelessWidget {
  const AdminDateRangeFilter({
    super.key,
    this.label,
    this.startDate,
    this.endDate,
    this.onStartDateChanged,
    this.onEndDateChanged,
  });

  final String? label;
  final DateTime? startDate;
  final DateTime? endDate;
  final void Function(DateTime?)? onStartDateChanged;
  final void Function(DateTime?)? onEndDateChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: colors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
        ],
        Row(
          children: [
            Expanded(
              child: _DateButton(
                label: 'From',
                date: startDate,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: startDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: endDate ?? DateTime(2100),
                  );
                  onStartDateChanged?.call(date);
                },
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _DateButton(
                label: 'To',
                date: endDate,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: endDate ?? DateTime.now(),
                    firstDate: startDate ?? DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  onEndDateChanged?.call(date);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DateButton extends StatelessWidget {
  const _DateButton({
    required this.label,
    required this.onTap,
    this.date,
  });

  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: colors.surfaceVariant,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: colors.outline),
        ),
        child: Row(
          children: [
            Icon(
              Iconsax.calendar_1,
              size: 16.r,
              color: colors.textSecondary,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                date != null
                    ? '${date!.day}/${date!.month}/${date!.year}'
                    : label,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: date != null ? colors.textPrimary : colors.textTertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

