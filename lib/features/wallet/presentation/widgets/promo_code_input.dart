/// File: lib/features/wallet/presentation/widgets/promo_code_input.dart
/// Purpose: Promo code input field with validation
/// Belongs To: wallet feature
/// Customization Guide:
///    - Modify validation messages
///    - Add animation for success/error states
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/promo_code_model.dart';

/// Promo code input field with apply button.
///
/// Features:
/// - Auto-uppercase input
/// - Loading state during validation
/// - Success state with discount display
/// - Error state with message
class PromoCodeInputField extends StatefulWidget {
  const PromoCodeInputField({
    required this.onApply,
    super.key,
    this.onRemove,
    this.isLoading = false,
    this.appliedPromo,
    this.discountAmount = 0.0,
    this.errorMessage,
    this.hintText = 'Enter promo code',
  });

  final void Function(String code) onApply;
  final VoidCallback? onRemove;
  final bool isLoading;
  final PromoCodeModel? appliedPromo;
  final double discountAmount;
  final String? errorMessage;
  final String hintText;

  @override
  State<PromoCodeInputField> createState() => _PromoCodeInputFieldState();
}

class _PromoCodeInputFieldState extends State<PromoCodeInputField> {
  late TextEditingController _controller;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // If promo is applied, show success state
    if (widget.appliedPromo != null) {
      return _buildAppliedState(isDark);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: isDark
                ? colors.surfaceVariant
                : colors.surfaceVariant,
            borderRadius: BorderRadius.circular(12.r),
            border: widget.errorMessage != null
                ? Border.all(color: colors.danger, width: 1.5)
                : null,
          ),
          child: Row(
            children: [
              SizedBox(width: 12.w),
              Icon(
                Iconsax.ticket_discount,
                color: isDark
                    ? colors.textTertiary
                    : colors.textTertiary,
                size: 20.r,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  textCapitalization: TextCapitalization.characters,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    color: isDark
                        ? colors.textPrimary
                        : colors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0,
                      color: isDark
                          ? colors.textTertiary
                          : colors.textTertiary,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  onSubmitted: (_) => _applyPromo(),
                ),
              ),
              _buildApplyButton(isDark),
              SizedBox(width: 8.w),
            ],
          ),
        ),
        if (widget.errorMessage != null) ...[
          SizedBox(height: 6.h),
          Row(
            children: [
              Icon(Iconsax.info_circle, size: 14.r, color: colors.danger),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  widget.errorMessage!,
                  style: TextStyle(fontSize: 12.sp, color: colors.danger),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildApplyButton(bool isDark) {
    if (widget.isLoading) {
      return Container(
        padding: EdgeInsets.all(12.r),
        child: SizedBox(
          width: 18.r,
          height: 18.r,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: _applyPromo,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          'Apply',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: context.appColors.surface,
          ),
        ),
      ),
    );
  }

  Widget _buildAppliedState(bool isDark) {
    final promo = widget.appliedPromo!;

    final colors = context.appColors;
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: colors.successContainer,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Iconsax.tick_circle,
                  color: AppColors.success,
                  size: 16.r,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      promo.code,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.successContainer,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      promo.title ?? promo.formattedDiscount,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: widget.onRemove,
                child: Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: context.appColors.surface,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Icon(
                    Iconsax.close_circle,
                    color: colors.danger,
                    size: 16.r,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: context.appColors.surface,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'You save: ',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: colors.textSecondary,
                  ),
                ),
                Text(
                  '\$${widget.discountAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _applyPromo() {
    final code = _controller.text.trim();
    if (code.isNotEmpty) {
      widget.onApply(code);
    }
  }
}

/// Available promo code card for selection
class PromoCodeCard extends StatelessWidget {
  const PromoCodeCard({
    required this.promo,
    required this.onApply,
    super.key,
    this.isSelected = false,
  });

  final PromoCodeModel promo;
  final VoidCallback onApply;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onApply,
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primaryContainer
              : (isDark
                    ? colors.surfaceVariant
                    : colors.surfaceVariant),
          borderRadius: BorderRadius.circular(12.r),
          border: isSelected
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
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Iconsax.ticket_discount,
                color: AppColors.primary,
                size: 20.r,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    promo.code,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? colors.textPrimary
                          : colors.textPrimary,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    promo.title ?? promo.description ?? promo.formattedDiscount,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isDark
                          ? colors.textSecondary
                          : colors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                promo.formattedDiscount,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: context.appColors.surface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
