/// File: lib/widgets/loading_wrapper.dart
/// Purpose: Reusable loading state wrapper widget
/// Belongs To: shared
/// Customization Guide:
///    - Use for loading, error, and empty states
///    - Customize loading indicator, error, and empty widgets
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_colors.dart';
import 'common_button.dart';

/// Loading wrapper that handles loading, error, and empty states.
class LoadingWrapper extends StatelessWidget {
  const LoadingWrapper({
    required this.isLoading, required this.child, super.key,
    this.error,
    this.isEmpty = false,
    this.onRetry,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
    this.emptyTitle,
    this.emptyMessage,
    this.emptyIcon,
  });
  
  final bool isLoading;
  final Widget child;
  final String? error;
  final bool isEmpty;
  final VoidCallback? onRetry;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Widget? emptyWidget;
  final String? emptyTitle;
  final String? emptyMessage;
  final IconData? emptyIcon;
  
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loadingWidget ?? const LoadingIndicator();
    }
    
    if (error != null) {
      return errorWidget ?? ErrorStateWidget(
        message: error!,
        onRetry: onRetry,
      );
    }
    
    if (isEmpty) {
      return emptyWidget ?? EmptyStateWidget(
        title: emptyTitle ?? AppStrings.noDataFound,
        message: emptyMessage,
        icon: emptyIcon,
        onAction: onRetry,
        actionLabel: onRetry != null ? AppStrings.retry : null,
      );
    }
    
    return child;
  }
}

/// Loading indicator widget.
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.size,
    this.strokeWidth,
    this.color,
    this.message,
  });
  
  final double? size;
  final double? strokeWidth;
  final Color? color;
  final String? message;
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size ?? 40.r,
            height: size ?? 40.r,
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth ?? 3,
              valueColor: AlwaysStoppedAnimation(
                color ?? Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          if (message != null) ...[
            SizedBox(height: 16.h),
            Text(
              message!,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondaryLight,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Error state widget.
class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({
    required this.message, super.key,
    this.onRetry,
    this.icon,
    this.title,
  });
  
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;
  final String? title;
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.error_outline_rounded,
              size: 64.r,
              color: AppColors.error,
            ),
            SizedBox(height: 16.h),
            Text(
              title ?? AppStrings.errorOccurred,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              SizedBox(height: 24.h),
              CommonButton(
                label: AppStrings.retry,
                onPressed: onRetry,
                isFullWidth: false,
                icon: Icons.refresh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty state widget.
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    required this.title, super.key,
    this.message,
    this.icon,
    this.image,
    this.onAction,
    this.actionLabel,
  });
  
  final String title;
  final String? message;
  final IconData? icon;
  final Widget? image;
  final VoidCallback? onAction;
  final String? actionLabel;
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (image != null)
              image!
            else
              Icon(
                icon ?? Icons.inbox_outlined,
                size: 80.r,
                color: AppColors.textTertiaryLight,
              ),
            SizedBox(height: 24.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              SizedBox(height: 8.h),
              Text(
                message!,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondaryLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onAction != null && actionLabel != null) ...[
              SizedBox(height: 24.h),
              CommonButton(
                label: actionLabel!,
                onPressed: onAction,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Shimmer loading placeholder.
class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({
    required this.width, required this.height, super.key,
    this.borderRadius,
  });
  
  final double width;
  final double height;
  final double? borderRadius;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.outlineLight,
        borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
      ),
    );
  }
}

