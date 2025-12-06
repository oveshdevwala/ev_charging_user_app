/// File: lib/features/wallet/presentation/widgets/recharge_amount_selector.dart
/// Purpose: Quick amount selector grid for wallet recharge
/// Belongs To: wallet feature
/// Customization Guide:
///    - Modify predefined amounts via quickAmounts
///    - Adjust grid layout and styling
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';

/// Amount selector for wallet recharge.
///
/// Features:
/// - Predefined quick amounts grid
/// - Custom amount input
/// - Selection highlight
class RechargeAmountSelector extends StatefulWidget {
  const RechargeAmountSelector({
    required this.selectedAmount,
    required this.onAmountSelected,
    required this.onCustomAmountChanged,
    super.key,
    this.quickAmounts = const [10, 25, 50, 100, 200, 500],
    this.currency = r'$',
    this.customAmount,
    this.minAmount = 10,
    this.maxAmount = 10000,
  });

  final double selectedAmount;
  final void Function(double) onAmountSelected;
  final void Function(double?) onCustomAmountChanged;
  final List<double> quickAmounts;
  final String currency;
  final double? customAmount;
  final double minAmount;
  final double maxAmount;

  @override
  State<RechargeAmountSelector> createState() => _RechargeAmountSelectorState();
}

class _RechargeAmountSelectorState extends State<RechargeAmountSelector> {
  late TextEditingController _customController;
  bool _isCustomFocused = false;

  @override
  void initState() {
    super.initState();
    _customController = TextEditingController(
      text: widget.customAmount?.toStringAsFixed(0) ?? '',
    );
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Amount',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: isDark
                ? colors.textPrimary
                : colors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10.h,
            crossAxisSpacing: 10.w,
            childAspectRatio: 1.4,
          ),
          itemCount: widget.quickAmounts.length,
          itemBuilder: (context, index) {
            final amount = widget.quickAmounts[index];
            final isSelected =
                widget.selectedAmount == amount && widget.customAmount == null;

            return _AmountChip(
              amount: amount,
              currency: widget.currency,
              isSelected: isSelected,
              onTap: () {
                _customController.clear();
                widget.onAmountSelected(amount);
              },
            );
          },
        ),
        SizedBox(height: 16.h),
        _buildCustomAmountInput(isDark),
      ],
    );
  }

  Widget _buildCustomAmountInput(bool isDark) {
    final hasCustomAmount =
        widget.customAmount != null && widget.customAmount! > 0;

    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Or enter custom amount',
          style: TextStyle(
            fontSize: 12.sp,
            color: isDark
                ? colors.textSecondary
                : colors.textSecondary,
          ),
        ),
        SizedBox(height: 8.h),
        DecoratedBox(
          decoration: BoxDecoration(
            color: isDark
                ? colors.surfaceVariant
                : colors.surfaceVariant,
            borderRadius: BorderRadius.circular(12.r),
            border: _isCustomFocused || hasCustomAmount
                ? Border.all(color: AppColors.primary, width: 2)
                : Border.all(
                    color: isDark
                        ? colors.outline
                        : colors.outline,
                  ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(11.r),
                    bottomLeft: Radius.circular(11.r),
                  ),
                ),
                child: Text(
                  widget.currency,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _customController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? colors.textPrimary
                        : colors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter amount',
                    hintStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: isDark
                          ? colors.textTertiary
                          : colors.textTertiary,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 14.h,
                    ),
                  ),
                  onTap: () {
                    setState(() => _isCustomFocused = true);
                  },
                  onChanged: (value) {
                    if (value.isEmpty) {
                      widget.onCustomAmountChanged(null);
                    } else {
                      final amount = double.tryParse(value);
                      widget.onCustomAmountChanged(amount);
                    }
                  },
                  onSubmitted: (_) {
                    setState(() => _isCustomFocused = false);
                  },
                ),
              ),
              if (_customController.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _customController.clear();
                    widget.onCustomAmountChanged(null);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(12.r),
                    child: Icon(
                      Iconsax.close_circle,
                      color: isDark
                          ? colors.textTertiary
                          : colors.textTertiary,
                      size: 20.r,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Min: ${widget.currency}${widget.minAmount.toStringAsFixed(0)} • Max: ${widget.currency}${widget.maxAmount.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 11.sp,
            color: isDark
                ? colors.textTertiary
                : colors.textTertiary,
          ),
        ),
      ],
    );
  }
}

class _AmountChip extends StatelessWidget {
  const _AmountChip({
    required this.amount,
    required this.currency,
    required this.isSelected,
    required this.onTap,
  });

  final double amount;
  final String currency;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark
                    ? colors.surfaceVariant
                    : colors.surfaceVariant),
          borderRadius: BorderRadius.circular(12.r),
          border: isSelected
              ? null
              : Border.all(
                  color: isDark
                      ? colors.outline
                      : colors.outline,
                ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8.r,
                    offset: Offset(0, 4.h),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            '$currency${amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: isSelected
                  ? context.appColors.surface
                  : (isDark
                        ? colors.textPrimary
                        : colors.textPrimary),
            ),
          ),
        ),
      ),
    );
  }
}
