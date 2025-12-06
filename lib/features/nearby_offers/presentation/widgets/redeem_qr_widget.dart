/// File: lib/features/nearby_offers/presentation/widgets/redeem_qr_widget.dart
/// Purpose: Dynamic QR code with refresh timer
/// Belongs To: nearby_offers feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/extensions/context_ext.dart';
import '../../data/models/redemption_model.dart';

class RedeemQrWidget extends StatelessWidget {
  const RedeemQrWidget({required this.redemption, super.key});

  final RedemptionModel redemption;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: context.appColors.surface,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: context.appColors.textPrimary.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: QrImageView(
            data: redemption.qrCode ?? 'INVALID',
            size: 200.w,
            backgroundColor: context.appColors.surface,
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          'Show this QR code to the cashier',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.timer_outlined,
                size: 16.sp,
                color: theme.colorScheme.error,
              ),
              SizedBox(width: 8.w),
              Text(
                'Expires in ${redemption.qrCountdown}',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
