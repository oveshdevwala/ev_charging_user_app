/// File: lib/features/wallet/presentation/screens/recharge_page.dart
/// Purpose: Wallet recharge screen with amount selection and payment
/// Belongs To: wallet feature
/// Route: /walletRecharge
/// Customization Guide:
///    - Modify payment methods list
///    - Add actual payment gateway integration
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/app_app_bar.dart';
import '../../../../widgets/common_button.dart';
import '../../data/repositories/wallet_repository.dart';
import '../blocs/blocs.dart';
import '../widgets/widgets.dart';

/// Recharge page for adding money to wallet.
///
/// Flow:
/// 1. Select amount (quick or custom)
/// 2. Apply promo code (optional)
/// 3. Select payment method
/// 4. Confirm and process
class RechargePage extends StatelessWidget {
  const RechargePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          RechargeCubit(walletRepository: DummyWalletRepository())
            ..loadPromoCodes(),
      child: const _RechargePageContent(),
    );
  }
}

class _RechargePageContent extends StatelessWidget {
  const _RechargePageContent();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<RechargeCubit, RechargeState>(
      listener: (context, state) {
        if (state.isSuccess) {
          _showSuccessBottomSheet(context, state);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: isDark
              ? colors.background
              : colors.background,
          appBar: const AppAppBar(title: 'Recharge Wallet'),
          body: state.isProcessingPayment
              ? _buildProcessingState(context)
              : _buildContent(context, state, isDark),
          bottomNavigationBar: state.isSuccess
              ? null
              : _buildBottomBar(context, state, isDark),
        );
      },
    );
  }

  Widget _buildProcessingState(BuildContext context) {
    final colors = context.appColors;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60.r,
            height: 60.r,
            child: const CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Processing Payment...',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          Text(
            'Please wait while we process your payment',
            style: TextStyle(
              fontSize: 14.sp,
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, RechargeState state, bool isDark) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Amount Selector
          RechargeAmountSelector(
            selectedAmount: state.selectedAmount,
            customAmount: state.customAmount,
            onAmountSelected: (amount) {
              context.read<RechargeCubit>().selectAmount(amount);
            },
            onCustomAmountChanged: (amount) {
              if (amount != null) {
                context.read<RechargeCubit>().setCustomAmount(amount);
              } else {
                context.read<RechargeCubit>().clearCustomAmount();
              }
            },
          ),

          SizedBox(height: 24.h),

          // Promo Code Section
          _buildPromoSection(context, state, isDark),

          SizedBox(height: 24.h),

          // Payment Methods
          _buildPaymentMethods(context, state, isDark),

          SizedBox(height: 24.h),

          // Order Summary
          if (state.hasValidAmount) _buildOrderSummary(context, state, isDark),
        ],
      ),
    );
  }

  Widget _buildPromoSection(
    BuildContext context,
    RechargeState state,
    bool isDark,
  ) {
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Apply Promo Code',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: isDark
                ? colors.textPrimary
                : colors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        PromoCodeInputField(
          onApply: (code) {
            context.read<RechargeCubit>().applyPromoCode(code);
          },
          onRemove: () {
            context.read<RechargeCubit>().removePromo();
          },
          isLoading: state.isApplyingPromo,
          appliedPromo: state.appliedPromo,
          discountAmount: state.discountAmount,
          errorMessage: state.promoError,
        ),

        // Available promos
        if (state.appliedPromo == null && state.availablePromos.isNotEmpty) ...[
          SizedBox(height: 16.h),
          Text(
            'Available Offers',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? colors.textSecondary
                  : colors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          ...state.availablePromos
              .take(3)
              .map(
                (promo) => Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: PromoCodeCard(
                    promo: promo,
                    onApply: () {
                      context.read<RechargeCubit>().applyPromoCode(promo.code);
                    },
                  ),
                ),
              ),
        ],
      ],
    );
  }

  Widget _buildPaymentMethods(
    BuildContext context,
    RechargeState state,
    bool isDark,
  ) {
    final colors = context.appColors;
    final methods = [
      _PaymentMethodData(
        id: 'credit_card',
        name: 'Credit Card',
        icon: Iconsax.card,
        subtitle: '**** 4532',
      ),
      _PaymentMethodData(
        id: 'debit_card',
        name: 'Debit Card',
        icon: Iconsax.card,
        subtitle: '**** 7891',
      ),
      _PaymentMethodData(
        id: 'upi',
        name: 'UPI',
        icon: Iconsax.mobile,
        subtitle: 'Google Pay, PhonePe',
      ),
      _PaymentMethodData(
        id: 'apple_pay',
        name: 'Apple Pay',
        icon: Icons.apple,
        subtitle: 'Fast & Secure',
      ),
      _PaymentMethodData(
        id: 'bank',
        name: 'Net Banking',
        icon: Iconsax.bank,
        subtitle: 'All major banks',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: isDark
                ? colors.textPrimary
                : colors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        ...methods.map(
          (method) => _PaymentMethodTile(
            method: method,
            isSelected: state.selectedPaymentMethod == method.id,
            onTap: () {
              context.read<RechargeCubit>().selectPaymentMethod(method.id);
            },
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary(BuildContext context, RechargeState state, bool isDark) {
    final colors = context.appColors;
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark
            ? colors.surfaceVariant
            : colors.surfaceVariant,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? colors.textPrimary
                  : colors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          _buildSummaryRow(context,
            'Recharge Amount',
            '\$${state.effectiveAmount.toStringAsFixed(2)}',
            isDark,
          ),
          if (state.hasPromo) ...[
            SizedBox(height: 8.h),
            _buildSummaryRow(context,
              'Discount (${state.appliedPromo!.code})',
              '-\$${state.discountAmount.toStringAsFixed(2)}',
              isDark,
              valueColor: AppColors.success,
            ),
          ],
          SizedBox(height: 8.h),
          Divider(
            color: isDark ? colors.outline : colors.outline,
          ),
          SizedBox(height: 8.h),
          _buildSummaryRow(context,
            'Total',
            '\$${state.finalAmount.toStringAsFixed(2)}',
            isDark,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value,
    bool isDark, {
    Color? valueColor,
    bool isBold = false,
  }) {final colors = context.appColors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            color: isDark
                ? colors.textSecondary
                : colors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 18.sp : 14.sp,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color:
                valueColor ??
                (isDark
                    ? colors.textPrimary
                    : colors.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    RechargeState state,
    bool isDark,
  ) {final colors = context.appColors;
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? colors.surface : colors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (state.hasValidAmount)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark
                          ? colors.textSecondary
                          : colors.textSecondary,
                    ),
                  ),
                  Text(
                    '\$${state.finalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            SizedBox(height: 12.h),
            CommonButton(
              label: 'Pay \$${state.finalAmount.toStringAsFixed(2)}',
              onPressed: state.canProceedToPayment
                  ? () => context.read<RechargeCubit>().processPayment()
                  : null,
              isDisabled: !state.canProceedToPayment,
              icon: Iconsax.wallet_check,
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessBottomSheet(BuildContext context, RechargeState state) {
    showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) => _SuccessBottomSheet(
        amount: state.effectiveAmount,
        transactionId: state.lastTransaction?.id ?? '',
        onDone: () {
          Navigator.pop(ctx);
          context.pop();
        },
      ),
    );
  }
}

class _PaymentMethodData {
  _PaymentMethodData({
    required this.id,
    required this.name,
    required this.icon,
    required this.subtitle,
  });
  final String id;
  final String name;
  final IconData icon;
  final String subtitle;
}

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({
    required this.method,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  final _PaymentMethodData method;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primaryContainer
              : (isDark
                    ? colors.surfaceVariant
                    : colors.surface),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? colors.outline : colors.outline),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : (isDark
                          ? colors.surface
                          : colors.surfaceVariant),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                method.icon,
                color: isSelected
                    ? AppColors.primary
                    : (isDark
                          ? colors.textSecondary
                          : colors.textSecondary),
                size: 22.r,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? colors.textPrimary
                          : colors.textPrimary,
                    ),
                  ),
                  Text(
                    method.subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isDark
                          ? colors.textTertiary
                          : colors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: EdgeInsets.all(4.r),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: context.appColors.surface,
                  size: 14.r,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SuccessBottomSheet extends StatelessWidget {
  const _SuccessBottomSheet({
    required this.amount,
    required this.transactionId,
    required this.onDone,
  });

  final double amount;
  final String transactionId;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: EdgeInsets.all(24.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80.r,
            height: 80.r,
            decoration:  BoxDecoration(
              color: colors.successContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Iconsax.tick_circle,
              color: AppColors.success,
              size: 48.r,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Payment Successful!',
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8.h),
          Text(
            '\$${amount.toStringAsFixed(2)} added to your wallet',
            style: TextStyle(
              fontSize: 16.sp,
              color: colors.textSecondary,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: colors.surfaceVariant,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              'Transaction ID: $transactionId',
              style: TextStyle(
                fontSize: 12.sp,
                color: colors.textTertiary,
              ),
            ),
          ),
          SizedBox(height: 32.h),
          CommonButton(label: 'Done', onPressed: onDone),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
