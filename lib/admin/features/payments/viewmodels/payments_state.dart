/// File: lib/admin/features/payments/viewmodels/payments_state.dart
/// Purpose: State definitions for payments list BLoC
/// Belongs To: admin/features/payments
/// Customization Guide:
/// - Extend with pagination metadata when backend adds paging
library;

import 'package:equatable/equatable.dart';

import '../models/payment.dart';

/// Lifecycle status for payments list.
enum PaymentsStatus { initial, loading, loaded, refreshing, error }

/// State for [PaymentsBloc].
class PaymentsState extends Equatable {
  const PaymentsState({
    this.status = PaymentsStatus.initial,
    this.payments = const [],
    this.filtered = const [],
    this.statusFilter,
    this.methodFilter,
    this.searchQuery = '',
    this.error,
  });

  final PaymentsStatus status;
  final List<AdminPayment> payments;
  final List<AdminPayment> filtered;
  final AdminPaymentStatus? statusFilter;
  final AdminPaymentMethod? methodFilter;
  final String searchQuery;
  final String? error;

  bool get isLoading =>
      status == PaymentsStatus.loading || status == PaymentsStatus.refreshing;

  PaymentsState copyWith({
    PaymentsStatus? status,
    List<AdminPayment>? payments,
    List<AdminPayment>? filtered,
    AdminPaymentStatus? statusFilter,
    AdminPaymentMethod? methodFilter,
    String? searchQuery,
    String? error,
  }) {
    return PaymentsState(
      status: status ?? this.status,
      payments: payments ?? this.payments,
      filtered: filtered ?? this.filtered,
      statusFilter: statusFilter ?? this.statusFilter,
      methodFilter: methodFilter ?? this.methodFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        status,
        payments,
        filtered,
        statusFilter,
        methodFilter,
        searchQuery,
        error,
      ];
}
