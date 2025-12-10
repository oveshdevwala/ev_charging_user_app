/// File: lib/admin/features/partners/views/widgets/partners_table.dart
/// Purpose: Data table widget for partners list
/// Belongs To: admin/features/partners
library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/admin_strings.dart';
import '../../../../core/extensions/admin_context_ext.dart';
import '../../../../core/widgets/widgets.dart';
import '../../bloc/partners_state.dart' as partners_state;
import '../../models/models.dart';

/// Partners data table widget.
class PartnersTable extends StatelessWidget {
  const PartnersTable({
    required this.partners,
    required this.selectedIds,
    required this.onPartnerTap,
    required this.onToggleSelect,
    required this.onSelectAll,
    required this.onSort,
    required this.currentPage,
    required this.totalPages,
    required this.perPage,
    required this.total,
    required this.onPageChanged,
    required this.onPageSizeChanged,
    super.key,
    this.sortState,
    this.isLoading = false,
  });

  final List<PartnerModel> partners;
  final Set<String> selectedIds;
  final ValueChanged<String> onPartnerTap;
  final ValueChanged<String> onToggleSelect;
  final VoidCallback onSelectAll;
  final void Function(String columnId, bool ascending) onSort;
  final partners_state.SortState? sortState;
  final int currentPage;
  final int totalPages;
  final int perPage;
  final int total;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onPageSizeChanged;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;
    final textStyle = TextStyle(fontSize: 12.sp, color: colors.textSecondary);
    final allSelected =
        partners.isNotEmpty &&
        partners.every((p) => selectedIds.contains(p.id));

    return AdminCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: SingleChildScrollView(
                      child: DataTable(
                        headingRowHeight: 44.h,
                        dataRowMinHeight: 64.h,
                        dataRowMaxHeight: 72.h,
                        headingTextStyle: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                        columns: [
                          // Selection checkbox column
                          DataColumn(
                            label: Checkbox(
                              value: allSelected,
                              onChanged: partners.isEmpty
                                  ? null
                                  : (_) => onSelectAll(),
                            ),
                          ),
                          _buildSortableColumn(context, 'Logo', 'logo', false),
                          _buildSortableColumn(context, 'Name', 'name', true),
                          _buildSortableColumn(context, 'Type', 'type', false),
                          const DataColumn(label: Text('Email')),
                          const DataColumn(label: Text('Country')),
                          const DataColumn(label: Text('Status')),
                          _buildSortableColumn(
                            context,
                            'Rating',
                            'rating',
                            true,
                          ),
                          _buildSortableColumn(
                            context,
                            'Created',
                            'createdAt',
                            true,
                          ),
                          const DataColumn(label: Text('Actions')),
                        ],
                        rows: partners.map((partner) {
                          final isSelected = selectedIds.contains(partner.id);
                          return DataRow(
                            selected: isSelected,
                            cells: [
                              // Checkbox
                              DataCell(
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => onToggleSelect(partner.id),
                                  child: Checkbox(
                                    value: isSelected,
                                    onChanged: (_) =>
                                        onToggleSelect(partner.id),
                                  ),
                                ),
                              ),
                              // Logo
                              DataCell(
                                GestureDetector(
                                  onTap: () => onPartnerTap(partner.id),
                                  child: partner.logoUrl != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: partner.logoUrl!,
                                            width: 40.w,
                                            height: 40.h,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Container(
                                                  width: 40.w,
                                                  height: 40.h,
                                                  color: colors.surfaceVariant,
                                                  child: Icon(
                                                    Iconsax.image,
                                                    size: 20.r,
                                                    color: colors.textTertiary,
                                                  ),
                                                ),
                                            errorWidget:
                                                (
                                                  context,
                                                  url,
                                                  error,
                                                ) => Container(
                                                  width: 40.w,
                                                  height: 40.h,
                                                  color: colors.surfaceVariant,
                                                  child: Icon(
                                                    Iconsax.image,
                                                    size: 20.r,
                                                    color: colors.textTertiary,
                                                  ),
                                                ),
                                          ),
                                        )
                                      : Container(
                                          width: 40.w,
                                          height: 40.h,
                                          decoration: BoxDecoration(
                                            color: colors.surfaceVariant,
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                          ),
                                          child: Icon(
                                            Iconsax.building,
                                            size: 20.r,
                                            color: colors.textTertiary,
                                          ),
                                        ),
                                ),
                              ),
                              // Name
                              DataCell(
                                GestureDetector(
                                  onTap: () => onPartnerTap(partner.id),
                                  child: Text(
                                    partner.name,
                                    style: textStyle.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              // Type
                              DataCell(
                                GestureDetector(
                                  onTap: () => onPartnerTap(partner.id),
                                  child: AdminStatusBadge(
                                    label: partner.typeName,
                                    type: AdminStatusType.info,
                                  ),
                                ),
                              ),
                              // Email
                              DataCell(
                                GestureDetector(
                                  onTap: () => onPartnerTap(partner.id),
                                  child: Text(partner.email, style: textStyle),
                                ),
                              ),
                              // Country
                              DataCell(
                                GestureDetector(
                                  onTap: () => onPartnerTap(partner.id),
                                  child: Text(
                                    partner.country,
                                    style: textStyle,
                                  ),
                                ),
                              ),
                              // Status
                              DataCell(
                                GestureDetector(
                                  onTap: () => onPartnerTap(partner.id),
                                  child: AdminStatusBadge(
                                    label: partner.statusName,
                                    type: _getStatusType(partner.status),
                                  ),
                                ),
                              ),
                              // Rating
                              DataCell(
                                GestureDetector(
                                  onTap: () => onPartnerTap(partner.id),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Iconsax.star1,
                                        size: 14.r,
                                        color: colors.warning,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        partner.formattedRating,
                                        style: textStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Created
                              DataCell(
                                GestureDetector(
                                  onTap: () => onPartnerTap(partner.id),
                                  child: Text(
                                    DateFormat(
                                      'MMM dd, yyyy',
                                    ).format(partner.createdAt),
                                    style: textStyle,
                                  ),
                                ),
                              ),
                              // Actions
                              DataCell(
                                AdminButton(
                                  label: AdminStrings.actionViewDetails,
                                  size: AdminButtonSize.small,
                                  variant: AdminButtonVariant.text,
                                  onPressed: () => onPartnerTap(partner.id),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          AdminTablePagination(
            currentPage: currentPage,
            totalPages: totalPages,
            totalItems: total,
            pageSize: perPage,
            onPageChanged: onPageChanged,
            onPageSizeChanged: onPageSizeChanged,
          ),
        ],
      ),
    );
  }

  DataColumn _buildSortableColumn(
    BuildContext context,
    String label,
    String columnId,
    bool sortable,
  ) {
    final isSorted = sortState?.columnId == columnId;
    final isAscending = (sortState?.ascending ?? true) == true;

    return DataColumn(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (sortable) ...[
            SizedBox(width: 4.w),
            GestureDetector(
              onTap: () => onSort(columnId, !isSorted || !isAscending),
              child: Icon(
                isSorted
                    ? (isAscending ? Iconsax.arrow_up_2 : Iconsax.arrow_down_1)
                    : Iconsax.arrow_3,
                size: 14.r,
                color: isSorted
                    ? context.adminColors.primary
                    : context.adminColors.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  AdminStatusType _getStatusType(PartnerStatus status) {
    switch (status) {
      case PartnerStatus.active:
        return AdminStatusType.success;
      case PartnerStatus.pending:
        return AdminStatusType.pending;
      case PartnerStatus.suspended:
        return AdminStatusType.error;
      case PartnerStatus.rejected:
        return AdminStatusType.rejected;
    }
  }
}
