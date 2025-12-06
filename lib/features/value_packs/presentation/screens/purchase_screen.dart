/// File: lib/features/value_packs/presentation/screens/purchase_screen.dart
/// Purpose: Purchase flow screen for value packs
/// Belongs To: value_packs feature
/// Route: AppRoutes.purchasePack
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/extensions/context_ext.dart';
import '../../../../widgets/app_app_bar.dart';
import '../../../../widgets/common_button.dart';
import '../../../../widgets/common_text_field.dart';
import '../cubits/purchase_cubit.dart';
import '../cubits/purchase_state.dart';

/// Purchase screen for value packs.
class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({
    required this.packId,
    super.key,
  });

  final String packId;

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  final _couponController = TextEditingController();
  String? _selectedPaymentMethod;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.text;

    return BlocProvider(
      create: (context) => sl<PurchaseCubit>()..reset(),
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: AppAppBar(
          title: AppStrings.valuePackPurchase,
        ),
        body: BlocConsumer<PurchaseCubit, PurchaseState>(
          listener: (context, state) {
            if (state.isSuccess) {
              // Show success dialog
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  title: const Text('Purchase Successful!'),
                  content: const Text('Your value pack has been activated.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.popRoute();
                      },
                      child: const Text(AppStrings.ok),
                    ),
                  ],
                ),
              );
            } else if (state.isFailed) {
              context.showErrorSnackBar(state.error ?? 'Purchase failed');
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Payment Method Selection
                  Text(
                    'Payment Method',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _PaymentMethodCard(
                    method: 'Wallet',
                    icon: Iconsax.wallet,
                    isSelected: _selectedPaymentMethod == 'wallet',
                    onTap: () => setState(() => _selectedPaymentMethod = 'wallet'),
                  ),
                  SizedBox(height: 8.h),
                  _PaymentMethodCard(
                    method: 'Credit/Debit Card',
                    icon: Iconsax.card,
                    isSelected: _selectedPaymentMethod == 'card',
                    onTap: () => setState(() => _selectedPaymentMethod = 'card'),
                  ),
                  SizedBox(height: 24.h),

                  // Coupon Code
                  Text(
                    'Coupon Code (Optional)',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  CommonTextField(
                    controller: _couponController,
                    hint: 'Enter coupon code',
                    prefixIcon: Iconsax.ticket,
                  ),
                  SizedBox(height: 24.h),

                  // Terms Checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _agreeToTerms,
                        onChanged: (value) => setState(() => _agreeToTerms = value ?? false),
                      ),
                      Expanded(
                        child: Text(
                          'I agree to the terms and conditions',
                          style: textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),

                  // Purchase Button
                  CommonButton(
                    label: state.isProcessing ? 'Processing...' : AppStrings.confirm,
                    onPressed: _canPurchase() && !state.isProcessing
                        ? () {
                            context.read<PurchaseCubit>().startPurchase(
                                  packId: widget.packId,
                                  paymentMethodId: _selectedPaymentMethod ?? 'wallet',
                                  coupon: _couponController.text.isEmpty
                                      ? null
                                      : _couponController.text,
                                );
                          }
                        : null,
                    isDisabled: !_canPurchase() || state.isProcessing,
                    isLoading: state.isProcessing,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  bool _canPurchase() {
    return _selectedPaymentMethod != null && _agreeToTerms;
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({
    required this.method,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String method;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.text;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? colors.primary : colors.outline.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? colors.primary : colors.textSecondary),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                method,
                style: textTheme.bodyLarge,
              ),
            ),
            if (isSelected)
              Icon(
                Iconsax.tick_circle,
                color: colors.primary,
                size: 24.r,
              ),
          ],
        ),
      ),
    );
  }
}

