/// File: lib/features/vehicle_add/presentation/view/widgets/vehicle_form_field.dart
/// Purpose: Reusable vehicle form field widget
/// Belongs To: vehicle_add feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/extensions/context_ext.dart';

/// Vehicle form field wrapper.
class VehicleFormField extends StatelessWidget {
  const VehicleFormField({
    required this.label,
    required this.child,
    this.errorText,
    this.helperText,
    super.key,
  });

  final String label;
  final Widget child;
  final String? errorText;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: context.appColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        child,
        if (errorText != null) ...[
          SizedBox(height: 4.h),
          Text(
            errorText!,
            style: TextStyle(
              fontSize: 12.sp,
              color: context.appColors.danger,
            ),
          ),
        ],
        if (helperText != null && errorText == null) ...[
          SizedBox(height: 4.h),
          Text(
            helperText!,
            style: TextStyle(
              fontSize: 12.sp,
              color: context.appColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

