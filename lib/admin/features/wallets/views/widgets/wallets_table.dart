/// File: lib/admin/features/wallets/views/widgets/wallets_table.dart
/// Purpose: Data table widget for wallets list
/// Belongs To: admin/features/wallets
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/admin_strings.dart';
import '../../../../core/extensions/admin_context_ext.dart';
import '../../../../core/widgets/widgets.dart';
import '../../models/wallet_model.dart';

/// Wallets data table widget.
class WalletsTable extends StatelessWidget {
  const WalletsTable({
    required this.wallets,
    required this.selectedIds,
    required this.onWalletTap,
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

  final List<WalletModel> wallets;
  final Set<String> selectedIds;
  final ValueChanged<String> onWalletTap;
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
        wallets.isNotEmpty && wallets.every((w) => selectedIds.contains(w.id));

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
                              onChanged: wallets.isEmpty
                                  ? null
                                  : (_) => onSelectAll(),
                            ),
                          ),
                          const DataColumn(label: Text('ID')),
                          const DataColumn(label: Text('User')),
                          const DataColumn(label: Text('Currency')),
                          const DataColumn(label: Text('Balance')),
                          const DataColumn(label: Text('Reserved')),
                          const DataColumn(label: Text('Available')),
                          const DataColumn(label: Text('Status')),
                          const DataColumn(label: Text('Created')),
                          const DataColumn(label: Text('Last Activity')),
                          const DataColumn(label: Text('Actions')),
                        ],
                        rows: wallets.map((wallet) {
                          final isSelected = selectedIds.contains(wallet.id);
                          return DataRow(
                            selected: isSelected,
                            cells: [
                              // Manual checkbox for selection - only toggles selection
                              DataCell(
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => onToggleSelect(wallet.id),
                                  child: Checkbox(
                                    value: isSelected,
                                    onChanged: (_) => onToggleSelect(wallet.id),
                                  ),
                                ),
                              ),
                              // All other cells open detail modal on tap
                              DataCell(
                                GestureDetector(
                                  onTap: () => onWalletTap(wallet.id),
                                  child: Text(wallet.id, style: textStyle),
                                ),
                              ),
                              DataCell(
                                GestureDetector(
                                  onTap: () => onWalletTap(wallet.id),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        wallet.userName,
                                        style: textStyle.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        wallet.userEmail,
                                        style: textStyle.copyWith(
                                          fontSize: 11.sp,
                                          color: colors.textTertiary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              DataCell(
                                GestureDetector(
                                  onTap: () => onWalletTap(wallet.id),
                                  child: Text(
                                    wallet.currencyCode,
                                    style: textStyle,
                                  ),
                                ),
                              ),
                              DataCell(
                                GestureDetector(
                                  onTap: () => onWalletTap(wallet.id),
                                  child: Text(
                                    '${wallet.currencySymbol}${wallet.balance.toStringAsFixed(2)}',
                                    style: textStyle.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                GestureDetector(
                                  onTap: () => onWalletTap(wallet.id),
                                  child: Text(
                                    '${wallet.currencySymbol}${wallet.reserved.toStringAsFixed(2)}',
                                    style: textStyle,
                                  ),
                                ),
                              ),
                              DataCell(
                                GestureDetector(
                                  onTap: () => onWalletTap(wallet.id),
                                  child: Text(
                                    '${wallet.currencySymbol}${wallet.available.toStringAsFixed(2)}',
                                    style: textStyle.copyWith(
                                      color: colors.success,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                GestureDetector(
                                  onTap: () => onWalletTap(wallet.id),
                                  child: AdminStatusBadge(
                                    label: wallet.status == WalletStatus.active
                                        ? AdminStrings.walletsStatusActive
                                        : AdminStrings.walletsStatusFrozen,
                                    type: wallet.status == WalletStatus.active
                                        ? AdminStatusType.success
                                        : AdminStatusType.warning,
                                    size: AdminBadgeSize.small,
                                  ),
                                ),
                              ),
                              DataCell(
                                GestureDetector(
                                  onTap: () => onWalletTap(wallet.id),
                                  child: Text(
                                    DateFormat.yMMMd().format(wallet.createdAt),
                                    style: textStyle,
                                  ),
                                ),
                              ),
                              DataCell(
                                GestureDetector(
                                  onTap: () => onWalletTap(wallet.id),
                                  child: Text(
                                    DateFormat.yMMMd().add_jm().format(
                                      wallet.lastActivity,
                                    ),
                                    style: textStyle,
                                  ),
                                ),
                              ),
                              DataCell(
                                AdminButton(
                                  size: AdminButtonSize.small,
                                  variant: AdminButtonVariant.outlined,
                                  icon: Iconsax.eye,
                                  label: AdminStrings.actionViewDetails,
                                  onPressed: () => onWalletTap(wallet.id),
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
            'Showing $start to $end of $total',
            style: TextStyle(fontSize: 12.sp, color: colors.textSecondary),
          ),
          const Spacer(),
          DropdownButton<int>(
            value: perPage,
            items: [10, 25, 50]
                .map(
                  (size) => DropdownMenuItem(
                    value: size,
                    child: Text('$size per page'),
                  ),
                )
                .toList(),
            onChanged: isLoading
                ? null
                : (value) => onPageSizeChanged(value ?? 10),
          ),
          SizedBox(width: 16.w),
          IconButton(
            icon: const Icon(Iconsax.arrow_left_2),
            onPressed: isLoading || currentPage <= 1
                ? null
                : () => onPageChanged(currentPage - 1),
          ),
          Text(
            'Page $currentPage of $totalPages',
            style: TextStyle(fontSize: 12.sp, color: colors.textPrimary),
          ),
          IconButton(
            icon: const Icon(Iconsax.arrow_right_2),
            onPressed: isLoading || currentPage >= totalPages
                ? null
                : () => onPageChanged(currentPage + 1),
          ),
        ],
      ),
    );
  }
}
