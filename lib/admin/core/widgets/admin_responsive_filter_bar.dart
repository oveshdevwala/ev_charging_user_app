/// File: lib/admin/core/widgets/admin_responsive_filter_bar.dart
/// Purpose: Responsive filter bar widget that adapts to screen sizes
/// Belongs To: admin/core/widgets
/// Customization Guide:
///   - Use filterItems to define filter dropdowns
///   - searchHint for search placeholder text
///   - onSearchChanged for search callback
///   - onReset for clearing all filters
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../config/admin_responsive.dart';
import '../constants/admin_strings.dart';
import '../extensions/admin_context_ext.dart';
import 'admin_button.dart';
import 'admin_search_bar.dart';

/// Configuration for a single filter dropdown item.
/// Each item builds its own dropdown widget to preserve type information.
class AdminFilterItem<T> {
  const AdminFilterItem({
    required this.id,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
    this.width,
  });

  /// Unique identifier for this filter
  final String id;

  /// Label displayed above the dropdown
  final String label;

  /// Current selected value
  final T? value;

  /// Dropdown menu items
  final List<DropdownMenuItem<T>> items;

  /// Callback when value changes
  final ValueChanged<T?> onChanged;

  /// Optional fixed width for the filter
  final double? width;

  /// Builds the dropdown widget for this filter item
  Widget build(BuildContext context) {
    final colors = context.adminColors;
    return SizedBox(
      width: width ?? 160.w,
      child: DropdownButtonFormField<T>(
        initialValue: value,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 10.h,
          ),
          isDense: true,
        ),
        style: TextStyle(fontSize: 13.sp, color: colors.textPrimary),
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}

/// Responsive filter bar that adapts to different screen sizes.
/// - Desktop: Single row with all filters
/// - Tablet: Two rows - search on top, filters below
/// - Mobile: Stacked with collapsible filter section
class AdminResponsiveFilterBar extends StatefulWidget {
  const AdminResponsiveFilterBar({
    required this.filterItems,
    super.key,
    this.searchController,
    this.searchHint,
    this.onSearchChanged,
    this.onReset,
    this.showFilterButton = false,
    this.filterCount = 0,
    this.actions = const [],
    this.showResetButton = true,
  });

  /// List of filter dropdown configurations
  final List<AdminFilterItem<Object?>> filterItems;

  /// Optional search controller
  final TextEditingController? searchController;

  /// Search bar hint text
  final String? searchHint;

  /// Search callback
  final ValueChanged<String>? onSearchChanged;

  /// Reset all filters callback
  final VoidCallback? onReset;

  /// Show filter toggle button (for mobile)
  final bool showFilterButton;

  /// Number of active filters (shown on filter button badge)
  final int filterCount;

  /// Additional action buttons
  final List<Widget> actions;

  /// Whether to show the reset button
  final bool showResetButton;

  @override
  State<AdminResponsiveFilterBar> createState() =>
      _AdminResponsiveFilterBarState();
}

class _AdminResponsiveFilterBarState extends State<AdminResponsiveFilterBar> {
  bool _showFilters = true;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isMobile = screenWidth < AdminBreakpoints.tablet;
        final isTablet =
            screenWidth >= AdminBreakpoints.tablet &&
            screenWidth < AdminBreakpoints.desktop;

        if (isMobile) {
          return _buildMobileLayout(context);
        } else if (isTablet) {
          return _buildTabletLayout(context);
        } else {
          return _buildDesktopLayout(context);
        }
      },
    );
  }

  /// Mobile layout - stacked with collapsible filters
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Search bar with filter toggle
        Row(
          children: [
            Expanded(
              child: AdminSearchBar(
                hint: widget.searchHint ?? 'Search...',
                controller: widget.searchController,
                onChanged: widget.onSearchChanged,
              ),
            ),
            SizedBox(width: 8.w),
            _FilterToggleButton(
              isExpanded: _showFilters,
              filterCount: widget.filterCount,
              onPressed: () {
                setState(() {
                  _showFilters = !_showFilters;
                });
              },
            ),
          ],
        ),
        // Collapsible filters section
        if (_showFilters) ...[
          SizedBox(height: 12.h),
          _buildFilterGrid(context, crossAxisCount: 2),
        ],
        // Actions
        if (widget.actions.isNotEmpty) ...[
          SizedBox(height: 12.h),
          Wrap(spacing: 8.w, runSpacing: 8.h, children: widget.actions),
        ],
      ],
    );
  }

  /// Tablet layout - search on top, filters in row below
  Widget _buildTabletLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Search bar
        AdminSearchBar(
          hint: widget.searchHint ?? 'Search...',
          controller: widget.searchController,
          onChanged: widget.onSearchChanged,
        ),
        SizedBox(height: 12.h),
        // Filters in horizontal scrollable row
        _buildScrollableFiltersRow(context),
      ],
    );
  }

  /// Desktop layout - all in single row
  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        // Search bar - flexible
        Expanded(
          flex: 2,
          child: AdminSearchBar(
            hint: widget.searchHint ?? 'Search...',
            controller: widget.searchController,
            onChanged: widget.onSearchChanged,
          ),
        ),
        SizedBox(width: 16.w),
        // Filters - scrollable if needed
        Expanded(flex: 3, child: _buildScrollableFiltersRow(context)),
      ],
    );
  }

  /// Builds a scrollable horizontal row of filters
  Widget _buildScrollableFiltersRow(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Each filter item builds itself to preserve type info
          ...widget.filterItems.map((item) {
            return Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: item.build(context),
            );
          }),
          ...widget.actions.map((action) {
            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: action,
            );
          }),
          if (widget.showResetButton && widget.onReset != null)
            AdminButton(
              label: AdminStrings.filterClear,
              variant: AdminButtonVariant.outlined,
              size: AdminButtonSize.small,
              icon: Iconsax.refresh,
              onPressed: widget.onReset,
            ),
        ],
      ),
    );
  }

  /// Builds a grid of filters for mobile
  Widget _buildFilterGrid(BuildContext context, {required int crossAxisCount}) {
    final children = <Widget>[
      // Each filter item builds itself to preserve type info
      ...widget.filterItems.map((item) => item.build(context)),
      if (widget.showResetButton && widget.onReset != null)
        AdminButton(
          label: AdminStrings.filterClear,
          variant: AdminButtonVariant.outlined,
          size: AdminButtonSize.small,
          icon: Iconsax.refresh,
          onPressed: widget.onReset,
        ),
    ];

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: children.map((child) {
        if (child is AdminButton) {
          return child;
        }
        return SizedBox(
          width: (MediaQuery.of(context).size.width - 48.w) / crossAxisCount,
          child: child,
        );
      }).toList(),
    );
  }
}

/// Filter toggle button for mobile
class _FilterToggleButton extends StatelessWidget {
  const _FilterToggleButton({
    required this.isExpanded,
    required this.filterCount,
    required this.onPressed,
  });

  final bool isExpanded;
  final int filterCount;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Material(
      color: isExpanded ? colors.primaryContainer : colors.surfaceVariant,
      borderRadius: BorderRadius.circular(8.r),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.all(12.r),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                isExpanded ? Iconsax.arrow_up_2 : Iconsax.filter,
                size: 20.r,
                color: isExpanded ? colors.primary : colors.textSecondary,
              ),
              if (filterCount > 0)
                Positioned(
                  right: -6.w,
                  top: -6.h,
                  child: Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      color: colors.error,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$filterCount',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: colors.onError,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
