/// File: lib/admin/features/payments/views/payment_detail_view.dart
/// Purpose: Payment detail screen with refund flow and timeline
/// Belongs To: admin/features/payments
/// Route: AdminRoutes.paymentDetail
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/admin_strings.dart';
import '../../../core/extensions/admin_context_ext.dart';
import '../../../core/widgets/admin_button.dart';
import '../../../core/widgets/admin_card.dart';
import '../../../core/widgets/admin_empty_state.dart';
import '../../../core/widgets/admin_shell.dart';
import '../../../core/widgets/admin_status_badge.dart';
import '../models/payment.dart';
import '../viewmodels/payment_detail_bloc.dart';
import '../viewmodels/payment_detail_event.dart';
import '../viewmodels/payment_detail_state.dart';
import 'widgets/payment_timeline.dart';

/// Payment detail page routed via go_router.
class PaymentDetailView extends StatelessWidget {
  const PaymentDetailView({required this.paymentId, super.key});

  final String paymentId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentDetailBloc, PaymentDetailState>(
      listener: (context, state) {
        if (state.status == PaymentDetailStatus.refundFailure &&
            state.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error ?? '')));
        }
        if (state.status == PaymentDetailStatus.refundSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(AdminStrings.paymentsRefundSuccess)),
          );
        }
      },
      builder: (context, state) {
        if (state.status == PaymentDetailStatus.loading ||
            (state.payment == null &&
                state.status != PaymentDetailStatus.error)) {
          return SizedBox(
            height: 240.h,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status == PaymentDetailStatus.error) {
          return AdminPageContent(
            child: AdminEmptyState(
              title: AdminStrings.paymentsDetailTitle,
              message: state.error,
              actionLabel: AdminStrings.actionRefresh,
              onAction: () => context.read<PaymentDetailBloc>().add(
                PaymentDetailRequested(paymentId),
              ),
            ),
          );
        }

        final payment = state.payment!;
        final colors = context.adminColors;
        final currencyFormatter = NumberFormat.simpleCurrency(
          name: payment.currency,
        );

        return AdminPageContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminPageHeader(
                title: AdminStrings.paymentsDetailTitle,
                subtitle: payment.id,
                actions: [
                  AdminButton(
                    label: AdminStrings.actionRefresh,
                    icon: Iconsax.refresh,
                    onPressed: () => context.read<PaymentDetailBloc>().add(
                      PaymentDetailRequested(paymentId),
                    ),
                  ),
                  AdminButton(
                    label: AdminStrings.paymentsRefundAction,
                    icon: Iconsax.undo,
                    variant: AdminButtonVariant.outlined,
                    onPressed: payment.status == AdminPaymentStatus.refunded
                        ? null
                        : () => context.read<PaymentDetailBloc>().add(
                            PaymentRefundRequested(payment.id),
                          ),
                    isLoading:
                        state.status == PaymentDetailStatus.refundProcessing,
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              AdminCard(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            currencyFormatter.format(payment.amount),
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                            ),
                          ),
                        ),
                        AdminStatusBadge(
                          label: _statusLabel(payment.status),
                          type: _statusType(payment.status),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 12.w,
                      runSpacing: 8.h,
                      children: [
                        _pill(
                          context,
                          icon: Iconsax.card,
                          label:
                              '${AdminStrings.paymentsMethodLabel}: ${_methodLabel(payment.method)}',
                        ),
                        _pill(
                          context,
                          icon: Iconsax.profile_tick,
                          label:
                              '${AdminStrings.paymentsUserLabel}: ${payment.userName}',
                        ),
                        _pill(
                          context,
                          icon: Iconsax.buildings,
                          label:
                              '${AdminStrings.paymentsStationLabel}: ${payment.stationName}',
                        ),
                        if (payment.sessionId != null)
                          _pill(
                            context,
                            icon: Iconsax.flash,
                            label:
                                '${AdminStrings.paymentsSessionLabel}: ${payment.sessionId}',
                          ),
                        _pill(
                          context,
                          icon: Iconsax.ticket,
                          label:
                              '${AdminStrings.paymentsReferenceLabel}: ${payment.referenceId}',
                        ),
                        _pill(
                          context,
                          icon: Iconsax.calendar_1,
                          label: DateFormat.yMMMd().add_jm().format(
                            payment.createdAt.toLocal(),
                          ),
                        ),
                      ],
                    ),
                    if (payment.notes != null) ...[
                      SizedBox(height: 12.h),
                      Text(
                        payment.notes!,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              AdminCardWithHeader(
                title: AdminStrings.paymentsTimelineTitle,
                child: PaymentTimeline(entries: payment.timeline),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _pill(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    final colors = context.adminColors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.r, color: colors.textSecondary),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, color: colors.textSecondary),
          ),
        ],
      ),
    );
  }

  AdminStatusType _statusType(AdminPaymentStatus status) {
    switch (status) {
      case AdminPaymentStatus.pending:
        return AdminStatusType.pending;
      case AdminPaymentStatus.completed:
        return AdminStatusType.completed;
      case AdminPaymentStatus.failed:
        return AdminStatusType.error;
      case AdminPaymentStatus.refunded:
        return AdminStatusType.success;
    }
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
}
