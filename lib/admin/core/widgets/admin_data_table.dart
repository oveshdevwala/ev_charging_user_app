/// File: lib/admin/core/widgets/admin_data_table.dart
/// Purpose: Reusable data table widget with sorting, filtering, pagination
/// Belongs To: admin/core/widgets
/// Customization Guide:
///    - Use AdminDataColumn for column definitions
///    - Pagination is built-in
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../config/admin_config.dart';
import '../constants/admin_strings.dart';
import '../extensions/admin_context_ext.dart';

/// Column definition for AdminDataTable.
class AdminDataColumn<T> {
  const AdminDataColumn({
    required this.id,
    required this.label,
    required this.cellBuilder,
    this.width,
    this.flex,
    this.sortable = false,
    this.alignment = Alignment.centerLeft,
  });

  final String id;
  final String label;
  final Widget Function(T item) cellBuilder;
  final double? width;
  final int? flex;
  final bool sortable;
  final Alignment alignment;
}

/// Sort state.
class SortState {
  const SortState({this.columnId, this.ascending = true});

  final String? columnId;
  final bool ascending;

  SortState copyWith({String? columnId, bool? ascending}) {
    return SortState(
      columnId: columnId ?? this.columnId,
      ascending: ascending ?? this.ascending,
    );
  }
}

/// Admin data table widget.
class AdminDataTable<T> extends StatelessWidget {
  const AdminDataTable({
    required this.columns,
    required this.items,
    super.key,
    this.sortState,
    this.onSort,
    this.onRowTap,
    this.selectedItems,
    this.onSelectionChanged,
    this.isLoading = false,
    this.emptyMessage,
    this.rowHeight,
    this.headerHeight,
  });

  final List<AdminDataColumn<T>> columns;
  final List<T> items;
  final SortState? sortState;
  final void Function(String columnId, bool ascending)? onSort;
  final void Function(T item)? onRowTap;
  final Set<T>? selectedItems;
  final void Function(Set<T> items)? onSelectionChanged;
  final bool isLoading;
  final String? emptyMessage;
  final double? rowHeight;
  final double? headerHeight;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;
    final effectiveRowHeight = rowHeight ?? AdminConfig.tableRowHeight;
    final effectiveHeaderHeight = headerHeight ?? AdminConfig.tableHeaderHeight;

    if (isLoading) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.r),
          child: const CircularProgressIndicator(),
        ),
      );
    }

    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Iconsax.document, size: 48.r, color: colors.textTertiary),
              SizedBox(height: 16.h),
              Text(
                emptyMessage ?? AdminStrings.tableNoResults,
                style: TextStyle(fontSize: 14.sp, color: colors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.tableBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          children: [
            // Header
            Container(
              height: effectiveHeaderHeight,
              color: colors.tableHeader,
              child: Row(
                children: [
                  // Selection checkbox
                  if (onSelectionChanged != null)
                    SizedBox(
                      width: 48.w,
                      child: Checkbox(
                        value:
                            selectedItems?.length == items.length &&
                            items.isNotEmpty,
                        tristate: true,
                        onChanged: (value) {
                          if (value ?? false) {
                            onSelectionChanged?.call(items.toSet());
                          } else {
                            onSelectionChanged?.call({});
                          }
                        },
                      ),
                    ),

                  // Column headers
                  ...columns.map((column) => _buildHeaderCell(context, column)),
                ],
              ),
            ),

            // Data rows
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = selectedItems?.contains(item) ?? false;

                  return _DataRow<T>(
                    item: item,
                    columns: columns,
                    height: effectiveRowHeight,
                    isSelected: isSelected,
                    onTap: onRowTap != null ? () => onRowTap!(item) : null,
                    onSelectionChanged: onSelectionChanged != null
                        ? (selected) {
                            final newSelection = Set<T>.from(
                              selectedItems ?? {},
                            );
                            if (selected) {
                              newSelection.add(item);
                            } else {
                              newSelection.remove(item);
                            }
                            onSelectionChanged!(newSelection);
                          }
                        : null,
                    isLast: index == items.length - 1,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(BuildContext context, AdminDataColumn<T> column) {
    final colors = context.adminColors;
    final isSorted = sortState?.columnId == column.id;
    final isAscending = sortState?.ascending ?? true;

    Widget cell = Padding(
      padding: EdgeInsets.symmetric(horizontal: AdminConfig.tableCellPadding.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: column.alignment == Alignment.centerRight
            ? MainAxisAlignment.end
            : column.alignment == Alignment.center
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              column.label.toUpperCase(),
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: isSorted ? colors.primary : colors.textSecondary,
                letterSpacing: 0.5,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (column.sortable) ...[
            SizedBox(width: 4.w),
            Icon(
              isSorted
                  ? (isAscending ? Iconsax.arrow_up_2 : Iconsax.arrow_down_1)
                  : Iconsax.arrow_3,
              size: 14.r,
              color: isSorted ? colors.primary : colors.textTertiary,
            ),
          ],
        ],
      ),
    );

    if (column.sortable && onSort != null) {
      cell = InkWell(
        onTap: () {
          final newAscending = !isSorted || !isAscending;
          onSort!(column.id, newAscending);
        },
        child: cell,
      );
    }

    if (column.width != null) {
      return SizedBox(width: column.width, child: cell);
    }
    return Flexible(flex: column.flex ?? 1, fit: FlexFit.tight, child: cell);
  }
}

class _DataRow<T> extends StatefulWidget {
  const _DataRow({
    required this.item,
    required this.columns,
    required this.height,
    required this.isSelected,
    required this.isLast,
    this.onTap,
    this.onSelectionChanged,
  });

  final T item;
  final List<AdminDataColumn<T>> columns;
  final double height;
  final bool isSelected;
  final bool isLast;
  final VoidCallback? onTap;
  final void Function(bool selected)? onSelectionChanged;

  @override
  State<_DataRow<T>> createState() => _DataRowState<T>();
}

class _DataRowState<T> extends State<_DataRow<T>> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.isSelected
                ? colors.primaryContainer.withValues(alpha: 0.3)
                : _isHovered
                ? colors.tableRowHover
                : colors.surface,
            border: widget.isLast
                ? null
                : Border(bottom: BorderSide(color: colors.tableBorder)),
          ),
          child: Row(
            children: [
              // Selection checkbox
              if (widget.onSelectionChanged != null)
                SizedBox(
                  width: 48.w,
                  child: Checkbox(
                    value: widget.isSelected,
                    onChanged: (value) {
                      widget.onSelectionChanged?.call(value ?? false);
                    },
                  ),
                ),

              // Data cells
              ...widget.columns.map(_buildDataCell),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataCell(AdminDataColumn<T> column) {
    final Widget cell = Padding(
      padding: EdgeInsets.symmetric(horizontal: AdminConfig.tableCellPadding.w),
      child: Align(
        alignment: column.alignment,
        child: column.cellBuilder(widget.item),
      ),
    );

    if (column.width != null) {
      return SizedBox(width: column.width, child: cell);
    }
    return Flexible(flex: column.flex ?? 1, fit: FlexFit.tight, child: cell);
  }
}

/// Pagination widget for data tables.
class AdminTablePagination extends StatelessWidget {
  const AdminTablePagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.pageSize,
    required this.onPageChanged,
    super.key,
    this.onPageSizeChanged,
    this.pageSizeOptions = AdminConfig.pageSizeOptions,
  });

  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int pageSize;
  final void Function(int page) onPageChanged;
  final void Function(int pageSize)? onPageSizeChanged;
  final List<int> pageSizeOptions;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;
    final startItem = totalItems == 0 ? 0 : (currentPage - 1) * pageSize + 1;
    final endItem = (currentPage * pageSize).clamp(0, totalItems);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.divider)),
      ),
      child: Row(
        children: [
          // Items per page
          if (onPageSizeChanged != null) ...[
            Text(
              AdminStrings.tableItemsPerPage,
              style: TextStyle(fontSize: 13.sp, color: colors.textSecondary),
            ),
            SizedBox(width: 8.w),
            DropdownButton<int>(
              value: pageSize,
              underline: const SizedBox.shrink(),
              isDense: true,
              items: pageSizeOptions.map((size) {
                return DropdownMenuItem(value: size, child: Text('$size'));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  onPageSizeChanged!(value);
                }
              },
            ),
            SizedBox(width: 24.w),
          ],

          // Showing X to Y of Z
          Text(
            'Showing $startItem to $endItem of $totalItems',
            style: TextStyle(fontSize: 13.sp, color: colors.textSecondary),
          ),

          const Spacer(),

          // Page navigation
          Row(
            children: [
              IconButton(
                onPressed: currentPage > 1 ? () => onPageChanged(1) : null,
                icon: Icon(Icons.first_page, size: 20.r),
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                onPressed: currentPage > 1
                    ? () => onPageChanged(currentPage - 1)
                    : null,
                icon: Icon(Icons.chevron_left, size: 20.r),
                visualDensity: VisualDensity.compact,
              ),
              SizedBox(width: 8.w),
              Text(
                'Page $currentPage of $totalPages',
                style: TextStyle(fontSize: 13.sp, color: colors.textPrimary),
              ),
              SizedBox(width: 8.w),
              IconButton(
                onPressed: currentPage < totalPages
                    ? () => onPageChanged(currentPage + 1)
                    : null,
                icon: Icon(Icons.chevron_right, size: 20.r),
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                onPressed: currentPage < totalPages
                    ? () => onPageChanged(totalPages)
                    : null,
                icon: Icon(Icons.last_page, size: 20.r),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
