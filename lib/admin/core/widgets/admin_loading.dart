/// File: lib/admin/core/widgets/admin_loading.dart
/// Purpose: Loading indicator widgets for admin panel
/// Belongs To: admin/core/widgets
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/admin_context_ext.dart';

/// Full page loading indicator.
class AdminLoadingPage extends StatelessWidget {
  const AdminLoadingPage({
    super.key,
    this.message,
  });

  final String? message;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            SizedBox(height: 16.h),
            Text(
              message!,
              style: TextStyle(
                fontSize: 14.sp,
                color: colors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Loading overlay widget.
class AdminLoadingOverlay extends StatelessWidget {
  const AdminLoadingOverlay({
    required this.isLoading,
    required this.child,
    super.key,
    this.message,
  });

  final bool isLoading;
  final Widget child;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: colors.surface.withValues(alpha: 0.7),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    if (message != null) ...[
                      SizedBox(height: 16.h),
                      Text(
                        message!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Shimmer loading placeholder.
class AdminShimmer extends StatefulWidget {
  const AdminShimmer({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = 4,
  });

  final double? width;
  final double height;
  final double borderRadius;

  @override
  State<AdminShimmer> createState() => _AdminShimmerState();
}

class _AdminShimmerState extends State<AdminShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width?.w,
          height: widget.height.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius.r),
            gradient: LinearGradient(
              begin: Alignment(-1 + _animation.value, 0),
              end: Alignment(_animation.value, 0),
              colors: [
                colors.surfaceVariant,
                colors.surfaceContainerHigh,
                colors.surfaceVariant,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Skeleton loader for list items.
class AdminListSkeleton extends StatelessWidget {
  const AdminListSkeleton({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 72,
    this.padding,
  });

  final int itemCount;
  final double itemHeight;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding ?? EdgeInsets.all(16.r),
      itemCount: itemCount,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        return _SkeletonItem(height: itemHeight);
      },
    );
  }
}

class _SkeletonItem extends StatelessWidget {
  const _SkeletonItem({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Container(
      height: height.h,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: colors.outline),
      ),
      child: Row(
        children: [
          AdminShimmer(width: 48, height: 48, borderRadius: 8),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AdminShimmer(width: 120, height: 14),
                SizedBox(height: 8.h),
                AdminShimmer(width: 80, height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

