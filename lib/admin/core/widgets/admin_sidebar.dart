/// File: lib/admin/core/widgets/admin_sidebar.dart
/// Purpose: Admin panel sidebar navigation
/// Belongs To: admin/core/widgets
/// Customization Guide:
///    - Modify sidebarItems list to add/remove menu items
///    - Adjust styling in SidebarItem widget
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../config/admin_config.dart';
import '../constants/admin_strings.dart';
import '../extensions/admin_context_ext.dart';
import '../theme/admin_colors.dart';
import '../../routes/admin_routes.dart';

/// Sidebar navigation item data.
class SidebarItemData {
  const SidebarItemData({
    required this.title,
    required this.icon,
    required this.route,
    this.children,
    this.badge,
  });

  final String title;
  final IconData icon;
  final AdminRoutes route;
  final List<SidebarItemData>? children;
  final int? badge;
}

/// Sidebar section data.
class SidebarSectionData {
  const SidebarSectionData({
    required this.title,
    required this.items,
  });

  final String title;
  final List<SidebarItemData> items;
}

/// Admin sidebar widget.
class AdminSidebar extends StatefulWidget {
  const AdminSidebar({
    required this.currentRoute,
    super.key,
    this.isCollapsed = false,
    this.onItemSelected,
  });

  final String currentRoute;
  final bool isCollapsed;
  final VoidCallback? onItemSelected;

  @override
  State<AdminSidebar> createState() => _AdminSidebarState();
}

class _AdminSidebarState extends State<AdminSidebar> {
  final Set<String> _expandedItems = {};

  /// Sidebar sections with items.
  static const List<SidebarSectionData> _sections = [
    SidebarSectionData(
      title: 'MAIN',
      items: [
        SidebarItemData(
          title: AdminStrings.navDashboard,
          icon: Iconsax.home_2,
          route: AdminRoutes.dashboard,
        ),
      ],
    ),
    SidebarSectionData(
      title: 'MANAGEMENT',
      items: [
        SidebarItemData(
          title: AdminStrings.navStations,
          icon: Iconsax.gas_station,
          route: AdminRoutes.stations,
        ),
        SidebarItemData(
          title: AdminStrings.navManagers,
          icon: Iconsax.user_octagon,
          route: AdminRoutes.managers,
        ),
        SidebarItemData(
          title: AdminStrings.navUsers,
          icon: Iconsax.people,
          route: AdminRoutes.users,
        ),
        SidebarItemData(
          title: AdminStrings.navSessions,
          icon: Iconsax.flash_1,
          route: AdminRoutes.sessions,
        ),
      ],
    ),
    SidebarSectionData(
      title: 'FINANCIAL',
      items: [
        SidebarItemData(
          title: AdminStrings.navPayments,
          icon: Iconsax.card,
          route: AdminRoutes.payments,
        ),
        SidebarItemData(
          title: AdminStrings.navWallets,
          icon: Iconsax.wallet_3,
          route: AdminRoutes.wallets,
        ),
        SidebarItemData(
          title: AdminStrings.navOffers,
          icon: Iconsax.discount_shape,
          route: AdminRoutes.offers,
        ),
      ],
    ),
    SidebarSectionData(
      title: 'ENGAGEMENT',
      items: [
        SidebarItemData(
          title: AdminStrings.navPartners,
          icon: Iconsax.building_4,
          route: AdminRoutes.partners,
        ),
        SidebarItemData(
          title: AdminStrings.navReviews,
          icon: Iconsax.star,
          route: AdminRoutes.reviews,
        ),
      ],
    ),
    SidebarSectionData(
      title: 'SYSTEM',
      items: [
        SidebarItemData(
          title: AdminStrings.navReports,
          icon: Iconsax.chart_2,
          route: AdminRoutes.reports,
        ),
        SidebarItemData(
          title: AdminStrings.navContent,
          icon: Iconsax.document_text,
          route: AdminRoutes.content,
        ),
        SidebarItemData(
          title: AdminStrings.navMedia,
          icon: Iconsax.gallery,
          route: AdminRoutes.media,
        ),
        SidebarItemData(
          title: AdminStrings.navLogs,
          icon: Iconsax.document_code_2,
          route: AdminRoutes.logs,
        ),
        SidebarItemData(
          title: AdminStrings.navSettings,
          icon: Iconsax.setting_2,
          route: AdminRoutes.settings,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return Container(
      width: widget.isCollapsed
          ? AdminConfig.sidebarCollapsedWidth
          : AdminConfig.sidebarWidth,
      height: double.infinity,
      decoration: BoxDecoration(
        color: colors.sidebar,
        border: Border(
          right: BorderSide(
            color: colors.divider,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Logo section
          _buildLogo(context),

          // Navigation items
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: widget.isCollapsed ? 8.w : 12.w,
                vertical: 8.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final section in _sections) ...[
                    _buildSection(context, section),
                    SizedBox(height: 16.h),
                  ],
                ],
              ),
            ),
          ),

          // Bottom section (user profile / logout)
          _buildBottomSection(context),
        ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    final colors = context.adminColors;

    return Container(
      height: AdminConfig.topbarHeight,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.divider,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              gradient: AdminColors.primaryGradient,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Iconsax.flash_15,
              color: AdminColors.onPrimary,
              size: 20.r,
            ),
          ),
          if (!widget.isCollapsed) ...[
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EV Charging',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                  Text(
                    'Admin Panel',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: colors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, SidebarSectionData section) {
    final colors = context.adminColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.isCollapsed)
          Padding(
            padding: EdgeInsets.only(left: 12.w, bottom: 8.h),
            child: Text(
              section.title,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: colors.textTertiary,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ...section.items.map((item) => _buildItem(context, item)),
      ],
    );
  }

  Widget _buildItem(BuildContext context, SidebarItemData item) {
    final colors = context.adminColors;
    final isSelected = widget.currentRoute.startsWith(item.route.path);
    final hasChildren = item.children != null && item.children!.isNotEmpty;
    final isExpanded = _expandedItems.contains(item.title);

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (hasChildren) {
                setState(() {
                  if (isExpanded) {
                    _expandedItems.remove(item.title);
                  } else {
                    _expandedItems.add(item.title);
                  }
                });
              } else {
                context.go(item.route.path);
                widget.onItemSelected?.call();
              }
            },
            borderRadius: BorderRadius.circular(8.r),
            child: AnimatedContainer(
              duration: AdminConfig.animationFast,
              padding: EdgeInsets.symmetric(
                horizontal: widget.isCollapsed ? 12.w : 12.w,
                vertical: 10.h,
              ),
              decoration: BoxDecoration(
                color: isSelected ? colors.sidebarActive : Colors.transparent,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(
                    item.icon,
                    size: 20.r,
                    color: isSelected ? colors.primary : colors.textSecondary,
                  ),
                  if (!widget.isCollapsed) ...[
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? colors.primary : colors.textPrimary,
                        ),
                      ),
                    ),
                    if (item.badge != null)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: colors.error,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          '${item.badge}',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.onError,
                          ),
                        ),
                      ),
                    if (hasChildren)
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        size: 20.r,
                        color: colors.textTertiary,
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
        // Children items
        if (hasChildren && isExpanded && !widget.isCollapsed)
          Padding(
            padding: EdgeInsets.only(left: 32.w),
            child: Column(
              children: item.children!.map((child) => _buildItem(context, child)).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    final colors = context.adminColors;

    return Container(
      padding: EdgeInsets.all(widget.isCollapsed ? 8.r : 12.r),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colors.divider,
            width: 1,
          ),
        ),
      ),
      child: widget.isCollapsed
          ? IconButton(
              onPressed: () {
                // Logout action
              },
              icon: Icon(
                Iconsax.logout,
                color: colors.textSecondary,
                size: 20.r,
              ),
            )
          : Row(
              children: [
                CircleAvatar(
                  radius: 18.r,
                  backgroundColor: colors.primary,
                  child: Text(
                    'AD',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.onPrimary,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Admin User',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                      Text(
                        'admin@evcharging.com',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: colors.textTertiary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Logout action
                  },
                  icon: Icon(
                    Iconsax.logout,
                    color: colors.textSecondary,
                    size: 18.r,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
    );
  }
}

