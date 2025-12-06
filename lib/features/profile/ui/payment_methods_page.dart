/// File: lib/features/profile/ui/payment_methods_page.dart
/// Purpose: Payment methods management screen
/// Belongs To: profile feature
/// Route: /paymentMethods
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/context_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/common_button.dart';
import '../bloc/bloc.dart';
import '../models/models.dart';
import '../repositories/repositories.dart';

/// Payment methods page.
class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              PaymentBloc(repository: sl<ProfileRepository>())
                ..add(const LoadPaymentMethods()),
        ),
      ],
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(title: const Text('Payment Methods')),
        body: BlocBuilder<PaymentBloc, PaymentState>(
          builder: (context, state) {
            if (state.isLoading && state.paymentMethods.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Expanded(
                  child: state.paymentMethods.isEmpty
                      ? _buildEmptyState(context)
                      : ListView.builder(
                          padding: EdgeInsets.all(20.r),
                          itemCount: state.paymentMethods.length,
                          itemBuilder: (context, index) {
                            final method = state.paymentMethods[index];
                            return _buildPaymentMethodCard(context, method);
                          },
                        ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.r),
                  child: CommonButton(
                    label: 'Add Payment Method',
                    onPressed: () => _showAddCardDialog(context),
                    icon: Iconsax.add,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colors = context.appColors;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.card, size: 64.r, color: colors.textTertiary),
          SizedBox(height: 16.h),
          Text(
            'No payment methods',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add a payment method to get started',
            style: TextStyle(fontSize: 14.sp, color: colors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(
    BuildContext context,
    PaymentMethodModel method,
  ) {
    final colors = context.appColors;

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: ListTile(
        leading: Icon(Iconsax.card, size: 32.r, color: colors.primary),
        title: Text(
          '${method.brand} •••• ${method.last4}',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
        subtitle: Text(
          'Expires ${method.formattedExpiry}',
          style: TextStyle(fontSize: 14.sp, color: colors.textSecondary),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (method.isDefault)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'Default',
                  style: TextStyle(fontSize: 12.sp, color: colors.primary),
                ),
              ),
            SizedBox(width: 8.w),
            PopupMenuButton(
              itemBuilder: (context) => [
                if (!method.isDefault)
                  PopupMenuItem(
                    child: const Text('Set as Default'),
                    onTap: () {
                      context.read<PaymentBloc>().add(
                        SetDefaultPaymentMethod(method.id),
                      );
                    },
                  ),
                PopupMenuItem(
                  child: Text('Remove', style: TextStyle(color: colors.danger)),
                  onTap: () {
                    _showRemoveDialog(context, method);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCardDialog(BuildContext context) {
    // TODO: Implement add card dialog
  }

  void _showRemoveDialog(BuildContext context, PaymentMethodModel method) {
    final colors = context.appColors;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text(
          'Remove Payment Method',
          style: TextStyle(color: colors.textPrimary),
        ),
        content: Text(
          'Are you sure you want to remove ${method.brand} •••• ${method.last4}?',
          style: TextStyle(color: colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: colors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<PaymentBloc>().add(RemovePaymentMethod(method.id));
              Navigator.pop(context);
            },
            child: Text('Remove', style: TextStyle(color: colors.danger)),
          ),
        ],
      ),
    );
  }
}
