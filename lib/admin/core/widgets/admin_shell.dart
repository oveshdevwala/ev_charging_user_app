/// File: lib/admin/core/widgets/admin_shell.dart
/// Purpose: Main admin shell with sidebar and topbar layout
/// Belongs To: admin/core/widgets
/// Customization Guide:
///    - Modify sidebar items in AdminSidebar
///    - Adjust layout breakpoints in AdminConfig
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/admin_config.dart';
import '../config/admin_responsive.dart';
import '../extensions/admin_context_ext.dart';
import 'admin_sidebar.dart';
import 'admin_topbar.dart';

/// Main admin shell that provides sidebar + topbar layout.
class AdminShell extends StatefulWidget {
  const AdminShell({
    required this.child,
    required this.currentRoute,
    super.key,
    this.title,
    this.actions,
    this.floatingActionButton,
  });

  final Widget child;
  final String currentRoute;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  bool _isSidebarCollapsed = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Auto-collapse sidebar on smaller screens
    if (context.shouldCollapseSidebar && !_isSidebarCollapsed) {
      setState(() => _isSidebarCollapsed = true);
    }
  }

  void _toggleSidebar() {
    if (isMobileScreen(context)) {
      _scaffoldKey.currentState?.openDrawer();
    } else {
      setState(() => _isSidebarCollapsed = !_isSidebarCollapsed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;
    final isMobile = isMobileScreen(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colors.background,
      drawer: isMobile
          ? Drawer(
              width: AdminConfig.sidebarWidth,
              child: AdminSidebar(
                currentRoute: widget.currentRoute,
                isCollapsed: false,
                onItemSelected: () => Navigator.of(context).pop(),
              ),
            )
          : null,
      body: Row(
        children: [
          // Sidebar (hidden on mobile)
          if (!isMobile)
            AnimatedContainer(
              duration: AdminConfig.animationNormal,
              width: _isSidebarCollapsed
                  ? AdminConfig.sidebarCollapsedWidth
                  : AdminConfig.sidebarWidth,
              child: AdminSidebar(
                currentRoute: widget.currentRoute,
                isCollapsed: _isSidebarCollapsed,
              ),
            ),

          // Main content area
          Expanded(
            child: Column(
              children: [
                // Topbar
                AdminTopbar(
                  title: widget.title,
                  onMenuPressed: _toggleSidebar,
                  actions: widget.actions,
                ),

                // Page content
                Expanded(
                  child: Container(
                    color: colors.background,
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: widget.floatingActionButton,
    );
  }
}

/// Admin page wrapper with standard padding and scroll.
class AdminPageContent extends StatelessWidget {
  const AdminPageContent({
    required this.child,
    super.key,
    this.padding,
    this.maxWidth,
    this.scrollable = true,
  });

  final Widget child;
  final EdgeInsets? padding;
  final double? maxWidth;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final contentPadding = padding ?? getContentPadding(context);
    final effectiveMaxWidth = maxWidth ?? AdminConfig.contentMaxWidth;

    Widget content = Padding(
      padding: contentPadding,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
          child: child,
        ),
      ),
    );

    if (scrollable) {
      content = SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 24.h),
        child: content,
      );
    }

    return content;
  }
}

/// Admin page header with title and actions.
class AdminPageHeader extends StatelessWidget {
  const AdminPageHeader({
    required this.title,
    super.key,
    this.subtitle,
    this.actions,
    this.breadcrumbs,
  });

  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final List<String>? breadcrumbs;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Breadcrumbs
        if (breadcrumbs != null && breadcrumbs!.isNotEmpty) ...[
          Row(
            children: [
              for (var i = 0; i < breadcrumbs!.length; i++) ...[
                if (i > 0)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Icon(
                      Icons.chevron_right,
                      size: 16.r,
                      color: colors.textTertiary,
                    ),
                  ),
                Text(
                  breadcrumbs![i],
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: i == breadcrumbs!.length - 1
                        ? colors.textPrimary
                        : colors.textTertiary,
                    fontWeight: i == breadcrumbs!.length - 1
                        ? FontWeight.w500
                        : FontWeight.normal,
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 8.h),
        ],

        // Title and actions row
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (actions != null && actions!.isNotEmpty) ...[
              SizedBox(width: 16.w),
              ...actions!.map((action) => Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: action,
              )),
            ],
          ],
        ),
      ],
    );
  }
}

