/// File: lib/admin/features/offers/views/widgets/offers_table.dart
/// Purpose: Data table widget for offers list
/// Belongs To: admin/features/offers
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../core/config/admin_responsive.dart';
import '../../../../core/constants/admin_strings.dart';
import '../../../../core/extensions/admin_context_ext.dart';
import '../../../../core/widgets/widgets.dart';
import '../../models/offer_model.dart';

/// Offers data table widget.
class OffersTable extends StatelessWidget {
  const OffersTable({
    required this.offers,
    required this.selectedIds,
    required this.onOfferTap,
    required this.onToggleSelect,
    required this.onSelectAll,
    required this.currentPage,
    required this.totalPages,
    required this.perPage,
    required this.total,
    required this.onPageChanged,
    required this.onPageSizeChanged,
    super.key,
    this.isLoading = false,
  });

  final List<OfferModel> offers;
  final Set<String> selectedIds;
  final ValueChanged<String> onOfferTap;
  final ValueChanged<String> onToggleSelect;
  final VoidCallback onSelectAll;
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
        offers.isNotEmpty && offers.every((o) => selectedIds.contains(o.id));

    return AdminCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final isMobile = screenWidth < AdminBreakpoints.tablet;
                final isTablet =
                    screenWidth >= AdminBreakpoints.tablet &&
                    screenWidth < AdminBreakpoints.desktop;

                // Responsive column sizing
                final checkboxWidth = 48.w;
                final titleWidth = isMobile
                    ? 120.w
                    : (isTablet ? 150.w : 200.w);
                final discountWidth = isMobile
                    ? 100.w
                    : (isTablet ? 120.w : 140.w);
                final statusWidth = 80.w;
                final dateWidth = isMobile ? 90.w : (isTablet ? 100.w : 110.w);
                final usesWidth = 80.w;
                final actionsWidth = isMobile
                    ? 100.w
                    : (isTablet ? 120.w : 140.w);

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: DataTable(
                      columnSpacing: 12.w,
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
                          label: SizedBox(
                            width: checkboxWidth,
                            child: Checkbox(
                              value: allSelected,
                              onChanged: offers.isEmpty
                                  ? null
                                  : (_) => onSelectAll(),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: titleWidth,
                            child: const Text(
                              'Title',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: discountWidth,
                            child: const Text(
                              'Discount',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: statusWidth,
                            child: const Text(
                              'Status',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: dateWidth,
                            child: const Text(
                              'Valid From',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: dateWidth,
                            child: const Text(
                              'Valid Until',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: usesWidth,
                            child: const Text(
                              'Uses',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: actionsWidth,
                            child: const Text(
                              'Actions',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                      rows: offers.map((offer) {
                        final isSelected = selectedIds.contains(offer.id);
                        return DataRow(
                          selected: isSelected,
                          cells: [
                            // Manual checkbox for selection
                            DataCell(
                              SizedBox(
                                width: checkboxWidth,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => onToggleSelect(offer.id),
                                  child: Checkbox(
                                    value: isSelected,
                                    onChanged: (_) => onToggleSelect(offer.id),
                                  ),
                                ),
                              ),
                            ),
                            // All other cells open detail modal on tap
                            DataCell(
                              SizedBox(
                                width: titleWidth,
                                child: GestureDetector(
                                  onTap: () => onOfferTap(offer.id),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        offer.title,
                                        style: textStyle.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      if (offer.code != null)
                                        Text(
                                          'Code: ${offer.code}',
                                          style: textStyle.copyWith(
                                            fontSize: 11.sp,
                                            color: colors.textTertiary,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: discountWidth,
                                child: GestureDetector(
                                  onTap: () => onOfferTap(offer.id),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        offer.formattedDiscount,
                                        style: textStyle.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: colors.success,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text(
                                        offer.discountType.name,
                                        style: textStyle.copyWith(
                                          fontSize: 11.sp,
                                          color: colors.textTertiary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: statusWidth,
                                child: GestureDetector(
                                  onTap: () => onOfferTap(offer.id),
                                  child: AdminStatusBadge(
                                    label: _getStatusLabel(offer.status),
                                    type: _getStatusType(offer.status),
                                    size: AdminBadgeSize.small,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: dateWidth,
                                child: GestureDetector(
                                  onTap: () => onOfferTap(offer.id),
                                  child: Text(
                                    DateFormat.yMMMd().format(offer.validFrom),
                                    style: textStyle,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: dateWidth,
                                child: GestureDetector(
                                  onTap: () => onOfferTap(offer.id),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        DateFormat.yMMMd().format(
                                          offer.validUntil,
                                        ),
                                        style: textStyle,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text(
                                        '${offer.daysUntilExpiry} days left',
                                        style: textStyle.copyWith(
                                          fontSize: 11.sp,
                                          color: offer.daysUntilExpiry < 7
                                              ? colors.error
                                              : colors.textTertiary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: usesWidth,
                                child: GestureDetector(
                                  onTap: () => onOfferTap(offer.id),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${offer.currentUses}${offer.maxUses != null ? '/${offer.maxUses}' : ''}',
                                        style: textStyle,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      if (offer.maxUses != null)
                                        Text(
                                          '${offer.remainingUses} remaining',
                                          style: textStyle.copyWith(
                                            fontSize: 11.sp,
                                            color: colors.textTertiary,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: actionsWidth,
                                child: AdminButton(
                                  size: AdminButtonSize.small,
                                  variant: AdminButtonVariant.outlined,
                                  icon: Iconsax.eye,
                                  label: isMobile
                                      ? 'View'
                                      : AdminStrings.actionViewDetails,
                                  onPressed: () => onOfferTap(offer.id),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
          _PaginationControls(
            currentPage: currentPage,
            totalPages: totalPages,
            perPage: perPage,
            total: total,
            onPageChanged: onPageChanged,
            onPageSizeChanged: onPageSizeChanged,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }

  String _getStatusLabel(OfferStatus status) {
    switch (status) {
      case OfferStatus.active:
        return AdminStrings.statusActive;
      case OfferStatus.inactive:
        return AdminStrings.statusInactive;
      case OfferStatus.scheduled:
        return AdminStrings.statusPending;
      case OfferStatus.expired:
        return AdminStrings.statusCompleted;
    }
  }

  AdminStatusType _getStatusType(OfferStatus status) {
    switch (status) {
      case OfferStatus.active:
        return AdminStatusType.success;
      case OfferStatus.inactive:
        return AdminStatusType.warning;
      case OfferStatus.scheduled:
        return AdminStatusType.info;
      case OfferStatus.expired:
        return AdminStatusType.error;
    }
  }
}

class _PaginationControls extends StatelessWidget {
  const _PaginationControls({
    required this.currentPage,
    required this.totalPages,
    required this.perPage,
    required this.total,
    required this.onPageChanged,
    required this.onPageSizeChanged,
    this.isLoading = false,
  });

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
    final start = ((currentPage - 1) * perPage) + 1;
    final end = (currentPage * perPage).clamp(0, total);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.divider)),
      ),
      child: Row(
        children: [
          Text(
            'Showing $start to $end of $total entries',
            style: TextStyle(fontSize: 12.sp, color: colors.textSecondary),
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                'Items per page:',
                style: TextStyle(fontSize: 12.sp, color: colors.textSecondary),
              ),
              SizedBox(width: 8.w),
              DropdownButton<int>(
                value: perPage,
                items: const [
                  DropdownMenuItem(value: 10, child: Text('10')),
                  DropdownMenuItem(value: 25, child: Text('25')),
                  DropdownMenuItem(value: 50, child: Text('50')),
                  DropdownMenuItem(value: 100, child: Text('100')),
                ],
                onChanged: isLoading
                    ? null
                    : (value) => onPageSizeChanged(value ?? 25),
              ),
            ],
          ),
          SizedBox(width: 16.w),
          IconButton(
            icon: const Icon(Iconsax.arrow_left_2),
            onPressed: isLoading || currentPage <= 1
                ? null
                : () => onPageChanged(currentPage - 1),
            tooltip: 'Previous page',
          ),
          Text(
            '$currentPage / $totalPages',
            style: TextStyle(fontSize: 12.sp, color: colors.textPrimary),
          ),
          IconButton(
            icon: const Icon(Iconsax.arrow_right_2),
            onPressed: isLoading || currentPage >= totalPages
                ? null
                : () => onPageChanged(currentPage + 1),
            tooltip: 'Next page',
          ),
        ],
      ),
    );
  }
}
