/// File: lib/admin/features/payments/datasource/payments_local_datasource.dart
/// Purpose: Dummy local data source for payments with delay/error simulation
/// Belongs To: admin/features/payments
/// Customization Guide:
/// - Replace with real API integration
/// - Toggle [simulateError] for error-state previews
library;

import 'dart:async';

import '../../../core/constants/admin_assets.dart';
import '../../../core/utils/admin_helpers.dart';
import '../models/payment.dart';

/// Local data source that loads payments from bundled JSON and simulates latency.
class PaymentsLocalDataSource {
  PaymentsLocalDataSource({
    this.simulateError = false,
    this.artificialDelay = const Duration(milliseconds: 600),
  });

  bool simulateError;
  final Duration artificialDelay;

  List<AdminPayment> _cache = [];
  bool _isInitialized = false;

  /// Load all payments, using cached values unless [forceRefresh] is true.
  Future<List<AdminPayment>> fetchPayments({bool forceRefresh = false}) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('payments_fetch_failed');

    if (!_isInitialized || forceRefresh) {
      final data = await AdminHelpers.loadJsonAsset(AdminAssets.jsonPayments)
          as List<dynamic>;
      _cache = data
          .map((item) =>
              AdminPayment.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
      _isInitialized = true;
    }

    return _clonePayments(_cache);
  }

  /// Get a single payment by id.
  Future<AdminPayment> fetchPaymentById(String id) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('payment_detail_failed');

    if (!_isInitialized) {
      await fetchPayments();
    }

    final payment =
        _cache.firstWhere((p) => p.id == id, orElse: () => throw Exception('payment_not_found'));
    return payment.copyWith(
      timeline: payment.timeline.map((t) => t.copyWith()).toList(),
    );
  }

  /// Request a refund and update cached entry.
  Future<AdminPayment> requestRefund(String id) async {
    await Future<void>.delayed(artificialDelay);
    if (simulateError) throw Exception('refund_failed');

    if (!_isInitialized) {
      await fetchPayments();
    }

    final index = _cache.indexWhere((p) => p.id == id);
    if (index == -1) throw Exception('payment_not_found');

    final now = DateTime.now().toUtc();
    final payment = _cache[index];
    final updatedTimeline = [
      ...payment.timeline.map((t) => t.copyWith()),
      AdminPaymentTimelineEntry(
        title: 'Refunded',
        description: 'Refund issued',
        timestamp: now,
        status: AdminPaymentStatus.refunded,
      ),
    ];

    final updated = payment.copyWith(
      status: AdminPaymentStatus.refunded,
      updatedAt: now,
      timeline: updatedTimeline,
    );

    _cache[index] = updated;
    return updated.copyWith(
      timeline: updated.timeline.map((t) => t.copyWith()).toList(),
    );
  }

  List<AdminPayment> _clonePayments(List<AdminPayment> payments) {
    return payments
        .map(
          (p) => p.copyWith(
            timeline: p.timeline.map((t) => t.copyWith()).toList(),
          ),
        )
        .toList();
  }
}
