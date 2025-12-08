/// File: lib/features/value_packs/presentation/widgets/feature_chip.dart
/// Purpose: Feature chip widget for displaying pack features
/// Belongs To: value_packs feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/extensions/context_ext.dart';

/// Feature chip widget.
class FeatureChip extends StatelessWidget {
  const FeatureChip({
    required this.label,
    this.icon,
    super.key,
  });

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.text;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: colors.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon ?? Iconsax.tick_circle,
              size: 16.r,
              color: colors.success,
            ),
            SizedBox(width: 8.w),
          ],
          Flexible(
            child: Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                fontSize: 13.sp,
                color: colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

