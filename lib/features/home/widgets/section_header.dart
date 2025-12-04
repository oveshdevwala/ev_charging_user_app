/// File: lib/features/home/widgets/section_header.dart
/// Purpose: Reusable section header with title and optional action
/// Belongs To: home feature
/// Customization Guide:
///    - Customize text styles via params
///    - onViewAll is optional for sections without "See All"
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';

/// Section header widget with title and optional view all action.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title, super.key,
    this.onViewAll,
    this.actionText,
    this.showAction = true,
    this.titleStyle,
    this.actionStyle,
    this.padding,
  });

  /// Section title text.
  final String title;

  /// Callback when view all is tapped.
  final VoidCallback? onViewAll;

  /// Custom action text (defaults to "See All").
  final String? actionText;

  /// Whether to show the action button.
  final bool showAction;

  /// Custom title text style.
  final TextStyle? titleStyle;

  /// Custom action text style.
  final TextStyle? actionStyle;

  /// Custom padding.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: titleStyle ??
                  TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryLight,
                    letterSpacing: -0.3,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (showAction && onViewAll != null)
            GestureDetector(
              onTap: onViewAll,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
                child: Text(
                  actionText ?? AppStrings.seeAll,
                  style: actionStyle ??
                      TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

