/// File: lib/admin/features/payments/viewmodels/payments_bloc.dart
/// Purpose: Payments list BLoC (ViewModel) handling load/search/filter
/// Belongs To: admin/features/payments
/// Customization Guide:
/// - Wire to real repository when backend is available
library;

import 'package:bloc/bloc.dart';

import '../datasource/payments_local_datasource.dart';
import '../models/payment.dart';
import 'payments_event.dart';
import 'payments_state.dart';

/// Handles payments list state with caching, search, and filters.
class PaymentsBloc extends Bloc<PaymentsEvent, PaymentsState> {
  PaymentsBloc({required this.dataSource}) : super(const PaymentsState()) {
    on<PaymentsLoadRequested>(_onLoadRequested);
    on<PaymentsRefreshRequested>(_onRefreshRequested);
    on<PaymentsFilterApplied>(_onFilterApplied);
    on<PaymentsSearchRequested>(_onSearchRequested);
    on<PaymentsFiltersReset>(_onFiltersReset);
  }

  final PaymentsLocalDataSource dataSource;

  Future<void> _onLoadRequested(
    PaymentsLoadRequested event,
    Emitter<PaymentsState> emit,
  ) async {
    emit(state.copyWith(status: PaymentsStatus.loading));
    try {
      final payments = await dataSource.fetchPayments();
      final filtered = _applyFilters(
        payments,
        status: state.statusFilter,
        method: state.methodFilter,
        query: state.searchQuery,
      );

      emit(
        state.copyWith(
          status: PaymentsStatus.loaded,
          payments: payments,
          filtered: filtered,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: PaymentsStatus.error, error: e.toString()));
    }
  }

  Future<void> _onRefreshRequested(
    PaymentsRefreshRequested event,
    Emitter<PaymentsState> emit,
  ) async {
    emit(state.copyWith(status: PaymentsStatus.refreshing));
    try {
      final payments = await dataSource.fetchPayments(forceRefresh: true);
      final filtered = _applyFilters(
        payments,
        status: state.statusFilter,
        method: state.methodFilter,
        query: state.searchQuery,
      );
      emit(
        state.copyWith(
          status: PaymentsStatus.loaded,
          payments: payments,
          filtered: filtered,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: PaymentsStatus.error, error: e.toString()));
    }
  }

  void _onFilterApplied(
    PaymentsFilterApplied event,
    Emitter<PaymentsState> emit,
  ) {
    final filtered = _applyFilters(
      state.payments,
      status: event.status,
      method: event.method,
      query: state.searchQuery,
    );

    emit(
      state.copyWith(
        status: PaymentsStatus.loaded,
        filtered: filtered,
        statusFilter: event.status,
        methodFilter: event.method,
      ),
    );
  }

  void _onSearchRequested(
    PaymentsSearchRequested event,
    Emitter<PaymentsState> emit,
  ) {
    final filtered = _applyFilters(
      state.payments,
      status: state.statusFilter,
      method: state.methodFilter,
      query: event.query,
    );

    emit(
      state.copyWith(
        status: PaymentsStatus.loaded,
        filtered: filtered,
        searchQuery: event.query,
      ),
    );
  }

  void _onFiltersReset(
    PaymentsFiltersReset event,
    Emitter<PaymentsState> emit,
  ) {
    emit(
      state.copyWith(
        status: PaymentsStatus.loaded,
        filtered: state.payments,
        searchQuery: '',
      ),
    );
  }

  List<AdminPayment> _applyFilters(
    List<AdminPayment> payments, {
    AdminPaymentStatus? status,
    AdminPaymentMethod? method,
    String? query,
  }) {
    final normalizedQuery = (query ?? '').toLowerCase().trim();
    return payments.where((payment) {
      final matchesStatus = status == null || payment.status == status;
      final matchesMethod = method == null || payment.method == method;

      final matchesQuery =
          normalizedQuery.isEmpty ||
          payment.id.toLowerCase().contains(normalizedQuery) ||
          payment.transactionId.toLowerCase().contains(normalizedQuery) ||
          payment.stationName.toLowerCase().contains(normalizedQuery);

      return matchesStatus && matchesMethod && matchesQuery;
    }).toList();
  }
}
