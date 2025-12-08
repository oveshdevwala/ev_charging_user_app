/// File: lib/admin/routes/admin_routes.dart
/// Purpose: Admin panel routing configuration using go_router
/// Belongs To: admin/routes
/// Customization Guide:
///    - Add new routes by extending AdminRoutes enum
///    - Configure route parameters and transitions
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/dashboard/view/dashboard_page.dart';
import '../features/stations/view/stations_list_page.dart';
import '../features/stations/view/station_detail_page.dart';
import '../features/stations/view/station_edit_page.dart';

// ============================================================
// ADMIN ROUTES ENUM
// ============================================================

/// Enum containing all admin panel routes.
enum AdminRoutes {
  // -------- Main Routes --------
  dashboard,
  
  // -------- Stations --------
  stations,
  stationDetail,
  stationCreate,
  stationEdit,
  
  // -------- Managers --------
  managers,
  managerDetail,
  managerCreate,
  managerEdit,
  
  // -------- Users --------
  users,
  userDetail,
  
  // -------- Sessions --------
  sessions,
  sessionDetail,
  
  // -------- Payments --------
  payments,
  paymentDetail,
  
  // -------- Wallets --------
  wallets,
  walletDetail,
  
  // -------- Offers --------
  offers,
  offerDetail,
  offerCreate,
  offerEdit,
  
  // -------- Partners --------
  partners,
  partnerDetail,
  partnerCreate,
  partnerEdit,
  
  // -------- Reviews --------
  reviews,
  reviewDetail,
  
  // -------- Reports --------
  reports,
  reportsRevenue,
  reportsUsage,
  
  // -------- Content --------
  content,
  contentPages,
  contentFaq,
  contentBanners,
  
  // -------- Media --------
  media,
  
  // -------- Logs --------
  logs,
  
  // -------- Settings --------
  settings,
  settingsGeneral,
  settingsPayment,
  settingsNotification,
  settingsSecurity,
  settingsRoles,
  
  // -------- Auth --------
  login,
  forgotPassword,
}

// ============================================================
// ROUTE PATH EXTENSION
// ============================================================

/// Extension to get route paths and generate dynamic paths.
extension AdminRoutePath on AdminRoutes {
  /// Get the path string for this route.
  String get path {
    switch (this) {
      // Main
      case AdminRoutes.dashboard:
        return '/admin';
      
      // Stations
      case AdminRoutes.stations:
        return '/admin/stations';
      case AdminRoutes.stationDetail:
        return '/admin/stations/detail';
      case AdminRoutes.stationCreate:
        return '/admin/stations/create';
      case AdminRoutes.stationEdit:
        return '/admin/stations/edit';
      
      // Managers
      case AdminRoutes.managers:
        return '/admin/managers';
      case AdminRoutes.managerDetail:
        return '/admin/managers/detail';
      case AdminRoutes.managerCreate:
        return '/admin/managers/create';
      case AdminRoutes.managerEdit:
        return '/admin/managers/edit';
      
      // Users
      case AdminRoutes.users:
        return '/admin/users';
      case AdminRoutes.userDetail:
        return '/admin/users/detail';
      
      // Sessions
      case AdminRoutes.sessions:
        return '/admin/sessions';
      case AdminRoutes.sessionDetail:
        return '/admin/sessions/detail';
      
      // Payments
      case AdminRoutes.payments:
        return '/admin/payments';
      case AdminRoutes.paymentDetail:
        return '/admin/payments/detail';
      
      // Wallets
      case AdminRoutes.wallets:
        return '/admin/wallets';
      case AdminRoutes.walletDetail:
        return '/admin/wallets/detail';
      
      // Offers
      case AdminRoutes.offers:
        return '/admin/offers';
      case AdminRoutes.offerDetail:
        return '/admin/offers/detail';
      case AdminRoutes.offerCreate:
        return '/admin/offers/create';
      case AdminRoutes.offerEdit:
        return '/admin/offers/edit';
      
      // Partners
      case AdminRoutes.partners:
        return '/admin/partners';
      case AdminRoutes.partnerDetail:
        return '/admin/partners/detail';
      case AdminRoutes.partnerCreate:
        return '/admin/partners/create';
      case AdminRoutes.partnerEdit:
        return '/admin/partners/edit';
      
      // Reviews
      case AdminRoutes.reviews:
        return '/admin/reviews';
      case AdminRoutes.reviewDetail:
        return '/admin/reviews/detail';
      
      // Reports
      case AdminRoutes.reports:
        return '/admin/reports';
      case AdminRoutes.reportsRevenue:
        return '/admin/reports/revenue';
      case AdminRoutes.reportsUsage:
        return '/admin/reports/usage';
      
      // Content
      case AdminRoutes.content:
        return '/admin/content';
      case AdminRoutes.contentPages:
        return '/admin/content/pages';
      case AdminRoutes.contentFaq:
        return '/admin/content/faq';
      case AdminRoutes.contentBanners:
        return '/admin/content/banners';
      
      // Media
      case AdminRoutes.media:
        return '/admin/media';
      
      // Logs
      case AdminRoutes.logs:
        return '/admin/logs';
      
      // Settings
      case AdminRoutes.settings:
        return '/admin/settings';
      case AdminRoutes.settingsGeneral:
        return '/admin/settings/general';
      case AdminRoutes.settingsPayment:
        return '/admin/settings/payment';
      case AdminRoutes.settingsNotification:
        return '/admin/settings/notification';
      case AdminRoutes.settingsSecurity:
        return '/admin/settings/security';
      case AdminRoutes.settingsRoles:
        return '/admin/settings/roles';
      
      // Auth
      case AdminRoutes.login:
        return '/admin/login';
      case AdminRoutes.forgotPassword:
        return '/admin/forgot-password';
    }
  }

  /// Generate path with dynamic ID parameter.
  String id(String value) => '$path/$value';
}

// ============================================================
// GO ROUTER CONFIGURATION
// ============================================================

/// Admin router configuration.
class AdminRouter {
  AdminRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AdminRoutes.dashboard.path,
    debugLogDiagnostics: true,
    routes: [
      // -------- Dashboard --------
      GoRoute(
        path: AdminRoutes.dashboard.path,
        name: AdminRoutes.dashboard.name,
        builder: (context, state) => const DashboardPage(),
      ),

      // -------- Stations --------
      GoRoute(
        path: AdminRoutes.stations.path,
        name: AdminRoutes.stations.name,
        builder: (context, state) => const StationsListPage(),
      ),
      GoRoute(
        path: '${AdminRoutes.stationDetail.path}/:id',
        name: AdminRoutes.stationDetail.name,
        builder: (context, state) {
          final stationId = state.pathParameters['id'] ?? '';
          return StationDetailPage(stationId: stationId);
        },
      ),
      GoRoute(
        path: AdminRoutes.stationCreate.path,
        name: AdminRoutes.stationCreate.name,
        builder: (context, state) => const StationEditPage(),
      ),
      GoRoute(
        path: '${AdminRoutes.stationEdit.path}/:id',
        name: AdminRoutes.stationEdit.name,
        builder: (context, state) {
          final stationId = state.pathParameters['id'] ?? '';
          return StationEditPage(stationId: stationId);
        },
      ),

      // -------- Placeholder routes for other features --------
      // These will be implemented step by step
      GoRoute(
        path: AdminRoutes.managers.path,
        name: AdminRoutes.managers.name,
        builder: (context, state) => _PlaceholderPage(title: 'Managers'),
      ),
      GoRoute(
        path: AdminRoutes.users.path,
        name: AdminRoutes.users.name,
        builder: (context, state) => _PlaceholderPage(title: 'Users'),
      ),
      GoRoute(
        path: AdminRoutes.sessions.path,
        name: AdminRoutes.sessions.name,
        builder: (context, state) => _PlaceholderPage(title: 'Sessions'),
      ),
      GoRoute(
        path: AdminRoutes.payments.path,
        name: AdminRoutes.payments.name,
        builder: (context, state) => _PlaceholderPage(title: 'Payments'),
      ),
      GoRoute(
        path: AdminRoutes.wallets.path,
        name: AdminRoutes.wallets.name,
        builder: (context, state) => _PlaceholderPage(title: 'Wallets'),
      ),
      GoRoute(
        path: AdminRoutes.offers.path,
        name: AdminRoutes.offers.name,
        builder: (context, state) => _PlaceholderPage(title: 'Offers'),
      ),
      GoRoute(
        path: AdminRoutes.partners.path,
        name: AdminRoutes.partners.name,
        builder: (context, state) => _PlaceholderPage(title: 'Partners'),
      ),
      GoRoute(
        path: AdminRoutes.reviews.path,
        name: AdminRoutes.reviews.name,
        builder: (context, state) => _PlaceholderPage(title: 'Reviews'),
      ),
      GoRoute(
        path: AdminRoutes.reports.path,
        name: AdminRoutes.reports.name,
        builder: (context, state) => _PlaceholderPage(title: 'Reports'),
      ),
      GoRoute(
        path: AdminRoutes.content.path,
        name: AdminRoutes.content.name,
        builder: (context, state) => _PlaceholderPage(title: 'Content'),
      ),
      GoRoute(
        path: AdminRoutes.media.path,
        name: AdminRoutes.media.name,
        builder: (context, state) => _PlaceholderPage(title: 'Media'),
      ),
      GoRoute(
        path: AdminRoutes.logs.path,
        name: AdminRoutes.logs.name,
        builder: (context, state) => _PlaceholderPage(title: 'Logs'),
      ),
      GoRoute(
        path: AdminRoutes.settings.path,
        name: AdminRoutes.settings.name,
        builder: (context, state) => _PlaceholderPage(title: 'Settings'),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(state.uri.path),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AdminRoutes.dashboard.path),
              child: const Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Placeholder page for features not yet implemented.
class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'This feature will be implemented in the next phase',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

