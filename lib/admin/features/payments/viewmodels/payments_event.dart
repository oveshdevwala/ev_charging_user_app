/// File: lib/admin/features/payments/viewmodels/payments_event.dart
/// Purpose: Event definitions for payments list BLoC
/// Belongs To: admin/features/payments
/// Customization Guide:
/// - Add new events when introducing pagination/sorting
library;

import 'package:equatable/equatable.dart';

import '../models/payment.dart';

/// Base payments event.
abstract class PaymentsEvent extends Equatable {
  const PaymentsEvent();

  @override
  List<Object?> get props => [];
}

/// Load initial payments.
class PaymentsLoadRequested extends PaymentsEvent {
  const PaymentsLoadRequested();
}

/// Refresh payments from data source.
class PaymentsRefreshRequested extends PaymentsEvent {
  const PaymentsRefreshRequested();
}

/// Apply status and method filters.
class PaymentsFilterApplied extends PaymentsEvent {
  const PaymentsFilterApplied({
    this.status,
    this.method,
  });

  final AdminPaymentStatus? status;
  final AdminPaymentMethod? method;

  @override
  List<Object?> get props => [status, method];
}

/// Apply search query.
class PaymentsSearchRequested extends PaymentsEvent {
  const PaymentsSearchRequested(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Clear all filters and search.
class PaymentsFiltersReset extends PaymentsEvent {
  const PaymentsFiltersReset();
}
