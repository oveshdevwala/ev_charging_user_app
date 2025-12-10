/// File: lib/admin/features/payments/views/payments_list_view.dart
/// Purpose: Payments list screen with search, filters, refresh, and cards
/// Belongs To: admin/features/payments
/// Route: AdminRoutes.payments
/// Customization Guide:
/// - Replace dummy datasource via [PaymentsBindings] when API is ready
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/admin_strings.dart';
import '../../../core/extensions/admin_context_ext.dart';
import '../../../core/widgets/widgets.dart';
import '../models/payment.dart';
import '../payments_bindings.dart';
import '../viewmodels/payment_detail_bloc.dart';
import '../viewmodels/payment_detail_event.dart';
import '../viewmodels/payments_bloc.dart';
import '../viewmodels/payments_event.dart';
import '../viewmodels/payments_state.dart';
import 'payment_detail_view.dart';
import 'widgets/payment_filters.dart';

/// Entry widget wiring PaymentsBloc to the view.
class PaymentsListView extends StatelessWidget {
  PaymentsListView({super.key, PaymentsBindings? bindings})
    : bindings = bindings ?? PaymentsBindings.instance;

  final PaymentsBindings bindings;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          bindings.paymentsBloc()..add(const PaymentsLoadRequested()),
      child: _PaymentsListBody(bindings: bindings),
    );
  }
}

class _PaymentsListBody extends StatelessWidget {
  const _PaymentsListBody({required this.bindings});

  final PaymentsBindings bindings;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentsBloc, PaymentsState>(
      listener: (context, state) {
        if (state.status == PaymentsStatus.error && state.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error ?? '')));
        }
      },
      builder: (context, state) {
        final payments = state.filtered;

        return AdminPageContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminPageHeader(
                title: AdminStrings.paymentsTitle,
                subtitle: AdminStrings.paymentsListTitle,
                actions: [
                  AdminButton(
                    label: AdminStrings.paymentsRefresh,
                    icon: Iconsax.refresh,
                    onPressed: () => context.read<PaymentsBloc>().add(
                      const PaymentsRefreshRequested(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              PaymentFilters(
                status: state.statusFilter,
                method: state.methodFilter,
                onSearchChanged: (query) => context.read<PaymentsBloc>().add(
                  PaymentsSearchRequested(query),
                ),
                onFilterChanged: (status, method) => context
                    .read<PaymentsBloc>()
                    .add(PaymentsFilterApplied(status: status, method: method)),
                onReset: () => context.read<PaymentsBloc>().add(
                  const PaymentsFiltersReset(),
                ),
              ),
              SizedBox(height: 16.h),
              if (state.status == PaymentsStatus.loading)
                SizedBox(
                  height: 320.h,
                  child: const AdminListSkeleton(
                    itemCount: 6,
                    padding: EdgeInsets.all(0),
                  ),
                )
              else if (state.status == PaymentsStatus.error)
                AdminEmptyState(
                  title: AdminStrings.paymentsEmptyState,
                  message: state.error,
                  actionLabel: AdminStrings.actionRefresh,
                  onAction: () => context.read<PaymentsBloc>().add(
                    const PaymentsLoadRequested(),
                  ),
                )
              else if (payments.isEmpty)
                AdminEmptyState(
                  title: AdminStrings.paymentsEmptyState,
                  actionLabel: AdminStrings.actionRefresh,
                  onAction: () => context.read<PaymentsBloc>().add(
                    const PaymentsRefreshRequested(),
                  ),
                )
              else
                _PaymentsTable(payments: payments, bindings: bindings),
            ],
          ),
        );
      },
    );
  }
}

class _PaymentsTable extends StatelessWidget {
  const _PaymentsTable({required this.payments, required this.bindings});

  final List<AdminPayment> payments;
  final PaymentsBindings bindings;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;
    final textStyle = TextStyle(fontSize: 12.sp, color: colors.textSecondary);

    return AdminCard(
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 44.h,
          dataRowMinHeight: 64.h,
          dataRowMaxHeight: 72.h,
          headingTextStyle: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
          columns: const [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Station')),
            DataColumn(label: Text('User')),
            DataColumn(label: Text('Amount')),
            DataColumn(label: Text('Method')),
            DataColumn(label: Text('Created')),
            DataColumn(label: Text('Actions')),
          ],
          rows: payments.map((payment) {
            return DataRow(
              cells: [
                DataCell(Text(payment.id, style: textStyle)),
                DataCell(
                  AdminStatusBadge(
                    label: _statusLabel(payment.status),
                    type: _statusType(payment.status),
                    size: AdminBadgeSize.small,
                  ),
                ),
                DataCell(Text(payment.stationName, style: textStyle)),
                DataCell(Text(payment.userName, style: textStyle)),
                DataCell(
                  Text(
                    '${payment.currency} ${payment.amount.toStringAsFixed(2)}',
                    style: textStyle,
                  ),
                ),
                DataCell(Text(_methodLabel(payment.method), style: textStyle)),
                DataCell(
                  Text(
                    DateFormat.yMMMd().add_jm().format(
                      payment.createdAt.toLocal(),
                    ),
                    style: textStyle,
                  ),
                ),
                DataCell(
                  Row(
                    children: [
                      AdminButton(
                        size: AdminButtonSize.small,
                        variant: AdminButtonVariant.outlined,
                        icon: Iconsax.eye,
                        label: AdminStrings.actionViewDetails,
                        onPressed: () => _openDetail(context, payment.id),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  String _statusLabel(AdminPaymentStatus status) {
    switch (status) {
      case AdminPaymentStatus.pending:
        return AdminStrings.statusPending;
      case AdminPaymentStatus.completed:
        return AdminStrings.statusCompleted;
      case AdminPaymentStatus.failed:
        return AdminStrings.statusFailed;
      case AdminPaymentStatus.refunded:
        return AdminStrings.statusRefunded;
    }
  }

  AdminStatusType _statusType(AdminPaymentStatus status) {
    switch (status) {
      case AdminPaymentStatus.pending:
        return AdminStatusType.pending;
      case AdminPaymentStatus.completed:
        return AdminStatusType.success;
      case AdminPaymentStatus.failed:
        return AdminStatusType.error;
      case AdminPaymentStatus.refunded:
        return AdminStatusType.warning;
    }
  }

  String _methodLabel(AdminPaymentMethod method) {
    switch (method) {
      case AdminPaymentMethod.card:
        return AdminStrings.paymentsMethodCard;
      case AdminPaymentMethod.wallet:
        return AdminStrings.paymentsMethodWallet;
      case AdminPaymentMethod.upi:
        return AdminStrings.paymentsMethodUpi;
    }
  }

  Future<void> _openDetail(BuildContext context, String paymentId) {
    return AdminModalSheet.show(
      context: context,
      maxWidth: 1100,
      child: BlocProvider<PaymentDetailBloc>(
        create: (_) =>
            bindings.paymentDetailBloc()
              ..add(PaymentDetailRequested(paymentId)),
        child: PaymentDetailView(paymentId: paymentId),
      ),
    );
  }
}
