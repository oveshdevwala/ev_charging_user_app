/// File: lib/features/profile/ui/payment_methods_page.dart
/// Purpose: Payment methods management screen
/// Belongs To: profile feature
/// Route: /paymentMethods
library;

import 'package:ev_charging_user_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../core/di/injection.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              PaymentBloc(repository: sl<ProfileRepository>())
                ..add(const LoadPaymentMethods()),
        ),
      ],
      child: Scaffold(
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.card, size: 64.r, color: AppColors.textTertiaryLight),
          SizedBox(height: 16.h),
          Text(
            'No payment methods',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add a payment method to get started',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(
    BuildContext context,
    PaymentMethodModel method,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: ListTile(
        leading: Icon(Iconsax.card, size: 32.r, color: AppColors.primary),
        title: Text(
          '${method.brand} •••• ${method.last4}',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'Expires ${method.formattedExpiry}',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textSecondaryLight,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (method.isDefault)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'Default',
                  style: TextStyle(fontSize: 12.sp, color: AppColors.primary),
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
                  child: const Text(
                    'Remove',
                    style: TextStyle(color: AppColors.error),
                  ),
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
    context.push(AppRoutes.addCard.path);
  }

  void _showRemoveDialog(BuildContext context, PaymentMethodModel method) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<PaymentBloc>(),
        child: AlertDialog(
          title: const Text('Remove Payment Method'),
          content: Text(
            'Are you sure you want to remove ${method.brand} •••• ${method.last4}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<PaymentBloc>().add(RemovePaymentMethod(method.id));
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Remove',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
