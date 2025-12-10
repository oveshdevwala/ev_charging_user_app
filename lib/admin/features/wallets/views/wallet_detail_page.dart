/// File: lib/admin/features/wallets/views/wallet_detail_page.dart
/// Purpose: Wallet detail screen with transactions, balance adjustment, freeze/unfreeze
/// Belongs To: admin/features/wallets
library;

import 'package:ev_charging_user_app/admin/features/wallets/models/wallet_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/constants/admin_strings.dart';
import '../../../core/extensions/admin_context_ext.dart';
import '../../../core/widgets/widgets.dart';
import '../bloc/wallet_detail_bloc.dart';
import '../bloc/wallet_detail_event.dart';
import '../bloc/wallet_detail_state.dart';
import 'widgets/wallet_transaction_item.dart';

/// Wallet detail page shown in modal.
class WalletDetailPage extends StatefulWidget {
  const WalletDetailPage({required this.walletId, super.key});

  final String walletId;

  @override
  State<WalletDetailPage> createState() => _WalletDetailPageState();
}

class _WalletDetailPageState extends State<WalletDetailPage> {
  final _amountController = TextEditingController();
  final _memoController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _memoController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletDetailBloc, WalletDetailState>(
      listener: (context, state) {
        if (state.error != null && state.status == WalletDetailStatus.error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error ?? '')));
        }
        if (state.successMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.successMessage ?? '')));
          _amountController.clear();
          _memoController.clear();
        }
      },
      builder: (context, state) {
        if (state.isLoading && state.wallet == null) {
          return SizedBox(
            height: 400.h,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status == WalletDetailStatus.error && state.wallet == null) {
          return AdminPageContent(
            child: AdminEmptyState(
              title: AdminStrings.walletsDetailTitle,
              message: state.error,
              actionLabel: AdminStrings.actionRefresh,
              onAction: () => context.read<WalletDetailBloc>().add(
                LoadWalletDetail(widget.walletId),
              ),
            ),
          );
        }

        if (state.wallet == null) {
          return const SizedBox(
            height: 400,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final wallet = state.wallet!;
        final colors = context.adminColors;

        return AdminPageContent(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Wallet Summary Card
                AdminCard(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  wallet.userName,
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w700,
                                    color: colors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  wallet.userEmail,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AdminStatusBadge(
                            label: wallet.status == WalletStatus.active
                                ? AdminStrings.walletsStatusActive
                                : AdminStrings.walletsStatusFrozen,
                            type: wallet.status == WalletStatus.active
                                ? AdminStatusType.success
                                : AdminStatusType.warning,
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        children: [
                          Expanded(
                            child: _MetricItem(
                              label: AdminStrings.walletsBalance,
                              value:
                                  '${wallet.currencySymbol}${wallet.balance.toStringAsFixed(2)}',
                              color: colors.primary,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: _MetricItem(
                              label: AdminStrings.walletsReserved,
                              value:
                                  '${wallet.currencySymbol}${wallet.reserved.toStringAsFixed(2)}',
                              color: colors.warning,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: _MetricItem(
                              label: AdminStrings.walletsAvailable,
                              value:
                                  '${wallet.currencySymbol}${wallet.available.toStringAsFixed(2)}',
                              color: colors.success,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      Wrap(
                        spacing: 12.w,
                        runSpacing: 12.h,
                        children: [
                          AdminButton(
                            label: AdminStrings.walletsAdjustBalance,
                            icon: Iconsax.wallet_money,
                            onPressed: state.isProcessing
                                ? null
                                : () => _showAdjustBalanceDialog(context),
                            isLoading: state.isProcessing,
                          ),
                          AdminButton(
                            label: wallet.status == WalletStatus.active
                                ? AdminStrings.walletsFreeze
                                : AdminStrings.walletsUnfreeze,
                            icon: wallet.status == WalletStatus.active
                                ? Iconsax.lock
                                : Iconsax.unlock,
                            variant: AdminButtonVariant.outlined,
                            onPressed: state.isProcessing
                                ? null
                                : () => _showFreezeDialog(context, wallet),
                            isLoading: state.isProcessing,
                          ),
                          AdminButton(
                            label: AdminStrings.walletsRefund,
                            icon: Iconsax.undo,
                            variant: AdminButtonVariant.outlined,
                            onPressed: state.isProcessing
                                ? null
                                : () => _showRefundDialog(context),
                            isLoading: state.isProcessing,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                // Transactions
                AdminCard(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            AdminStrings.walletsTransactions,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                          ),
                          const Spacer(),
                          if (state.transactionsPage > 1 ||
                              state.transactionsTotal >
                                  state.transactionsPerPage)
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Iconsax.arrow_left_2),
                                  onPressed: state.transactionsPage > 1
                                      ? () => context
                                            .read<WalletDetailBloc>()
                                            .add(
                                              LoadTransactions(
                                                walletId: widget.walletId,
                                                page:
                                                    state.transactionsPage - 1,
                                              ),
                                            )
                                      : null,
                                ),
                                Text(
                                  'Page ${state.transactionsPage}',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: colors.textSecondary,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Iconsax.arrow_right_2),
                                  onPressed:
                                      (state.transactionsPage *
                                              state.transactionsPerPage) <
                                          state.transactionsTotal
                                      ? () => context
                                            .read<WalletDetailBloc>()
                                            .add(
                                              LoadTransactions(
                                                walletId: widget.walletId,
                                                page:
                                                    state.transactionsPage + 1,
                                              ),
                                            )
                                      : null,
                                ),
                              ],
                            ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      if (state.transactions.isEmpty)
                        const AdminEmptyState(
                          title: 'No transactions',
                          message: 'No transaction history available',
                        )
                      else
                        ...state.transactions.map(
                          (txn) => WalletTransactionItem(transaction: txn),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showAdjustBalanceDialog(BuildContext context) {
    _amountController.clear();
    _memoController.clear();
    _confirmController.clear();

    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AdminDialog(
          title: AdminStrings.walletsConfirmAdjust,
          width: 500.w,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: AdminStrings.walletsAmountLabel,
                  hintText: '0.00',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: _memoController,
                decoration: InputDecoration(
                  labelText: AdminStrings.walletsMemoLabel,
                  hintText: 'Reason for adjustment',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: _confirmController,
                decoration: InputDecoration(
                  labelText: 'Type CONFIRM to proceed',
                  hintText: 'CONFIRM',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            AdminButton(
              label: AdminStrings.actionCancel,
              variant: AdminButtonVariant.outlined,
              onPressed: () => Navigator.of(context).pop(),
            ),
            AdminButton(
              label: AdminStrings.actionSave,
              onPressed: () {
                final amount = double.tryParse(_amountController.text);
                if (amount == null || _memoController.text.isEmpty) {
                  return;
                }
                if (_confirmController.text != 'CONFIRM') {
                  return;
                }
                context.read<WalletDetailBloc>().add(
                  AdjustBalance(
                    walletId: widget.walletId,
                    amount: amount,
                    memo: _memoController.text,
                  ),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showFreezeDialog(BuildContext context, WalletModel wallet) {
    _confirmController.clear();

    return showDialog(
      context: context,
      builder: (context) => AdminDialog(
        title: wallet.status == WalletStatus.active
            ? AdminStrings.walletsConfirmFreeze
            : AdminStrings.walletsConfirmUnfreeze,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are you sure you want to ${wallet.status == WalletStatus.active ? 'freeze' : 'unfreeze'} this wallet?',
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 16.h),
            AdminTextField(
              label: 'Type CONFIRM to proceed',
              controller: _confirmController,
              hint: 'CONFIRM',
            ),
          ],
        ),
        actions: [
          AdminButton(
            label: AdminStrings.actionCancel,
            variant: AdminButtonVariant.outlined,
            onPressed: () => Navigator.of(context).pop(),
          ),
          AdminButton(
            label: AdminStrings.actionSave,
            onPressed: () {
              if (_confirmController.text != 'CONFIRM') {
                return;
              }
              if (wallet.status == WalletStatus.active) {
                context.read<WalletDetailBloc>().add(
                  FreezeWallet(widget.walletId),
                );
              } else {
                context.read<WalletDetailBloc>().add(
                  UnfreezeWallet(widget.walletId),
                );
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showRefundDialog(BuildContext context) {
    _amountController.clear();
    _memoController.clear();
    _confirmController.clear();

    return showDialog(
      context: context,
      builder: (context) => AdminDialog(
        title: AdminStrings.walletsConfirmRefund,
        width: 500.w,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: AdminStrings.walletsAmountLabel,
                hintText: '0.00',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _memoController,
              decoration: InputDecoration(
                labelText: AdminStrings.walletsMemoLabel,
                hintText: 'Refund reason',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _confirmController,
              decoration: InputDecoration(
                labelText: 'Type CONFIRM to proceed',
                hintText: 'CONFIRM',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ],
        ),
        actions: [
          AdminButton(
            label: AdminStrings.actionCancel,
            variant: AdminButtonVariant.outlined,
            onPressed: () => Navigator.of(context).pop(),
          ),
          AdminButton(
            label: AdminStrings.actionSave,
            onPressed: () {
              final amount = double.tryParse(_amountController.text);
              if (amount == null || _memoController.text.isEmpty) {
                return;
              }
              if (_confirmController.text != 'CONFIRM') {
                return;
              }
              context.read<WalletDetailBloc>().add(
                ProcessRefund(
                  walletId: widget.walletId,
                  amount: amount,
                  memo: _memoController.text,
                ),
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: colors.textSecondary),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}
