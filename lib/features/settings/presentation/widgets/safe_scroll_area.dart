/// File: lib/features/settings/presentation/widgets/safe_scroll_area.dart
/// Purpose: Safe scroll area wrapper to prevent overflow
/// Belongs To: settings feature
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Safe scroll area widget.
class SafeScrollArea extends StatelessWidget {
  const SafeScrollArea({
    required this.child,
    this.padding,
    this.physics,
    super.key,
  });

  final Widget child;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: physics ?? const AlwaysScrollableScrollPhysics(),
        padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: child,
      ),
    );
  }
}

