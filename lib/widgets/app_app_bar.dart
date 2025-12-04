/// File: lib/widgets/app_app_bar.dart
/// Purpose: Reusable app bar widget with customization options
/// Belongs To: shared
/// Customization Guide:
///    - Customize via parameters (title, actions, leading, etc.)

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Reusable app bar widget.
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.bottom,
  });
  
  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final PreferredSizeWidget? bottom;
  
  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight + (bottom?.preferredSize.height ?? 0),
  );
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canPop = Navigator.of(context).canPop();
    
    return AppBar(
      title: titleWidget ?? (title != null
          ? Text(
              title!,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: foregroundColor ?? theme.appBarTheme.foregroundColor,
              ),
            )
          : null),
      leading: leading ?? (showBackButton && canPop
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20.r,
              ),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null),
      automaticallyImplyLeading: showBackButton,
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      elevation: elevation ?? 0,
      scrolledUnderElevation: 0.5,
      bottom: bottom,
    );
  }
}

/// Sliver app bar variant.
class AppSliverAppBar extends StatelessWidget {
  const AppSliverAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.expandedHeight,
    this.flexibleSpace,
    this.pinned = true,
    this.floating = false,
    this.snap = false,
  });
  
  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? expandedHeight;
  final Widget? flexibleSpace;
  final bool pinned;
  final bool floating;
  final bool snap;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canPop = Navigator.of(context).canPop();
    
    return SliverAppBar(
      title: titleWidget ?? (title != null
          ? Text(
              title!,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: foregroundColor ?? theme.appBarTheme.foregroundColor,
              ),
            )
          : null),
      leading: leading ?? (showBackButton && canPop
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20.r,
              ),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null),
      automaticallyImplyLeading: showBackButton,
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      expandedHeight: expandedHeight,
      flexibleSpace: flexibleSpace,
      pinned: pinned,
      floating: floating,
      snap: snap,
    );
  }
}

