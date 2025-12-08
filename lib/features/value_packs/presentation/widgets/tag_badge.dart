/// File: lib/features/value_packs/presentation/widgets/tag_badge.dart
/// Purpose: Tag badge widget for displaying pack tags
/// Belongs To: value_packs feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_ext.dart';

/// Tag badge widget.
class TagBadge extends StatelessWidget {
  const TagBadge({
    required this.label,
    this.color,
    super.key,
  });

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.text;
    final badgeColor = color ?? colors.primary;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: badgeColor.withOpacity(0.3),
        ),
      ),
      child: Text(
        label,
        style: textTheme.labelSmall?.copyWith(
          fontSize: 10.sp,
          color: badgeColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

