/// File: lib/admin/features/admin_main/view/admin_main_page.dart
/// Purpose: Main admin page with tab-based navigation using IndexedStack
/// Belongs To: admin/features/admin_main
/// Customization Guide:
///    - Add new tabs by adding to _views list
///    - Update _routeToIndex to map routes to indices
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/core.dart';
import '../../../routes/admin_routes.dart';
import '../../dashboard/view/dashboard_page.dart';
import '../../stations/view/stations_list_page.dart';

/// Main admin page that manages tab switching within AdminShell.
/// Uses IndexedStack for instant tab switching while maintaining URL sync for browser navigation.
/// Widget instance persists across tab changes - only IndexedStack index updates.
class AdminMainPage extends StatefulWidget {
  const AdminMainPage({
    super.key,
    required this.initialRoute,
  });

  final AdminRoutes initialRoute;

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  /// Map of routes to view indices.
  static const Map<AdminRoutes, int> _routeToIndex = {
    AdminRoutes.dashboard: 0,
    AdminRoutes.stations: 1,
    AdminRoutes.managers: 2,
    AdminRoutes.users: 3,
    AdminRoutes.sessions: 4,
    AdminRoutes.payments: 5,
    AdminRoutes.wallets: 6,
    AdminRoutes.offers: 7,
    AdminRoutes.partners: 8,
    AdminRoutes.reviews: 9,
    AdminRoutes.reports: 10,
    AdminRoutes.content: 11,
    AdminRoutes.media: 12,
    AdminRoutes.logs: 13,
    AdminRoutes.settings: 14,
  };

  /// Reverse map: index to route.
  static final Map<int, AdminRoutes> _indexToRoute = {
    for (var entry in _routeToIndex.entries) entry.value: entry.key,
  };

  /// List of main view widgets (one per tab) - created once and kept in memory.
  final List<Widget> _views = [
    const DashboardPage(),
    const StationsListPage(),
    const _PlaceholderView(title: AdminStrings.navManagers),
    const _PlaceholderView(title: AdminStrings.navUsers),
    const _PlaceholderView(title: AdminStrings.navSessions),
    const _PlaceholderView(title: AdminStrings.navPayments),
    const _PlaceholderView(title: AdminStrings.navWallets),
    const _PlaceholderView(title: AdminStrings.navOffers),
    const _PlaceholderView(title: AdminStrings.navPartners),
    const _PlaceholderView(title: AdminStrings.navReviews),
    const _PlaceholderView(title: AdminStrings.navReports),
    const _PlaceholderView(title: AdminStrings.navContent),
    const _PlaceholderView(title: AdminStrings.navMedia),
    const _PlaceholderView(title: AdminStrings.navLogs),
    const _PlaceholderView(title: AdminStrings.navSettings),
  ];

  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = _routeToIndex[widget.initialRoute] ?? 0;
  }

  @override
  void didUpdateWidget(AdminMainPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update index if navigated from URL change (browser back/forward)
    if (widget.initialRoute != oldWidget.initialRoute) {
      final newIndex = _routeToIndex[widget.initialRoute] ?? 0;
      if (newIndex != _currentIndex) {
        setState(() {
          _currentIndex = newIndex;
        });
      }
    }
  }

  /// Handle tab selection - updates UI and syncs URL for browser navigation.
  void _onViewChanged(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
      // Update URL to reflect current tab (supports browser back/forward)
      final route = _indexToRoute[index];
      if (route != null) {
        context.go(route.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = _indexToRoute[_currentIndex] ?? AdminRoutes.dashboard;

    return AdminShell(
      currentRoute: currentRoute.path,
      title: _getTitleForRoute(currentRoute),
      onViewChanged: _onViewChanged,
      currentViewIndex: _currentIndex,
      child: IndexedStack(
        index: _currentIndex,
        children: _views,
      ),
    );
  }

  String _getTitleForRoute(AdminRoutes route) {
    switch (route) {
      case AdminRoutes.dashboard:
        return AdminStrings.navDashboard;
      case AdminRoutes.stations:
        return AdminStrings.navStations;
      case AdminRoutes.managers:
        return AdminStrings.navManagers;
      case AdminRoutes.users:
        return AdminStrings.navUsers;
      case AdminRoutes.sessions:
        return AdminStrings.navSessions;
      case AdminRoutes.payments:
        return AdminStrings.navPayments;
      case AdminRoutes.wallets:
        return AdminStrings.navWallets;
      case AdminRoutes.offers:
        return AdminStrings.navOffers;
      case AdminRoutes.partners:
        return AdminStrings.navPartners;
      case AdminRoutes.reviews:
        return AdminStrings.navReviews;
      case AdminRoutes.reports:
        return AdminStrings.navReports;
      case AdminRoutes.content:
        return AdminStrings.navContent;
      case AdminRoutes.media:
        return AdminStrings.navMedia;
      case AdminRoutes.logs:
        return AdminStrings.navLogs;
      case AdminRoutes.settings:
        return AdminStrings.navSettings;
      default:
        return AdminStrings.appTitle;
    }
  }
}

/// Placeholder view for features not yet implemented.
class _PlaceholderView extends StatelessWidget {
  const _PlaceholderView({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.adminColors;

    return AdminPageContent(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64.r,
              color: colors.textTertiary,
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'This feature will be implemented in the next phase',
              style: TextStyle(
                fontSize: 14.sp,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

