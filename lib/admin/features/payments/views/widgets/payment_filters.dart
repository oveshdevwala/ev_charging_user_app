/// File: lib/admin/features/payments/views/widgets/payment_filters.dart
/// Purpose: Search + filter row for payments list
/// Belongs To: admin/features/payments
/// Route: AdminRoutes.payments
/// Customization Guide:
/// - Add more dropdowns for date range or amount when needed
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/admin_strings.dart';
import '../../../../core/widgets/widgets.dart';
import '../../models/payment.dart';

/// Payments filter bar with search, status, and method dropdowns.
class PaymentFilters extends StatelessWidget {
  const PaymentFilters({
    super.key,
    this.status,
    this.method,
    this.onSearchChanged,
    this.onFilterChanged,
    this.onReset,
  });

  final AdminPaymentStatus? status;
  final AdminPaymentMethod? method;
  final ValueChanged<String>? onSearchChanged;
  final void Function(AdminPaymentStatus?, AdminPaymentMethod?)?
  onFilterChanged;
  final VoidCallback? onReset;

  int _getFilterCount() {
    var count = 0;
    if (status != null) count++;
    if (method != null) count++;
    return count;
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

  @override
  Widget build(BuildContext context) {
    return AdminResponsiveFilterBar(
      searchHint: AdminStrings.paymentsSearchHint,
      onSearchChanged: onSearchChanged,
      onReset: onReset,
      filterCount: _getFilterCount(),
      filterItems: [
        AdminFilterItem<AdminPaymentStatus?>(
          id: 'status',
          label: AdminStrings.paymentsFilterStatus,
          value: status,
          width: 160.w,
          items: [
            const DropdownMenuItem<AdminPaymentStatus?>(
              child: Text(AdminStrings.paymentsFiltersReset),
            ),
            ...AdminPaymentStatus.values.map(
              (value) => DropdownMenuItem<AdminPaymentStatus?>(
                value: value,
                child: Text(_statusLabel(value)),
              ),
            ),
          ],
          onChanged: (value) => onFilterChanged?.call(value, method),
        ),
        AdminFilterItem<AdminPaymentMethod?>(
          id: 'method',
          label: AdminStrings.paymentsFilterMethod,
          value: method,
          width: 160.w,
          items: [
            const DropdownMenuItem<AdminPaymentMethod?>(
              child: Text(AdminStrings.paymentsFiltersReset),
            ),
            ...AdminPaymentMethod.values.map(
              (value) => DropdownMenuItem<AdminPaymentMethod?>(
                value: value,
                child: Text(_methodLabel(value)),
              ),
            ),
          ],
          onChanged: (value) => onFilterChanged?.call(status, value),
        ),
      ],
    );
  }
}
