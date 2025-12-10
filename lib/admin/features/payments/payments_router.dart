/// File: lib/admin/features/payments/payments_router.dart
/// Purpose: GoRouter definitions for payments module
/// Belongs To: admin/features/payments
/// Customization Guide:
/// - Extend with additional nested routes if needed
library;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../routes/admin_routes.dart';
import 'payments_bindings.dart';
import 'viewmodels/payment_detail_bloc.dart';
import 'viewmodels/payment_detail_event.dart';
import 'views/payment_detail_view.dart';

/// Payments GoRouter helpers to keep wiring scoped per route.
class PaymentsRouter {
  PaymentsRouter._();

  static List<RouteBase> routes(PaymentsBindings bindings) => [
    GoRoute(
      path: '${AdminRoutes.paymentDetail.path}/:id',
      name: AdminRoutes.paymentDetail.name,
      builder: (context, state) {
        final paymentId = state.pathParameters['id'] ?? '';
        return BlocProvider<PaymentDetailBloc>(
          create: (_) =>
              bindings.paymentDetailBloc()
                ..add(PaymentDetailRequested(paymentId)),
          child: PaymentDetailView(paymentId: paymentId),
        );
      },
    ),
  ];
}
