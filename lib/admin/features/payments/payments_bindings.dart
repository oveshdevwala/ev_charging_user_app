/// File: lib/admin/features/payments/payments_bindings.dart
/// Purpose: Helper factory for wiring blocs/datasource for payments module
/// Belongs To: admin/features/payments
/// Customization Guide:
/// - Swap datasource with API implementation while preserving factory helpers
library;

import 'datasource/payments_local_datasource.dart';
import 'viewmodels/payment_detail_bloc.dart';
import 'viewmodels/payments_bloc.dart';

/// Simple binding helper to keep bloc creation consistent across routes.
class PaymentsBindings {
  PaymentsBindings({PaymentsLocalDataSource? dataSource})
    : dataSource = dataSource ?? PaymentsLocalDataSource();

  /// Shared singleton for module wiring.
  static final PaymentsBindings instance = PaymentsBindings();

  final PaymentsLocalDataSource dataSource;

  PaymentsBloc paymentsBloc() => PaymentsBloc(dataSource: dataSource);

  PaymentDetailBloc paymentDetailBloc() =>
      PaymentDetailBloc(dataSource: dataSource);
}
