/// File: lib/admin/routes/admin_routes.dart
/// Purpose: Admin panel routing configuration using go_router
/// Belongs To: admin/routes
/// Customization Guide:
///    - Add new routes by extending AdminRoutes enum
///    - Configure route parameters and transitions
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/widgets/no_transition_page.dart';
import '../features/admin_main/view/admin_main_page.dart';
import '../features/payments/payments_bindings.dart';
import '../features/payments/payments_router.dart';
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
        return '/admin/dashboard';

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
    initialLocation: '/admin/dashboard',
    debugLogDiagnostics: true,
    routes: [
      // -------- Stations Detail/Edit (shown as separate pages) --------
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

      // -------- Main Admin Shell Route (handles all main tabs) --------
      // Single persistent route - tab switching handled internally via IndexedStack
      // Uses NoTransitionPage to prevent screen transitions and keep widget instance
      GoRoute(
        path: AdminRoutes.dashboard.path,
        name: AdminRoutes.dashboard.name,
        pageBuilder: (context, state) => const AdminNoTransitionPage(
          key: ValueKey('admin-main'),
          child: AdminMainPage(initialRoute: AdminRoutes.dashboard),
        ),
      ),
      GoRoute(
        path: AdminRoutes.stations.path,
        name: AdminRoutes.stations.name,
        pageBuilder: (context, state) => const AdminNoTransitionPage(
          key: ValueKey('admin-main'),
          child: AdminMainPage(initialRoute: AdminRoutes.stations),
        ),
      ),
      GoRoute(
        path: AdminRoutes.managers.path,
        name: AdminRoutes.managers.name,
        pageBuilder: (context, state) => const AdminNoTransitionPage(
          key: ValueKey('admin-main'),
          child: AdminMainPage(initialRoute: AdminRoutes.managers),
        ),
      ),
      GoRoute(
        path: AdminRoutes.users.path,
        name: AdminRoutes.users.name,
        pageBuilder: (context, state) => const AdminNoTransitionPage(
          key: ValueKey('admin-main'),
          child: AdminMainPage(initialRoute: AdminRoutes.users),
        ),
      ),
      GoRoute(
        path: AdminRoutes.sessions.path,
        name: AdminRoutes.sessions.name,
        pageBuilder: (context, state) => const AdminNoTransitionPage(
          key: ValueKey('admin-main'),
          child: AdminMainPage(initialRoute: AdminRoutes.sessions),
        ),
      ),
      GoRoute(
        path: AdminRoutes.payments.path,
        name: AdminRoutes.payments.name,
        pageBuilder: (context, state) => const AdminNoTransitionPage(
          key: ValueKey('admin-main'),
          child: AdminMainPage(initialRoute: AdminRoutes.payments),
        ),
      ),
      GoRoute(
        path: AdminRoutes.wallets.path,
        name: AdminRoutes.wallets.name,
        pageBuilder: (context, state) => const AdminNoTransitionPage(
          key: ValueKey('admin-main'),
          child: AdminMainPage(initialRoute: AdminRoutes.wallets),
        ),
      ),
      GoRoute(
        path: AdminRoutes.offers.path,
        name: AdminRoutes.offers.name,
        pageBuilder: (context, state) => const AdminNoTransitionPage(
          key: ValueKey('admin-main'),
          child: AdminMainPage(initialRoute: AdminRoutes.offers),
        ),
      ),
      GoRoute(
        path: AdminRoutes.partners.path,
        name: AdminRoutes.partners.name,
        pageBuilder: (context, state) => const AdminNoTransitionPage(
          key: ValueKey('admin-main'),
          child: AdminMainPage(initialRoute: AdminRoutes.partners),
        ),
      ),
      GoRoute(
        path: AdminRoutes.reviews.path,
        name: AdminRoutes.reviews.name,
        pageBuilder: (context, state) => const AdminNoTransitionPage(
          key: ValueKey('admin-main'),
          child: AdminMainPage(initialRoute: AdminRoutes.reviews),
        ),
      ),
      GoRoute(
        path: AdminRoutes.reports.path,
        name: AdminRoutes.reports.name,
        pageBuilder: (context, state) => const AdminNoTransitionPage(
          key: ValueKey('admin-main'),
          child: AdminMainPage(initialRoute: AdminRoutes.reports),
        ),
      ),
      GoRoute(
        path: AdminRoutes.content.path,
        name: AdminRoutes.content.name,
        pageBuilder: (context, state) => const AdminNoTransitionPage(
          key: ValueKey('admin-main'),
          child: AdminMainPage(initialRoute: AdminRoutes.content),
        ),
      ),
      GoRoute(
        path: AdminRoutes.media.path,
        name: AdminRoutes.media.name,
        pageBuilder: (context, state) => const AdminNoTransitionPage(
          key: ValueKey('admin-main'),
          child: AdminMainPage(initialRoute: AdminRoutes.media),
        ),
      ),
      GoRoute(
        path: AdminRoutes.logs.path,
        name: AdminRoutes.logs.name,
        pageBuilder: (context, state) => const AdminNoTransitionPage(
          key: ValueKey('admin-main'),
          child: AdminMainPage(initialRoute: AdminRoutes.logs),
        ),
      ),
      GoRoute(
        path: AdminRoutes.settings.path,
        name: AdminRoutes.settings.name,
        pageBuilder: (context, state) => const AdminNoTransitionPage(
          key: ValueKey('admin-main'),
          child: AdminMainPage(initialRoute: AdminRoutes.settings),
        ),
      ),
      ...PaymentsRouter.routes(PaymentsBindings.instance),
      // Redirect root /admin to dashboard
      GoRoute(
        path: '/admin',
        redirect: (context, state) => AdminRoutes.dashboard.path,
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
