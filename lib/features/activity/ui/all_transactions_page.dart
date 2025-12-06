/// File: lib/features/activity/ui/all_transactions_page.dart
/// Purpose: View all transactions with filter and sort
/// Belongs To: activity feature
/// Route: /allTransactions
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/extensions/context_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/transaction_model.dart';
import '../../../repositories/activity_repository.dart';
import '../../../routes/app_routes.dart';
import '../widgets/transaction_card.dart';

/// Sort options for transactions.
enum TransactionSortOption {
  dateDesc('Newest First'),
  dateAsc('Oldest First'),
  amountDesc('Highest Amount'),
  amountAsc('Lowest Amount');

  const TransactionSortOption(this.label);
  final String label;
}

/// Filter options for transaction type.
enum TransactionFilterType {
  all('All'),
  moneyIn('Money In'),
  moneyOut('Money Out'),
  charging('Charging'),
  topUp('Top Up'),
  reward('Rewards');

  const TransactionFilterType(this.label);
  final String label;
}

/// All transactions page with filter and sort.
class AllTransactionsPage extends StatefulWidget {
  const AllTransactionsPage({super.key});

  @override
  State<AllTransactionsPage> createState() => _AllTransactionsPageState();
}

class _AllTransactionsPageState extends State<AllTransactionsPage> {
  TransactionSortOption _sortOption = TransactionSortOption.dateDesc;
  TransactionFilterType _filterType = TransactionFilterType.all;
  late List<TransactionModel> _allTransactions;
  List<TransactionModel> _filteredTransactions = [];

  @override
  void initState() {
    super.initState();
    _allTransactions = DummyActivityRepository().getTransactions();
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    var transactions = List<TransactionModel>.from(_allTransactions);

    // Apply filter
    switch (_filterType) {
      case TransactionFilterType.all:
        break;
      case TransactionFilterType.moneyIn:
        transactions = transactions.where((t) => t.isCredit).toList();
      case TransactionFilterType.moneyOut:
        transactions = transactions.where((t) => !t.isCredit).toList();
      case TransactionFilterType.charging:
        transactions = transactions
            .where((t) => t.type == TransactionType.charging)
            .toList();
      case TransactionFilterType.topUp:
        transactions = transactions
            .where((t) => t.type == TransactionType.topUp)
            .toList();
      case TransactionFilterType.reward:
        transactions = transactions
            .where(
              (t) =>
                  t.type == TransactionType.reward ||
                  t.type == TransactionType.referral,
            )
            .toList();
    }

    // Apply sort
    switch (_sortOption) {
      case TransactionSortOption.dateDesc:
        transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case TransactionSortOption.dateAsc:
        transactions.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      case TransactionSortOption.amountDesc:
        transactions.sort((a, b) => b.amount.abs().compareTo(a.amount.abs()));
      case TransactionSortOption.amountAsc:
        transactions.sort((a, b) => a.amount.abs().compareTo(b.amount.abs()));
    }

    setState(() {
      _filteredTransactions = transactions;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: colors.surfaceVariant,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Iconsax.arrow_left,
              size: 20.r,
              color: colors.textPrimary,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'All Transactions',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Filter & Sort Bar
          _buildFilterSortBar(context),
          // Transactions List
          Expanded(
            child: _filteredTransactions.isEmpty
                ? _buildEmptyState(context)
                : ListView.separated(
                    padding: EdgeInsets.all(20.r),
                    itemCount: _filteredTransactions.length,
                    separatorBuilder: (_, __) => SizedBox(height: 10.h),
                    itemBuilder: (context, index) {
                      final transaction = _filteredTransactions[index];
                      return TransactionCard(
                        transaction: transaction,
                        onTap: () => context.push(
                          AppRoutes.transactionDetail.id(transaction.id),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSortBar(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.outline)),
      ),
      child: Row(
        children: [
          // Filter Button
          Expanded(
            child: _buildFilterChip(
              context,
              icon: Iconsax.filter,
              label: _filterType.label,
              onTap: _showFilterSheet,
            ),
          ),
          SizedBox(width: 12.w),
          // Sort Button
          Expanded(
            child: _buildFilterChip(
              context,
              icon: Iconsax.sort,
              label: _sortOption.label,
              onTap: _showSortSheet,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final colors = context.appColors;

    return Material(
      color: colors.surfaceVariant,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18.r, color: colors.textSecondary),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                Iconsax.arrow_down_1,
                size: 14.r,
                color: colors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colors = context.appColors;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.receipt_item, size: 64.r, color: colors.textTertiary),
          SizedBox(height: 16.h),
          Text(
            'No transactions found',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try adjusting your filters',
            style: TextStyle(fontSize: 14.sp, color: colors.textTertiary),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    final colors = context.appColors;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(top: 12.h),
              decoration: BoxDecoration(
                color: colors.outline,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filter by Type',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ...TransactionFilterType.values.map(
                    (type) => _buildOptionTile(
                      context,
                      label: type.label,
                      isSelected: _filterType == type,
                      onTap: () {
                        setState(() => _filterType = type);
                        _applyFiltersAndSort();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  void _showSortSheet() {
    final colors = context.appColors;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(top: 12.h),
              decoration: BoxDecoration(
                color: colors.outline,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sort by',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ...TransactionSortOption.values.map(
                    (option) => _buildOptionTile(
                      context,
                      label: option.label,
                      isSelected: _sortOption == option,
                      onTap: () {
                        setState(() => _sortOption = option);
                        _applyFiltersAndSort();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colors = context.appColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? colors.primary : colors.textPrimary,
                  ),
                ),
              ),
              if (isSelected)
                Icon(Iconsax.tick_circle5, size: 22.r, color: colors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
